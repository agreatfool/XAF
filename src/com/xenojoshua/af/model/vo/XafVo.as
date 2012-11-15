package com.xenojoshua.af.model.vo
{
	public class XafVo
	{
		/**
		 * Initialize vo with data parsing.
		 * @param Object obj
		 * @return void
		 */
		public function XafVo(obj:Object) {
			parseVo(obj);
		}
		
		/**
		 * Parse input object, and set data into current vo attributes.
		 * @param Object obj
		 * @return void
		 */
		public function parseVo(obj:Object):void {
			for (var key:String in obj) {
				if (this.hasOwnProperty(key)) {
					if ((this[key] is Array) && !obj[key]) {
						this[key] = [];
					} else {
						this[key] = obj[key];
					}
				}
			}
		}
	}
}