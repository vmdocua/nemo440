package docsultant.nemo440.abc
{
	import flash.utils.ByteArray;
	
	import mx.messaging.messages.ErrorMessage;
	
	import nochump.util.zip.ZipEntry;
	import nochump.util.zip.ZipFile;
	
	public final class AbcUtils
	{
		public static const PRINT_MODE_TRACE       : int = 1;
		public static const PRINT_MODE_STRING      : int = 2;		
		public static const PRINT_MODE_PRINTWRITER : int = 3;				
		//
		public static var printEnabled :Boolean = false;
		//public static var printEnabled :Boolean = true;
		public static var printMode    :int = PRINT_MODE_TRACE;		
		public static var printString  :String = "";				
		public static var printWriter  :IPrintWriter = null;						

		public static function dump(data:ByteArray):void
		{
			var o:Boolean = printEnabled;
			printEnabled = true;
			parse(data);
			printEnabled = o;
		}
		
		public static function dumpToString(data:ByteArray):String
		{
			printString = "";
			printMode = PRINT_MODE_STRING;
			dump(data);
			return printString;
		}

		public static function dumpToPrintWriter(data:ByteArray, writer:IPrintWriter):void
		{
			printMode = PRINT_MODE_PRINTWRITER;
			printWriter = writer;
			dump(data);
			printWriter = null;
		}

		public static function formatSize(n:int):String
		{
			return ""+n+" bytes"; // TODO:
		}

		public static function parse(data:ByteArray):IAbcDomItem
		{
			
			if( AbcUtils.printEnabled )
			{
				print("/*");
				print(" * Disassembled by "+Version.PRODUCT_FULL_NAME+".");
				var d:Date = new Date();
				print(" * Date: "+d.toDateString()+", "+d.toTimeString()+".");
				print(" * Copyright 2007 Vadim Melnik.");				
				print(" * Homepage: "+Version.PRODUCT_HOMEPAGE+" .");				
				print(" * USE AT YOUR OWN RISK. NO WARRANTIES EXTENDED.");								
				print(" */");
				print("");
			}
			data.endian = "littleEndian";
			var version:uint = data.readUnsignedInt();
			switch (version) 
			{
					// e.g. 0x10 0x00 0x2e 0x00 in file or 0x002E0010 int value in memory
					case 46<<16|14:
					case 46<<16|15:
					case 46<<16|16:
							if( AbcUtils.printEnabled ) print("[DUMP ABC]");
							var abc:AbcEntry = new AbcEntry(data);
							if( printEnabled ) abc.dump();
							return abc;
						break;
						
					case 67|87<<8|83<<16|11<<24: // CWS11	
					case 67|87<<8|83<<16|10<<24: // CWS10	
					case 67|87<<8|83<<16|9<<24 : // CWS9
					case 67|87<<8|83<<16|8<<24 : // CWS8
					case 67|87<<8|83<<16|7<<24 : // CWS7
					case 67|87<<8|83<<16|6<<24 : // CWS6
							if( AbcUtils.printEnabled ) print("[DUMP COMPRESSED SWF]");
							var udata:ByteArray = new ByteArray();
							udata.endian = "littleEndian";
							var lenCWS:uint = data.readUnsignedInt();
							data.position = 8;
							data.readBytes(udata,0,data.length-data.position);
							var csize:int = udata.length;
							try
							{
								udata.uncompress();
							} catch(e:*)
							{
								// TODO: report wraning
							}

							if( AbcUtils.printEnabled ) print("SWF decompressed from "+formatSize(csize)+" to "+formatSize(udata.length));
							udata.position = 0;
							var swf:SwfEntry = new SwfEntry(udata);
							return swf;
						break;
						
					case 70|87<<8|83<<16|9<<24: // FWS9
					case 70|87<<8|83<<16|8<<24: // FWS8
					case 70|87<<8|83<<16|7<<24: // FWS7
					case 70|87<<8|83<<16|6<<24: // FWS6
					case 70|87<<8|83<<16|5<<24: // FWS5
					case 70|87<<8|83<<16|4<<24: // FWS4
							if( AbcUtils.printEnabled ) print("[DUMP RAW SWF]");
							data.position = 8; // skip header and length
							var swf2:SwfEntry = new SwfEntry(data);
							return swf2;
						break;
						
					case 0x04034B50: // SWC file
							// read SWC file
							data.position = 0;
							var zip:ZipFile = new ZipFile(data);
							var lib:ZipEntry = zip.getEntry("library.swf");
							if( lib!=null )
							{
								var baLib:ByteArray = zip.getInput(lib);
								baLib.position = 0;
								var s:String = String(baLib);
								return parse(baLib);
							}
						break;	
							
					default:
							if( AbcUtils.printEnabled ) print("[DUMP] Unknown format 0x"+version.toString(16));
							throw new Error("Unknown format 0x"+version.toString(16));
						break;
				}
				return null;
		}
		
		public static function print(s:String):void
		{
			switch(printMode)
			{
				case PRINT_MODE_STRING: 
						printString += s+"\n";
					break;
					
				case PRINT_MODE_TRACE : 
						trace(s);				
					break;
					
				case PRINT_MODE_PRINTWRITER:
						printWriter.println(s);
					break;
				
			}
		}
	}
}