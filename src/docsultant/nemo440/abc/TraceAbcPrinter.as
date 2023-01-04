package docsultant.nemo440.abc
{
	public final class TraceAbcPrinter implements IAbcPrinter
	{
		private var _indent:int = 0;
		public function get indent():int
		{
			return _indent;
		}
		
		public function set indent(i:int)
		{
			_indent = i;
		}
		
		public function print(o:*)
		{
			trace(""+o);
		}
	}
}
