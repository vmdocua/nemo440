package docsultant.nemo440.air
{
	import docsultant.nemo440.abc.IPrintWriter;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class FilePrintWriter implements IPrintWriter
	{
		private var m_stm:FileStream;
		
		public function FilePrintWriter(name:String):void
		{
			open(name);
		}
		
		public function open(name:String):void
		{
			if( m_stm!=null ) throw new Error("File already openned");
			var f:File = new File();
			f.nativePath = name;

			m_stm = new FileStream();
			m_stm.open(f, FileMode.WRITE);
		}
		
		public function close():void
		{
			if( m_stm!=null )
			{
				m_stm.close();	
				m_stm = null;
			}
		}
		
		public function print(o:*):void
		{
			m_stm.writeMultiByte(""+o, "iso-8859-1");
		}
		
		public function println(o:*):void
		{
			m_stm.writeMultiByte(""+o+"\n", "iso-8859-1");
		}
	}
}