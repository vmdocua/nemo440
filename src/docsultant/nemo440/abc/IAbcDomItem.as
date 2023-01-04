package docsultant.nemo440.abc
{
	public interface IAbcDomItem
	{
		function get children():Array;   // IAbcDomItem[]
		function get itemLabel():String; // item label
		function get itemIcon():*;       // item icon
		function describe(o:*):String;   // provide item information
		//function dumpItem(prn:IAbcPrinter):void;
	}
}