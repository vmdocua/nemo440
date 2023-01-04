package docsultant.nemo440.abc
{
	import flash.utils.ByteArray;
	
	public final class TagEntry extends Constants
	{
		public var data     :ByteArray;
		public var type     :int;
		public var position :int = 0;
		public var length   :int = 0;		
		
		public function TagEntry(data_:ByteArray, type_:int, position_:int, length_:int):void
		{
			data = data_;
			type = type_;
			position = position_;
			length = length_;
		}
		
		public function toString():String
		{
			var s:String = tagNames[type]+": "+length+" bytes";
			return s;
		}
	}
}