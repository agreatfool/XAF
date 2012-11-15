package com.xenojoshua.af.preloader
{
	import com.xenojoshua.af.resource.XafInitLoader;
	
	import flash.events.Event;

	public interface XafIPreloader
	{
		/**
		 * Parse flash vars & set necessary information into config system.
		 * @return void
		 */
		function parseFlashVars(e:Event = null):void;
		
		/**
		 * Load the config file which describes the resource items.
		 * @return void
		 */
		function loadResourceListConfig():void;
		
		/**
		 * Load the items should be loaded in the preloader.
		 * @return void
		 */
		function loadPreloadItems(loader:XafInitLoader):void;
		
		/**
		 * Process system loading after preload items loaded completely.
		 * @return void
		 */
		function loadSystem():void;
	}
}