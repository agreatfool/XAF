package com.xenojoshua.af.utils.font
{
	import com.xenojoshua.af.utils.console.XafConsole;
	
	import flash.display.DisplayObjectContainer;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
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
		 * Initialize XafFontManager.
		 * @return void
		 */
		public function XafFontManager() {
			this._embeddedFonts = new Object();
			
			var currentChineseWeight:int = 100;
			var currentEnglishWeight:int = 100;
			var fonts:Array = Font.enumerateFonts(true).sortOn('fontName', Array.DESCENDING);
			
			for each (var font:Font in fonts) {
				if (this._chineseWishList.hasOwnProperty(font.fontName) // font exists
					&& this._chineseWishList[font.fontName] <= currentChineseWeight) { // font's privilege is higher than current font 
					this._defaultChineseFont = font.fontName;
					currentChineseWeight = this._chineseWishList[font.fontName];
				} else if (this._englishWishList.hasOwnProperty(font.fontName) // font exists
							&& this._englishWishList[font.fontName] <= currentEnglishWeight) { // font's privilege is higher than current font
					this._defaultEnglishFont = font.fontName;
					currentEnglishWeight = this._englishWishList[font.fontName];
				}
			}
		}
		
		private var _chineseWishList:Object = {'宋体':0, '黑体':1, '微软雅黑':2, '仿宋':3}; // <fontName:String, fontWeight:int>
		private var _englishWishList:Object = {'Courier':0, 'Arial':1}; // <fontName:String, fontWeight:int>
		
		private var _defaultChineseFont:String;
		private var _defaultEnglishFont:String;
		
		private var _embeddedFonts:Object; // <fontName:String, fontName:String>
		
		/**
		 * Validate & return embedded font name.
		 * If null given, the first enbedded font given.
		 * @param String fontName default null
		 * @return String fontName
		 */
		public function getEmbeddedFont(fontName:String = null):String {
			var name:String = null;
			
			if (!this._embeddedFonts) { // no font embedded yet
				name = this._defaultChineseFont;
			} else if (fontName == null // no font name specified
						|| !this._embeddedFonts.hasOwnProperty(fontName)) { // specified font name not registered
				for (var embeddedFontName:String in this._embeddedFonts) {
					name = embeddedFontName;
					break;
				}
			}
			
			return name;
		}
		
		/**
		 * Format font of TextField.
		 * @param TextField field
		 * @param String fontName default null
		 * @return void
		 */
		public function formatTextFont(field:TextField, fontName:String = null):void {
			var format:TextFormat = field.getTextFormat();
			
			if (fontName == null) {
				format.font = this._defaultChineseFont;
				field.embedFonts = false;
			} else {
				format.font = fontName;
				field.embedFonts = true;
			}
			
			field.setTextFormat(format);
			field.defaultTextFormat = format;
		}
		
		/**
		 * Format font of all TextField(s) in a DisplayObjectContainer.
		 * @param DisplayObjectContainer container
		 * @param String fontName default null
		 * @return void
		 */
		public function formatTextFonts(container:DisplayObjectContainer, fontName:String = null):void {
			var totalChildNum:int = container.numChildren;
			
			for (var index:int = 0; index < totalChildNum; ++index) {
				var child:Object = container.getChildAt(index);
				if (child is TextField) {
					this.formatTextFont(child as TextField, fontName);
				}
			}
		}
		
		/**
		 * Register one font class.
		 * @param String fontName
		 * @param String fontClassName
		 * @param Class fontClass
		 * @return void
		 */
		public function registerFont(fontName:String, fontClassName:String, fontClass:Class):void {
			Font.registerFont(fontClass);
			this._embeddedFonts[fontName] = fontName;
			XafConsole.instance.log(XafConsole.INFO, 'XafFontManager: FONT "' + fontName + '" of CLASS "' + fontClassName + '" registered!');
		}
		
		public function get defaultChineseFont():String { return this._defaultChineseFont; }
		public function get defaultEnglishFont():String { return this._defaultEnglishFont; }
	}
}