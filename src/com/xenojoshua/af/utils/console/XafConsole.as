package com.xenojoshua.af.utils.console
{
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
		
		public static var DEBUG:int   = 0;
		public static var INFO:int    = 1;
		public static var NOTICE:int  = 2;
		public static var WARNING:int = 3;
		public static var ERROR:int   = 4;
		private static var LOG_LEVELS:Object = {
			0: 'DEBUG',
			1: 'INFO',
			2: 'NOTICE',
			3: 'WARNING',
			4: 'ERROR'
		};
		private var _logLevel:int = 0; // default debug level
		
		private  var _stage:Stage;
		
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
		
		/**
		 * Get instance of XafConsole.
		 * @return XafConsole _console
		 */
		public static function get instance():XafConsole
		{
			return XafConsole._console;
		}
		
		/**
		 * Initialize console instance.
		 * @param Stage stage
		 * @param int logLevel
		 * @return void
		 */
		public static function startup(stage:Stage, logLevel:int = 0):void
		{
			if (!XafConsole._console) {
				XafConsole._console = new XafConsole(stage, logLevel);
			}
		}
		
		/**
		 * Constructor. Draw everything and add into root stage.
		 * @param Stage stage
		 * @param int logLevel
		 * @return void
		 */
		public function XafConsole(stage:Stage, logLevel:int)
		{
			super();
			this._stage = stage;
			this.initFPStats();
			this.initConsoleField();
			this.initSwitchBtn();
			this.initConsole();
			this._stage.addChild(this);
			this._logLevel = logLevel;
		}
		
		/**
		 * Log message into the console.
		 * @param int logLevel
		 * @param String msg
		 * @return void
		 */
		public function log(logLevel:int, msg:String):void
		{
			if (logLevel >= this._logLevel) {
				this._consoleField.appendText("\n[" + this.getLogLevelName(logLevel) + "]: " + msg);
			}
			this._consoleField.scrollV = this._consoleField.maxScrollV;
		}
		
		/**
		 * Get log level name.
		 * @param int logLevel
		 * @return String name
		 */
		private function getLogLevelName(logLevel:int):String
		{
			return XafConsole.LOG_LEVELS[logLevel];
		}
		
		/**
		 * Set console log level.
		 * @param int logLevel
		 * @return void
		 */
		public function setLogLevel(logLevel:int):void
		{
			if (XafConsole.LOG_LEVELS.hasOwnProperty(logLevel)) {
				this._logLevel = logLevel;
			}
		}
		
		/**
		 * Init console container.
		 * @return void
		 */
		private function initConsole():void
		{
			this.width = this._settings.consoleWidth;
			this.height = this._settings.consoleHeight;
			
			this.x = 0;
			if (this._settings.consolePosId <= 1) { // top
				this.y = 0;
			} else if (this._settings.consolePosId >= 2) { // bottom
				this.y = this._stage.stageHeight - this._settings.consoleHeight;
			}
			this.mouseEnabled = false;
			this.scaleX = this.scaleY = 1; // set it back to 1, since it will be calculated to bigger than 1 
		}
		
		/**
		 * Draw fps status & add it into console.
		 * @return void
		 */
		private function initFPStats():void
		{
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
		private function initConsoleField():void
		{
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
			
			this._consoleField.width = this._stage.stageWidth - this._settings.fpStatsWidth;
			this._consoleField.height = this._settings.consoleHeight;
			
			if (-1 != [0, 2].indexOf(this._settings.consolePosId)) { // left
				this._consoleField.x = this._settings.fpStatsWidth;
			} else if (-1 != [1, 3].indexOf(this._settings.consolePosId)) { // right
				this._consoleField.x = this._stage.stageWidth - this._settings.fpStatsWidth;
			}
			
			this.addChild(this._consoleField);
		}
		
		/**
		 * Drow switcher button & add it into this._fpStats.
		 * @return void
		 */
		private function initSwitchBtn():void
		{
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
		
		/**
		 * Switcher button click event, display | hide console.
		 * @param MouseEvent event
		 * @return void
		 */
		protected function onSwitchBtnClick(event:MouseEvent):void
		{
			this._isConsoleVisible = !this._isConsoleVisible;
			this._consoleField.visible = this._isConsoleVisible;
		}
	}
}