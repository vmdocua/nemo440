package common
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.Event;

	public class EventDispatcherFwd extends EventDispatcher
	{
		// TODO: in future allow multiple inner dispatchers and
		// update forwarding code in common.StatefulDataProvider
		private var m_inner:IEventDispatcher;
		private var m_events:Object;

		public function EventDispatcherFwd()
		{
			m_inner = null;
			m_events = {};
		}

		public function set dispatcher(o:IEventDispatcher):void
		{
			if( m_inner!=null )
				_detach(m_inner);

			m_inner = o;
			if( o!=null )
				_attach(m_inner);
		}

		public function get dispatcher():IEventDispatcher
		{
			return m_inner;
		}

		public function clearDispatcher():void
		{
			m_inner = null;
		}


		public override function addEventListener(eventType:String, eventListener:Function, useCapture:Boolean = false, priority:int = 0, weakRef:Boolean = false):void
		{
			var q:Array = null;
			if( m_events[eventType]==undefined )
			{
				q = new Array();
				m_events[eventType] = q;
			}
			else
				q = m_events[eventType] as Array;

			q.push(eventListener);

			if( m_inner!=null )
				m_inner.addEventListener(eventType, eventListener, useCapture, priority, weakRef);
		}

		public override function removeEventListener(eventType:String, eventListener:Function, useCapture:Boolean = false):void
		{
			if( m_events[eventType]!=undefined )
			{
				var q:Array = m_events[eventType] as Array;
				for(var i:Number=0; i<q.length; i++)
				{
					var el:* = q[i];
					if( el!=null && el==eventListener )
						q[i] = null;
					// TODO: optimize in future
				}
			}

			if( m_inner!=null )
				m_inner.removeEventListener(eventType, eventListener, useCapture);
		}

		public override function dispatchEvent(eventObj:Event):Boolean
		{
			if( m_inner!=null )
				return m_inner.dispatchEvent(eventObj);
			return false;
		}

		public override function hasEventListener(type:String):Boolean
		{
			if( m_inner!=null )
				return m_inner.hasEventListener(type);
			return false;
		}

		private function _attach(o:IEventDispatcher):void
		{
			for(var name:String in m_events)
			{
				var q:* = m_events[name];
				if( q!=null && q!=undefined && q is Array )
				{
					var len:Number = q.length;
					for(var i:Number=0; i<len; i++)
						o.addEventListener(name, q[i]);
				}
			}
		}

		private function _detach(o:IEventDispatcher):void
		{
			for(var name:String in m_events)
			{
				var q:* = m_events[name];
				if( q!=null && q!=undefined && q is Array )
				{
					var len:Number = q.length;
					for(var i:Number=0; i<len; i++)
						o.removeEventListener(name, q[i]);
				}
			}
		}

	}
}
