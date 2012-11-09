package com.xenojoshua.af.config
{
	public class XafConfig
	{
		private static var _config:XafConfig;
		
		private var _stageWidth:uint;
		private var _stageHeight:uint;
		
		/**
		 * Get instance of XafConfig.
		 * @return XafConfig _config
		 */
		public static function get instance():XafConfig
		{
			if (!XafConfig._config) {
				XafConfig._config = new XafConfig();
			}
			return XafConfig._config;
		}
		
		public function XafConfig() {}
		
		/**
		 * Set stage width.
		 * @param uint width
		 * @return void
		 */
		public function set stageWidth(width:uint):void
		{
			this._stageWidth = width;
		}
		
		/**
		 * Get stage width.
		 * @return uint _stageWidth
		 */
		public function get stageWidth():uint
		{
			return this._stageWidth;
		}
		
		/**
		 * Set stage height.
		 * @param uint height
		 * @return void
		 */
		public function set stageHeight(height:uint):void
		{
			this._stageHeight = height;
		}
		
		/**
		 * Get stage height.
		 * @return uint _stageHeight
		 */
		public function get stageHeight():uint
		{
			return this._stageHeight;
		}
	}
}