package com.xenojoshua.af.resource.config
{
	public interface XafIRsConfig
	{
		/**
		 * public class AppResources implements XafIRsConfig {
		 *     
		 *     // FILES
		 *     public static const FILE_MAIN:String = 'file.main';    // MovieClip swf resource file
		 *     public static const FILE_LISU:String = 'file.lisu';    // font swf resource file
		 *     public static const FILE_CFSD:String = 'file.soldier'; // config json resource file
		 *     
		 *     // MOVIECLIP CLASS NAMES
		 *     // const string is the class name of the MovieClip
		 *     public static const CLASS_MAIN:String = 'main.MainView';
		 *     
		 *     // CONFIG NAMES
		 *     public static const CONF_SOLDIER:String = 'config.soldier';
		 *     
		 *     // FONTS NAMES
		 *     public static const FONT_LISU:String = 'LiSu';
		 *     
		 *     // configs shall be described in some file, e.g. "resources.json"
		 *     // read "Resource Config" part in "XafRsManager" to get config structure
		 *     {
		 *         'file.main': { // same to AppResources.FILE_MAIN
		 *             url:     'assets/swf/main.swf',
		 *             type:    'swf',
		 *             preload: true,
		 *             main:    true
		 *         },
		 *         'file.lisu': { // same to AppResources.FILE_LISU
		 *             url:     'assets/font/lisu.swf',
		 *             type:    'font',
		 *             preload: true,
		 *             font:    {'LISU1': 'LiSu'} // 'fontClassName': 'fontName', fontName is same to AppResouces.FONT_LISU
		 *         },
		 *         'file.soldier': { // same to AppResources.FILE_CFSD
		 *             url:    'assets/json/soldier.json',
		 *             type:   'config',
		 *             config: 'config.soldier' // same to AppResources.CONF_SOLDIER, use this reference in code to find configs
		 *         }
		 *     }
		 * }
		 */
	}
}