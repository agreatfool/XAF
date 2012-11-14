package com.xenojoshua.af.preloader
{
	public interface XafIPreloader
	{
		/**
		 * Parse flash vars & set necessary information into config system.
		 * @return void
		 */
		function parseFlashVars():void;
		
		/**
		 * Load the xml file which describes the resource items.
		 * @return void
		 */
		function loadResourceListXml():void;
		
		/**
		 * Load the items should be loaded in the preloader.
		 * @return void
		 */
		function loadPreloadItems():void;
		
		/**
		 * Process system loading after preload items loaded completely.
		 * @return void
		 */
		function loadSystem():void;
	}
}