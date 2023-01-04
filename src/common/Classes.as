package common
{
	import mx.utils.*;
	import flash.utils.*;
	import mx.core.*;
	import flash.display.*;
	
	
	public class Classes
	{
		import mx.logging.Log;
		import mx.logging.ILogger;
		import mx.logging.LogEventLevel;
					
		private static const logger:ILogger = 
								Log.getLogger ("common.Classes");		
		private static var s_uid:int = 1;

		public static function get root():*
		{
			return Application.application;
		}

		public static function applyConstructor0(cls:Class):*
		{
			return new cls();
		}

		public static function applyConstructor1(cls:Class, o1:*):*
		{
			return new cls(o1);
		}

		public static function applyConstructor2(cls:Class, o1:*, o2:*):*
		{
			return new cls(o1, o2);
		}

		public static function applyConstructor3(cls:Class, o1:*, o2:*, o3:*):*
		{
			return new cls(o1, o2, o3);
		}

		public static function applyConstructor4(cls:Class, o1:*, o2:*, o3:*, o4:*):*
		{
			return new cls(o1, o2, o3, o4);
		}

		public static function applyConstructor5(cls:Class, o1:*, o2:*, o3:*, o4:*, o5:*):*
		{
			return new cls(o1, o2, o3, o4, o5);
		}

		public static function applyConstructor6(cls:Class, o1:*, o2:*, o3:*, o4:*, o5:*, o6:*):*
		{
			return new cls(o1, o2, o3, o4, o5, o6);
		}

		public static function applyConstructor7(cls:Class, o1:*, o2:*, o3:*, o4:*, o5:*, o6:*, o7:*):*
		{
			return new cls(o1, o2, o3, o4, o5, o6, o7);
		}

		public static function applyConstructor8(cls:Class, o1:*, o2:*, o3:*, o4:*, o5:*, o6:*, o7:*, o8:*):*
		{
			return new cls(o1, o2, o3, o4, o5, o6, o7, o8);
		}


		private static var s_mapConstr:Array = null;

		public static function applyConstructor(cls:Class, args:Array=null):*
		{
			//if (Log.isDebug())  logger.debug("applyConstructor(cls="+cls+", args="+args+")");
			if( s_mapConstr==null )
			{
				s_mapConstr = [
					applyConstructor0,
					applyConstructor1,
					applyConstructor2,
					applyConstructor3,
					applyConstructor4,
					applyConstructor5,
					applyConstructor6,
					applyConstructor7,
					applyConstructor8
				];
			}

			if( args!=null && args.length>s_mapConstr.length )
			{
				logger.error("[common.Classes] only up to "+s_mapConstr.length+" arguments supported in constructor call at this moment.");
				return null;
			}

			var args2:Array = [cls];
			var index:int = (args==null)?0:args.length;
			if( index>0 )
				args2["push"].apply(args2, args);
			return s_mapConstr[index].apply(null, args2);
		}

		public static function applyMethod(obj:*, name:String, argArray:Array=null):*
		{
			if( obj is flash.utils.Proxy )
			{
				var args:Array = [name];
				if( argArray!=null && argArray.length>0 )
					args["push"].apply(args, argArray);
				return flash.utils.Proxy(obj).flash_proxy::callProperty.apply(obj, args);
			} else
				return obj[name].apply(obj, argArray);
		}

		public static function callConstructor(cls:Class, ... args):*
		{
			return applyConstructor(cls, args);
		}

		public static function callMethod(obj:*, name:String, ... args):*
		{
			return applyMethod(obj, name, args);
		}

		public static function createInstance(clsOrObj:* , ... args):*
		{
			return createInstance2(clsOrObj, args);
		}

		public static function createInstance2(clsOrObj:* , args:Array):*
		{
			if( clsOrObj==null ) return null;

			var cls:Class = null;
			if( typeof(clsOrObj)=="string" )
				cls = load(clsOrObj);
			else if( clsOrObj is Class )
				cls = clsOrObj;
			else if( clsOrObj is IFactory )
				return IFactory(clsOrObj).newInstance();

			if( cls==null )
				return null;
			return applyConstructor(cls, args);
		}

		public static function dump(obj:*, detailed:Boolean=false):String
		{
			return detailed?dumpObjectDetailed(obj):dumpObject(obj);
		}

		public static function dumpObject(obj:Object):String
		{
			var sb:String = "";
			if( obj==null ) return "{ null }";

			if( obj is XML )
				return "{ XML="+obj.toXMLString()+" }";

			if( obj is XMLList )
				return "{ XMLList="+obj.toXMLString()+" }";

			var t:XML = describeType(obj);
			sb += t.@name+ " { \n";

			for each(var acc:* in t.accessor.(@access=="readwrite" || @access=="readonly") )
			{
				var p:String = acc.@name;
				try{ sb += " "+p+" = "+obj[p]+"\n"; } catch(e:Error){}
			}

			for( var p2:String in obj)
			{
				try {
					var val:* = obj[p2];
					if( val is Function ) continue;
					sb += " "+p2+" = "+val+"\n";
				} catch(e:Error){}
			}

			sb += " toString="+obj.toString()+"\n";
			sb += "}";
			return sb;
		}

		public static function dumpObjectDetailed(obj:*):String
		{
			if( obj===undefined ) return "undefined";
			if( obj===null ) return "null";
			var proxy:Boolean = isProxy(obj);
			var res:String = "TYPEOF="+typeof(obj)+",\nPROXY="+proxy;
			if( isInstanceOf(obj, "mx.data::ManagedObjectProxy") ) {
				res += " (ManagedObjectProxy)";
			} else if( obj is ObjectProxy ) {
				res += " (ObjectProxy)";
				//obj = ObjectProxy(obj).object; // TODO: doesn't work
			}	else if( obj is Proxy ) res += " (Proxy)";
			res += ",\nMANAGED="+isManaged(obj);
			res += ",\nTYPE="+describeType(obj)+",\n";
			res += ",\nCONTENT=";
			try	{ res +=mx.utils.ObjectUtil.toString(obj); } catch(e:Error) { res += "<FAILED>"; }
			res += ",\nDUMP="+dumpObject(obj);
			return res;
		}

		public static function dumpStack():String
		{
			var res:String = "Stack not available";
			try
			{
				var o:Object = null;
				o.aaa();
			} catch(e:Error)
			{
				try {
					var s:String = e.getStackTrace();
					if( s==null || s.length==0 ) return res;
					var index:Number = s.indexOf("dumpStack");
					if( index<0 ) return res;
					index = s.indexOf("\n", index);
					if( index<0 ) return res;
					return s.substring(index+1, s.length);
				} catch(e:Error) {}
			}
			return res;
		}

		public static function getUID():int
		{
			return s_uid++;
		}

		public static function isChildOf(obj:DisplayObject, parentObj:DisplayObject):Boolean
		{
			if( obj==null ) return false;
			if( parentObj==null ) return false;
			if( obj==parentObj ) return false;

			var p:* = obj.parent;
			while(p!=null)
			{
				if( p==parentObj ) return true;
				p = p.parent;
			}
			return false;
		}

		// qName - qualified class name, like "mx.collections::ListCollectionView"
		public static function isInstanceOf(obj:Object, qName:*):Boolean
		{
			if( obj==null ) return false;
			var x:XML = describeType(obj);
			if( x==null )
			{
				logger.error("[common.Classes] describeType failed, obj="+obj+", qName="+qName);
				return false;
			}

			if( x.@name==qName ) return true;

			if( x.child("extends").(@type==qName).length()>0 ) return true;
			if( x.child("implements").(@type==qName).length()>0 ) return true;
			return false;
		}

		public static function isManaged(obj:Object):Boolean
		{
			return isInstanceOf(obj, "mx.data::IManaged");
		}

		public static function isProxy(obj:Object):Boolean
		{
			return obj!=null && (obj is ObjectProxy || obj is Proxy || isInstanceOf(obj, "mx.data::ManagedObjectProxy") );
		}

		public static function load(className:String):Class
		{
			var res:Class = flash.utils.getDefinitionByName(className) as Class;

			if( res==null )
				logger.error("[common.Classes] Class \""+className+"\" can't be loaded dynamically. Ensure it's explicitly referenced in the application file or specified via @rsl.");
			return res;
		}

		public static function getProperty(o:Object, name:String):*
		{
			if( o==null ) return undefined;
			if( o.hasOwnProperty(name) )
				return o[name];
			return undefined;
		}

	}
}
