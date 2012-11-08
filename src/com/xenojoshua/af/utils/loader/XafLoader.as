package com.xenojoshua.af.utils.loader
{
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	import com.xenojoshua.af.utils.console.XafConsole;
	
	import flash.display.Loader;
	
	public class XafLoader
	{
		public static var TYPE_SWF:String = "swf";
		public static var TYPE_XML:String = "xml";
		
		private static var _xafLoader:XafLoader;
		
		private var _loader:LoaderMax = null; // used to handle loaded content after load action
		
		/**
		 * Get instance of XafLoader.
		 * @return XafLoader _xafLoader
		 */
		public static function get instance():XafLoader
		{
			if (!XafLoader._xafLoader) 
			{
				XafLoader._xafLoader = new XafLoader();
			}
			return XafLoader._xafLoader;
		}
		
		/**
		 * Destory XafLoader instance.
		 * @return void
		 */
		public static function destory():void
		{
			XafLoader._xafLoader = null;
		}
		
		/**
		 * Constructor. Activate LoaderMax with SWF & XML type.
		 * @return void
		 */
		public function XafLoader()
		{
			LoaderMax.activate([SWFLoader, XMLLoader]); // activate swf & xml loader as default
		}
		
		/**
		 * Initialize one LoaderMax & start loading.
		 * @param Array urls array of urls to be loaded
		 * @param Object vars default null, please also see LoaderMax constructor
		 * @return XafLoader loader
		 */
		public function load(urls:Array, vars:Object = null):XafLoader
		{
			if (null == vars) {
				vars = XafLoader.buildLoaderVars(this.onComplete, this.onProgress, this.onError);
			}
			this._loader = null; // reset old loader
			
			var loader:LoaderMax = LoaderMax.parse(urls, vars);
			this._loader = loader;
			this._loader.load();
			
			return this; // same to XafLoader._xafLoader | XafLoader.instance
		}
		
		/**
		 * Get swf loaded in function "load".
		 * @param String name
		 * @return SWFLoader loader
		 */
		public function getSwf(name:String):SWFLoader
		{
			return this._loader.getLoader(name) as SWFLoader;
		}
		
		/**
		 * Get xml loaded in function "load".
		 * @param String name
		 * @return XML xml
		 */
		public function getXml(name:String):XML
		{
			return this._loader.getContent(name) as XML;
		}
		
		private function onComplete():void
		{
			XafConsole.instance.log("Resources loading complete!");
		}
		
		private function onProgress():void
		{
			
		}
		
		private function onError():void
		{
			
		}
		
		public static function buildLoaderVars(
			onComplete:Function,
			onProgress:Function,
			onError:Function,
			name:String         = "XafLoader",
			auditSize:Boolean   = false,
			maxConnections:uint = 10,
			skipFailed:Boolean  = false
		):Object
		{
			var vars:Object = {};
			
			vars["onComplete"]     = onProgress;
			vars["onProgress"]     = onProgress;
			vars["onError"]        = onError;
			vars["auditSize"]      = auditSize;
			vars["name"]           = name;
			vars["maxConnections"] = maxConnections;
			vars["skipFailed"]     = skipFailed;
			
			return vars;
		}
	}
}