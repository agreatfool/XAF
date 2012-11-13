package com.xenojoshua.af.utils.font
{
	import flash.text.Font;

	public class XafFontManager
	{
		/**
		 * Register one font class.
		 * @param Class cls font class
		 * @return void
		 */
		public static function registerFont(cls:Class):void {
			Font.registerFont(cls);
		}
	}
}