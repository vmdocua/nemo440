package docsultant.nemo440.abc
{
	public final class TraitsEntry implements IAbcDomItem
	{
		var name         :*;
		var init         :MethodEntry;
		var itraits      :TraitsEntry;
		var base         :*;
		var flags        :int;
		var protectedNs  :Namespace;
		var interfaces :Array = [];
		var names      :Object = {};
		var slots      :Array = [];
		var methods    :Array = [];
		var members    :Array = [];

		public function toString():String
		{
			return String(name);
		}

		public function dump(abc:AbcEntry, indent:String, attr:String=""):void
		{
			for each (var m:* in members)
				m.dump(abc,indent,attr)
		}
		
		// IAbcDomItem
		public function get children():Array
		{
			return [];
		}
		
		public function get itemIcon():*
		{
			return Icons.DEFAULT;
		}
		
		public function get itemLabel():String
		{
			return ""+name;
		}
		
		public function describe(o:*):String
		{
			return "TODO:";
		}
		
		public function dumpItem(prn:IAbcPrinter):void
		{
			prn.print("TODO:");
		}
	}
}