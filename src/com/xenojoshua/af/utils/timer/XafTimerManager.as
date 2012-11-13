package com.xenojoshua.af.utils.timer
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	public class XafTimerManager
	{
		private static var _mgr:XafTimerManager;
		
		private var _timers:Dictionary; // <name:String, timer:Timer>
		
		/**
		 * Get instance of XafTimerManager.
		 * @return XafTimerManager _mgr
		 */
		public static function get instance():XafTimerManager {
			if (!XafTimerManager._mgr) {
				XafTimerManager._mgr = new XafTimerManager();
			}
			return XafTimerManager._mgr;
		}
		
		/**
		 * Initialize XafTimerManager.
		 * @return void
		 */
		public function XafTimerManager() {
			this._timers = new Dictionary();
		}
		
		/**
		 * Get timer according to name.
		 * @param String name
		 * @return Timer timer
		 */
		public function getTimer(name:String):Timer {
			return this._timers[name];
		}
		
		/**
		 * Register one new timer.
		 * @param String name
		 * @param int delay
		 * @param Function onTime
		 * @param int repeatCount default 0
		 * @param Function onComplete
		 * @return Timer timer
		 */
		public function registerTimer(
			name:String,
			delay:int, 
			onTime:Function,
			repeatCount:int = 0,
			onComplete:Function = null
		):Timer {
			var timer:Timer = new Timer(delay, repeatCount);
			timer.addEventListener(TimerEvent.TIMER, onTime);
			if (null != onComplete) {
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
			}
			timer.start();
			this._timers[name] = timer;
			
			return timer;
		}
		
		/**
		 * Destory one registered timer.
		 * @param String name
		 * @return void
		 */
		public function destoryTimer(name:String):void {
			var timer:Timer = this._timers[name];
			if (timer) {
				timer.stop();
				timer = null;
				this._timers[name] = null;
				delete this._timers[name];
			}
		}
	}
}