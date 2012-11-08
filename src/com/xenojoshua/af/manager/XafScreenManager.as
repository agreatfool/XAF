package com.xenojoshua.af.manager
{
	import com.xenojoshua.af.utils.console.XafConsole;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	public class XafScreenManager
	{
		private static var _mgr:XafScreenManager;
		
		private var _screenLayers:Dictionary; // <name:String, layer:DisplayObjectContainer>
		
		public function XafScreenManager()
		{
			this._screenLayers = new Dictionary();
		}
		
		public static function instance():XafScreenManager
		{
			if (!XafScreenManager._mgr) {
				XafScreenManager._mgr = new XafScreenManager();
			}
			return XafScreenManager._mgr;
		}
		
		/**
		 * Register one new display layer.
		 * @param String name
		 * @param DisplayObjectContainer layer
		 * @return DisplayObjectContainer layer
		 */
		public function registerLayer(name:String, layer:DisplayObjectContainer):DisplayObjectContainer
		{
			if (!this._screenLayers.hasOwnProperty(name)) {
				this._screenLayers[name] = layer;
			}
			return layer;
		}
		
		/**
		 * Get one registered display layer. null returned if this layer is not registered.
		 * @param String name
		 * @return DisplayObjectContainer layer
		 */
		public function getLayer(name:String):DisplayObjectContainer
		{
			var layer:DisplayObjectContainer = null;
			
			if (!this._screenLayers.hasOwnProperty(name)) {
				XafConsole.instance.log('Screen layer "' + name + '" not registered!');
			} else {
				layer = this._screenLayers[name];
			}
			
			return layer;
		}
		
		/**
		 * Set one layer visible or not.
		 * @param String name
		 * @param Boolean visibility
		 * @return void
		 */
		public function setVisibility(name:String, visibility:Boolean):void
		{
			var layer:DisplayObjectContainer = null;
			
			if (!this._screenLayers.hasOwnProperty(name)) {
				XafConsole.instance.log('Screen layer "' + name + '" not registered!');
			} else {
				layer = this._screenLayers[name];
				layer.visible = visibility;
			}
		}
	}
}