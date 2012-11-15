package com.xenojoshua.af.utils.console
{
	import com.xenojoshua.af.config.XafConfig;
	import com.xenojoshua.af.constant.XafConst;
	import com.xenojoshua.af.mvc.view.screen.XafScreenManager;
	import com.xenojoshua.af.exception.XafException;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import net.hires.debug.Stats;
	
	public class XafConsole extends Sprite
	{
		private static var _console:XafConsole;
		
		/**
		 * Get instance of XafConsole.
		 * @return XafConsole _console
		 */
		public static function get instance():XafConsole {
			if (!XafConsole._console) {
				XafConsole._console = new XafConsole();
			}
			return XafConsole._console;
		}
		
		/**
		 * Restart & redraw console instance.
		 * It would be called after layer registration done,
		 * console UI is possible to be initialized.
		 * @return XafConsole _console
		 */
		public static function restart():XafConsole {
			var currLogLevel:int = XafConsole.instance.logLevel;
			XafConsole._console = new XafConsole(currLogLevel);
			
			return XafConsole._console;
		}
		
		public static const DEBUG:int   = 0;
		public static const INFO:int    = 1;
		public static const NOTICE:int  = 2;
		public static const WARNING:int = 3;
		public static const ERROR:int   = 4;
		private static const LOG_LEVELS:Object = {
			0: 'DEBUG',
			1: 'INFO',
			2: 'NOTICE',
			3: 'WARNING',
			4: 'ERROR'
		};
		private var _logLevel:int = 0; // default debug level
		
		internal var _consoleField:TextField; 
		private  var _fpStats:Stats;
		private  var _switchBtn:SimpleButton;
		
		private  var _isConsoleVisible:Boolean = false;
		
		private  var _settings:Object = {
			consolePosId:        2, // 0 leftTop, 1 rightTop, 2 leftBottom, 3 rightBottom
			consoleWidth:        760,
			consoleHeight:       100,
			fpStatsWidth:        70,
			fpStatsHeight:       100,
			consoleFieldBgColor: 0xffffff,
			consoleFieldAlpha:   0.6,
			switchBtnWidth:      10,
			switchBtnHeight:     30,
			switchBtnUpColor:    0x0099FF,
			switchBtnDownColor:  0xFFCC00,
			switchBtnOverColor:  0x9966FF
		};
		
		private var _isUIEnabled:Boolean;
		
		/**
		 * Constructor. Draw everything and add into console layer.
		 * @param int logLevel default 0, DEBUG level
		 * @return void
		 */
		public function XafConsole(logLevel:int = 0) {
			super();
			
			// check screen layer registration
			try {
				XafScreenManager.instance.getLayer(XafConst.SCREEN_CONSOLE);
				this._isUIEnabled = true;
			} catch (e:XafException) {
				if (e.errorID == 10002) { // console layer not registered
					this._isUIEnabled = false;
				}
			}
			// draw UI
			if (this._isUIEnabled) {
				this.drawUI();
			}
			
			this._logLevel = logLevel;
		}
		
		/**
		 * Log message into the console.
		 * @param int logLevel
		 * @param String msg
		 * @return void
		 */
		public function log(logLevel:int, msg:String):void {
			if (logLevel >= this._logLevel) {
				msg = "[" + this.getLogLevelName(logLevel) + "]: " + msg;
				if (this._isUIEnabled) { // UI enabled
					this._consoleField.appendText("\n" + msg);
					this._consoleField.scrollV = this._consoleField.maxScrollV;
				}
				trace(msg);
			}
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* UTILITIES
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Set console log level.
		 * @param int logLevel
		 * @return void
		 */
		public function set logLevel(logLevel:int):void {
			if (XafConsole.LOG_LEVELS.hasOwnProperty(logLevel)) {
				this._logLevel = logLevel;
			}
		}
		
		/**
		 * Get console log level.
		 * @return int logLevel
		 */
		public function get logLevel():int {
			return this._logLevel;
		}
		
		/**
		 * Get log level name.
		 * @param int logLevel
		 * @return String name
		 */
		private function getLogLevelName(logLevel:int):String {
			return XafConsole.LOG_LEVELS[logLevel];
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* UI FUNCTIONS
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Draw console UI.
		 * @return void
		 */
		private function drawUI():void {
			this.initFPStats();
			this.initConsoleField();
			this.initSwitchBtn();
			this.initConsole();
			XafScreenManager.instance.getLayer(XafConst.SCREEN_CONSOLE).addChild(this);
		}
		
		/**
		 * Init console container.
		 * @return void
		 */
		private function initConsole():void {
			this.width = this._settings.consoleWidth;
			this.height = this._settings.consoleHeight;
			
			this.x = 0;
			if (this._settings.consolePosId <= 1) { // top
				this.y = 0;
			} else if (this._settings.consolePosId >= 2) { // bottom
				this.y = XafConfig.instance.stageHeight - this._settings.consoleHeight;
			}
			this.mouseEnabled = false;
			this.scaleX = this.scaleY = 1; // set it back to 1, since it will be calculated to bigger than 1 
		}
		
		/**
		 * Draw fps status & add it into console.
		 * @return void
		 */
		private function initFPStats():void {
			this._fpStats = new Stats();
			
			// determine y position
			if (this._settings.consolePosId <= 1) { // top
				this._fpStats.y = 0
			} else if (this._settings.consolePosId >= 2) { // bottom
				this._fpStats.y = this._settings.consoleHeight - this._settings.fpStatsHeight;
			}
			// determine x position
			if (-1 != [0, 2].indexOf(this._settings.consolePosId)) { // left
				this._fpStats.x = 0;
			} else if (-1 != [1, 3].indexOf(this._settings.consolePosId)) { // right
				this._fpStats.x = this._settings.consoleWidth - this._settings.fpStatsWidth;
			}
			
			this.addChild(this._fpStats);
		}
		
		/**
		 * Draw console text field & add it into console.
		 * @return void
		 */
		private function initConsoleField():void {
			this._consoleField = new TextField();
			this._consoleField.backgroundColor = this._settings.consoleFieldBgColor;
			this._consoleField.background = true;
			
			var fmt:TextFormat = this._consoleField.getTextFormat(); // fmt.color = 0x00ff00;
			this._consoleField.defaultTextFormat = fmt;
			this._consoleField.setTextFormat(fmt);
			this._consoleField.multiline = true;
			this._consoleField.wordWrap = true;
			
			this._consoleField.text = "-----console-----";
			this._consoleField.alpha = this._settings.consoleFieldAlpha;
			
			this._consoleField.width = XafConfig.instance.stageWidth - this._settings.fpStatsWidth;
			this._consoleField.height = this._settings.consoleHeight;
			
			if (-1 != [0, 2].indexOf(this._settings.consolePosId)) { // left
				this._consoleField.x = this._settings.fpStatsWidth;
			} else if (-1 != [1, 3].indexOf(this._settings.consolePosId)) { // right
				this._consoleField.x = XafConfig.instance.stageWidth - this._settings.fpStatsWidth;
			}
			
			this.addChild(this._consoleField);
		}
		
		/**
		 * Drow switcher button & add it into this._fpStats.
		 * @return void
		 */
		private function initSwitchBtn():void {
			this._switchBtn = new SimpleButton();
			
			var switchBtnXPos:int = this._settings.fpStatsWidth - this._settings.switchBtnWidth - 5;
			
			var down:Sprite = new Sprite();
			down.graphics.lineStyle(1, 0x000000);
			down.graphics.beginFill(this._settings.switchBtnDownColor);
			down.graphics.drawRect(switchBtnXPos, 0, this._settings.switchBtnWidth, this._settings.switchBtnHeight);
			
			var up:Sprite = new Sprite();
			up.graphics.lineStyle(1, 0x000000);
			up.graphics.beginFill(this._settings.switchBtnUpColor);
			up.graphics.drawRect(switchBtnXPos, 0, this._settings.switchBtnWidth, this._settings.switchBtnHeight);
			
			var over:Sprite = new Sprite();
			over.graphics.lineStyle(1, 0x000000);
			over.graphics.beginFill(this._settings.switchBtnOverColor);
			over.graphics.drawRect(switchBtnXPos, 0, this._settings.switchBtnWidth, this._settings.switchBtnHeight);
			
			this._switchBtn.upState = up;
			this._switchBtn.overState = over;
			this._switchBtn.downState = down;
			this._switchBtn.useHandCursor = true;
			this._switchBtn.hitTestState = up;
			
			this._switchBtn.addEventListener(MouseEvent.CLICK, this.onSwitchBtnClick);
			
			this._fpStats.addChild(this._switchBtn);
			this._consoleField.visible = this._isConsoleVisible;
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* CLICK EVENT
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Switcher button click event, display | hide console.
		 * @param MouseEvent event
		 * @return void
		 */
		protected function onSwitchBtnClick(event:MouseEvent):void {
			this._isConsoleVisible = !this._isConsoleVisible;
			this._consoleField.visible = this._isConsoleVisible;
		}
	}
}