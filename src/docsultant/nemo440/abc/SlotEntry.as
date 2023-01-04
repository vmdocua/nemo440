package docsultant.nemo440.abc
{
	public final class SlotEntry extends MemberEntry
	{
		var type  :*;
		var value :*;
		
		public function format():String
		{
			return traitKinds[kind] + " " + name + ":" + type +
				(value !== undefined ? (" = " + (value is String ? ('"'+value+'"') : value)) : "") +
				"\t/* slot_id " + id + " */";
		}
		

		override function dump(abc:AbcEntry, indent:String, attr:String=""):void
		{
			if( !_checkQName(name) ) return;
			if (kind == TRAIT_Const || kind == TRAIT_Slot)
			{
				if (metadata) 
				{
					for each (var md:* in metadata)
						if( AbcUtils.printEnabled ) print(indent+md);
				}
				if( AbcUtils.printEnabled ) print(indent+attr+format());
				return;
			}

			// else, class

			var ct:TraitsEntry = value;
			var it:TraitsEntry = ct.itraits;
			if( AbcUtils.printEnabled ) print('');
			if (metadata) {
				for each (var md2:* in metadata)
					{ if( AbcUtils.printEnabled ) print(indent+md2); }
			}
			
			var def:String;
			if (it.flags & CLASS_FLAG_interface)
				def = "interface"
			else 
			{
				def = "class";
				if (!(it.flags & CLASS_FLAG_sealed))
					def = "dynamic " + def;
				if (it.flags & CLASS_FLAG_final)
					def = "final " + def;
			}
			
			if( AbcUtils.printEnabled ) 
			{
				var exts:String = ""+it.base;
				if( exts=="" || exts=="*" )
					exts = "";
				else
					exts = " extends "+exts;
					
				print(indent+attr+def+" "+name+exts);
			}
			var oldindent:* = indent;
			indent += TAB
			if (it.interfaces.length > 0)
				{ if( AbcUtils.printEnabled ) print(indent+"implements "+it.interfaces); }
				
			if( AbcUtils.printEnabled ) print(oldindent+"{");
			it.init.dump(abc,indent);
			it.dump(abc,indent);
			ct.dump(abc,indent,"static ");
			ct.init.dump(abc,indent,"static ");
			if( AbcUtils.printEnabled ) print(oldindent+"}\n");
		}
		
		include "Protect.asinc";
	}
}