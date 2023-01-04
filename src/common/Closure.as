package common
{
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	

	public class Closure extends Object
	{
		import mx.logging.Log;
		import mx.logging.ILogger;
		import mx.logging.LogEventLevel;
					
		private static const logger:ILogger = 
								Log.getLogger ("common.Closure");
		
		public static function create(obj:Object, func:Function, ... pms):Function
		{
			if ( Log.isDebug() ) _log("create(obj="+obj+", func="+func+", parms="+pms+")");
			var f:Function = function():*
			{
				var target:*  = arguments.callee.target;
				var func:*    = arguments.callee.func;
				var params:*  = arguments.callee.params;
				if ( Log.isDebug() ) _log("call(target="+target+", func="+func+", params="+params);
				if ( Log.isDebug() ) _log(" arguments.length="+arguments.length);

				var len:Number = arguments.length;
				var args:Array = new Array(len);
				for(var i:Number=0; i<len; i++)
					args[i] = arguments[i];

				args["push"].apply(args, params);
				return func.apply(target, args);
			};

			var _f:Object = f;
			_f.target  = obj;
			_f.func    = func;
			_f.params  = pms;
			return f;
		}

		private static function _log(s:*):void
		{
			if (Log.isDebug()) logger.debug("[Closure] "+s);
		}


		public static function post(obj:Object, func:Function, timeout:int, ...params):void
		{
			var t:Timer = new Timer(timeout, 1);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, create(null, _on_timer, obj, func, params));
			t.start();
		}

		private static function _on_timer(evt:TimerEvent, obj:Object, func:Function, params:Array):void
		{
			func.apply(obj, params);
		}
	}
}