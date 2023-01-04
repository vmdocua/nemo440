package docsultant.nemo440.abc
{
	public class Constants
	{
		public const TAB = "  ";

		// method flags
		public const NEED_ARGUMENTS:int  = 0x01;
		public const NEED_ACTIVATION:int = 0x02;
		public const NEED_REST:int       = 0x04;
		public const HAS_OPTIONAL:int    = 0x08;
		public const IGNORE_REST:int     = 0x10;
		public const NATIVE:int          = 0x20;
		
		public const HAS_ParamNames:int  = 0x80;

		public const CONSTANT_Utf8              :int = 0x01;
		public const CONSTANT_Int               :int = 0x03;
		public const CONSTANT_UInt              :int = 0x04;
		public const CONSTANT_PrivateNs         :int = 0x05; // non-shared namespace
		public const CONSTANT_Double            :int = 0x06;
		public const CONSTANT_Qname             :int = 0x07; // o.ns::name, ct ns, ct name
		public const CONSTANT_Namespace         :int = 0x08;
		public const CONSTANT_Multiname         :int = 0x09; // o.name, ct nsset, ct name
		public const CONSTANT_False             :int = 0x0A;
		public const CONSTANT_True              :int = 0x0B;
		public const CONSTANT_Null              :int = 0x0C;
		public const CONSTANT_QnameA            :int = 0x0D; // o.@ns::name, ct ns, ct attr-name
		public const CONSTANT_MultinameA        :int = 0x0E; // o.@name, ct attr-name
		public const CONSTANT_RTQname           :int = 0x0F; // o.ns::name, rt ns, ct name
		public const CONSTANT_RTQnameA          :int = 0x10; // o.@ns::name, rt ns, ct attr-name
		public const CONSTANT_RTQnameL          :int = 0x11; // o.ns::[name], rt ns, rt name
		public const CONSTANT_RTQnameLA         :int = 0x12; // o.@ns::[name], rt ns, rt attr-name
		public const CONSTANT_NameL             :int = 0x13; // o.[], ns=public implied, rt name
		public const CONSTANT_NameLA            :int = 0x14; // o.@[], ns=public implied, rt attr-name
		public const CONSTANT_NamespaceSet      :int = 0x15;
		public const CONSTANT_PackageNs         :int = 0x16;
		public const CONSTANT_PackageInternalNs :int = 0x17;
		public const CONSTANT_ProtectedNs       :int = 0x18;
		public const CONSTANT_StaticProtectedNs :int = 0x19;
		public const CONSTANT_StaticProtectedNs2:int = 0x1A;
		public const CONSTANT_MultinameL        :int = 0x1B;
		public const CONSTANT_MultinameLA       :int = 0x1C;
		public const CONSTANT_TypeName          :int = 0x1D;		

		public const constantKinds:Array = [ 
			"0",              // 1
			"utf8", 
			"2",
			"int", 
			"uint",           // 5 
			"private", 
			"double", 
			"qname", 
			"namespace",
			"multiname",      // 10
			"false", 
			"true", 
			"null", 
			"@qname", 
			"@multiname",     // 15
			"rtqname",
			"@rtqname", 
			"[qname]", 
			"@[qname]", 
			"[name]",         // 1A
			"@[name]", 
			"nsset"
		];
		
		public const TRAIT_Slot                :int = 0x00;
		public const TRAIT_Method              :int = 0x01;
		public const TRAIT_Getter              :int = 0x02;
		public const TRAIT_Setter              :int = 0x03;
		public const TRAIT_Class               :int = 0x04;
		public const TRAIT_Function            :int = 0x05;
		public const TRAIT_Const               :int = 0x06;
		public const TRAIT_mask                :int = 15; // TODO:

		public const traitKinds:Array = [
			"var",           // 0
			"function",      // 1
			"function get",  // 2
			"function set",  // 3
			"class",         // 4
			"function",      // 5
			"const"          // 6
		];

		public const OP_bkpt:int = 0x01;
		public const OP_nop:int = 0x02;
		public const OP_throw:int = 0x03;
		public const OP_getsuper:int = 0x04;
		public const OP_setsuper:int = 0x05;
		public const OP_dxns:int = 0x06;
		public const OP_dxnslate:int = 0x07;
		public const OP_kill:int = 0x08;
		public const OP_label:int = 0x09;
		public const OP_ifnlt:int = 0x0C;
		public const OP_ifnle:int = 0x0D;
		public const OP_ifngt:int = 0x0E;
		public const OP_ifnge:int = 0x0F;
		public const OP_jump:int = 0x10;
		public const OP_iftrue:int = 0x11;
		public const OP_iffalse:int = 0x12;
		public const OP_ifeq:int = 0x13;
		public const OP_ifne:int = 0x14;
		public const OP_iflt:int = 0x15;
		public const OP_ifle:int = 0x16;
		public const OP_ifgt:int = 0x17;
		public const OP_ifge:int = 0x18;
		public const OP_ifstricteq:int = 0x19;
		public const OP_ifstrictne:int = 0x1A;
		public const OP_lookupswitch:int = 0x1B;
		public const OP_pushwith:int = 0x1C;
		public const OP_popscope:int = 0x1D;
		public const OP_nextname:int = 0x1E;
		public const OP_hasnext:int = 0x1F;
		public const OP_pushnull:int = 0x20;
		public const OP_pushundefined:int = 0x21;
		public const OP_pushconstant:int = 0x22;
		public const OP_nextvalue:int = 0x23;
		public const OP_pushbyte:int = 0x24;
		public const OP_pushshort:int = 0x25;
		public const OP_pushtrue:int = 0x26;
		public const OP_pushfalse:int = 0x27;
		public const OP_pushnan:int = 0x28;
		public const OP_pop:int = 0x29;
		public const OP_dup:int = 0x2A;
		public const OP_swap:int = 0x2B;
		public const OP_pushstring:int = 0x2C;
		public const OP_pushint:int = 0x2D;
		public const OP_pushuint:int = 0x2E;
		public const OP_pushdouble:int = 0x2F;
		public const OP_pushscope:int = 0x30;
		public const OP_pushnamespace:int = 0x31;
		public const OP_hasnext2:int = 0x32;
		public const OP_newfunction:int = 0x40;
		public const OP_call:int = 0x41;
		public const OP_construct:int = 0x42;
		public const OP_callmethod:int = 0x43;
		public const OP_callstatic:int = 0x44;
		public const OP_callsuper:int = 0x45;
		public const OP_callproperty:int = 0x46;
		public const OP_returnvoid:int = 0x47;
		public const OP_returnvalue:int = 0x48;
		public const OP_constructsuper:int = 0x49;
		public const OP_constructprop:int = 0x4A;
		public const OP_callsuperid:int = 0x4B;
		public const OP_callproplex:int = 0x4C;
		public const OP_callinterface:int = 0x4D;
		public const OP_callsupervoid:int = 0x4E;
		public const OP_callpropvoid:int = 0x4F;
		public const OP_newobject:int = 0x55;
		public const OP_newarray:int = 0x56;
		public const OP_newactivation:int = 0x57;
		public const OP_newclass:int = 0x58;
		public const OP_getdescendants:int = 0x59;
		public const OP_newcatch:int = 0x5A;
		public const OP_findpropstrict:int = 0x5D;
		public const OP_findproperty:int = 0x5E;
		public const OP_finddef:int = 0x5F;
		public const OP_getlex:int = 0x60;
		public const OP_setproperty:int = 0x61;
		public const OP_getlocal:int = 0x62;
		public const OP_setlocal:int = 0x63;
		public const OP_getglobalscope:int = 0x64;
		public const OP_getscopeobject:int = 0x65;
		public const OP_getproperty:int = 0x66;
		public const OP_getpropertylate:int = 0x67;
		public const OP_initproperty:int = 0x68;
		public const OP_setpropertylate:int = 0x69;
		public const OP_deleteproperty:int = 0x6A;
		public const OP_deletepropertylate:int = 0x6B;
		public const OP_getslot:int = 0x6C;
		public const OP_setslot:int = 0x6D;
		public const OP_getglobalslot:int = 0x6E;
		public const OP_setglobalslot:int = 0x6F;
		public const OP_convert_s:int = 0x70;
		public const OP_esc_xelem:int = 0x71;
		public const OP_esc_xattr:int = 0x72;
		public const OP_convert_i:int = 0x73;
		public const OP_convert_u:int = 0x74;
		public const OP_convert_d:int = 0x75;
		public const OP_convert_b:int = 0x76;
		public const OP_convert_o:int = 0x77;
		public const OP_coerce:int = 0x80;
		public const OP_coerce_b:int = 0x81;
		public const OP_coerce_a:int = 0x82;
		public const OP_coerce_i:int = 0x83;
		public const OP_coerce_d:int = 0x84;
		public const OP_coerce_s:int = 0x85;
		public const OP_astype:int = 0x86;
		public const OP_astypelate:int = 0x87;
		public const OP_coerce_u:int = 0x88;
		public const OP_coerce_o:int = 0x89;
		public const OP_negate:int = 0x90;
		public const OP_increment:int = 0x91;
		public const OP_inclocal:int = 0x92;
		public const OP_decrement:int = 0x93;
		public const OP_declocal:int = 0x94;
		public const OP_typeof:int = 0x95;
		public const OP_not:int = 0x96;
		public const OP_bitnot:int = 0x97;
		public const OP_concat:int = 0x9A;
		public const OP_add_d:int = 0x9B;
		public const OP_add:int = 0xA0;
		public const OP_subtract:int = 0xA1;
		public const OP_multiply:int = 0xA2;
		public const OP_divide:int = 0xA3;
		public const OP_modulo:int = 0xA4;
		public const OP_lshift:int = 0xA5;
		public const OP_rshift:int = 0xA6;
		public const OP_urshift:int = 0xA7;
		public const OP_bitand:int = 0xA8;
		public const OP_bitor:int = 0xA9;
		public const OP_bitxor:int = 0xAA;
		public const OP_equals:int = 0xAB;
		public const OP_strictequals:int = 0xAC;
		public const OP_lessthan:int = 0xAD;
		public const OP_lessequals:int = 0xAE;
		public const OP_greaterthan:int = 0xAF;
		public const OP_greaterequals:int = 0xB0;
		public const OP_instanceof:int = 0xB1;
		public const OP_istype:int = 0xB2;
		public const OP_istypelate:int = 0xB3;
		public const OP_in:int = 0xB4;
		public const OP_increment_i:int = 0xC0;
		public const OP_decrement_i:int = 0xC1;
		public const OP_inclocal_i:int = 0xC2;
		public const OP_declocal_i:int = 0xC3;
		public const OP_negate_i:int = 0xC4;
		public const OP_add_i:int = 0xC5;
		public const OP_subtract_i:int = 0xC6;
		public const OP_multiply_i:int = 0xC7;
		public const OP_getlocal0:int = 0xD0;
		public const OP_getlocal1:int = 0xD1;
		public const OP_getlocal2:int = 0xD2;
		public const OP_getlocal3:int = 0xD3;
		public const OP_setlocal0:int = 0xD4;
		public const OP_setlocal1:int = 0xD5;
		public const OP_setlocal2:int = 0xD6;
		public const OP_setlocal3:int = 0xD7;
		public const OP_debug:int = 0xEF;
		public const OP_debugline:int = 0xF0;
		public const OP_debugfile:int = 0xF1;
		public const OP_bkptline:int = 0xF2;

		public const opNames = [
			"OP_0x00       ",
			"bkpt          ",
			"nop           ",
			"throw         ",
			"getsuper      ",
			"setsuper      ",
			"dxns          ",
			"dxnslate      ",
			"kill          ",
			"label         ",
			"OP_0x0A       ",
			"OP_0x0B       ",
			"ifnlt         ",
			"ifnle         ",
			"ifngt         ",
			"ifnge         ",
			"jump          ",
			"iftrue        ",
			"iffalse       ",
			"ifeq          ",
			"ifne          ",
			"iflt          ",
			"ifle          ",
			"ifgt          ",
			"ifge          ",
			"ifstricteq    ",
			"ifstrictne    ",
			"lookupswitch  ",
			"pushwith      ",
			"popscope      ",
			"nextname      ",
			"hasnext       ",
			"pushnull      ",
			"pushundefined ",
			"pushconstant  ",
			"nextvalue     ",
			"pushbyte      ",
			"pushshort     ",
			"pushtrue      ",
			"pushfalse     ",
			"pushnan       ",
			"pop           ",
			"dup           ",
			"swap          ",
			"pushstring    ",
			"pushint       ",
			"pushuint      ",
			"pushdouble    ",
			"pushscope     ",
			"pushnamespace ",
			"hasnext2      ",
			"OP_0x33       ",
			"OP_0x34       ",
			"OP_0x35       ",
			"OP_0x36       ",
			"OP_0x37       ",
			"OP_0x38       ",
			"OP_0x39       ",
			"OP_0x3A       ",
			"OP_0x3B       ",
			"OP_0x3C       ",
			"OP_0x3D       ",
			"OP_0x3E       ",
			"OP_0x3F       ",
			"newfunction   ",
			"call          ",
			"construct     ",
			"callmethod    ",
			"callstatic    ",
			"callsuper     ",
			"callproperty  ",
			"returnvoid    ",
			"returnvalue   ",
			"constructsuper",
			"constructprop ",
			"callsuperid   ",
			"callproplex   ",
			"callinterface ",
			"callsupervoid ",
			"callpropvoid  ",
			"OP_0x50       ",
			"OP_0x51       ",
			"OP_0x52       ",
			"OP_0x53       ",
			"OP_0x54       ",
			"newobject     ",
			"newarray      ",
			"newactivation ",
			"newclass      ",
			"getdescendants",
			"newcatch      ",
			"OP_0x5B       ",
			"OP_0x5C       ",
			"findpropstrict",
			"findproperty  ",
			"finddef       ",
			"getlex        ",
			"setproperty   ",
			"getlocal      ",
			"setlocal      ",
			"getglobalscope",
			"getscopeobject",
			"getproperty   ",
			"OP_0x67       ",
			"initproperty  ",
			"OP_0x69       ",
			"deleteproperty",
			"OP_0x6A       ",
			"getslot       ",
			"setslot       ",
			"getglobalslot ",
			"setglobalslot ",
			"convert_s     ",
			"esc_xelem     ",
			"esc_xattr     ",
			"convert_i     ",
			"convert_u     ",
			"convert_d     ",
			"convert_b     ",
			"convert_o     ",
			"checkfilter   ",
			"OP_0x79       ",
			"OP_0x7A       ",
			"OP_0x7B       ",
			"OP_0x7C       ",
			"OP_0x7D       ",
			"OP_0x7E       ",
			"OP_0x7F       ",
			"coerce        ",
			"coerce_b      ",
			"coerce_a      ",
			"coerce_i      ",
			"coerce_d      ",
			"coerce_s      ",
			"astype        ",
			"astypelate    ",
			"coerce_u      ",
			"coerce_o      ",
			"OP_0x8A       ",
			"OP_0x8B       ",
			"OP_0x8C       ",
			"OP_0x8D       ",
			"OP_0x8E       ",
			"OP_0x8F       ",
			"negate        ",
			"increment     ",
			"inclocal      ",
			"decrement     ",
			"declocal      ",
			"typeof        ",
			"not           ",
			"bitnot        ",
			"OP_0x98       ",
			"OP_0x99       ",
			"concat        ",
			"add_d         ",
			"OP_0x9C       ",
			"OP_0x9D       ",
			"OP_0x9E       ",
			"OP_0x9F       ",
			"add           ",
			"subtract      ",
			"multiply      ",
			"divide        ",
			"modulo        ",
			"lshift        ",
			"rshift        ",
			"urshift       ",
			"bitand        ",
			"bitor         ",
			"bitxor        ",
			"equals        ",
			"strictequals  ",
			"lessthan      ",
			"lessequals    ",
			"greaterthan   ",
			"greaterequals ",
			"instanceof    ",
			"istype        ",
			"istypelate    ",
			"in            ",
			"OP_0xB5       ",
			"OP_0xB6       ",
			"OP_0xB7       ",
			"OP_0xB8       ",
			"OP_0xB9       ",
			"OP_0xBA       ",
			"OP_0xBB       ",
			"OP_0xBC       ",
			"OP_0xBD       ",
			"OP_0xBE       ",
			"OP_0xBF       ",
			"increment_i   ",
			"decrement_i   ",
			"inclocal_i    ",
			"declocal_i    ",
			"negate_i      ",
			"add_i         ",
			"subtract_i    ",
			"multiply_i    ",
			"OP_0xC8       ",
			"OP_0xC9       ",
			"OP_0xCA       ",
			"OP_0xCB       ",
			"OP_0xCC       ",
			"OP_0xCD       ",
			"OP_0xCE       ",
			"OP_0xCF       ",
			"getlocal0     ",
			"getlocal1     ",
			"getlocal2     ",
			"getlocal3     ",
			"setlocal0     ",
			"setlocal1     ",
			"setlocal2     ",
			"setlocal3     ",
			"OP_0xD8       ",
			"OP_0xD9       ",
			"OP_0xDA       ",
			"OP_0xDB       ",
			"OP_0xDC       ",
			"OP_0xDD       ",
			"OP_0xDE       ",
			"OP_0xDF       ",
			"OP_0xE0       ",
			"OP_0xE1       ",
			"OP_0xE2       ",
			"OP_0xE3       ",
			"OP_0xE4       ",
			"OP_0xE5       ",
			"OP_0xE6       ",
			"OP_0xE7       ",
			"OP_0xE8       ",
			"OP_0xE9       ",
			"OP_0xEA       ",
			"OP_0xEB       ",
			"OP_0xEC       ",
			"OP_0xED       ",
			"OP_0xEE       ",
			"debug         ",
			"debugline     ",
			"debugfile     ",
			"bkptline      ",
			"timestamp     ",
			"OP_0xF4       ",
			"verifypass    ",
			"alloc         ",
			"mark          ",
			"wb            ",
			"prologue      ",
			"sendenter     ",
			"doubletoatom  ",
			"sweep         ",
			"codegenop     ",
			"verifyop      ",
			"decode        "
		];

		public var totalSize:int;
		public var opSizes:Array = new Array(256);


		public const stagDoABC         :int = 72;   // embedded .abc (AVM+) bytecode
		public const stagSymbolClass   :int = 76;
		public const stagDoABC2        :int = 82;   // revised ABC version with a name

		public var tagNames:Array = [
			"End",                  // 00
			"ShowFrame",            // 01
			"DefineShape",          // 02
			"FreeCharacter",        // 03
			"PlaceObject",          // 04
			"RemoveObject",         // 05
			"DefineBits",           // 06
			"DefineButton",         // 07
			"JPEGTables",           // 08
			"SetBackgroundColor",   // 09

			"DefineFont",           // 10
			"DefineText",           // 11
			"DoAction",             // 12
			"DefineFontInfo",       // 13

			"DefineSound",          // 14
			"StartSound",           // 15
			"StopSound",            // 16

			"DefineButtonSound",    // 17

			"SoundStreamHead",      // 18
			"SoundStreamBlock",     // 19

			"DefineBitsLossless",   // 20
			"DefineBitsJPEG2",      // 21

			"DefineShape2",         // 22
			"DefineButtonCxform",   // 23

			"Protect",              // 24

			"PathsArePostScript",   // 25

			"PlaceObject2",         // 26
			"27 (invalid)",         // 27
			"RemoveObject2",        // 28

			"SyncFrame",            // 29
			"30 (invalid)",         // 30
			"FreeAll",              // 31

			"DefineShape3",         // 32
			"DefineText2",          // 33
			"DefineButton2",        // 34
			"DefineBitsJPEG3",      // 35
			"DefineBitsLossless2",  // 36
			"DefineEditText",       // 37

			"DefineVideo",          // 38

			"DefineSprite",         // 39
			"NameCharacter",        // 40
			"ProductInfo",          // 41
			"DefineTextFormat",     // 42
			"FrameLabel",           // 43
			"DefineBehavior",       // 44
			"SoundStreamHead2",     // 45
			"DefineMorphShape",     // 46
			"FrameTag",             // 47
			"DefineFont2",          // 48
			"GenCommand",           // 49
			"DefineCommandObj",     // 50
			"CharacterSet",         // 51
			"FontRef",              // 52

			"DefineFunction",       // 53
			"PlaceFunction",        // 54

			"GenTagObject",         // 55

			"ExportAssets",         // 56
			"ImportAssets",         // 57

			"EnableDebugger",       // 58

			"DoInitAction",         // 59
			"DefineVideoStream",    // 60
			"VideoFrame",           // 61

			"DefineFontInfo2",      // 62
			"DebugID",              // 63
			"EnableDebugger2",      // 64
			"ScriptLimits",         // 65

			"SetTabIndex",          // 66

			"DefineShape4",         // 67
			"DefineMorphShape2",    // 68

			"FileAttributes",       // 69

			"PlaceObject3",         // 70
			"ImportAssets2",        // 71

			"DoABC",                // 72
			"73 (invalid)",         // 73
			"74 (invalid)",         // 74
			"75 (invalid)",         // 75
			"SymbolClass",          // 76
			"77 (invalid)",         // 77
			"78 (invalid)",         // 78
			"79 (invalid)",         // 79
			"80 (invalid)",         // 80
			"81 (invalid)",         // 81
			"DoABC2",               // 82
			"83 (invalid)"          // 83
		];

		const ATTR_final            :int = 0x01; // 1=final, 0=virtual
		const ATTR_override         :int = 0x02; // 1=override, 0=new
		const ATTR_metadata         :int = 0x04; // 1=has metadata, 0=no metadata
		const ATTR_public           :int = 0x08; // 1=add public namespace

		const CLASS_FLAG_sealed     :int = 0x01;
		const CLASS_FLAG_final      :int = 0x02;
		const CLASS_FLAG_interface  :int = 0x04;
	}
}