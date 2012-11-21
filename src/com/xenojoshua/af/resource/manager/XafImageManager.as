package com.xenojoshua.af.resource.manager
{
	import com.xenojoshua.af.mvc.view.utils.XafDisplayUtil;
	import com.xenojoshua.af.utils.XafUtil;
	import com.xenojoshua.af.utils.console.XafConsole;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import com.xenojoshua.af.resource.XafRsManager;

	public class XafImageManager
	{
		private static var _mgr:XafImageManager;
		
		/**
		 * Get instance of XafImageManager.
		 * @return XafImageManager _mgr
		 */
		public static function get instance():XafImageManager {
			if (!XafImageManager._mgr) {
				XafImageManager._mgr = new XafImageManager();
			}
			return XafImageManager._mgr;
		}
		
		/**
		 * Initialize XafImageManager.
		 * @return void
		 */
		public function XafImageManager() {
			this._images = new Object();
			this._loadings = new Object();
			this._loadingNameUrl = new Object();
		}
		
		/**
		 * Destory XafImageManager.
		 * @return void
		 */
		public function dispose():void {
			this._images = null;
			this._loadings = null;
			this._loadingNameUrl = null;
		}
		
		private var _images:Object; // <name:String, image:DisplayObject>
		
		private var _loadingNameUrl:Object; // <url:String, name:String>
		private var _loadings:Object; // <name:String, loader:Loader>
		
		/**
		 * Register an image into manager.
		 * @param String name
		 * @param DisplayObject image
		 * @return void
		 */
		public function registerImage(name:String, image:DisplayObject):void {
			this._images[name] = image;
			XafConsole.instance.log(XafConsole.INFO, 'XafImageManager: Image "' + name + '" registered!');
		}
		
		/**
		 * Get image from cached images, if no image found & "startLoad" is true,
		 * it will start to load the image.
		 * @param String name
		 * @param Boolean startLoad
		 * @return DisplayObject image
		 */
		public function getImage(name:String, startLoad:Boolean = false):DisplayObject {
			var image:DisplayObject = null;
			var display:DisplayObject = this._images[name];
			
			if (display) {
				image = XafDisplayUtil.cloneDisplayBitmap(display);
			} else if (!display && startLoad) {
				image = this.loadImage(name);
			}
			
			return image;
		}
		
		/**
		 * Load image via resource name.
		 * @param String name
		 * @return Loader loader
		 */
		public function loadImage(name:String):Loader {
			var loader:Loader = new Loader();
			
			var url:String = this.getUrlFromResourceName(name);
			this._loadings[name] = loader;
			this._loadingNameUrl[url] = name;
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onError);
			loader.load(new URLRequest(url));
			
			return loader;
		}
		
		/**
		 * Complete handler, replace image content with loader in cache object.
		 * @param Event e
		 * @return void
		 */
		private function onComplete(e:Event):void {
			var loader:Loader = e.currentTarget.loader as Loader;
			
			var url:String = loader.contentLoaderInfo.url;
			var name:String = this._loadingNameUrl[url];
			
			this._loadings[name] = null;
			this._loadingNameUrl[url] = null;
			this.registerImage(name, loader.content);
		}
		
		/**
		 * IOError handler, remove loading status.
		 * @param Event e
		 * @return void
		 */
		private function onError(e:Event):void {
			var loader:Loader = e.currentTarget.loader as Loader;
			
			var url:String = loader.loaderInfo.url;
			var name:String = this._loadingNameUrl[url];
			
			this._loadings[name] = null;
			this._loadingNameUrl[url] = null;
		}
		
		/**
		 * Get absolute media url from resource name.
		 * @param String name
		 * @return String url
		 */
		private function getUrlFromResourceName(name:String):String {
			var config:Object = XafRsManager.instance.getResourceConfig(name);
			
			return XafUtil.getAbsoluteMediaUrl(config.url);
		}
	}
}