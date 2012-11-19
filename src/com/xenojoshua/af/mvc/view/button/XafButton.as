package com.xenojoshua.af.mvc.view.button
{
	import com.xenojoshua.af.utils.font.XafFontManager;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.osflash.signals.Signal;

	public class XafButton
	{
		private static var STAT_NORMAL:int   = 1;
		private static var STAT_OVER:int     = 2;
		private static var STAT_DOWN:int     = 3;
		private static var STAT_DISABLE:int  = 4;
		private static var STAT_SELECTED:int = 5;
		
		private static const TEXTFIELD_NAME_PREFIX:String = 't';
		
		private var _clickSignal:Signal;
		
		private var _buttonMovie:MovieClip;
		private var _buttonText:String;
		private var _buttonFont:String;
		private var _isDisabled:Boolean;
		private var _isSelected:Boolean;
		
		/**
		 * Initialize XafButton.
		 * @param MovieClip movie
		 * @param String text
		 * @param String fontName
		 * @return void
		 */
		public function XafButton(movie:MovieClip, text:String = '', fontName:String = null) {
			// set params
			this._buttonMovie = movie;
			this._buttonText = text;
			this._buttonFont = fontName ? fontName : XafFontManager.instance.defaultChineseFont;
			
			// format font & set text
			if (this._buttonFont) {
				for (var i:int = 1; i <= 5; ++i) {
					var field:TextField = this.getButtonTextField(i);
					if (field) {
						XafFontManager.instance.formatTextFont(field, this._buttonFont);
					}
				}
			}
			if (this._buttonText) {
				this.setText(this._buttonText);
			}
			
			// format button style
			this._buttonMovie.mouseChildren = false;
			this._buttonMovie.useHandCursor = this._buttonMovie.buttonMode = true;
			this._buttonMovie.gotoAndStop(XafButton.STAT_NORMAL);
			this.showTextField(XafButton.STAT_NORMAL);
			
			// add action listeners
			this._buttonMovie.addEventListener(MouseEvent.ROLL_OVER,  this.onOver);
			this._buttonMovie.addEventListener(MouseEvent.ROLL_OUT,   this.onOut);
			this._buttonMovie.addEventListener(MouseEvent.MOUSE_DOWN, this.onDown);
			this._buttonMovie.addEventListener(MouseEvent.MOUSE_UP,   this.onUp);
			this._buttonMovie.addEventListener(MouseEvent.CLICK,      this.onClick);
			
			this._clickSignal = new Signal();
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* OPEN APIS
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Disable the button.
		 * @return void
		 */
		public function disable():void {
			if (this._isDisabled) {
				return;
			}
			this._buttonMovie.gotoAndStop(XafButton.STAT_DISABLE);
			this.showTextField(XafButton.STAT_DISABLE);
			this._buttonMovie.useHandCursor = this._buttonMovie.buttonMode = false;
			this._isDisabled = true;
		}
		
		/**
		 * Enable the button.
		 * @return void
		 */
		public function enable():void {
			if (!this._isDisabled) {
				return;
			}
			if (this._isSelected) {
				this._buttonMovie.gotoAndStop(XafButton.STAT_SELECTED);
				this.showTextField(XafButton.STAT_SELECTED);
			} else {
				this._buttonMovie.gotoAndStop(XafButton.STAT_NORMAL);
				this.showTextField(XafButton.STAT_NORMAL);
			}
			this._buttonMovie.useHandCursor = this._buttonMovie.buttonMode = true;
			this._isDisabled = false;
		}
		
		/**
		 * Select the button.
		 * @param Boolean value indicate whether button selected
		 * @return void
		 */
		public function set selected(value:Boolean):void {
			this._isSelected = value;
			if (this._isSelected) {
				this._buttonMovie.gotoAndStop(XafButton.STAT_SELECTED);
				this.showTextField(XafButton.STAT_SELECTED);
			} else {
				if(this._isDisabled) {
					this._buttonMovie.gotoAndStop(XafButton.STAT_DISABLE);
					this.showTextField(XafButton.STAT_DISABLE);
				} else {
					this._buttonMovie.gotoAndStop(XafButton.STAT_NORMAL);
					this.showTextField(XafButton.STAT_NORMAL);
				}
			}
		}
		
		/**
		 * Set text content into all TextField(s) in movie.
		 * @param String text
		 * @return void
		 */
		public function setText(text:String):void {
			this._buttonText = text;
			for (var i:int = 1; i <= 5; ++i) {
				var field:TextField = this.getButtonTextField(i);
				if (field) {
					(field as TextField).text = text;
				}
			}
		}
		
		/**
		 * Display specified index TextField, hide others.
		 * @param int index
		 * @return void
		 */
		public function showTextField(index:int):void {
			for (var i:int = 1; i <= 5; ++i) {
				var field:TextField = this.getButtonTextField(index);
				if (!field) {
					continue;
				}
				if (i == index) {
					(field as TextField).visible = true;
				} else {
					(field as TextField).visible = false;
				}
			}
		}
		
		/**
		 * Distory button action listeners.
		 * @return void
		 */
		public function dispose():void {
			this._buttonMovie.removeEventListener(MouseEvent.ROLL_OVER,  this.onOver);
			this._buttonMovie.removeEventListener(MouseEvent.ROLL_OUT,   this.onOut);
			this._buttonMovie.removeEventListener(MouseEvent.MOUSE_DOWN, this.onDown);
			this._buttonMovie.removeEventListener(MouseEvent.MOUSE_UP,   this.onUp);
			this._buttonMovie.removeEventListener(MouseEvent.CLICK,      this.onClick);
			this._clickSignal.removeAll();
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* EVENTS
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Register one click callback function.
		 * @param Function callback
		 * @return void
		 */
		public function registerClickCallback(callback:Function):void {
			this._clickSignal.add(callback);
		}
		
		/**
		 * Button event on out.
		 * @param MouseEvent e
		 * @return void
		 */
		private function onOut(e:MouseEvent):void {
			if (this._isDisabled || this._isSelected) {
				return;
			}
			this._buttonMovie.gotoAndStop(XafButton.STAT_NORMAL);
			this.showTextField(XafButton.STAT_NORMAL);
		}
		
		/**
		 * Button event on down.
		 * @param MouseEvent e
		 * @return void
		 */
		private function onDown(e:MouseEvent):void {
			if (this._isDisabled || this._isSelected) {
				return;
			}
			if (this._buttonMovie.totalFrames < XafButton.STAT_DOWN) {
				// max status if 5 status, and it's possible to be only 1 or 2 status
				// and at that time, there is only 1 or 2 frames in the button movie
				XafButton.STAT_DOWN = this._buttonMovie.totalFrames;
			}
			this._buttonMovie.gotoAndStop(XafButton.STAT_DOWN);
			this.showTextField(XafButton.STAT_DOWN);
		}
		
		/**
		 * Button event on up.
		 * @param MouseEvent e
		 * @return void
		 */
		private function onUp(e:MouseEvent):void {
			if (this._isDisabled || this._isSelected) {
				return;
			}
			this._buttonMovie.gotoAndStop(XafButton.STAT_NORMAL);
			this.showTextField(XafButton.STAT_NORMAL);
		}
		
		/**
		 * Button event on click.
		 * @param MouseEvent e default null
		 * @return void
		 */
		private function onClick(e:MouseEvent = null):void {
			if (this._isDisabled) {
				return;
			}
			this._clickSignal.dispatch(e);
		}
		
		/**
		 * Button on over event.
		 * @param MouseEvent e
		 * @return void
		 */
		private function onOver(e:MouseEvent):void {
			if (this._isDisabled || this._isSelected) {
				return;
			}
			this._buttonMovie.gotoAndStop(XafButton.STAT_OVER);
			this.showTextField(XafButton.STAT_OVER);
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* UTILITIES
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Get TextField from button movie.
		 * @param int index text field index
		 * @return TextField field
		 */
		private function getButtonTextField(index:int):TextField {
			var field:TextField = null;
			var tfName:String = XafButton.TEXTFIELD_NAME_PREFIX + index;
			
			if (this._buttonMovie[tfName]) {
				field = this._buttonMovie[tfName];
			}
			
			return field;
		}
		
		public function get movie():MovieClip    { return this._buttonMovie; }
		public function get isDisabled():Boolean { return this._isDisabled; }
		public function get isSelected():Boolean { return this._isSelected; }
	}
}