package com.xenojoshua.af.exception
{
	public class XafExManager
	{
		private static var _mgr:XafExManager;
		
		private var _msg:Object = { // <exceptionId:int, message:String>
			10000: 'XafScreenManager: Root layer should be registered before other layers!',
			10001: 'XafScreenManager: Root layer cannot be registered as empty display object container!',
			10002: 'XafScreenManager: Screen layer specified not registered!',
			10003: 'XafRsManager: Resource url not defined!',
			10004: 'XafRsManager: Resource type invalid!'
		};
		
		/**
		 * Get instance of XafExManager.
		 * @return XafExManager _mgr
		 */
		public static function get instance():XafExManager
		{
			if (!XafExManager._mgr) {
				XafExManager._mgr = new XafExManager();
			}
			return XafExManager._mgr;
		}
		
		/**
		 * Get exception message from exception id.
		 * @param int exId
		 * @return String message
		 */
		public function getExMsg(exId:int):String
		{
			return this._msg[exId];
		}
		
		/**
		 * Add more exception messages into manager.
		 * @param Object messages
		 * @return void
		 */
		public function registerMessages(messages:Object):void
		{
			if (messages) {
				for (var key:String in messages) {
					this._msg[key] =  messages[key];
				}
			}
		}
	}
}