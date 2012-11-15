package com.xenojoshua.af.mvc.controller.event
{
	import flash.events.Event;
	
	public class XafEvent extends Event
	{
		private var _data:Object;
		
		/**
		 * Initialize XafEvent.
		 * @param String type
		 * @param Boolean bubbles
		 * @param Boolean cancelable
		 * @return void
		 */
		public function XafEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		public function get data():Object          { return this._data; }
		public function set data(val:Object):void  { this._data = val; }
	}
}