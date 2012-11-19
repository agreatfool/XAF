package com.xenojoshua.af.mvc.view.robotlegs
{
	import com.xenojoshua.af.mvc.view.button.XafButton;
	import com.xenojoshua.af.utils.console.XafConsole;
	import com.xenojoshua.af.utils.mask.XafMaskMaker;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.natives.NativeSignal;
	
	public class XafRobotlegsView extends Sprite
	{
		protected var _movies:Object;               // <movieName:String, movie:MovieClip>
		protected var _components:Object;           // <componentName:String, component:*>
		protected var _buttons:Object;              // <buttonName:String, button:XafButton>
		protected var _signals:Object;              // <signalName:String, signal:NativeSignal>
		
		protected var _tabs:Object;                 // <tabName:String, tabName:String>
		protected var _currentTabName:String;       // used to keep current tab name
		protected var _tabButtonClickFunc:Function; // tab button click handler
		
		protected var _hasBgMask:Boolean; // whether has a background mask drew together when this view is added to stage
		
		/**
		 * Initialize XafRobotlegsView.
		 * @param Boolean withBgMask default false, whether to draw a background mask when added to stage
		 * @return void
		 */
		public function XafRobotlegsView(withBgMask:Boolean = false) {
			super();
			
			this._movies     = new Object();
			this._components = new Object();
			this._buttons    = new Object();
			this._signals    = new Object();
			this._tabs       = new Object();
			
			this._currentTabName     = '';
			this._tabButtonClickFunc = null;
			
			if (withBgMask) {
				this._hasBgMask = withBgMask;
				XafMaskMaker.instance.makeMask(this);
			}
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* MOVIE
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Register a movie into this view.
		 * @param String movieName
		 * @param MovieClip movie
		 * @param Boolean addToStage default true, add it to stage when registration
		 * @return MovieClip movie
		 */
		protected function registerMovie(
			movieName:String,
			movie:MovieClip,
			addToStage:Boolean = true
		):MovieClip {
			if (this._movies.hasOwnProperty(movieName)) {
				XafConsole.instance.log(XafConsole.WARNING, 'XafRobotlegsView: Movie name "' + movieName + '" already registered!');
			}
			this._movies[movieName] = movie;
			XafConsole.instance.log(XafConsole.DEBUG, 'XafRootlegsView: Moive "' + movieName + '" registered!');
			if (addToStage) {
				this.addChild(movie);
				XafConsole.instance.log(XafConsole.DEBUG, 'XafRootlegsView: Moive "' + movieName + '" added to stage!');
			}
			
			return movie;
		}
		
		/**
		 * Get movie from registered movies.
		 * @param String movieName
		 * @return MovieClip movie
		 */
		public function getMovie(movieName:String):MovieClip {
			var movie:MovieClip = null;
			if (this._movies.hasOwnProperty(movieName)) {
				movie = this._movies[movieName];
			} else {
				XafConsole.instance.log(XafConsole.ERROR, 'XafRobotlegsView: Movie with name "' + movieName + '" cannot be found!');
			}
			
			return movie;
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* COMPONENT
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Register a display movie component name into a movie.
		 * @param String movieName
		 * @param String componentName
		 * @return void
		 */
		protected function registerComponent(movieName:String, componentName:String):void {
			var movie:MovieClip = this.getMovie(movieName);
			if (movie) {
				var component:Object = movie[componentName];
				if (component) {
					if (this._components.hasOwnProperty(componentName)) {
						XafConsole.instance.log(XafConsole.WARNING, 'XafRobotlegsView: Component name "' + componentName + '" already registered!');
					}
					this._components[componentName] = component;
					XafConsole.instance.log(XafConsole.DEBUG, 'XafRobotlegsView: Component "' + componentName + '" registered!');
				} else {
					XafConsole.instance.log(XafConsole.ERROR, 'XafRobotlegsView: Component with name "' + componentName + '" cannot be found in movie "' + movieName + '"');
				}
			}
		}
		
		/**
		 * Get a component from a movie.
		 * @param String componentName
		 * @return * component it's possible to be MovieClip, SimpleButton, TextField, etc...
		 */
		public function getComponent(componentName:String):* {
			var component:Object = null;
			if (this._components.hasOwnProperty(componentName)) {
				component = this._components[componentName];
			} else {
				XafConsole.instance.log(XafConsole.ERROR, 'XafRobotlegsView: Component with name "' + componentName + '" cannot be found!');
			}
			
			return component;
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* BUTTON
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Register a XafButton (five status button).
		 * @param String movieName
		 * @param String buttonName
		 * @param String text default ''
		 * @param String fontName default null
		 * @return void
		 */
		protected function registerButton(movieName:String, buttonName:String, text:String = '', fontName:String = null):void {
			var movie:MovieClip = this.getMovie(movieName);
			if (movie) {
				var buttonMovie:MovieClip = movie[buttonName];
				if (buttonMovie) {
					if (this._buttons.hasOwnProperty(buttonName)) {
						XafConsole.instance.log(XafConsole.WARNING, 'XafRobotlegsView: XafButton name "' + buttonName + '" already registered!');
					}
					var button:XafButton = new XafButton(buttonMovie, text, fontName);
					button.registerClickCallback(this.onTabButtonClick);
					this._buttons[buttonName] = button;
					XafConsole.instance.log(XafConsole.DEBUG, 'XafRobotlegsView: XafButton "' + buttonName + '" registered!');
				} else {
					XafConsole.instance.log(XafConsole.ERROR, 'XafRobotlegsView: XafButton with name "' + buttonName + '" cannot be found in movie "' + movieName + '"');
				}
			}
		}
		
		/**
		 * Get a XafButton from registered buttons.
		 * @param String buttonName
		 * @return XafButton button
		 */
		public function getButton(buttonName:String):XafButton {
			var button:XafButton = null;
			if (this._buttons.hasOwnProperty(buttonName)) {
				button = this._buttons[buttonName];
			} else {
				XafConsole.instance.log(XafConsole.ERROR, 'XafRobotlegsView: XafButton with name "' + buttonName + '" cannot be found!');
			}
			
			return button;
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* SIGNAL
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Register a NativeSignal on a movie component or movie itself.
		 * @param String componentName
		 * @param String signalName
		 * @param String eventType
		 * @param Event event
		 * @return void
		 */
		protected function registerSignal(
			componentName:String,
			signalName:String,
			eventType:String,
			event:Class
		):void {
			var component:IEventDispatcher = this.getComponent(componentName); // IEventDispatcher is used here to match "new NativeSignal"
			if (component) {
				if (this._signals.hasOwnProperty(signalName)) {
					XafConsole.instance.log(XafConsole.WARNING, 'XafRobotlegsView: Signal name "' + signalName + '" already registered!');
				}
				XafConsole.instance.log(XafConsole.DEBUG, 'XafRobotlegsView: Signal "' + signalName + '" registered!');
				this._signals[signalName] = new NativeSignal(component, eventType, event);
			}
		}
		
		/**
		 * Get a signal from registered signals.
		 * @param String signalName
		 * @return NativeSignal signal
		 */
		public function getSignal(signalName:String):NativeSignal {
			var signal:NativeSignal = null;
			if (this._signals.hasOwnProperty(signalName)) {
				signal = this._signals[signalName];
			} else {
				XafConsole.instance.log(XafConsole.ERROR, 'XafRobotlegsView: Signal with name "' + signalName + '" cannot be found!');
			}
			
			return signal;
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* TAB
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Register several XafButton(s) together as a STATUS TAB spawn.
		 * Buttons shall all be registered before tabs registration.
		 * @param Array tabButtonNames 'tabName:String, ...'
		 * @return void
		 */
		protected function registerTabs(tabButtonNames:Array):void {
			if (tabButtonNames) {
				for each (var buttonName:String in tabButtonNames) {
					var button:XafButton = this.getButton(buttonName);
					if (button) {
						if (!this._currentTabName) {
							this._currentTabName = buttonName;
						}
						this._tabs[buttonName] = buttonName;
						XafConsole.instance.log(XafConsole.DEBUG, 'XafRobotlegsView: Tab button with name "' + buttonName + '" registered!');
					} else {
						XafConsole.instance.log(XafConsole.WARNING, 'XafRobotlegsView: Tab button with name "' + buttonName + '" not found!');
					}
				}
			} else {
				XafConsole.instance.log(XafConsole.WARNING, 'XafRobotlegsView: Tab button registration names are empty!');
			}
		}
		
		/**
		 * Tabs display change for the action of tab button click.
		 * @param MouseEvent e
		 * @return void
		 */
		protected function onTabButtonClick(e:MouseEvent):void {
			var buttonMovie:MovieClip = e.currentTarget as MovieClip;
			var tabButtonName:String = buttonMovie.name;
			if (tabButtonName != this._currentTabName) {
				this.unselectAllTabButtons();
				this.getButton(tabButtonName).selected = true;
				this._currentTabName = tabButtonName;
				if (this._tabButtonClickFunc != null) {
					this._tabButtonClickFunc(tabButtonName);
				}
			}
		}
		
		/**
		 * Unselect all tab buttons.
		 * @return void
		 */
		protected function unselectAllTabButtons():void {
			if (this._tabs) {
				for (var tabButtonName:String in this._tabs) {
					this.getButton(tabButtonName).selected = false;
				}
			}
		}
		
		/**
		 * Register a display content change handler for the action of tab button click.
		 * @param Function func
		 * @return void
		 */
		public function registerTabButtonClickFunc(func:Function):void {
			this._tabButtonClickFunc = func;
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* DISPOSE
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Destory this view.
		 * @return void
		 */
		public function dispose():void {
			// remove this view & it's mask
			this.parent.removeChild(this);
			if (this._hasBgMask) {
				XafMaskMaker.instance.removeMask(this);
			}
			// remove components
			if (this._components) {
				for (var componentName:String in this._components) {
					var component:Object = this._components[componentName];
					try {
						component.dispose();
					} catch (e:Error) {
						if (1006 == e.errorID
							|| 1069 == e.errorID) {
							// do nothing for "method does not exist" exception
						} else {
							throw e;
						}
					}
				}
				this._components = null;
			}
			// remove signals
			if (this._signals) {
				for (var signalName:String in this._signals) {
					this._signals[signalName].removeAll();
				}
				this._signals = null;
			}
			// remove tabs
			if (this._tabs) {
				this._tabs = null;
				this._currentTabName = null;
				this._tabButtonClickFunc = null;
			}
			// remove buttons
			if (this._buttons) {
				for each (var button:XafButton in this._buttons) {
					button.dispose();
				}
				this._buttons = null;
			}
			// remove movies
			if (this._movies) {
				for (var index:int = 0; index < this.numChildren; ++index) {
					this.removeChildAt(index);
				}
				this._movies = null;
			}
		}
	}
}