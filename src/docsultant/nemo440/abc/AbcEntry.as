package docsultant.nemo440.abc
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public final class AbcEntry extends Constants  implements IAbcDomItem
	{

		public var name:String;

		public var data:ByteArray;

		private var major:int;
		private var minor:int;

		var ints:Array;
		var uints:Array;
		var doubles:Array;
		var strings:Array;
		var namespaces:Array;
		var nssets:Array;
		var names:Array;

		private var defaults:Array;

		var methods:Array;
		var instances:Array;
		private var classes:Array;
		private var scripts:Array;

		private var publicNs:Namespace = new Namespace("");
		private var anyNs:Namespace = new Namespace("*");

		private var magic:int;
		private var metadata:*;
		
		private var _children:Array;
		private var _packageMap:Dictionary;
		private var nsMap:Array;

		public function AbcEntry(data_:ByteArray, packageMap_:Dictionary=null):void
		{
			defaults = new Array(constantKinds.length);
			_packageMap = packageMap_;
			
			nsMap = [];
			nsMap[CONSTANT_Namespace] = "public_ns ";
			nsMap[CONSTANT_PackageNs] = "public_package ";
			nsMap[CONSTANT_ProtectedNs] = "protected_ns ";
			nsMap[CONSTANT_StaticProtectedNs] = "protected_sns";
			nsMap[CONSTANT_StaticProtectedNs2] = "protected_sns2";

			data = data_;
			data.position = 0;
			magic = data.readInt();

			if (magic != (46<<16|14) && magic != (46<<16|15) && magic != (46<<16|16))
				throw new Error("Invalid ABC file, magic=" + magic.toString(16));

			parseCpool();

			defaults[CONSTANT_Utf8] = strings;
			defaults[CONSTANT_Int] = ints;
			defaults[CONSTANT_UInt] = uints;
			defaults[CONSTANT_Double] = doubles;
			defaults[CONSTANT_Int] = ints;
			defaults[CONSTANT_False] = { 10:false };
			defaults[CONSTANT_True] = { 11:true };
			defaults[CONSTANT_Namespace] = namespaces;
			defaults[CONSTANT_PrivateNs] = namespaces;
			defaults[CONSTANT_PackageNs] = namespaces;
			defaults[CONSTANT_PackageInternalNs] = namespaces;
			defaults[CONSTANT_ProtectedNs] = namespaces;
			defaults[CONSTANT_StaticProtectedNs] = namespaces;
			defaults[CONSTANT_StaticProtectedNs2] = namespaces;
			defaults[CONSTANT_Null] = { 12: null };

			parseMethodInfos();
			parseMetadataInfos();
			parseInstanceInfos();
			parseClassInfos();
			parseScriptInfos();
			parseMethodBodies();
			
			createChildren();
		}

		private function readU32():int
		{
			var result:int = data.readUnsignedByte();
			if (!(result & 0x00000080))
				return result;
				
			result = result & 0x0000007f | data.readUnsignedByte()<<7;
			if (!(result & 0x00004000))
				return result;

			result = result & 0x00003fff | data.readUnsignedByte()<<14;
			if (!(result & 0x00200000))
				return result;
				
			result = result & 0x001fffff | data.readUnsignedByte()<<21;
			if (!(result & 0x10000000))
				return result;
				
			return result & 0x0fffffff | data.readUnsignedByte()<<28;
		}

		private function parseCpool():void
		{
			var i:int;
			var j:int;
			var n:int;
			var kind:int;

			var start:int = data.position;

			// ints
			n = readU32();
			ints = [0];
			for(i=1; i < n; i++)
				ints[i] = readU32();

			// uints
			n = readU32();
			uints = [0];
			for (i=1; i < n; i++)
				uints[i] = uint(readU32());

			// doubles
			n = readU32();
			doubles = [NaN];
			for (i=1; i < n; i++)
			doubles[i] = data.readDouble();

			if( AbcUtils.printEnabled ) print("CPool numbers size     : "+AbcUtils.formatSize(data.position-start));
			start = data.position;

			// strings
			n = readU32();
			strings = [""];
			for (i=1; i < n; i++)
				strings[i] = data.readUTFBytes(readU32());

			if( AbcUtils.printEnabled ) 
			{
				print("CPool strings count    : "+ n);
				print("CPool strings size     : "+AbcUtils.formatSize(data.position-start));
			}
			start = data.position;

			// namespaces
			n = readU32();
			namespaces = [publicNs];
			for (i=1; i < n; i++)
			{
				var nb:int = data.readByte();
				switch(nb)
				{
					case CONSTANT_Namespace:
					case CONSTANT_PackageNs:
					case CONSTANT_PackageInternalNs:
					case CONSTANT_ProtectedNs:
					case CONSTANT_StaticProtectedNs:
					case CONSTANT_StaticProtectedNs2:
						{
								var ns:String = strings[readU32()];
								//namespaces[i] = (ns=="")?new Namespace(ns):new Namespace(null, nsMap[nb]+ns);
								namespaces[i] = new Namespace(ns);
								// TODO: mark kind of namespace.
							break;
						}
						
					case CONSTANT_PrivateNs:
								var ns2:String =  strings[readU32()];
								namespaces[i] = new Namespace(null, "private");
							break;
				}
			}

			if( AbcUtils.printEnabled ) 
			{
				print("CPool namespaces count : "+ n);
			 	print("CPool namespaces size  : "+AbcUtils.formatSize(data.position-start));
			}
			start = data.position;

			// namespace sets
			n = readU32();
			nssets = [null];
			for (i=1; i < n; i++)
			{
				var count:int = readU32();
				var nsset:* = nssets[i] = [];
				for (j=0; j < count; j++)
					nsset[j] = namespaces[readU32()];
			}

			if( AbcUtils.printEnabled ) 
			{
				print("CPool nssets count     : "+ n );
				print("CPool nssets size      : "+AbcUtils.formatSize(data.position-start));
			}
			start = data.position;

			// multinames
			n = readU32();
			names = [null];
			namespaces[0] = anyNs;
			strings[0] = "*" // any name
			for (i=1; i < n; i++)
				switch (data.readByte())
				{
					case CONSTANT_Qname:
					case CONSTANT_QnameA:
							names[i] = new QName(namespaces[readU32()], strings[readU32()]);
						break;

					case CONSTANT_RTQname:
					case CONSTANT_RTQnameA:
							names[i] = new QName(strings[readU32()]);
						break;

					case CONSTANT_RTQnameL:
					case CONSTANT_RTQnameLA:
							names[i] = null;
						break;

					case CONSTANT_NameL:
					case CONSTANT_NameLA:
							names[i] = new QName(new Namespace(""), null);
						break;

					case CONSTANT_Multiname:
					case CONSTANT_MultinameA:
							var name:* = strings[readU32()];
							names[i] = new MName(nssets[readU32()], name);
						break;

					case CONSTANT_MultinameL:
					case CONSTANT_MultinameLA:
							names[i] = new MName(nssets[readU32()], null);
						break;
									
					case CONSTANT_TypeName:
						var name:* = names[readU32()];
						var count:* = readU32();
						var types:* = [];
						for( var t:*=0; t < count; ++t )
							types.push(names[readU32()]);
						names[i] = new TypeName(name, types);
					break;
									
					default:
							throw new Error("invalid kind " + data[data.position-1]);
				}

			if( AbcUtils.printEnabled ) 
			{
				print("CPool names count      : "+ n);
				print("CPool names size       : "+ AbcUtils.formatSize(data.position-start));
			}
			start = data.position;

			namespaces[0] = publicNs;
			strings[0] = "*";
		}
		
		private function parseMethodInfos():void
		{
			var start:int = data.position;
			names[0] = new QName(publicNs,"*");
			var method_count:int = readU32();
			methods = [];
			
			for (var i:int=0; i < method_count; i++)
			{
				var m:* = methods[i] = new MethodEntry();
				var param_count:int = readU32();
				m.returnType = names[readU32()];
				m.paramTypes = [];
				for (var j:int=0; j < param_count; j++)
								m.paramTypes[j] = names[readU32()];
				m.debugName = strings[readU32()];
				m.flags = data.readByte();
				if (m.flags & HAS_OPTIONAL)
				{
					// has_optional
					var optional_count:int = readU32();
					m.optionalValues = [];
					for( var k:int = param_count-optional_count; k < param_count; ++k)
					{
						var index:* = readU32();    // optional value index
						var kind:int = data.readByte(); // kind byte for each default value
						if (index == 0)
						{
							// kind is ignored, default value is based on type
							m.optionalValues[k] = undefined;
						} else
						{
							if (!defaults[kind])
							{
								if( AbcUtils.printEnabled ) print("ERROR kind="+kind+" method_id " + i);
							} else
								m.optionalValues[k] = defaults[kind][index];
						}
					}
				}
				
				if (m.flags & HAS_ParamNames)
				{
					// has_paramnames
					for( var k2:int = 0; k2 < param_count; ++k2)
					{
						readU32();
					}
				}
			}
			if( AbcUtils.printEnabled ) 
			{
				print("Methods count          : " +method_count);
				print("Methods size           : " + AbcUtils.formatSize(data.position-start));
			}
		}


		private function parseMetadataInfos():void
		{
			var count:int = readU32();
			metadata = [];
			for (var i:int=0; i < count; i++)
			{
				// MetadataInfo
				var m:* = metadata[i] = new MetadataEntry();
				m.name = strings[readU32()];
				var values_count:int = readU32();
				var names:Array = []
				for(var q:int = 0; q < values_count; ++q)
					names[q] = strings[readU32()]; // name
					
				for(var q2:int = 0; q2 < values_count; ++q2)
					m[names[q2]] = strings[readU32()]; // value
			}
		}

		private function parseInstanceInfos():void
		{
			var start:int = data.position;
			var count:int = readU32();
			instances = [];
			for (var i:int=0; i < count; i++)
			{
				var t:* = instances[i] = new TraitsEntry();
				t.name = names[readU32()];
				t.base = names[readU32()];
				t.flags = data.readByte();
				if (t.flags & 8)
					t.protectedNs = namespaces[readU32()];
					
				var interface_count:* = readU32();
				for (var j:int=0; j < interface_count; j++)
					t.interfaces[j] = names[readU32()];
					
				var m:* = t.init = methods[readU32()];
				m.name = t.name;
				m.kind = TRAIT_Method;
				m.id = -1;
				parseTraits(t);
			}
			if( AbcUtils.printEnabled ) 
			{
				print("Instances    count     : "+count);
				print("Instances    size      : "+AbcUtils.formatSize(data.position-start));
			}
		}

		private function parseTraits(t:TraitsEntry):void
		{
			var namecount:* = readU32();
			for(var i:int=0; i < namecount; i++)
			{
				var name:* = names[readU32()];
				var tag:* = data.readByte();
				var kind:* = tag & 0xf;
				var member:*;
				switch(kind)
				{
					case TRAIT_Slot:
					case TRAIT_Const:
					case TRAIT_Class:
							var slot:* = member = new SlotEntry();
							slot.id = readU32();
							t.slots[slot.id] = slot;
							if (kind==TRAIT_Slot || kind==TRAIT_Const)
							{
								slot.type = names[readU32()];
								var index:* = readU32();
								if (index)
									slot.value = defaults[data.readByte()][index];
							} else // (kind == TRAIT_Class)
							{
								slot.value = classes[readU32()];
							}
						break;
						
					case TRAIT_Method:
					case TRAIT_Getter:
					case TRAIT_Setter:
							var disp_id:* = readU32();
							var method:* = member = methods[readU32()];
							t.methods[disp_id] = method;
							method.id = disp_id;
							//if( AbcUtils.printEnabled ) print("\t",traitKinds[kind],name,disp_id,method,"// disp_id", disp_id);
						break;
				}
				
				if (!member)
						if( AbcUtils.printEnabled ) print("error trait kind "+kind);
				member.kind = kind;
				member.name = name;
				t.names[String(name)] = t.members[i] = member;

				if ( (tag >> 4) & ATTR_metadata ) 
				{
					member.metadata = [];
					for(var j:int=0, mdCount:int=readU32(); j < mdCount; ++j)
						member.metadata[j] = metadata[readU32()];
				}
			}
		}

		private function parseClassInfos():void
		{
			var start:int = data.position;
			var count:int = instances.length;
			classes = [];
			for (var i:int=0; i < count; i++)
			{
				var t:TraitsEntry = classes[i] = new TraitsEntry();
				t.init = methods[readU32()];
				t.base = "Class";
				t.itraits = instances[i];
				t.name = t.itraits.name + "$";
				t.init.name = t.itraits.name + "$cinit";
				t.init.kind = TRAIT_Method;
				parseTraits(t);
			}
			if( AbcUtils.printEnabled ) 
			{
				print("Classes   count        : "+count);
				print("Classes   size         : "+AbcUtils.formatSize(data.position-start));
			}
		}

		private function parseScriptInfos():void
		{
			var start:int = data.position;
			var count:int = readU32();
			scripts = [];
			for (var i:int=0; i < count; i++)
			{
				var t:TraitsEntry = new TraitsEntry();
				scripts[i] = t;
				t.name = "script" + i;
				t.base = names[0] // Object;
				t.init = methods[readU32()];
				t.init.name = t.name + "$init";
				t.init.kind = TRAIT_Method;
				parseTraits(t);
			}
			if( AbcUtils.printEnabled ) 
			{
				print("Scripts count          : "+count);
				print("Scripts size           : "+AbcUtils.formatSize(data.position-start));
			}
		}

		private function parseMethodBodies():void
		{
			var start:int = data.position;
			var count:int = readU32();
			for (var i:int=0; i < count; i++)
			{
				var m:* = methods[readU32()];
				m.max_stack = readU32();
				m.local_count = readU32()
				var initScopeDepth:* = readU32()
				var maxScopeDepth:* = readU32();
				m.max_scope = maxScopeDepth - initScopeDepth;
				var code_length:* = readU32();
				m.code = new ByteArray();
				m.code.endian = "littleEndian";
				if (code_length > 0)
					data.readBytes(m.code, 0, code_length);
					
				var ex_count:* = readU32();
				for (var j:int = 0; j < ex_count; j++)
				{
					var from:* = readU32();
					var to:* = readU32();
					var target:* = readU32();
					var type:* = names[readU32()];
					//if( AbcUtils.printEnabled ) print("magic " + magic.toString(16));
					//if (magic >= (46<<16|16));
					var name:* = names[readU32()];
				}
				parseTraits(m.activation = new TraitsEntry());
			}
			if( AbcUtils.printEnabled ) 
			{
				print("Method bodies count    : "+count);
				print("Method bodies size     : "+AbcUtils.formatSize(data.position-start));
			}
		}

		public function dump(indent:String=""):void
		{
			for each (var t:* in scripts)
			{
				if( AbcUtils.printEnabled ) print(indent+"/* "+t.name+" */");
				t.dump(this,indent);
				t.init.dump(this,indent);
			}

			for each (var m:* in methods)
			{
				if (m.anon) {
					m.dump(this,indent);
				}
			}

			//if( AbcUtils.printEnabled ) print("OPCODE\tSIZE\t% OF "+totalSize);
			if( AbcUtils.printEnabled ) print("OPCODE");
			var done:* = [];
			for (;;)
			{
				var max:int = -1;
				var maxsize:int = 0;
				for (var i:int=0; i < 256; i++)
				{
					if (opSizes[i] > maxsize && !done[i])
					{
						max = i;
						maxsize = opSizes[i];
					}
				}
				
				if (max == -1)
					break;
					
				done[max] = 1;
				if( AbcUtils.printEnabled ) print(opNames[max]+"\t"+int(opSizes[max])+"\t"+int(100*opSizes[max]/totalSize)+"%");
			}
		}

		// IAbcDomItem
		public function get children():Array
		{
			return _children;
		}
		
		public function get itemIcon():*
		{
			return Icons.DEFAULT;
		}
		
		public function get itemLabel():String
		{
			return name==null?"ABC":"ABC ["+name+"]";
		}
		
		public function describe(o:*):String
		{
			return "TODO:";
		}
		
		public function dumpItem(prn:IAbcPrinter):void
		{
			prn.print("TODO:");
			prn.print("magic " + magic.toString(16));
			// 
		}
		
		//
		private function createChildren():void
		{
			/*
			_children = [];
			for each(var c:* in classes)
			{
				if( _checkName(c.itemLabel) )
					_children.push(c);
			}
			_children = _children.sortOn("itemLabel");
			*/
			
			_children = [];
			if( _packageMap==null )
				_packageMap = new Dictionary();
			for each(var t:TraitsEntry in scripts )
			{
				for each(var m:MemberEntry in t.members)
				{
					var p:String = m.packageName;
					if( p==null )
						p = "(default)";
						
					if( !_checkName(p) ) 
						continue;	
						
					var pe:NodePackage = _packageMap[p];
					if( pe==null )
					{
						pe = new NodePackage(p);
						_packageMap[p] = pe;
						_children.push(pe);
					}
					
					var ce:NodeClass = new NodeClass(this, m);
					pe.addItem(ce);
				}
			}
		}
		
		include "Protect.asinc";
                
	}
}