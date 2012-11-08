package com.xenojoshua.af.manager
{
	import com.greensock.loading.SWFLoader;
	import com.xenojoshua.af.utils.console.XafConsole;
	
	import flash.display.MovieClip;
	import flash.utils.Dictionary;

	public class XafRsManager
	{
		private static var _mgr:XafRsManager;
		
		private var _loaders:Dictionary; // <name:String, loader:SWFLoader>
		
		public static function get instance():XafRsManager
		{
			if (!XafRsManager._mgr) {
				XafRsManager._mgr = new XafRsManager();
			}
			return XafRsManager._mgr;
		}
		
		public function XafRsManager() {
			this._loaders = new Dictionary();
		}
		
		/**
		 * Register one swf loader in loader list.
		 * @param String name the name of the loader
		 * @param SWFLoader loader
		 * @return SWFLoader loader
		 */
		public function registerSwfLoader(name:String, loader:SWFLoader):SWFLoader
		{
			this._loaders[name] = loader;
			
			return loader;
		}
		
		/**
		 * Get MovieClip instance in swf target.
		 * @param String name the name of the SWFLoader
		 * @param String className
		 * @return MovieClip movie
		 */
		public function getMovieClipInSwf(name:String, className:String):MovieClip
		{
			var movie:MovieClip = null;
			
			var cls:Class = this.getClassDefInSwf(name, className);
			if (cls != null) {
				movie = (new cls()) as MovieClip;
			}
			
			return movie;
		}
		
		/**
		 * Get class defined in the swf target.
		 * @param String name the name of the SWFLoader
		 * @param String className
		 * @return Class cls
		 */
		public function getClassDefInSwf(name:String, className:String):Class
		{
			var cls:Class = null;
			
			var loader:SWFLoader = this.getSwfLoader(name);
			if (loader != null) {
				cls = loader.getClass(className);
			}
			
			return cls;
		}
		
		/**
		 * Get one SWFLoader from loader list if it exists, otherwise null returned.
		 * @param String name the name of the SWFLoader
		 * @return SWFLoader loader
		 */
		private function getSwfLoader(name:String):SWFLoader
		{
			var loader:SWFLoader = null;
			
			if (this._loaders.hasOwnProperty(name)) {
				loader = this._loaders[name];
			} else {
				XafConsole.instance.log('SWFLoader with name "' + name + '" not registered in the XafRsManager!');
			}
			
			return loader;
		}
	}
}