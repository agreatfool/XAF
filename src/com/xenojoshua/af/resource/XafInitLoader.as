package com.xenojoshua.af.resource
{
	import com.xenojoshua.af.utils.console.XafConsole;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.osflash.signals.Signal;

	public class XafInitLoader
	{
		private var _loader:URLLoader;
		private var _completeSignal:Signal;
		private var _errorSignal:Signal;
		
		public function XafInitLoader(url:String, onComplete:Function, onError:Function = null) {
			// init loader
			this._loader = new URLLoader();
			this._loader.addEventListener(Event.COMPLETE,        this.onComplete);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, this.onError);
			// init signals & bind signals with callbacks
			this._completeSignal = new Signal();
			this._completeSignal.add(onComplete);
			if (onError != null) {
				this._errorSignal = new Signal();
				this._errorSignal.add(onError);
			}
			// start loading
			this._loader.load(new URLRequest(url));
		}
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* OPEN APIS
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		public function getXML():XML {
			return new XML(this._loader.data);
		}
		
		/**
		 * Load JSON content.
		 * @return Object json
		 */
		public function getJSON():Object {
			return JSON.parse(this._loader.data);
		}
		
		/**
		 * Destory this loader.
		 * @return void
		 */
		public function dispose():void {
			this._completeSignal.removeAll();
			if (this._errorSignal) {
				this._errorSignal.removeAll();
			}
		}
		
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		//-* EVENTS
		//-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
		/**
		 * Load complete event.
		 * @param Event e
		 * @return void
		 */
		private function onComplete(e:Event):void {
			XafConsole.instance.log(XafConsole.INFO, 'XafInitLoader: Load complete!');
			this._completeSignal.dispatch(this);
		}
		
		/**
		 * Load fail event.
		 * @param Event e
		 * @return void
		 */
		private function onError(e:IOErrorEvent):void {
			XafConsole.instance.log(XafConsole.ERROR, 'XafInitLoader: Load failed! Msg: ' + e.text);
			if (this._errorSignal) {
				this._errorSignal.dispatch(this);
			}
		}
	}
}