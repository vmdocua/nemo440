package common
{
	public interface ICommandTarget
	{
		function exec(command:String, parms:*):*;
	}
}