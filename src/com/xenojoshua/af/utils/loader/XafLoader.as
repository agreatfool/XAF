package com.xenojoshua.af.utils.loader
{
	import com.greensock.events.LoaderEvent;
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
				vars = this.buildLoaderVars();
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
		
		/**
		 * Default onComplete handler.
		 * @param LoaderEvent e
		 * @return void
		 */
		private function onComplete(e:LoaderEvent):void
		{
			XafConsole.instance.log(XafConsole.INFO, "Resources loading completed! " + e.target + " is complete!");
		}
		
		/**
		 * Default onProgress handler.
		 * @param LoaderEvent e
		 * @return void
		 */
		private function onProgress(e:LoaderEvent):void
		{
			//XafConsole.instance.log(XafConsole.INFO, "Resources bytes loaded: " + this._loader.bytesLoaded);
			//XafConsole.instance.log(XafConsole.INFO, "Resource loading progress: " + e.target.progress);
		}
		
		/**
		 * Default onError handler.
		 * @param LoaderEvent e
		 * @return void
		 */
		private function onError(e:LoaderEvent):void
		{
			XafConsole.instance.log(XafConsole.INFO, "Resources loading failed! Error occured with " + e.target + ": " + e.text);
		}
		
		/**
		 * Build LoaderMax vars.
		 * @param Function onComplete
		 * @param Function onProgress
		 * @param Function onError
		 * @param String name default "XafLoader"
		 * @param Boolean auditSize default false
		 * @param uint maxConnections default 10
		 * @param Boolean skipFailed default false
		 * @return Object vars
		 */
		public function buildLoaderVars(
			onComplete:Function = null,
			onProgress:Function = null,
			onError:Function    = null,
			name:String         = "XafLoader",
			auditSize:Boolean   = false,
			maxConnections:uint = 10,
			skipFailed:Boolean  = false
		):Object
		{
			var vars:Object = {};
			
			vars["onComplete"]     = (onComplete == null) ? this.onComplete : onComplete;
			vars["onProgress"]     = (onProgress == null) ? this.onProgress : onProgress;
			vars["onError"]        = (onError == null) ? this.onError : onError;
			vars["auditSize"]      = auditSize;
			vars["name"]           = name;
			vars["maxConnections"] = maxConnections;
			vars["skipFailed"]     = skipFailed;
			
			return vars;
		}
	}
}