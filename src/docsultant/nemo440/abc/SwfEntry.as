package docsultant.nemo440.abc
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public final class SwfEntry extends Constants implements IAbcDomItem
	{
		private var bitPos:int;
		private var bitBuf:int;
		public var data:ByteArray;
		
		private var rect       : Rectangle;
		private var frameRate  : Number;
		private var frameCount : Number;
		private var tags       : TagList;
		private var abcs       : Array;
		private var _children  : Array;		
		private var _packageMap: Dictionary;		

		function SwfEntry(data_:ByteArray):void
		{
			data = data_;
			rect = decodeRect();
			frameRate = (data.readUnsignedByte()<<8|data.readUnsignedByte());
			frameCount = data.readUnsignedShort();
			
			if( AbcUtils.printEnabled )
			{
				print("Size       : "+rect);
				print("Frame rate : "+frameRate);
				print("Frame count: "+frameCount);
			}	
			
			_packageMap = new Dictionary();
			
			tags = new TagList();
			decodeTags();
			
			createChildren();
		}

		private function decodeTags():void
		{
			var type:int;
			var h:int;
			var length:int;
			var offset:int;

			while( data.position<data.length )
			{
				h = data.readUnsignedShort();
				type = (h >> 6);

				length = h & 0x3F;

				if( length==0x3F )
					length = data.readInt();

				var tag:TagEntry = new TagEntry(data, type, data.position, length);
				tags.children.push(tag);

				var sname:String = "";
				switch( type )
				{
					case 0: 
							return;

					case stagDoABC2:
								var pos1:int = data.position;
								data.readInt();
								sname = readString();
								if( AbcUtils.printEnabled ) print("\nDoABC2 ["+sname+"]");
								length -= (data.position-pos1);
								// fall through
								
					case stagDoABC:
								var data2:ByteArray = new ByteArray();
								data2.endian = "littleEndian"
								data.readBytes(data2,0,length)
								var a:AbcEntry = new AbcEntry(data2, _packageMap);
								if( sname!=null )
									a.name = sname;
									
								if( abcs==null ) abcs = [];
									abcs.push(a);
								
								if( AbcUtils.printEnabled )	
									a.dump("  ");
							break;
							
					default:
								data.position += length
							break;
				}
			}
		}

		private function readString():String
		{
			var s:String = "";
			var c:int;

			while( c=data.readUnsignedByte() )
				s += String.fromCharCode(c);

			return s;
		}

		private function syncBits():void
		{
			bitPos = 0;
		}

		private function decodeRect():Rectangle
		{
			syncBits();

			var rect:Rectangle = new Rectangle();

			var nBits:int = readUBits(5);
			rect.xMin = readSBits(nBits);
			rect.xMax = readSBits(nBits);
			rect.yMin = readSBits(nBits);
			rect.yMax = readSBits(nBits);

			return rect;
		}

		private function readSBits(numBits:int):int
		{
			if (numBits > 32)
				throw new Error("Number of bits > 32");

			var num:int = readUBits(numBits);
			var shift:int = 32-numBits;
			// sign extension
			num = (num << shift) >> shift;
			return num;
		}

		private function readUBits(numBits:int):uint
		{
			if (numBits == 0)
				return 0;

			var bitsLeft:int = numBits;
			var result:int = 0;

			if( bitPos == 0 ) //no value in the buffer - read a byte
			{
					bitBuf = data.readUnsignedByte();
					bitPos = 8;
			}

			while (true)
			{
				var shift:int = bitsLeft - bitPos;
				if (shift > 0)
				{
						// Consume the entire buffer
						result |= bitBuf << shift;
						bitsLeft -= bitPos;

						// Get the next byte from the input stream
						bitBuf = data.readUnsignedByte();
						bitPos = 8;
				}
				else
				{
						// Consume a portion of the buffer
						result |= bitBuf >> -shift;
						bitPos -= bitsLeft;
						bitBuf &= 0xff >> (8 - bitPos); // mask off the consumed bits

						//if (print) System.out.println("  read"+numBits+" " + result);
						return result;
				}
			}
			return 0;
		}
		
		
		// IAbcDomItem
		public function get children():Array
		{
			return _children;
		}
		
		public function get itemIcon():*
		{
			return Icons.MOVIE;
		}
		
		public function get itemLabel():String
		{
			return "SWF";
		}
		
		public function describe(o:*):String
		{
			var s:String = "Size: "+rect;
			s += "\nFrame rate: "+frameRate;
			s += "\nFrame count "+frameCount;
			s += "\n\n[Tags]";
			s += tags.describe(o);
			return s;
		}
		
		public function dumpItem(prn:IAbcPrinter):void
		{
			prn.print("Size: "+rect);
			prn.print("Frame rate: "+frameRate);
			prn.print("Frame count "+frameCount);
			tags.dumpItem(prn);
			for each(var a:AbcEntry in abcs)
				a.dumpItem(prn);
		}
		
		////
		private function createChildren():void
		{
			/*
			_children = [];
			_children.push(tags);
			_children["push"].apply(_children, abcs);
			*/
			
			_children = [];
			for each(var abc:AbcEntry in abcs)
			{
				_children["push"].apply(_children, abc.children);
			}
			
			_children = _children.sortOn("itemLabel");
			
			for each(var c:NodePackage in _children)
			{
				c.sort();
			}
		}
	}
}
