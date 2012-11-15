package com.xenojoshua.af.config
{
	import com.xenojoshua.af.exception.XafException;
	import com.xenojoshua.af.utils.console.XafConsole;

	public class XafConfig
	{
		private static var _config:XafConfig;
		
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
		
		/**
		 * Initialize XafConfig.
		 * @return void
		 */
		public function XafConfig() {
			this._configs = new Object();
		}
		
		private var _isLocal:Boolean;
		
		private var _playerId:int;
		
		private var _mediaHost:String;
		private var _apiHost:String;
		
		private var _stageWidth:uint;
		private var _stageHeight:uint;
		
		private var _configs:Object; // <name:String, configs:Object>
		
		/**
		 * Register configs into config manager.
		 * @param String name
		 * @param Object configs
		 * @return void
		 */
		public function registerConfigs(name:String, configs:Object):void {
			this._configs[name] = configs;
			XafConsole.instance.log(XafConsole.INFO, 'XafConfig: Config file with name "' + name + '" registered!');
		}
		
		/**
		 * Get configs from registered "configName".
		 * @param String configName
		 * @return Object value
		 */
		public function loadConfigs(configName:String):Object {
			var value:Object = null;
			
			if (!this._configs.hasOwnProperty(configName)) {
				XafConsole.instance.log(XafConsole.ERROR, 'XafConfig: Config file with name "' + configName + '" not registered!');
			} else {
				value = this._configs[configName];
			}
			
			return value;
		}
		
		/**
		 * Get config from registered "configName" with "key".
		 * @param String configName
		 * @param String key
		 * @return * value
		 */
		public function loadConfig(configName:String, key:String):* {
			var value:* = null;
			
			if (!this._configs.hasOwnProperty(configName)) {
				XafConsole.instance.log(XafConsole.ERROR, 'XafConfig: Config file with name "' + configName + '" not registered!');
			} else if (!this._configs[configName].hasOwnProperty(key)) {
				XafConsole.instance.log(XafConsole.ERROR, 'XafConfig: Config with key "' + key + '" not found in file "' + configName + '"!');
			} else {
				value = this._configs[configName][key]
			}
			
			return value;
		}
		
		public function set isLocal(val:Boolean):void     { this._isLocal = val; }
		public function get isLocal():Boolean             { return this._isLocal; }
		
		public function set playerId(id:int):void         { this._playerId = id; }
		public function get playerId():int                { return this._playerId; }
		
		public function set mediaHost(host:String):void   { this._mediaHost = host; }
		public function get mediaHost():String            { return this._mediaHost; }
		
		public function set apiHost(host:String):void     { this._apiHost = host; }
		public function get apiHost():String              { return this._apiHost; }
		
		public function set stageWidth(width:uint):void   { this._stageWidth = width; }
		public function get stageWidth():uint             { return this._stageWidth; }
		
		public function set stageHeight(height:uint):void { this._stageHeight = height; }
		public function get stageHeight():uint            { return this._stageHeight; }
	}
}