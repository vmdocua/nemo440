package common
{
	import mx.controls.Alert;
	import flash.display.Sprite;
	import flash.events.Event;
	import mx.events.CloseEvent;
	import common.Classes;
	

	// Win32-like MessageBox
	public class MessageBox extends Object
	{
		import mx.logging.Log;
		import mx.logging.ILogger;
		import mx.logging.LogEventLevel;
					
		private static const logger:ILogger = 
								Log.getLogger ("common.MessageBox");		
		
		private static const DEBUG:Boolean = false;

		public static const YES         : int = 0x01;
		public static const NO          : int = 0x02;
		public static const OK          : int = 0x04;
		public static const CANCEL      : int = 0x08;
		//
		public static const YESNO       : int = YES | NO;
		public static const YESNOCANCEL : int = YES | NO | CANCEL;
		public static const OKCANCEL    : int = OK  | CANCEL;
		//
		public static const ICONINFORMATION : int = 0x10;
		public static const ICONASTERISK    : int = 0x10;
		public static const ICONWARNING     : int = 0x20;
		public static const ICONEXCLAMATION : int = 0x20;
		public static const ICONQUESTION    : int = 0x30;
		public static const ICONSTOP        : int = 0x40;
		public static const ICONERROR       : int = 0x40;
		//
		public static const DEFBUTTON1      : int = 0x0100;
		public static const DEFBUTTON2      : int = 0x0200;
		public static const DEFBUTTON3      : int = 0x0300;
		public static const DEFBUTTON4      : int = 0x0400;

		//
		[Embed(source="/assets/information.png")]
		private static var ICON_INFO:Class;
		[Embed(source="/assets/attention.png")]
		private static var ICON_WARN:Class;
		[Embed(source="/assets/question.png")]
		private static var ICON_ASK:Class;
		[Embed(source="/assets/stopsign.png")]
		private static var ICON_ERROR:Class;


		//
		// listener - function fooFunc(dialogResult:Number, param) {...}
		//
		public static function show(owner:Sprite, text:String, title:String=null, flags:int=0, listener:Function=null, param:*=null):void
		{
			var icon        : Class = null;
			var defButton   : int = flags & 0x0F00;
			var flagsButton : int = flags & 0x000F;

			if( flagsButton==0 )
				flagsButton = OK;

			var flagsIcon:int = flags & 0x00F0;
			switch(flagsIcon)
			{
				case ICONINFORMATION: icon = ICON_INFO;  break;
				case ICONWARNING:     icon = ICON_WARN;  break;
				case ICONQUESTION:    icon = ICON_ASK;   break;
				case ICONERROR:       icon = ICON_ERROR; break;
			}

			if( defButton==0 )
				defButton = DEFBUTTON1;

			var a:Array = new Array();
			if( flags & OK ) a.push(OK);
			if( flags & YES ) a.push(YES);
			if( flags & NO )  a.push(NO);
			if( flags & CANCEL ) a.push(CANCEL);

			defButton = (defButton >> 8)-1;
			defButton = a[defButton];


			var listener2:Function = null;
			if( listener!=null )
				listener2 = common.Closure.create({}, _onCloseDialog, { l:listener, p:param });
			Alert.show(text, title, flagsButton, owner, listener2, icon, defButton);
		}

		private static function _onCloseDialog(evt:CloseEvent, param:*):void
		{
			if ( Log.isDebug() ) _log("_onCloseDialog(evt="+evt+", param="+param+"-> "+Classes.dump(param)+")");
			param.l(evt.detail, param.p);
		}

		private static function _log(s:*):void
		{
			if (Log.isDebug())  logger.debug("[MessageBox] "+s);
		}
	}
}