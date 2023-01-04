package docsultant.nemo440.ui
{
	public final class MruItem
	{
		public static const FILE : int = 1;
		public static const URL  : int = 2;
		
		public var type:int;
		public var value:String;
		
		public function MruItem(t:int, v:String):void
		{
			type = t;
			value = v;
		}
	}
}