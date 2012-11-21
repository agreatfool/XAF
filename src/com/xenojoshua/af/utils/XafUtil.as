package com.xenojoshua.af.utils
{
	import com.xenojoshua.af.config.XafConfig;

	public class XafUtil
	{
		/**
		 * Get absolute media url according to relative url.
		 * @param String url
		 * @return String url
		 */
		public static function getAbsoluteMediaUrl(url:String):String {
			return XafConfig.instance.mediaHost + url;
		}
	}
}