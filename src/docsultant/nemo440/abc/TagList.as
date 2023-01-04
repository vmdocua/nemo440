package docsultant.nemo440.abc
{
	public final class TagList implements IAbcDomItem
	{
		public var _children:Array = [];
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
			return "Tags";
		}
		
		public function describe(o:*):String
		{
			var s:String = "";
			for each(var tag:TagEntry in _children)
				s += "\n"+tag;
			return s;
		}
		
		public function dumpItem(prn:IAbcPrinter):void
		{
			for each(var tag:TagEntry in _children)
				prn.print(tag);
		}
	}
}