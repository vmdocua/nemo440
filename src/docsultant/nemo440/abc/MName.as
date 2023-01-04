package docsultant.nemo440.abc
{
	public final class MName
	{
		var nsset :Array;
		var name  :String;
		
		function MName(nsset:Array, name:String):void
		{
			this.nsset = nsset;
			this.name = name;
		}

		public function toString():String
		{
			return /*'{' + nsset + '}::' + */name;
		}
	}
}