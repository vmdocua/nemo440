package docsultant.nemo440.ui
{
	public class MruList
	{
		public var maxSize:int = 10;
		public var source:Array;
		
		public function MruList(a:Array = null):void
		{
			if( a==null ) a = [];
			source = a;
		}
	}
}