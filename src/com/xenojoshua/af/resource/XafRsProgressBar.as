package com.xenojoshua.af.resource
{
	import com.xenojoshua.af.config.XafConfig;
	import com.xenojoshua.af.utils.display.XafDisplayUtil;
	
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
		
		private var _totalBytes:Number;
		private var _targetList:Object;   // <resourceName:String, resourceTotalSize:Number>
		private var _progressList:Object; // <resourceName:String, loadedSize:Number>
		
		/**
		 * Initialize XafRsProgressBar.
		 * @param MovieClip movie default null, loading bar animation
		 * @param DisplayObject background default null, background image
		 * @param Number alpha default 0.0 means, means background is transparent, background alpha value
		 * @return void
		 */
		public function XafRsProgressBar(movie:MovieClip = null, background:DisplayObject = null, alpha:Number = 0.0) {
			this._totalBytes   = 0;
			this._targetList   = new Object();
			this._progressList = new Object();
			
			this.drawBackground(background, alpha);
			this.drawLoadingBar(movie);
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* DATA INITIALIZATION
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Set resource target into progress bar.
		 * @param String name
		 * @param Number bytes
		 * @return void
		 */
		public function setTarget(name:String, bytes:Number):void {
			this._targetList[name] = bytes;
			this._progressList[name] = 0;
		}
		
		/**
		 * Set resource targets into progress bar.
		 * @param Object targets 'name:String => bytes:Number'
		 * @return void
		 */
		public function setTargets(targets:Object):void {
			if (targets) {
				for (var name:String in targets) {
					this._targetList[name] = targets[name];
					this._progressList[name] = 0;
				}
			}
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* PROGRESS FUNCTIONALITY
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Update progress bar according to the loading progress.
		 * @param String name
		 * @return void
		 */
		public function updateProgressBar(name:String = null):void {
			var progress:Number = (name == null) ? this.getTotalProgress() : this.getTargetProgress(name);
			
			if (progress < 1) {
				progress = 1;
			} else if (progress > 100) {
				progress = 100;
			}
			
			this._movie.gotoAndStop(progress);
		}
		
		/**
		 * Get specified target loaded progress.
		 * @param String name
		 * @return Number progress e.g. 0.23 => 23%
		 */
		private function getTargetProgress(name:String):Number {
			var progress:Number = 0;
			
			if (this._progressList.hasOwnProperty(name)) {
				progress = Math.round(this._progressList[name] / this._targetList[name] * 100);
			}
			
			return progress;
		}
		
		/**
		 * Get total loaded progress.
		 * @return Number progress e.g. 0.23 => 23%
		 */
		private function getTotalProgress():Number {
			var progress:Number = 0;
			
			if (this._progressList && this._totalBytes) {
				var currentTargetLoaded:Number = 0;
				for (var name:String in this._progressList) {
					currentTargetLoaded += this._progressList[name];
				}
				progress = Math.round(currentTargetLoaded / this._totalBytes * 100);
			}
			
			return progress;
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* ON PROGRESS EVENT
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Set target loaded bytes on progress.
		 * @param String name
		 * @param Number bytes
		 * @param Boolean updateCurrent default false, whether update the progress bar according to current target loading progress
		 * @return void
		 */
		public function setTargetProgressBytes(name:String, bytes:Number, updateCurrent:Boolean = false):void {
			if (this._progressList.hasOwnProperty(name)) {
				this._progressList[name] = Math.round(bytes);
			}
			if (updateCurrent) {
				this.updateProgressBar(name);
			} else {
				this.updateProgressBar();
			}
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* UTILITIES
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Destory the loading progress bar.
		 * @return void
		 */
		public function dispose():void {
			this._totalBytes   = 0;
			this._targetList   = null;
			this._progressList = null;
			this._movie        = null;
			this._background   = null;
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
			
			this.addChild(this._movie);
		}
	}
}