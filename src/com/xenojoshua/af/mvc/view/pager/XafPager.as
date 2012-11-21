package com.xenojoshua.af.mvc.view.pager
{
	import com.greensock.TweenLite;
	import com.xenojoshua.af.mvc.view.utils.XafDisplayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.osflash.signals.natives.NativeSignal;

	public class XafPager
	{
		// container size
		private var _containerWidth:int;
		private var _containerHeight:int;
		private var _rowCount:int;
		private var _columeCount:int;
		private var _gridWidth:int;
		private var _gridHeight:int;
		private var _gridCountOnPage:int;
		
		// container
		private var _container:Sprite;
		private var _containerMask:DisplayObject;
		private var _data:Array;
		private var _renderFunction:Function;
		
		// page control
		private var _pages:Object;
		private var _pageCount:int;
		private var _currentPageIndex:int;
		private var _targetPageIndex:int;
		private var _isChangingIndex:Boolean;
		private var _pageSwitchTime:Number = 0.4;
		
		private var _prevSignal:NativeSignal;
		private var _nextSignal:NativeSignal;
		private var _pageTextField:TextField;
		private var _prevBtn:InteractiveObject;
		private var _nextBtn:InteractiveObject;
		
		/**
		 * Initialize XafPager.
		 * @param Sprite container
		 * @param int row
		 * @param int column
		 * @param Function renderFunc param is a single data object, return value have to be a DisplayObject, e.g. renderInventoryGem(data:InventoryGem):MovieClip
		 * @param Array data default null, each content is a data object, e.g. InventoryGem
		 * @param int initPage default 0
		 * @return void
		 */
		public function XafPager(container:Sprite, row:int, colume:int, renderFunc:Function, data:Array = null, initPage:int = 0) {
			this._container       = container;
			this._containerWidth  = this._container.width;
			this._containerHeight = this._container.height;
			
			this._containerMask   = XafDisplayUtil.cloneDisplayBitmap(this._container);
			this._containerMask.x = this._container.x;
			this._containerMask.y = this._container.y;
			this._container.parent.addChild(this._containerMask);
			this._container.mask  = this._containerMask;
			
			this._rowCount        = row;
			this._columeCount     = colume;
			this._gridWidth       = this._container.width / this._columeCount;
			this._gridHeight      = this._container.height / this._rowCount;
			this._gridCountOnPage = this._columeCount * this._rowCount;
			this._renderFunction  = renderFunc;
			
			this.setData(data, initPage);
		}
		
		/**
		 * Destory the XafPager.
		 * @return void
		 */
		public function dispose():void {
			if (this._prevSignal) {
				this._prevSignal.removeAll();
			}
			if (this._nextSignal) {
				this._nextSignal.removeAll();
			}
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* CONTENTS
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Set data & switch page (if necessary).
		 * @param Array data
		 * @param int initPage default 0
		 * @return void
		 */
		public function setData(data:Array, initPage:int = 0):void {
			this.clearContainer();
			
			if (!data) {
				return;
			}
			
			this._data = data;
			this._pageCount = data.length / this._gridCountOnPage;
			if (data.length % this._gridCountOnPage) {
				++this._pageCount;
			}
			this._pages = new Object();
			
			this._currentPageIndex = -1;
			this._targetPageIndex = initPage;
			
			this.gotoPage();
		}
		
		/**
		 * Remove the content in the pager container.
		 * @return void
		 */
		private function clearContainer():void {
			if (this._pages) {
				var legacyPage:DisplayObject = this._pages[this._currentPageIndex];
				if (legacyPage && legacyPage.parent) {
					legacyPage.parent.removeChild(legacyPage);
				}
			}
		}
		
		/**
		 * Render(draw) the page of "pageIndex".
		 * @param int pageIndex
		 * @return void
		 */
		private function renderPage(pageIndex:int):void {
			var display:DisplayObject;
			var dataIndex:int;
			
			this._pages[pageIndex] = new Sprite();
			for(var row:int = 0; row < this._rowCount; ++row) {
				for(var column:int = 0; column < this._columeCount; ++column) {
					dataIndex = pageIndex * (this._columeCount * this._rowCount) + row * this._columeCount + column;
					if (dataIndex >= this._data.length) {
						return;
					}
					display = this._renderFunction(this._data[dataIndex]);
					display.x = column * this._gridWidth;
					display.y = row * this._gridHeight;
					this._pages[pageIndex].addChild(display);
				}
			}
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* SWITCH PAGE CONTROL FUNCTIONS
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Register the pager control buttons.
		 * @param InteractiveObject prev
		 * @param InteractiveObject next
		 * @param TextField pageTextField
		 * @return XafPager pager
		 */
		public function registerPagerControls(prev:InteractiveObject, next:InteractiveObject, pageTextField:TextField = null):XafPager {
			if (prev) {
				this._prevBtn = prev;
				this._prevSignal = new NativeSignal(prev, MouseEvent.CLICK);
				this._prevSignal.add(this.onGotoPrev);
			}
			if (next) {
				this._nextBtn = next;
				this._nextSignal = new NativeSignal(next, MouseEvent.CLICK);
				this._nextSignal.add(this.onGotoNext);
			}
			this._pageTextField = pageTextField;
			
			return this;
		}
		
		/**
		 * Switch to previous page.
		 * @param MouseEvent e
		 * @return void
		 */
		private function onGotoPrev(e:MouseEvent):void {
			if (this._isChangingIndex || this._currentPageIndex <= 0) {
				return;
			}
			this._targetPageIndex = this._currentPageIndex - 1;
			this.gotoPage();
		}
		
		/**
		 * Switch to next page.
		 * @param MouseEvent e
		 * @return void
		 */
		private function onGotoNext(e:MouseEvent):void {
			if (this._isChangingIndex || this._currentPageIndex >= (this._pageCount - 1)) {
				return;
			}
			this._targetPageIndex = this._currentPageIndex + 1; 
			this.gotoPage();
		}
		
		/**
		 * Go to the page with the index of "this._targetPageIndex".
		 * @return void
		 */
		private function gotoPage():void {
			if (!this._pages[this._targetPageIndex]) { // only draw the page when it does not exists
				this.renderPage(this._targetPageIndex);
			}
			// switch to target page
			this.tweenToTargetPage();
			// update page index text field
			if (this._pageTextField) {
				if (this._pageCount == 0) {
					this._pageTextField.text = "0 / 0";
				} else {
					this._pageTextField.text = (this._targetPageIndex + 1) + " / " + this._pageCount;
				}
			}
			// check previous button status
			if (this._prevBtn) {
				if (this._targetPageIndex <= 0) {
					XafDisplayUtil.applyBlackFilter(this._prevBtn);
					this._prevBtn.mouseEnabled = false;
				} else {
					XafDisplayUtil.cleanDisplayFilter(this._prevBtn);
					this._prevBtn.mouseEnabled = true;
				}
			}
			// check next button status
			if (this._nextBtn) {
				if (this._targetPageIndex >= this._pageCount - 1) {
					XafDisplayUtil.applyBlackFilter(this._nextBtn);
					this._nextBtn.mouseEnabled = false;
				} else {
					XafDisplayUtil.cleanDisplayFilter(this._nextBtn);
					this._nextBtn.mouseEnabled = true;
				}
			}
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* ANIMATION FUNCTIONS
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Play switch page animation.
		 * @return void
		 */
		private function tweenToTargetPage():void {
			this._isChangingIndex = true; // flag animation status
			
			var targetPageSprite:Sprite = this._pages[this._targetPageIndex];
			var currentPageSprite:Sprite = this._pages[this._currentPageIndex];
			
			if (!currentPageSprite) {
				this._container.addChild(targetPageSprite);
				this.onTweenEnd();
				return;
			}
			
			var forward:Boolean = true;
			if (this._targetPageIndex < this._currentPageIndex) {
				forward = false;
			}
			var currentPageTargetX:Number;
			if (forward) {
				targetPageSprite.x = this._containerWidth;
				currentPageTargetX = -this._containerWidth;
			} else {
				targetPageSprite.x = -this._containerWidth;
				currentPageTargetX = this._containerWidth;
			}
			
			this._container.addChild(targetPageSprite);
			
			new TweenLite(currentPageSprite, this._pageSwitchTime, {x: currentPageTargetX});
			new TweenLite(targetPageSprite, this._pageSwitchTime, {x: 0, onComplete: onTweenEnd});
		}
		
		/**
		 * Stop switch page animation.
		 * @return void
		 */
		private function onTweenEnd():void {
			var currentPageSprite:Sprite = this._pages[this._currentPageIndex];
			if(currentPageSprite && currentPageSprite.parent) {
				currentPageSprite.parent.removeChild(currentPageSprite);
			}
			this._currentPageIndex = this._targetPageIndex;
			
			this._isChangingIndex = false;
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* GETTER & SETTER FUNCTIONS
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		public function get pageSwitchTime():Number           { return this._pageSwitchTime; }
		public function set pageSwitchTime(value:Number):void { this._pageSwitchTime = value; }
	}
}