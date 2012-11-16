package com.xenojoshua.af.mvc.view.robotlegs
{
	import com.xenojoshua.af.utils.console.XafConsole;
	import com.xenojoshua.af.utils.mask.XafMaskMaker;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.osflash.signals.natives.NativeSignal;
	
	public class XafRobotlegsView extends Sprite
	{
		protected var _movies:Object; // <movieName:String, movie:MovieClip>
		/**
		 * Display component in the movie.
		 * e.g. Item display window, there are three tabs in the display window
		 * protected var _components:Object = {
		 *     'TAB1': 'ITEM_MOVIE',
		 *     'TAB2': 'ITEM_MOVIE',
		 *     'TAB3': 'ITEM_MOVIE'
		 * };
		 */
		protected var _components:Object; // <componentName:String, movieName:String>
		protected var _signals:Object;    // <signalName:String, signal:NativeSignal>
		
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
			this._signals    = new Object();
			
			if (withBgMask) {
				this._hasBgMask = withBgMask;
				XafMaskMaker.instance.makeMask(this);
			}
		}
		
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
			this.addChild(movie);
			XafConsole.instance.log(XafConsole.DEBUG, 'XafRootlegsView: Moive "' + movieName + '" registered!');
			
			return movie;
		}
		
		/**
		 * Get movie from registered movies.
		 * @param String movieName
		 * @return MovieClip movie
		 */
		public function getMovie(movieName:String):MovieClip {
			var movie:MovieClip = null;
			if (!this._movies.hasOwnProperty(movieName)) {
				XafConsole.instance.log(XafConsole.ERROR, 'XafRobotlegsView: Movie with name "' + movieName + '" cannot be found!');
			} else {
				movie = this._movies[movieName];
			}
			
			return movie;
		}
		
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
					this._components[componentName] = movieName;
					XafConsole.instance.log(XafConsole.DEBUG, 'XafRobotlegsView: Component "' + componentName + '" registered!');
				} else {
					XafConsole.instance.log(XafConsole.ERROR, 'XafRobotlegsView: Component with name "' + componentName + '" cannot be found in movie "' + movieName + '"');
				}
			}
		}
		
		/**
		 * Get a component from a movie.
		 * @param String movieName
		 * @param String componentName
		 * @return * component it's possible to be MovieClip, SimpleButton, TextField, etc...
		 */
		public function getComponent(movieName:String, componentName:String):* {
			var component:Object = null;
			var movie:MovieClip = this.getMovie(movieName);
			if (movie) {
				if (this._components.hasOwnProperty(componentName)) {
					component = movie[componentName];
				} else {
					XafConsole.instance.log(XafConsole.ERROR, 'XafRobotlegsView: Component with name "' + componentName + '" cannot be found!');
				}
			}
			
			return component;
		}
		
		/**
		 * Register a NativeSignal on a movie component or movie itself.
		 * @param String movieName
		 * @param String componentName
		 * @param String signalName
		 * @param String eventType
		 * @param Event event
		 * @return void
		 */
		protected function registerSignal(
			movieName:String,
			componentName:String,
			signalName:String,
			eventType:String,
			event:Class
		):void {
			var component:IEventDispatcher = this.getComponent(movieName, componentName); // IEventDispatcher is used here to match "new NativeSignal"
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
			// remove signals
			if (this._signals) {
				for (var signalName:String in this._signals) {
					var signal:NativeSignal = this._signals[signalName];
					signal.removeAll();
				}
				this._signals = null;
			}
			// remove components
			if (this._components) {
				for (var componentName:String in this._components) {
					var component:Object = this._components[componentName];
					try {
						component.dispose();
					} catch (e:Error) {
						if (1006 == e.errorID) {
							// do nothing for method does not exist exception
						} else {
							throw e;
						}
					}
				}
				this._components = null;
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