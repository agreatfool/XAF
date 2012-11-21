package com.xenojoshua.af.resource
{
	import com.xenojoshua.af.config.XafConfig;
	import com.xenojoshua.af.mvc.view.utils.XafDisplayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class XafRsProgressBar extends Sprite
	{
		[Embed(source="asset/default_loader.swf", symbol="XafDefaultLoadingBarAnime")]
		private var _embeddedMovieClass:Class;
		
		private var _movie:MovieClip;
		private var _background:Sprite;
		
		/**
		 * Initialize XafRsProgressBar.
		 * @param MovieClip movie default null, loading bar animation
		 * @param DisplayObject background default null, background image
		 * @param Number alpha default 0.0 means, means background is transparent, background alpha value
		 * @return void
		 */
		public function XafRsProgressBar(movie:MovieClip = null, background:DisplayObject = null, alpha:Number = 0.0) {
			this.drawBackground(background, alpha);
			this.drawLoadingBar(movie);
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* PROGRESS FUNCTIONALITY
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Update progress bar according to the loading progress.
		 * @param String name
		 * @return void
		 */
		public function updateProgressBar(bytesLoaded:Number, bytesTotal:Number):void {
			var progress:Number = Math.round(bytesLoaded / bytesTotal * 100);
			
			if (progress < 1) {
				progress = 1;
			} else if (progress > 100) {
				progress = 100;
			}
			
			this._movie.gotoAndStop(progress);
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* UTILITIES
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Destory the loading progress bar.
		 * @return void
		 */
		public function dispose():void {
			this.removeChild(this._movie);
			this.removeChild(this._background);
			this._movie = null;
			this._background = null;
		}
		
		/**
		 * Draw background on this container.
		 * @param DisplayObject default null, bg shall be an image
		 * @param Number alpha default 0.0, means background is transparent
		 * @return void
		 */
		private function drawBackground(bg:DisplayObject = null, alpha:Number = 0.0):void {
			this._background = new Sprite();
			
			if (bg == null) {
				var graph:Graphics = this._background.graphics;
				graph.beginFill(0x000000, alpha);
				graph.drawRect(0, 0, XafConfig.instance.stageWidth, XafConfig.instance.stageHeight);
				graph.endFill();
			} else {
				this._background.addChild(bg);
			}
			
			this.addChild(this._background);
		}
		
		/**
		 * Draw loading bar movie on this container.
		 * @param MovieClip movie default null
		 * @return void
		 */
		private function drawLoadingBar(movie:MovieClip = null):void {
			if (movie == null) {
				this._movie = new this._embeddedMovieClass();
			} else {
				this._movie = movie;
			}
			this._movie.stop();
			
			this._movie.x = this._background.width / 2;
			this._movie.y = this._background.height / 2;
			this.addChild(this._movie);
		}
	}
}