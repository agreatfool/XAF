package com.xenojoshua.af.utils.display
{
	import com.greensock.TweenMax;
	import com.xenojoshua.af.config.XafConfig;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class XafDisplayUtil
	{
		/**
		 * Put display object center of the stage.
		 * The registration point is the left top of the movie.
		 * @param DisplayObject display
		 * @return void
		 */
		public static function putStageCenter(display:DisplayObject):void {
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
		
		/**
		 * Put display object center of the parent.
		 * The registration point is the left top of the movie.
		 * @param DisplayObject display
		 * @param int parentWidth
		 * @param int parentHeight
		 * @return void
		 */
		public static function putParentCenter(
			display:DisplayObject,
			parentWidth:int,
			parentHeight:int
		):void {
			if (!display) {
				return;
			}
			display.x = parentWidth / 2 - display.width / 2;
			display.y = parentHeight / 2 - display.height / 2;
		}
		
		/**
		 * Clone a new display object instance.
		 * @param DisplayObject display
		 * @return DisplayObject clone
		 */
		public static function cloneDisplay(display:DisplayObject):DisplayObject {
			var cls:Class = flash.utils.getDefinitionByName(
				flash.utils.getQualifiedClassName(display)
			) as Class;
			
			return new cls();
		}
		
		/**
		 * Draw a display object into a bitmap.
		 * Commonly the display object is a picture.
		 * @param DisplayObject display
		 * @return Bitmap bitmap
		 */
		public static function cloneDisplayBitmap(display:DisplayObject):Bitmap {
			var bitmapData:BitmapData = new BitmapData(display.width, display.height);
			bitmapData.draw(display);
			return new Bitmap(bitmapData);
		}
		
		/**
		 * Show display object as stage popout (animation).
		 * @param DisplayObject display
		 * @return void
		 */
		public static function showAsStagePopout(display:DisplayObject):void {
			if (!display) {
				return;
			}
			var stageWidth:int  = XafConfig.instance.stageWidth;
			var stageHeight:int = XafConfig.instance.stageHeight;
			
			var originalWidth:int  = display.width;
			var originalHeight:int = display.height;
			var originalPosX:int   = display.x;
			var originalPosY:int   = display.y;
			
			display.x      = stageWidth / 2;
			display.y      = stageHeight / 2;
			display.width  = 1;
			display.height = 1;
			
			new TweenMax(
				display, 0.2, {
					width: originalWidth, height: originalHeight, x: originalPosX, y: originalPosY
				}
			);
		}
		
		/**
		 * Hide display object as stage popout (animation).
		 * @param DisplayObject display
		 * @param Function callback default null
		 * @return void
		 */
		public static function hideAsStagePopout(display:DisplayObject, callback:Function = null):void {
			if (!display) {
				return;
			}
			var originalPosX:int = display.width / 2;
			var originalPosY:int = display.height / 2;
			
			var vars:Object = {
				width: 1, height: 1, x: originalPosX, y: originalPosY
			};
			if (callback != null) {
				vars.onComplete = callback;
			}
			
			new TweenMax(display, 0.2, vars);
		}
		
		/**
		 * Apply a black filter to a display object.
		 * @param DisplayObject display
		 * @return void
		 */
		public static function applyBlackFilter(display:DisplayObject):void {
			var rLum:Number = 0.2225;
			var gLum:Number = 0.7169;
			var bLum:Number = 0.0606;
			var matrix:Array = [
				rLum, gLum, bLum, 0, 0, // red
				rLum, gLum, bLum, 0, 0, // green
				rLum, gLum, bLum, 0, 0, // blue
				0,    0,    0,    1, 0  // alpha
			];
			display.filters = [new ColorMatrixFilter(matrix)];
		}
		
		/**
		 * Clean the display filters of the display object.
		 * @param DisplayObject display
		 * @return void
		 */
		public static function cleanDisplayFilter(display:DisplayObject):void {
			display.filters = [];
		}
	}
}