package com.xenojoshua.af.utils.time
{
	public class XafTime
	{
		/**
		 * Get now timestamp.
		 * @return Number timestamp
		 */
		public static function getTime():Number {
			return Math.round((new Date()).valueOf() / 1000); // millisecond to second
		}
		
		/**
		 * Get timestamp from timeString, or now(null given).
		 * @param String timeString default null
		 * @return Number timestamp
		 */
		public static function getTimestamp(timeString:String = null):Number {
			var date:Date = new Date();
			
			var pattern:RegExp = /(\d\d\d\d)-(\d\d)-(\d\d) (\d\d):(\d\d):(\d\d)/; 
			var timeParts:Array = pattern.exec(timeString);
			
			if (null != timeParts) { // null means RegExp match failed, time string invalid
				date.setFullYear(timeParts[1]);
				date.setMonth(timeParts[2] - 1);
				date.setDate(timeParts[3]);
				date.setHours(timeParts[4]);
				date.setMinutes(timeParts[5]);
				date.setSeconds(timeParts[6]);
			}
			
			return Math.round(date.valueOf() / 1000); // millisecond to second
		}
		
		/**
		 * Get 'YYYY-mm-dd HH:mm:ss' time string, from timestamp given or now(0 given).
		 * @param Number timestamp
		 * @return String time
		 */
		public static function setTime(timestamp:Number = 0):String {
			var date:Date = (timestamp == 0) ? new Date() : new Date(timestamp * 1000);
			
			var H:String = XafTime.formatDateNumber((date.getHours()).toString());
			var m:String = XafTime.formatDateNumber((date.getMinutes()).toString());
			var s:String = XafTime.formatDateNumber((date.getSeconds()).toString());
			
			return XafTime.getDate(timestamp) + " " + H + ":" + m + ":" + s;
		}
		
		/**
		 * Get 'YYYY-mm-dd' date string, from timestamp given or now(0 given).
		 * @param Number timestamp default 0
		 * @return String date
		 */
		public static function getDate(timestamp:Number = 0):String {
			var date:Date = (timestamp == 0) ? new Date() : new Date(timestamp * 1000);
			
			var Y:String = date.getFullYear().toString();
			var m:String = XafTime.formatDateNumber((date.getMonth() + 1).toString());
			var d:String = XafTime.formatDateNumber((date.getDate()).toString());
			
			return Y + "-" + m + "-" + d;
		}
		
		/**
		 * Format date | time | second ... from '1' to '01'.
		 * @param String num
		 * @return String num
		 */
		private static function formatDateNumber(num:String):String {
			if (num.length == 1) {
				num = "0" + num;
			}
			
			return num;
		}
	}
}