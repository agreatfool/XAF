package com.xenojoshua.af.exception
{
	import com.xenojoshua.af.utils.console.XafConsole;

	public class XafException extends Error
	{
		public function XafException(id:int = 0, message:String = "")
		{
			var console:XafConsole = XafConsole.instance;
			if (console) {
				console.log(XafConsole.ERROR, XafExManager.instance.getExMsg(id));
			} else {
				trace('[ERROR] ' + XafExManager.instance.getExMsg(id));
			}
			
			super(message, id);
		}
	}
}