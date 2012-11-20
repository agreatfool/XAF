package com.xenojoshua.af.mvc.view.screen
{
	import flash.display.Sprite;
	
	public class XafScreen extends Sprite
	{
		/**
		 * Initialize XafScreen.
		 * @return void
		 */
		public function XafScreen() {
			super();
		}
		
		/**
		 * Remove all display children.
		 * @return void
		 */
		public function removeAll():void {
			if (this.numChildren) {
				for (var index:int = 0; index < this.numChildren; ++index) {
					this.removeChildAt(index);
				}
			}
		}
	}
}