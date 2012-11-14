package com.xenojoshua.af.utils.font
{
	import com.xenojoshua.af.utils.console.XafConsole;
	
	import flash.text.Font;
	import flash.utils.getQualifiedClassName;

	public class XafFontManager
	{
		private static var _mgr:XafFontManager;
		
		/**
		 * Get instance of XafFontManager.
		 * @return XafFontManager _mgr
		 */
		public static function get instance():XafFontManager {
			if (!XafFontManager._mgr) {
				XafFontManager._mgr = new XafFontManager();
			}
			return XafFontManager._mgr;
		}
		
		/**
		 * Register one font class.
		 * @param Class cls font class
		 * @return void
		 */
		public function registerFont(cls:Class):void {
			XafConsole.instance.log(XafConsole.INFO, 'XafFontManager: FONT "' + flash.utils.getQualifiedClassName(cls) + '" registered!');
			Font.registerFont(cls);
		}
	}
}