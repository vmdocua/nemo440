// ActionScript file
package common
{
	import flash.display.DisplayObject;
	
	// closeDialogHandler is the same syntax as plain closeDialog event handler
	public function showModalDialog(cls:*, dialogParam:*=null, closeDialogHandler:Function=null, parent:DisplayObject=null, position:String="centerParent", wndParams:*=null):DialogWindow
	{
		if( cls is String )
			cls = Classes.load(String(cls));
		var dlg:Dialog = new Dialog(cls, position);
		if( closeDialogHandler!=null )
			dlg.addEventListener("closeDialog", closeDialogHandler);
		return dlg.showModal(parent, dialogParam, wndParams);
	}
}
