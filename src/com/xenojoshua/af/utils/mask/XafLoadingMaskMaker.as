package com.xenojoshua.af.utils.mask
{
	import com.xenojoshua.af.resource.manager.XafConfigManager;
	import com.xenojoshua.af.constant.XafConst;
	import com.xenojoshua.af.resource.XafRsManager;
	import com.xenojoshua.af.mvc.view.screen.XafScreenManager;
	import com.xenojoshua.af.utils.console.XafConsole;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class XafLoadingMaskMaker
	{
		private static var _maker:XafLoadingMaskMaker;
		
		private var _loadingSwfName:String;
		private var _loadingClassName:String;
		
		private var _loadingNum:int;
		private var _loadingMovie:Sprite;
		
		/**
		 * Get instance of XafLoadingMaskMaker.
		 * @return XafLoadingMaskMaker _maker
		 */
		public static function get instance():XafLoadingMaskMaker {
			if (!XafLoadingMaskMaker._maker) {
				XafConsole.instance.log(XafConsole.ERROR, 'XafLoadingMaskMaker: XafLoadingMaskMaker has not been "startup"ed yet!');
			}
			return XafLoadingMaskMaker._maker;
		}
		
		/**
		 * Startup XafLoadingMaskMaker with loading movie resources.
		 * @param String swfName
		 * @param String className
		 * @param Boolean needToLoad default false
		 */
		public static function startup(swfName:String, className:String):XafLoadingMaskMaker {
			if (!XafLoadingMaskMaker._maker) {
				XafLoadingMaskMaker._maker = new XafLoadingMaskMaker(swfName, className);
			}
			return XafLoadingMaskMaker._maker;
		}
		
		/**
		 * Initialize XafLoadingMaskMaker with loading movie swf name & class name.
		 * @param String swfName
		 * @param String className
		 * @return void
		 */
		public function XafLoadingMaskMaker(swfName:String, className:String) {
			this._loadingSwfName = swfName;
			this._loadingClassName = className;
		}
		
		/**
		 * Add one loading number.
		 * If loading number equals to 1, start to display loading movie.
		 * @return void
		 */
		public function loading():void {
			++this._loadingNum;
			if(this._loadingNum == 1) { // only need to build loading movie when loading number start to be 1
				this._loadingMovie = this.buildLoadingMovie();
				XafScreenManager.instance.getLayer(XafConst.SCREEN_POPUP).addChild(this._loadingMovie);
			}
		}
		
		/**
		 * Minus one loading number.
		 * If loading number equals to or less than 0, hide loading movie.
		 * @return void
		 */
		public function hide():void {
			--this._loadingNum;
			if (this._loadingNum < 0) {
				this._loadingNum = 0;
			}
			if (this._loadingNum == 0 && this._loadingMovie) {
				if (this._loadingMovie.parent) {
					this._loadingMovie.parent.removeChild(this._loadingMovie);
				}
				this._loadingMovie = null;
			}
		}
		
		/**
		 * Build loading movie(both mask & loading movie).
		 * @return Sprite loadingMovie
		 */
		private function buildLoadingMovie():Sprite {
			var movie:Sprite = new Sprite();
			
			movie.graphics.beginFill(0x000000, 0.3);
			movie.graphics.drawRect(0, 0, XafConfigManager.instance.stageWidth, XafConfigManager.instance.stageHeight);
			movie.graphics.endFill();
			
			var loadingMovie:MovieClip = XafRsManager.instance.getMovieClipInSwf(this._loadingSwfName, this._loadingClassName);
			if (loadingMovie) {
				loadingMovie.x = movie.width / 2;
				loadingMovie.y = movie.height / 2;
				movie.addChild(loadingMovie);
			}
			
			return movie;
		}
	}
}