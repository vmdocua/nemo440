package common
{
	import mx.containers.TitleWindow;
	import mx.managers.PopUpManager;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import mx.events.CloseEvent;
	import mx.core.EventPriority;


	[Event(name="closeDialog",   type="common.EventX")]
	[Event(name="closingDialog", type="common.EventX")]
	[Event(name="initDialog",    type="common.EventX")]
	// TODO: add resizable property + ResizableTitleWindow
	public class DialogWindow extends TitleWindow
	{
		private static var DEBUG:Boolean = false;

		// the same values as in Alert, to make compatible
		public static const NONE   : int = 0x00;
		public static const YES    : int = 0x01;
		public static const NO     : int = 0x02;
		public static const OK     : int = 0x04;
		public static const CANCEL : int = 0x08;

		[Bindable]
		public var dialogParam  : *;
		[Bindable]
		public var dialogResult : int;

		public function DialogWindow()
		{
			if( DEBUG ) _log("constructor()");
			dialogResult = NONE;
			dialogParam  = null;
			horizontalScrollPolicy = "off";
			verticalScrollPolicy = "off";
			showCloseButton = true;

			// listen for close button if enabled
			addEventListener(CloseEvent.CLOSE, _onClose);

			// TODO: doesn't work well for many controls like TextInput etc
			// investigate how to intercept keyDown event at low level,
			// right before control recieved it
			addEventListener(KeyboardEvent.KEY_DOWN, _onKeyDown, false, EventPriority.DEFAULT_HANDLER);
		}

		public function closeDialog(_dialogResult:int, _param:*=null):void
		{
			if( DEBUG ) _log("closeDialog(_dialogResult="+_dialogResult+", _param="+_param+")");
			if( _param==null ) _param = dialogParam;
			try
			{
				dialogResult = _dialogResult;
				dialogParam  = _param;
				
				var evt:EventX = new EventX("closeDialog");
				evt.dialogResult = _dialogResult;
				evt.dialog = this;
				evt.dialogParam  = _param;
				dispatchEvent(evt);
				if( DEBUG ) _log("1");
	
				// notify dialog manager
				evt = evt.copy("_closeDialog");
				dispatchEvent(evt);
				
				if( DEBUG ) _log("2");
				
				PopUpManager.removePopUp(this);
			} catch(e:*)
			{
				Logger.error("[DialogWindow] "+e+", "+e.message);
			}
		}

		private function _onClose(evt:Event):void
		{
			if( DEBUG ) _log("_onClose(evt="+evt+")");
			_systemClose(CANCEL);
		}

		private function _onKeyDown(evt:KeyboardEvent):void
		{
			if( DEBUG )
			{
				_log("_onKeyDown(evt="+Classes.dump(evt)+")");
				_log(" isDefaultPrevented="+evt.isDefaultPrevented());
			}

			if( evt.isDefaultPrevented() )
				return;

			if( evt.keyCode==Keyboard.ESCAPE && !evt.shiftKey && !evt.ctrlKey )
			{
				_systemClose(CANCEL);
				return;
			}

			if( evt.keyCode==Keyboard.ENTER && !evt.shiftKey && !evt.ctrlKey )
			{
				_systemClose(OK);
				return;
			}
		}

		private function _systemClose(result:int):void
		{
			if( DEBUG ) _log("_systemClose(result="+result+")");
			var evt:EventX = new EventX("closingDialog");
			evt.dialogResult = result;
			evt.dialogParam  = null;
			evt.dialog       = this;
			evt.handled      = false;
			dispatchEvent(evt);

			if( !evt.handled )
				closeDialog(evt.dialogResult, evt.dialogParam);
		}

		private function _log(s:*):void
		{
			Logger.trace("[DialogWindow] "+s);
		}
	}
}
