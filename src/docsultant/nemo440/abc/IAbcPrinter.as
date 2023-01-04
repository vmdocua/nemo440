package docsultant.nemo440.abc
{
	public interface IAbcPrinter
	{
		function get indent():int;
		function set indent(i:int):void;
		function print(o:*):void;
	}
}