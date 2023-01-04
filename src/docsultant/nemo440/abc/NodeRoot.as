package docsultant.nemo440.abc
{
	import docsultant.nemo440.abc.IAbcDomItem;
	import flash.utils.ByteArray;
	import docsultant.nemo440.abc.AbcUtils;
	
	public class NodeRoot implements IAbcDomItem
	{
		public var path :String;
		public var data :ByteArray;
		public var item :IAbcDomItem;
		
		public function NodeRoot(data_:ByteArray, path_:String):void
		{
			data = data_;
			path = path_;
			item = AbcUtils.parse(data);
		}
		
		public function get children():Array
		{
			return item.children;
		}
		
		
		public function get itemIcon():*
		{
			return item.itemIcon;
		}
		
		public function get itemLabel():String
		{
			if( path!=null && path.length>0 )
				return item.itemLabel+" ["+path+"]";
			return item.itemLabel;
		}
		
		public function describe(o:*):String
		{
			return item.describe(o);
		}
	}
}