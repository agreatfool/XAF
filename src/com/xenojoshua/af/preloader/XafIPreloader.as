package com.xenojoshua.af.preloader
{
	import com.xenojoshua.af.resource.XafInitLoader;
	import com.xenojoshua.af.resource.XafRsManager;
	
	import flash.events.Event;

	public interface XafIPreloader
	{
		/**
		 * Parse flash vars & set necessary information into config system.
		 * @param Event e default null
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
		 * @param XafInitLoader loader
		 * @return void
		 */
		function loadPreloadItems(loader:XafInitLoader):void;
		
		/**
		 * Process system loading after preload items loaded completely.
		 * @param XafRsManager rsManager
		 * @return void
		 */
		function loadSystem(rsManager:XafRsManager):void;
	}
}