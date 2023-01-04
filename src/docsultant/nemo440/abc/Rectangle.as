package docsultant.nemo440.abc
{
	public final class Rectangle
	{
		var nBits :int;
		var xMin  :int;
		var xMax  :int;
		var yMin  :int;
		var yMax  :int;
		
		public function toString()
		{
			return "{"+xMin+", "+yMin+", "+xMax+", "+yMax+"}";
		}
	}
}