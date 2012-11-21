package com.xenojoshua.af.resource.manager
{
	import com.greensock.loading.SWFLoader;
	import com.xenojoshua.af.utils.console.XafConsole;
	
	import flash.display.MovieClip;

	public class XafSwfManager
	{
		private static var _mgr:XafSwfManager;
		
		/**
		 * Get instance of XafSwfManager.
		 * @return XafSwfManager _mgr
		 */
		public static function get instance():XafSwfManager {
			if (!XafSwfManager._mgr) {
				XafSwfManager._mgr = new XafSwfManager();
			}
			return XafSwfManager._mgr;
		}
		
		/**
		 * Initialize XafSwfManager.
		 * @return void
		 */
		public function XafSwfManager() {
			this._swfLoaders = new Object();
		}
		
		private var _swfLoaders:Object; // <name:String, loader:SWFLoader>
		
		/**
		 * Register one swf loader in loader list.
		 * @param String name the name of the loader
		 * @param SWFLoader loader
		 * @return void
		 */
		public function registerSwfLoader(name:String, loader:SWFLoader):void {
			this._swfLoaders[name] = loader;
			XafConsole.instance.log(XafConsole.INFO, 'XafRsManager: SWF "' + name + '" registered!');
		}
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
	}
}