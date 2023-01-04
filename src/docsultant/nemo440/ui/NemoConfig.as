package docsultant.nemo440.ui
{
	public final class NemoConfig
	{
		//public static var DEBUG:Boolean = true;
		public static var DEBUG:Boolean = false;
		public static var instance:NemoConfig = new NemoConfig();
		
		public var dumpFileName:String = "C:\\nemo440.dump";
		public var mru:MruList = new MruList([
				new MruItem(MruItem.URL,  "C:\\foo.swf")
				//new MruItem(MruItem.FILE, "C:\\airglobal.swc"),
				//new MruItem(MruItem.FILE, "C:\\airframework.swc"),
				//new MruItem(MruItem.URL,  "http://localhost")
			]);
	}
}