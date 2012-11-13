package com.xenojoshua.af.resource
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.xenojoshua.af.config.XafConfig;
	import com.xenojoshua.af.exception.XafException;
	import com.xenojoshua.af.utils.console.XafConsole;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
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
		 * Please refer to class "XafIRsConfig".
		 * XafRsManager.instance.registerResources(configs);
		 * XafRsManager.instance.registerCompleteSignal(onComplete).registerErrorSignal(onError);
		 * XafRsManager.instance.prepareLoading(['resourceA', 'resourceB', ...]).startLoading();
		 * 
		 * ----------------------------------------------------------------
		 * Note:
		 * ----------------------------------------------------------------
		 * Only swf resources will be registered in this resource manager.
		 * Other resources have to be processed before "this.dispose()" function called.
		 * (XML or JSON can be added into XafConfig, etc...)
		 * After "this.dispose()" all temporarily data would be deleted.
		 * 
		 * ----------------------------------------------------------------
		 * Resource Config:
		 * ----------------------------------------------------------------
		 * url:String      relative resource url
		 * type:String     swf | xml | json
		 * size:int        default 0, size of resource
		 * preload:Boolean default false, does resource have to be loaded before application initialized
		 * main:Boolean    default false, is resource main swf of the application
		 */
		
		/**
		 * Initialize class params.
		 * @return void
		 */
		public function XafRsManager() {
			this.setLoaderVars(); // init loader vars
			
			this._swfLoaders     = new Object();
			this._loadingList    = new Object();
			this._resources      = new Object();
			
			this._completeSignal = new Signal();
			this._errorSignal    = new Signal();
		}
		
		private var _loader:LoaderMax; // used to handle loaded content after load action
		private var _loaderVars:Object; // LoaderMax vars
		
		private var _swfLoaders:Object; // <name:String, loader:SWFLoader>
		private var _loadingList:Object; // <name:String, type:String>
		private var _validTypes:Object = {
			swf:  'swf',
			xml:  'xml',
			json: 'json'
		};
		private var _resources:Object; // <name:String, config:Object>
		
		private var _completeSignal:Signal;
		private var _errorSignal:Signal;
		
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
			
			return config;
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* EVENT APIS
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Clear last loading action records.
		 * @return void
		 */
		public function dispose():void {
			this._loadingList = [];
			this._loader = null;
			this._completeSignal.removeAll();
			this._errorSignal.removeAll();
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
					this._loadingList[rsName] = config.type;
				}
			}
			
			return this;
		}
		
		/**
		 * Start loading.
		 * @return void
		 */
		public function startLoading():void {
			if (this._loadingList) { // have items to load
				if (!this._loader) {
					this._loader = new LoaderMax(this._loaderVars);
				}
				for (var rsName:String in this._loadingList) {
					this.appendLoader(
						this.getAbsoluteUrl(this._resources[rsName].url),
						this._resources[rsName].type
					);
				}
				this._loader.load();
			}
		}
		
		/**
		 * Load resources defined as preload in "this._resources".
		 * @return void
		 */
		public function loadPreloads():void {
			this._loadingList = new Array();
			this._loader = new LoaderMax(this._loaderVars);
			
			for (var rsName:String in this._resources) {
				var config:Object = this._resources[rsName];
				if (config.preload) {
					this._loadingList[rsName] = config.type;
					this.appendLoader(this.getAbsoluteUrl(config.url), config.type);
				}
			}
			this._loader.load();
		}
		
		/**
		 * Get absolute url according to relative url.
		 * @param String url
		 * @return String url
		 */
		private function getAbsoluteUrl(url:String):String {
			return XafConfig.instance.mediaHost + url;
		}
		
		/**
		 * Append appropriate loader into LoaderMax.
		 * @param String url
		 * @param String type
		 * @return void
		 */
		private function appendLoader(url:String, type:String):void {
			if (type == this._validTypes.swf) {
				this._loader.append(new SWFLoader(url));
			} else if (type == this._validTypes.xml
				|| type == this._validTypes.json) {
				this._loader.append(new DataLoader(url));
			} else {
				this._loader.append(new ImageLoader(url));
			}
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
					this.registerSwfLoader(rsName, this.getContentAsSwfLoader(rsName));
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
		 * Resources loading progress.
		 * @param LoaderEvent e
		 * @return void
		 */
		private function onProgress(e:LoaderEvent):void {
			//XafConsole.instance.log(XafConsole.INFO, "Resources bytes loaded: " + this._loader.bytesLoaded);
			//XafConsole.instance.log(XafConsole.INFO, "Resource loading progress: " + e.target.progress);
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
			this._loaderVars.onComplete     = (onSucceed == null)  ? this.onSucceed  : onSucceed;
			this._loaderVars.onProgress     = (onProgress == null) ? this.onProgress : onProgress;
			this._loaderVars.onError        = (onError == null)    ? this.onError    : onError;
			this._loaderVars.name           = name;
			this._loaderVars.auditSize      = auditSize;
			this._loaderVars.maxConnections = maxConnections;
			this._loaderVars.skipFailed     = skipFailed;
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* RESOURCE HANDLING APIS
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Get class defined in the swf target.
		 * @param String name the name of the SWFLoader
		 * @param String className
		 * @return Class cls
		 */
		public function getClassDefInSwf(name:String, className:String):Class {
			var cls:Class = null;
			
			var loader:SWFLoader = this.getSwfLoader(name);
			if (loader != null) {
				cls = loader.getClass(className);
			}
			
			return cls;
		}
		
		/**
		 * Get MovieClip instance in swf target.
		 * @param String name the name of the SWFLoader
		 * @param String className
		 * @return MovieClip movie
		 */
		public function getMovieClipInSwf(name:String, className:String):MovieClip {
			var movie:MovieClip = null;
			
			var cls:Class = this.getClassDefInSwf(name, className);
			if (cls != null) {
				movie = (new cls()) as MovieClip;
			}
			
			return movie;
		}
		
		/**
		 * Get one SWFLoader from registered loader list if it exists, otherwise null returned.
		 * @param String name the name of the SWFLoader
		 * @return SWFLoader loader
		 */
		public function getSwfLoader(name:String):SWFLoader {
			var loader:SWFLoader = null;
			
			if (this._swfLoaders.hasOwnProperty(name)) {
				loader = this._swfLoaders[name];
			} else {
				XafConsole.instance.log(XafConsole.ERROR, 'XafRsManager: SWFLoader with name "' + name + '" not registered in the XafRsManager!');
			}
			
			return loader;
		}
		
		/**
		 * Get XML from loader.
		 * @param String name
		 * @return XML xml
		 */
		public function getXML(name:String):XML {
			return this._loader.getContent(this.getAbsoluteUrl(this._resources[name].url)) as XML;
		}
		
		/**
		 * Get JSON from loader.
		 * @param String name
		 * @return Object json
		 */
		public function getJSON(name:String):Object {
			return JSON.parse(this._loader.getContent(this.getAbsoluteUrl(this._resources[name].url)));
		}
		
		/**
		 * Get image from loader.
		 * @param String name
		 * @return DisplayObject image
		 */
		public function getImage(name:String):DisplayObject {
			return this._loader.getContent(this.getAbsoluteUrl(this._resources[name].url)) as DisplayObject;
		}
		
		/**
		 * Register one swf loader in loader list.
		 * @param String name the name of the loader
		 * @param SWFLoader loader
		 * @return void
		 */
		private function registerSwfLoader(name:String, loader:SWFLoader):void {
			this._swfLoaders[name] = loader;
		}
		
		/**
		 * Get loaded content as SWFLoader.
		 * @param String name
		 * @return SWFLoader loader
		 */
		private function getContentAsSwfLoader(name:String):SWFLoader {
			return this._loader.getLoader(this.getAbsoluteUrl(this._resources[name].url)) as SWFLoader;
		}
	}
}