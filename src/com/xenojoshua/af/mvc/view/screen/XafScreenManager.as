package com.xenojoshua.af.mvc.view.screen
{
	import com.xenojoshua.af.constant.XafConst;
	import com.xenojoshua.af.exception.XafException;
	import com.xenojoshua.af.utils.console.XafConsole;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class XafScreenManager
	{
		private static var _mgr:XafScreenManager;
		
		/**
		 * Get instance of XafScreenManager.
		 * @return XafScreenManager _mgr
		 */
		public static function get instance():XafScreenManager {
			if (!XafScreenManager._mgr) {
				XafScreenManager._mgr = new XafScreenManager();
			}
			return XafScreenManager._mgr;
		}
		
		private var _screenLayers:Object; // <name:String, layer:DisplayObjectContainer>
		
		/**
		 * Initialize XafScreenManager.
		 * @return void
		 */
		public function XafScreenManager() {
			this._screenLayers = new Object();
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
		):DisplayObjectContainer {
			if (this._screenLayers.hasOwnProperty(name)) { // already registered
				return this._screenLayers[name];
			}
			if (!isRootLayer) {
				var rootLayer:DisplayObjectContainer = this._screenLayers[XafConst.SCREEN_ROOT];
				if (null == layer) {
					layer = new XafScreen();
					layer.mouseEnabled = mouseEnabled;
				}
				if (rootLayer) {
					rootLayer.addChild(layer);
				} else {
					throw new XafException(10000); // root layer not registered
				}
			} else if (null == layer) { // root layer & layer is null INVALID
				throw new XafException(10001); // root layer registered as null
			}
			this._screenLayers[name] = layer;
			
			return layer;
		}
		
		/**
		 * Get one registered display layer. null returned if this layer is not registered.
		 * @param String name
		 * @return DisplayObjectContainer layer
		 */
		public function getLayer(name:String):DisplayObjectContainer {
			var layer:DisplayObjectContainer = null;
			
			if (!this._screenLayers.hasOwnProperty(name)) {
				throw new XafException(10002); // layer not registered
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
		public function setVisibility(name:String, visibility:Boolean):void {
			var layer:DisplayObjectContainer = null;
			
			if (!this._screenLayers.hasOwnProperty(name)) {
				throw new XafException(10002); // layer not registered
			} else {
				layer = this._screenLayers[name];
				layer.visible = visibility;
			}
		}
	}
}