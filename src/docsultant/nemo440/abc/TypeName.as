package docsultant.nemo440.abc
{
	public class TypeName
    {
        public var name  :*;
        public var types : Array;
        
        public function TypeName(name:*, types:Array):void
        {
            this.name = name;
            this.types = types;
        }
        
        public function toString():String
        {
            var s : String = name.toString();
            s += ".<";
            for( var i = 0; i < types.length; ++i )
                s += types[i] != null ? types[i].toString() : "*" + " ";
            s += ">"
            return s;
        }
    }
}