package com.xenojoshua.af.display.screen
{
	import com.xenojoshua.af.constant.XafConst;
	import com.xenojoshua.af.utils.console.XafConsole;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	public class XafScreenManager
	{
		private static var _mgr:XafScreenManager;
		
		private var _screenLayers:Dictionary; // <name:String, layer:DisplayObjectContainer>
		
		public function XafScreenManager()
		{
			this._screenLayers = new Dictionary();
		}
		
		public static function get instance():XafScreenManager
		{
			if (!XafScreenManager._mgr) {
				XafScreenManager._mgr = new XafScreenManager();
			}
			return XafScreenManager._mgr;
		}
		
		/**
		 * Register one new display layer.
		 * @param String name
		 * @param DisplayObjectContainer layer default null
		 * @param Boolean isRootLayer default false
		 * @param Boolean mouseEnabled default true
		 * @return DisplayObjectContainer layer
		 */
		public function registerLayer(
			name:String,
			layer:DisplayObjectContainer = null,
			isRootLayer:Boolean = false,
			mouseEnabled:Boolean = true
		):DisplayObjectContainer
		{
			if (this._screenLayers.hasOwnProperty(name)) { // already registered
				return this._screenLayers[name];
			}
			if (!isRootLayer) {
				var rootLayer:DisplayObjectContainer = this._screenLayers[XafConst.SCREEN_ROOT];
				if (null == layer) {
					layer = new Sprite();
					layer.mouseEnabled = mouseEnabled;
				}
				if (rootLayer) {
					rootLayer.addChild(layer);
				} else {
					XafConsole.instance.log(XafConsole.ERROR, 'Root layer should be registered before other layers!');
				}
			} else if (null == layer) { // root layer & layer is null INVALID
				XafConsole.instance.log(XafConsole.ERROR, 'Root layer cannot be registered as empty display object container!');
				return null;
			}
			this._screenLayers[name] = layer;
			
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
				XafConsole.instance.log(XafConsole.ERROR, 'Screen layer "' + name + '" not registered!');
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
				XafConsole.instance.log(XafConsole.ERROR, 'Screen layer "' + name + '" not registered!');
			} else {
				layer = this._screenLayers[name];
				layer.visible = visibility;
			}
		}
	}
}