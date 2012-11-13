package com.xenojoshua.af.config
{
	public class XafConfig
	{
		private static var _config:XafConfig;
		
		private var _mediaHost:String;
		private var _apiHost:String;
		
		private var _stageWidth:uint;
		private var _stageHeight:uint;
		
		/**
		 * Get instance of XafConfig.
		 * @return XafConfig _config
		 */
		public static function get instance():XafConfig {
			if (!XafConfig._config) {
				XafConfig._config = new XafConfig();
			}
			return XafConfig._config;
		}
		
		public function XafConfig() {}
		
		public function set mediaHost(host:String):void { this._mediaHost = host; }
		public function get mediaHost():String { return this._mediaHost; }
		
		public function set apiHost(host:String):void { this._apiHost = host; }
		public function get apiHost():String { return this._apiHost; }
		
		public function set stageWidth(width:uint):void { this._stageWidth = width; }
		public function get stageWidth():uint { return this._stageWidth; }
		
		public function set stageHeight(height:uint):void { this._stageHeight = height; }
		public function get stageHeight():uint { return this._stageHeight; }
	}
}