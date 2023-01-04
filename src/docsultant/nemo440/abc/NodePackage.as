package docsultant.nemo440.abc
{
	public class NodePackage implements IAbcDomItem
	{
		public var name:String;
		private var m_children:Array = null;
		
		public function NodePackage(name_:String):void
		{
			name = name_;
		}
		
		public function addItem(o:*):void
		{
			if( m_children==null )
				m_children = [];
			m_children.push(o);
			// TODO: sort
		}
		
		public function sort():void
		{
			if( m_children!=null )
				m_children = m_children.sortOn("itemLabel");
		}
		
		public function get children():Array
		{
			return m_children;
		}
		
		public function get itemIcon():*
		{
			return Icons.PACKAGE;
		}
		
		public function get itemLabel():String
		{
			return name;
		}
		
		public function describe(o:*):String
		{
			return "";
		}
	}
}