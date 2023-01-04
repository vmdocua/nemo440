package docsultant.nemo440.abc
{
	public class NodeClass implements IAbcDomItem
	{
		public var abc:AbcEntry;
		public var member:MemberEntry;
		//public var init:* //TODO
		
		public function NodeClass(abc_:AbcEntry, m:MemberEntry):void
		{
			abc = abc_;
			member = m;
		}
		
		public function get children():Array
		{
			return member.children;
		}
		
		public function get itemIcon():*
		{
			return Icons.CLASS;
		}
		
		public function get itemLabel():String
		{
			return member.itemLabel;
		}
		
		public function describe(o:*):String
		{
			AbcUtils.printMode = AbcUtils.PRINT_MODE_STRING;
			AbcUtils.printString = "";
			AbcUtils.printEnabled = true;
			member.dump(abc, "");
			AbcUtils.printEnabled = false;
			return AbcUtils.printString;
		}
	}
}