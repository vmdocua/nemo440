package docsultant.nemo440.abc
{
	public final dynamic class MetadataEntry
	{
		var name:String;
		
		public function toString():String
		{
			var last:String;
			var s:String = last = '['+name+'(';
			var n:*;
			for(n in this)
				s = (last = s + n + "=" + '"' + this[n] + '"') + ',';
			return last + ')]';
		}
	}
}