package com.xenojoshua.af.utils.mask
{
	import com.xenojoshua.af.config.XafConfig;
	import com.xenojoshua.af.constant.XafConst;
	import com.xenojoshua.af.display.screen.XafScreenManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	public class XafMaskMaker
	{
		private static var _maker:XafMaskMaker;
		
		private var _masks:Dictionary; // <display:DisplayObject, mask:Sprite>
		
		/**
		 * Get instance of XafMaskMaker.
		 * @return XafMaskMaker _maker
		 */
		public static function get instance():XafMaskMaker
		{
			if (!XafMaskMaker._maker) {
				XafMaskMaker._maker = new XafMaskMaker();
			}
			return XafMaskMaker._maker;
		}
		
		/**
		 * Initialize XafMaskMaker.
		 * @return void
		 */
		public function XafMaskMaker()
		{
			this._masks = new Dictionary();
		}
		
		/**
		 * Make a mask.
		 * Purpose1: Add a background mask after the DisplayObject "display", if "display" has a parent.
		 * Purpose2: Add a global mask before everything on the game screen layer, if "display" has no parent.
		 * @param DisplayObject display
		 * @param Number alpha
		 * @return void
		 */
		public function makeMask(display:DisplayObject, alpha:Number = 0.3):void
		{
			var mask:Sprite = new Sprite();
			var graph:Graphics = mask.graphics;
			graph.beginFill(0x000000, alpha);
			
			var parent:DisplayObjectContainer = display.parent;
			if (parent) {
				graph.drawRect(0, 0, parent.width, parent.height);
				graph.endFill();
				parent.addChildAt(mask, parent.getChildIndex(display));
			} else {
				graph.drawRect(0, 0, XafConfig.instance.stageWidth, XafConfig.instance.stageHeight);
				graph.endFill();
				XafScreenManager.instance.getLayer(XafConst.SCREEN_GAME).addChild(mask);
			}
			
			this._masks[display] = mask;
		}
		
		/**
		 * Remove a mask form DisplayObject "display".
		 * @param DisplayObject display
		 * @return void
		 */
		public function removeMask(display:DisplayObject):void
		{
			var mask:Sprite = this._masks[display];
			if(mask && mask.parent) {
				mask.parent.removeChild(mask);
			}
			
			this._masks[display] = null;
			delete this._masks[display];
		}
	}
}