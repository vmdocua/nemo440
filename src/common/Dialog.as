package common
{
	import common.Classes;
	import common.DialogWindow;
	import common.EventDispatcherFwd;
	import mx.managers.PopUpManager;
	import flash.display.DisplayObject;
	import mx.core.IFlexDisplayObject;
	import mx.core.IInvalidating;
	import flash.geom.Point;
	import flash.events.Event;


	[Event(name="closeDialog", type="common.EventX")]
	public class Dialog extends common.EventDispatcherFwd
	{
		private static const DEBUG:Boolean = false;

		// the same values as in Alert, to make compatible
		public static const NONE   : int = 0x00;
		public static const YES    : int = 0x01;
		public static const NO     : int = 0x02;
		public static const OK     : int = 0x04;
		public static const CANCEL : int = 0x08;
		//

		private var m_cls : Class;
		private var m_wnd : DialogWindow;

		// TODO: add positioning support like center and resizing support
		public function Dialog(cls:Class=null, _position:String=null)
		{
			m_cls = cls;
			position = _position;
			m_wnd = null;
		}

		public function set className(val:Class):void
		{
			m_cls = val;
		}

		public function get className():Class
		{
			return m_cls;
		}

		public var position:String;


		public static function centerWindow(wnd:IFlexDisplayObject, parent:DisplayObject=null):void
		{
			if( DEBUG) _log("centerWindow(wnd="+wnd+", parent="+parent+")");
			// TODO: check it
			if( wnd is IInvalidating )
				IInvalidating(wnd).validateNow();

			if( parent==null )
				parent = wnd.parent;

			if( DEBUG )
			{
				_log(" parent="+parent);
				_log(" wnd.parent="+wnd.parent);
			}

			if( parent==null )
				parent = Classes.root;

			var pt:Point = new Point(0, 0);
			pt = parent.localToGlobal(pt);
			if( wnd!=null && wnd.parent!=null )
				pt = wnd.parent.globalToLocal(pt);

			pt.x += Math.round((parent.width - wnd.width) / 2);
			pt.y += Math.round((parent.height - wnd.height) / 2);

			if( DEBUG ) _log(" x="+pt.x+", y="+pt.y);

			wnd.move(pt.x, pt.y);
		}

		public function hide():void
		{
			if( m_wnd==null )
				return;
				
			PopUpManager.removePopUp(m_wnd);
			m_wnd = null;
		}

		public function show(parent:DisplayObject=null, modal:Boolean=true, wndParams:*=null, param:*=null):DialogWindow
		{
			if( DEBUG ) _log("show(parent="+parent+", modal="+modal+", wndParams="+wndParams+", param="+param+")");
			if( m_wnd!=null )
				return null; // dialog already shown

			if( DEBUG ) _log("show 1");
			
			if( parent==null )
				parent = Classes.root;

			if( wndParams==null || wndParams==undefined )
				wndParams = {};

			wndParams.dialogParam = param;

			clearDispatcher();
			if( DEBUG ) _log("show 2");
			m_wnd = DialogWindow(PopUpManager.createPopUp(parent, m_cls, modal));
			if( m_wnd==null )
				return null;

			if( DEBUG ) _log("show 3");

			// copy init props
			for(var name:String in wndParams)
			{
				m_wnd[name] = wndParams[name];
			}
			
			if( DEBUG ) _log("show 4");

			if( modal )
			{
				mx.managers.CursorManager.setBusyCursor();
				m_wnd.addEventListener("creationComplete", _onCreationComplete);
			}

			// TODO: prevent window blink - create invisible, then center then doLatter to make visible again
			dispatcher = m_wnd; // attach event handlers
			m_wnd.addEventListener("_closeDialog", _onCloseDialog);

			// add "centerScreen" and "random"
			if( position=="centerParent" || position=="center" )
				PopUpManager.centerPopUp(m_wnd);
			else if ( position=="centerScreen" )
				centerWindow(m_wnd);

			var evt:EventX = new EventX("initDialog");
			evt.dialogParam = param;
			evt.dialog      = m_wnd;
			evt.param       = param;
			m_wnd.dispatchEvent(evt);
			if( DEBUG ) _log("show 5");
			return m_wnd;
		}

		public function showModal(parent:DisplayObject=null, param:*=null, wndParams:*=null):DialogWindow
		{
			return show(parent, true, wndParams, param);
		}

		public function showModeless(parent:DisplayObject, param:*=null, wndParams:*=null):DialogWindow
		{
			return show(parent, false, wndParams, param);
		}

		private function _onCloseDialog(evt:Event):void
		{
			if( DEBUG ) _log("_onCloseDialog");
			m_wnd = null;
		}

		private function _onCreationComplete(evt:Event):void
		{
			if( DEBUG ) _log("_onCreationComplete");			
			mx.managers.CursorManager.removeBusyCursor();
		}

		private static function _log(s:*):void
		{
			Logger.trace("[Dialog] "+s);
		}
	}
}
