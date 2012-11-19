package com.xenojoshua.af.utils.display
{
	import com.xenojoshua.af.config.XafConfig;
	
	import flash.display.DisplayObject;

	public class XafDisplayUtil
	{
		/**
		 * Put display object center of the stage.
		 * @param DisplayObject display
		 * @return void
		 */
		public static function putCenter(display:DisplayObject):void {
			if (!display) {
				return;
			}
			
			var positionW:uint = XafConfig.instance.stageWidth;
			var positionH:uint = XafConfig.instance.stageHeight;
			
			var maxDisplayW:int = Math.min(positionW, display.width);
			var maxDisplayH:int = Math.min(positionH, display.height);
			
			display.x = positionW / 2 - maxDisplayW / 2;
			display.y = positionH / 2 - maxDisplayH / 2;
		}
	}
}