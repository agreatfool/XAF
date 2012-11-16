package com.xenojoshua.af.exception
{
	import com.xenojoshua.af.utils.console.XafConsole;

	public class XafException extends Error
	{
		public function XafException(id:int = 0, message:String = '') {
			trace('[ERROR] ' + XafExManager.instance.getExMsg(id));
			super(message, id);
		}
	}
}