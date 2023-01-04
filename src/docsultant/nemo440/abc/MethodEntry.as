package docsultant.nemo440.abc
{
import flash.utils.ByteArray;

	public final class MethodEntry extends MemberEntry
	{
		var flags:int;
		var debugName;
		var paramTypes;
		var optionalValues;
		var returnType:*;
		var local_count:int;
		var max_scope:int;
		var max_stack:int;
		var code_length:uint;
		var code:ByteArray;
		var activation:TraitsEntry;
		var anon:Boolean;

		public function toString():String
		{
			return format();
		}

		public function format():String
		{
			var s:String = "";
			if (flags & NATIVE)
				s = "native ";

			return s + traitKinds[kind] + " " + name + "(" + paramTypes + "):" + returnType + "\t/* disp_id " + id + "*/";
		}

		override function dump(abc:AbcEntry, indent:String, attr:String=""):void
		{
			if( AbcUtils.printEnabled ) print("");

			if (metadata) {
				for each (var md in metadata)
					if( AbcUtils.printEnabled ) print(indent+md);
			}

			if( AbcUtils.printEnabled ) print(indent+attr+format());
			if (code)
			{
				if( AbcUtils.printEnabled ) print(indent+"{");
				//return;
				var oldindent:* = indent;
				indent += TAB;
				if (flags & NEED_ACTIVATION) 
				{
					if( AbcUtils.printEnabled ) print(indent+"activation {");
					activation.dump(abc, indent+TAB, "");
					if( AbcUtils.printEnabled ) print(indent+"}");
				}
				
				if( AbcUtils.printEnabled ) 
					print(indent+"// local_count="+local_count+
						" max_scope=" + max_scope +
						" max_stack=" + max_stack +
						" code_len=" + code.length);
						
				code.position = 0;
				var labels:LabelEntry = new LabelEntry();
				while (code.bytesAvailable > 0)
				{
					var start:int = code.position;
					var s = indent + start;
					while (s.length < 12) s += ' ';
					
					var opcode = code.readUnsignedByte();
					if (opcode == OP_label || ((code.position-1) in labels)) 
					{
						if( AbcUtils.printEnabled ) print(indent);
						if( AbcUtils.printEnabled ) print(indent + labels.labelFor(code.position-1) + ": ");
					}

					s += opNames[opcode];
					s += opNames[opcode].length < 8 ? "\t\t" : "\t";

					switch(opcode)
					{
						case OP_debugfile:
						case OP_pushstring:
								s += '"' + abc.strings[readU32()].replace(/\n/g,"\\n").replace(/\t/g,"\\t") + '"';
							break
						case OP_pushnamespace:
								s += abc.namespaces[readU32()];
							break
						case OP_pushint:
								var i:int = abc.ints[readU32()];
								s += i + "\t// 0x" + i.toString(16);
							break
						case OP_pushuint:
								var u:uint = abc.uints[readU32()];
								s += u + "\t// 0x" + u.toString(16);
							break;
						case OP_pushdouble:
								s += abc.doubles[readU32()];
							break;
						case OP_getsuper:
						case OP_setsuper:
						case OP_getproperty:
						case OP_initproperty:
						case OP_setproperty:
						case OP_getlex:
						case OP_findpropstrict:
						case OP_findproperty:
						case OP_finddef:
						case OP_deleteproperty:
						case OP_istype:
						case OP_coerce:
						case OP_astype:
						case OP_getdescendants:
								s += abc.names[readU32()];
							break;
						case OP_constructprop:
						case OP_callproperty:
						case OP_callproplex:
						case OP_callsuper:
						case OP_callsupervoid:
						case OP_callpropvoid:
								s += abc.names[readU32()];
								s += " (" + readU32() + ")";
							break;
						case OP_newfunction: {
								var method_id = readU32();
								s += abc.methods[method_id];
								abc.methods[method_id].anon = true;
								break;
						}
						case OP_callstatic:
								s += abc.methods[readU32()];
								s += " (" + readU32() + ")";
							break;
						case OP_newclass:
								s += abc.instances[readU32()];
							break;
						case OP_lookupswitch:
								var pos = code.position-1;
								var target = pos + readS24();
								var maxindex = readU32();
								s += "default:" + labels.labelFor(target) // target + "("+(target-pos)+")";
								s += " maxcase:" + maxindex;
								for (var i2:int=0; i2 <= maxindex; i2++) {
									target = pos + readS24();
									s += " " + labels.labelFor(target) // target + "("+(target-pos)+")";
								}
							break;
						case OP_jump:
						case OP_iftrue:              case OP_iffalse:
						case OP_ifeq:                case OP_ifne:
						case OP_ifge:                case OP_ifnge:
						case OP_ifgt:                case OP_ifngt:
						case OP_ifle:                case OP_ifnle:
						case OP_iflt:                case OP_ifnlt:
						case OP_ifstricteq:          case OP_ifstrictne:
								var offset:* = readS24();
								var target2:* = code.position+offset;
								//s += target + " ("+offset+")";
								s += labels.labelFor(target2);
								if (!((code.position) in labels))
									s += "\n";
							break;
						case OP_inclocal:
						case OP_declocal:
						case OP_inclocal_i:
						case OP_declocal_i:
						case OP_getlocal:
						case OP_kill:
						case OP_setlocal:
						case OP_debugline:
						case OP_getglobalslot:
						case OP_getslot:
						case OP_setglobalslot:
						case OP_setslot:
						case OP_pushshort:
						case OP_newcatch:
								s += readU32();
							break;
						case OP_debug:
								s += code.readUnsignedByte();
								s += " " + readU32();
								s += " " + code.readUnsignedByte();
								s += " " + readU32();
							break;
						case OP_newobject:
								s += "{" + readU32() + "}";
							break;
						case OP_newarray:
								s += "[" + readU32() + "]";
							break;
						case OP_call:
						case OP_construct:
						case OP_constructsuper:
								s += "(" + readU32() + ")";
							break;
						case OP_pushbyte:
						case OP_getscopeobject:
								s += code.readByte();
							break;
						case OP_hasnext2:
								s += readU32() + " " + readU32();
							break;

						default:
										/*if (opNames[opcode] == ("0x"+opcode.toString(16).toUpperCase()))
														s += " UNKNOWN OPCODE"*/
								break;
					}
					var size:int = code.position - start;
					totalSize += size;
					opSizes[opcode] = int(opSizes[opcode]) + size;
					if( AbcUtils.printEnabled ) print(s);
				}
				if( AbcUtils.printEnabled ) print(oldindent+"}\n");
			}
		}

		function readU32():int
		{
			var result:int = code.readUnsignedByte();
			if (!(result & 0x00000080))
				return result;
			result = result & 0x0000007f | code.readUnsignedByte()<<7;
			if (!(result & 0x00004000))
				return result;
			result = result & 0x00003fff | code.readUnsignedByte()<<14;
			if (!(result & 0x00200000))
				return result;
			result = result & 0x001fffff | code.readUnsignedByte()<<21;
			if (!(result & 0x10000000))
				return result;
			return   result & 0x0fffffff | code.readUnsignedByte()<<28;
		}

		function readS24():int
		{
			var b:int = code.readUnsignedByte();
			b |= code.readUnsignedByte()<<8;
			b |= code.readByte()<<16;
			return b;
		}
	}
}