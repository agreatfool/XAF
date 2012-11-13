package com.xenojoshua.af.resource
{
	public interface XafIRsConfig
	{
		/**
		 * public class AppResources implements XafIRsConfig {
		 *     public static const RESOURCE_A:String = 'rsa';
		 *     public static const RESOURCE_B:String = 'rsb';
		 *     public static const RESOURCE_C:String = 'rsc';
		 *     
		 *     private static var _configs:Object = {
		 *         rsa: {
		 *             url:     'assets/swf/main.swf',
		 *             type:    'swf',
		 *             size:    0,
		 *             preload: true,
		 *             main:    true,
		 *         },
		 *         rsb: { ... },
		 *         rsc: { ... }
		 *     };
		 *     
		 *     public static function getConfigs():Object {
		 *         return AppResources._configs;
		 *     }
		 * }
		 */
	}
}