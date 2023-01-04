package docsultant.nemo440.abc
{
	public class MemberEntry extends Constants implements IAbcDomItem
	{
		var id:int;
		var kind:int;
		var name:*;
		var metadata:Array;
		var _children:Array;
		
		public function get packageName():String
		{
			if( name is QName )
			{
				var s:String = QName(name).uri;
				if( s==null ) return null;
				if( s.length==0 ) return null;
				return s;
			}
			return null;
		}
		
		function dump(abc:AbcEntry, indent:String, attr:String=""):void
		{
			
		}
		
		// IAbcDomItem
		public function get children():Array
		{
			return _children;
		}
		
		public function get itemIcon():*
		{
			return Icons.DEFAULT;
		}
		
		public function get itemLabel():String
		{
			if( name is QName )
			{
				return QName(name).localName;
			}
			return name;
		}
		
		public function describe(o:*):String
		{
			return "";
		}
		
	}
}