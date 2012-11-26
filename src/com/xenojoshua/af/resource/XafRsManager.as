package com.xenojoshua.af.resource
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.xenojoshua.af.constant.XafConst;
	import com.xenojoshua.af.exception.XafException;
	import com.xenojoshua.af.mvc.view.screen.XafScreenManager;
	import com.xenojoshua.af.resource.manager.XafConfigManager;
	import com.xenojoshua.af.resource.manager.XafImageManager;
	import com.xenojoshua.af.resource.manager.XafSwfManager;
	import com.xenojoshua.af.utils.XafUtil;
	import com.xenojoshua.af.utils.console.XafConsole;
	import com.xenojoshua.af.utils.font.XafFontManager;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import org.osflash.signals.Signal;

	public class XafRsManager
	{
		private static var _mgr:XafRsManager;
		
		public static function get instance():XafRsManager {
			if (!XafRsManager._mgr) {
				XafRsManager._mgr = new XafRsManager();
			}
			return XafRsManager._mgr;
		}
		
		/**
		 * ----------------------------------------------------------------
		 * Usage:
		 * ----------------------------------------------------------------
		 * There should be one more class in your application to store resource configs.
		 * (Also, resource configs can come from some resource file to be loaded via XafInitLoader, e.g. resources.json)
		 * Please refer to class "XafIRsConfig".
		 * XafRsManager.instance.initializeLoadingBar(movie, background, alpha); (If you want a loading bar)
		 * XafRsManager.instance.registerResources(configs);
		 * XafRsManager.instance.registerCompleteSignal(onComplete).registerErrorSignal(onError);
		 * XafRsManager.instance.prepareLoading(['resourceA', 'resourceB', ...]);
		 * XafRsManager.instance.startLoading(); // XafRsManager.instance.loadPreloads(); // load preload items
		 * 
		 * ----------------------------------------------------------------
		 * Note:
		 * ----------------------------------------------------------------
		 * Resource of type 'swf' would be registered in this XafRsManager.
		 * Resource of type 'font' would be registered in the XafFontManager.
		 * Resource of type 'config' would be registered in the XafConfig (JSON format).
		 * Resource of type 'image' would be registered in the XafImageManager.
		 * 
		 * Resources have to be processed before "this.dispose()" function called.
		 * (XML or JSON can be added into XafConfig, etc...)
		 * After "this.dispose()" all temporarily data would be deleted.
		 * 
		 * ----------------------------------------------------------------
		 * Resource Config:
		 * ----------------------------------------------------------------
		 * url:String      obligatory relative resource url
		 * type:String     obligatory swf | font | config | image | xml | json
		 * size:int        optional   default 0, size of resource
		 * preload:Boolean optional   default false, does resource have to be loaded before application initialized
		 * main:Boolean    optional   default false, is resource main swf of the application
		 * font:Object     optional   default {}, font class names & font name contained in the resource file
		 *                                e.g. {'LISU1'(font class name): 'LiSu'(font name)}
		 * config:String   optional   default '', config name registered in XafConfig contained in the resource json file
		 */
		
		/**
		 * Initialize class params.
		 * @return void
		 */
		public function XafRsManager() {
			this.setLoaderVars(); // init loader vars
			
			this._loadingList    = new Object();
			this._resources      = new Object();
			
			this._completeSignal = new Signal();
			this._progressSignal = new Signal();
			this._errorSignal    = new Signal();
		}
		
		private var _loader:LoaderMax;   // used to handle loaded content after load action
		private var _loaderVars:Object;  // LoaderMax vars
		
		private var _loadingList:Object; // <name:String, type:String>
		private var _validTypes:Object = {
			swf:    'swf',
			font:   'font',
			config: 'config',
			image:  'image'
		};
		private var _resources:Object;   // <name:String, config:Object>
		
		private var _completeSignal:Signal;
		private var _progressSignal:Signal;
		private var _errorSignal:Signal;
		
		private var _loadingBar:XafRsProgressBar;
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* RESOURCE CONFIG APIS
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Register resources configs.
		 * @param Object resources
		 * @return void
		 */
		public function registerResources(resources:Object):void {
			if (resources) {
				for (var name:String in resources) {
					this.registerResource(name, resources[name]);
				}
			}
		}
		
		/**
		 * Register resource config.
		 * @param String name resource name
		 * @param Object config resource config
		 * @return void
		 */
		public function registerResource(name:String, config:Object):void {
			this._resources[name] = this.validateResourceConfig(config);
		}
		
		/**
		 * Validate resource config, and give default value if some param does not exist.
		 * @param Object config
		 * @return Object config
		 */
		private function validateResourceConfig(config:Object):Object {
			if (!config.hasOwnProperty('url')) {
				throw new XafException(10003);
			} else if (!config.hasOwnProperty('type')
				|| !this._validTypes.hasOwnProperty(config.type)) {
				throw new XafException(10004);
			}
			if (!config.hasOwnProperty('size')) {
				config.size = 0;
			}
			if (!config.hasOwnProperty('preload')) {
				config.preload = false;
			}
			if (!config.hasOwnProperty('main')) {
				config.main = false;
			}
			if (!config.hasOwnProperty('font')) {
				config.font = {};
			}
			if (!config.hasOwnProperty('config')) {
				config.config = '';
			}
			
			return config;
		}
		
		/**
		 * Get resource config according to resource name.
		 * @param String name
		 * @return Object config
		 */
		public function getResourceConfig(name:String):Object {
			var config:Object = null;
			if (this._resources.hasOwnProperty(name)) {
				config = this._resources[name];
			}
			
			return config;
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* LOADING PROGRESS BAR
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Initialize loading progress bar.
		 * @param MovieClip movie default null, loading bar animation
		 * @param DisplayObject background default null, background image
		 * @param Number alpha default 0.0, means background is transparent, background alpha value
		 * @return XafRsManager 
		 */
		public function initializeLoadingBar(movie:MovieClip = null, background:DisplayObject = null, alpha:Number = 0.0):XafRsManager {
			this._loadingBar = new XafRsProgressBar(movie, background, alpha);
			return this;
		}
		
		/**
		 * Display the loading progress bar.
		 * @return void
		 */
		private function showLoadingBar():void {
			if (this._loadingBar) {
				XafScreenManager.instance.getLayer(XafConst.SCREEN_POPUP).addChild(this._loadingBar);
			}
		}
		
		/**
		 * Hide the loading progress bar.
		 * @return void
		 */
		private function hideLoadingBar():void {
			if (this._loadingBar && this._loadingBar.parent) {
				this._loadingBar.parent.removeChild(this._loadingBar);
			}
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* EVENT APIS
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Clear last loading action records.
		 * @return void
		 */
		public function dispose():void {
			// remove loading list
			this._loadingList = {};
			// remove signal actions
			this._completeSignal.removeAll();
			this._progressSignal.removeAll();
			this._errorSignal.removeAll();
			// remove loaded content & destory LoaderMax
			if (this._loader) {
				this._loader = null;
			}
			// remove & destory loading bar
			if (this._loadingBar) {
				this.hideLoadingBar();
				this._loadingBar.dispose();
				this._loadingBar = null;
			}
		}
		
		/**
		 * Register loading complete action.
		 * @param Function callback
		 * @return XafRsManager
		 */
		public function registerCompleteSignal(callback:Function):XafRsManager {
			this._completeSignal.add(callback);
			return this;
		}
		
		/**
		 * Register loading progress action.
		 * @param Function callbackc
		 * @return XafRsManager
		 */
		public function registerProgressSignal(callback:Function):XafRsManager {
			this._progressSignal.add(callback);
			return this;
		}
		
		/**
		 * Register loading fail action.
		 * @param Function callback
		 * @return XafRsManager
		 */
		public function registerErrorSignal(callback:Function):XafRsManager {
			this._errorSignal.add(callback);
			return this;
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* RESOURCE LOADING APIS
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Add resource names to be loaded into manager.
		 * @param Array names
		 * @return XafRsManager
		 */
		public function prepareLoading(names:Array):XafRsManager {
			if (names) {
				for each (var rsName:String in names) {
					var config:Object = this._resources[rsName];
					if (!config) {
						XafConsole.instance.log(XafConsole.WARNING, 'XafRsManager: Config of resouce "' + rsName + '" not registered!');
						continue; // if resource config not registered, skip it
					}
					if (!this.checkIsLoaded(rsName, config)) {
						this._loadingList[rsName] = config.type;
					}
				}
			}
			
			return this;
		}
		
		/**
		 * Start loading.
		 * @return Boolean isStarted since it's possible that all specified resources are all already loaded
		 */
		public function startLoading():Boolean {
			var isThereAnyLoading:Boolean = false;
			
			if (this._loader == null) {
				this._loader = new LoaderMax(this._loaderVars);
			}
			for (var rsName:String in this._loadingList) {
				isThereAnyLoading = true;
				this.appendLoader(
					XafUtil.getAbsoluteMediaUrl(this._resources[rsName].url),
					this._resources[rsName].type,
					this._resources[rsName].size
				);
			}
			if (isThereAnyLoading) {
				if (this._loadingBar) {
					this.showLoadingBar();
				}
				this._loader.load();
			}
			
			return isThereAnyLoading;
		}
		
		/**
		 * Load resources defined as preload in "this._resources".
		 * @return Boolean isStarted since it's possible that all specified resources are all already loaded
		 */
		public function loadPreloads():Boolean {
			this._loadingList = new Array();
			this._loader = new LoaderMax(this._loaderVars);
			
			var isThereAnyPreload:Boolean = false;
			
			for (var rsName:String in this._resources) {
				if (this._resources[rsName].preload) {
					this._loadingList[rsName] = this._resources[rsName].type;
					this.appendLoader(
						XafUtil.getAbsoluteMediaUrl(this._resources[rsName].url),
						this._resources[rsName].type,
						this._resources[rsName].size
					);
					isThereAnyPreload = true;
				}
			}
			if (isThereAnyPreload) {
				if (this._loadingBar) {
					this.showLoadingBar();
				}
				this._loader.load();
			}
			
			return isThereAnyPreload;
		}
		
		/**
		 * Append appropriate loader into LoaderMax.
		 * @param String url
		 * @param String type
		 * @param Number size
		 * @return void
		 */
		private function appendLoader(url:String, type:String, size:Number):void {
			var vars:Object = {name: url};
			if (size) {
				vars.estimatedBytes = size;
				vars.onProgress = this.onSingleProgress;
			}
			
			if (type == this._validTypes.swf
				|| type == this._validTypes.font) {
				this._loader.append(new SWFLoader(url, vars));
			} else if (type == this._validTypes.config) {
				this._loader.append(new DataLoader(url, vars));
			} else if (type == this._validTypes.image) {
				this._loader.append(new ImageLoader(url, vars));
			}
		}
		
		/**
		 * Check target resource already loaded or not.
		 * @param String name
		 * @param Object config
		 * @return Boolean isLoaded
		 */
		private function checkIsLoaded(name:String, config:Object):Boolean {
			var isLoaded:Boolean = false;
			
			if (config.type == this._validTypes.swf
				|| config.type == this._validTypes.font) {
				isLoaded = XafSwfManager.instance.getSwfLoader(name) == null ? false : true;
			} else if (config.type == this._validTypes.config) {
				isLoaded = XafConfigManager.instance.loadConfigs(config.config) == null ? false : true;
			} else if (config.type == this._validTypes.image) {
				isLoaded = XafImageManager.instance.getImage(name) == null ? false : true;
			}
			
			return isLoaded;
		}
		
		/**
		 * Resources completely loaded, register swfs into manager.
		 * And dispatch XafRsManager into all registered signals.
		 * @param LoaderEvent e
		 * @return void
		 */
		private function onSucceed(e:LoaderEvent):void {
			XafConsole.instance.log(XafConsole.INFO, "XafRsManager: Resources loading completed! " + e.target + " is complete!");
			
			for (var rsName:String in this._loadingList) {
				if (this._loadingList[rsName] == this._validTypes.swf) {
					// register swf resource
					XafSwfManager.instance.registerSwfLoader(rsName, this.getContentAsSwfLoader(rsName));
				} else if (this._loadingList[rsName] == this._validTypes.font) {
					// register font resource
					XafSwfManager.instance.registerSwfLoader(rsName, this.getContentAsSwfLoader(rsName));
					for (var fontClassName:String in this._resources[rsName].font) {
						XafFontManager.instance.registerFont(
							this._resources[rsName].font[fontClassName],
							fontClassName,
							XafSwfManager.instance.getClassDefInSwf(rsName, fontClassName)
						);
					}
				} else if (this._loadingList[rsName] == this._validTypes.config) {
					// register config resource
					XafConfigManager.instance.registerConfigs(this._resources[rsName].config, this.getContentAsJSON(rsName));
				} else if (this._loadingList[rsName] == this._validTypes.image) {
					// register image resource
					XafImageManager.instance.registerImage(rsName, this.getContentAsImage(rsName));
				}
			}
			
			this._completeSignal.dispatch(this);
		}
		
		/**
		 * Resources loading failed, dispatch signals.
		 * @param LoaderEvent e
		 * @return void
		 */
		private function onError(e:LoaderEvent):void {
			XafConsole.instance.log(XafConsole.INFO, "XafRsManager: Resources loading failed! Error occured with " + e.target + ": " + e.text);
			this._errorSignal.dispatch();
		}
		
		/**
		 * Global total resources loading progress.
		 * @param LoaderEvent e
		 * @return void
		 */
		private function onTotalProgress(e:LoaderEvent):void {
			if (this._loadingBar) {
				//trace('Total progress: loaded: ' + e.target.bytesLoaded + ', total: ' + e.target.bytesTotal); // this code can make loading bar a bit slow to be finished
				this._loadingBar.updateProgressBar(e.target.bytesLoaded, e.target.bytesTotal);
			}
			this._progressSignal.dispatch([e.target.bytesLoaded, e.target.bytesTotal]);
		}
		
		/**
		 * Single resource loading progress.
		 * @param LoaderEvent e
		 * @return void
		 */
		private function onSingleProgress(e:LoaderEvent):void {
			// e.target is possible to be SWFLoader | ImageLoader | DataLoader etc...
			if (e.target.bytesLoaded == e.target.bytesTotal) {
				var url:String = e.target.name;
				var resourceName:String = url.substr(url.lastIndexOf('/') + 1);
				XafConsole.instance.log(XafConsole.DEBUG, 'XafRsManager: On resource progress "' + resourceName + '", size: ' + e.target.bytesTotal + ', consumed: ' + e.target.loadTime + ' (seconds)!');
			}
		}
		
		/**
		 * Set LoaderMax vars.
		 * @param Function onSucceed      default null
		 * @param Function onProgress     default null
		 * @param Function onError        default null
		 * @param String   name           default "XafLoader"
		 * @param Boolean  auditSize      default false
		 * @param uint     maxConnections default 10
		 * @param Boolean  skipFailed     default false
		 * @return void
		 */
		public function setLoaderVars(
			onSucceed:Function  = null,
			onProgress:Function = null,
			onError:Function    = null,
			name:String         = "XafLoader",
			auditSize:Boolean   = false,
			maxConnections:uint = 10,
			skipFailed:Boolean  = false
		):void
		{
			if (!this._loaderVars) {
				this._loaderVars = new Object();
			}
			this._loaderVars.onComplete     = (onSucceed == null)  ? this.onSucceed       : onSucceed;
			this._loaderVars.onProgress     = (onProgress == null) ? this.onTotalProgress : onProgress;
			this._loaderVars.onError        = (onError == null)    ? this.onError         : onError;
			this._loaderVars.name           = name;
			this._loaderVars.auditSize      = auditSize;
			this._loaderVars.maxConnections = maxConnections;
			this._loaderVars.skipFailed     = skipFailed;
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* RESOURCE HANDLING APIS
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Get loaded content as JSON.
		 * @param String name
		 * @return Object json
		 */
		private function getContentAsJSON(name:String):Object {
			return JSON.parse(this._loader.getContent(XafUtil.getAbsoluteMediaUrl(this._resources[name].url)));
		}
		
		/**
		 * Get loaded content as image.
		 * @param String name
		 * @return DisplayObject image
		 */
		private function getContentAsImage(name:String):DisplayObject {
			return this._loader.getContent(XafUtil.getAbsoluteMediaUrl(this._resources[name].url)) as DisplayObject;
		}
		
		/**
		 * Get loaded content as SWFLoader.
		 * @param String name
		 * @return SWFLoader loader
		 */
		private function getContentAsSwfLoader(name:String):SWFLoader {
			return this._loader.getLoader(XafUtil.getAbsoluteMediaUrl(this._resources[name].url)) as SWFLoader;
		}
	}
}