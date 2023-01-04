package common
{
	import flash.events.Event;
	
	public dynamic class EventX extends Event
	{
		public function EventX(type:String, bubbles:Boolean = false, cancelable:Boolean = false):void
		{
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			return Event(copy(type, bubbles, cancelable));
		}
		
		public function copy(type:String, bubbles:Boolean = false, cancelable:Boolean = false):EventX
		{
			var evt:EventX = new EventX(type, bubbles, cancelable);
			
			// skip standard props
			var std:Object = {};
			for(var p1:String in evt)
				std[p1] = true;
				
			for(var p2:String in this)
			{
				if( std[p2]!=null ) continue;
				evt[p2] = this[p2];
			}
			
			return evt;
		}
		
	}
}