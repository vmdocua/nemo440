package docsultant.nemo440.ui
{
	import mx.controls.Image;
	import mx.controls.treeClasses.*;
	import mx.collections.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mx.controls.Tree;

	public class AbcTreeItemRenderer extends TreeItemRenderer
	{
		// myImage: holds the image we are adding to the tree nodes
        protected var myImage:Image;
        
        // set image properties
        private var imageWidth:Number 	= 16;
	    private var imageHeight:Number 	= 16;
	    
	    // set the margin between the image we are adding, and the label
	   	private var imageToLabelMargin:Number = 2;
	   	
	   	// show default branch icon?
	   	private var showDefaultBranchIcon:Boolean 	= false;
	   	// show default leaf icon?
	   	private var showDefaultLeafIcon:Boolean 	= true;
	   	
	   	// the image to be placed in branch nodes
        //private var branchImage:String 	= "assets/branch.gif";
        //private var leafImage:String 	= "assets/leaf.gif";
        
        
        public function AbcTreeItemRenderer() 
		{
			super();

			// InteractiveObject variables.
			mouseEnabled = false;
		}
		
		public function openBranch(evt:Event):void
		{
			// get the TreeListData
			var myListData:TreeListData = TreeListData(this.listData);
			
			// get the selected node
			var selectedNode:Object = myListData.item;
			
			// get the tree that owns us
			var theTree:Tree = Tree(myListData.owner);
			
			// find out if the selected branch is already open
			var isBranchOpen:Boolean = theTree.isItemOpen( selectedNode );
			
			// if the selected branch is open, let's close it
			// and if it's closed, let's open it
			isBranchOpen = isBranchOpen ? false : true;
			theTree.expandItem(selectedNode, isBranchOpen, true, false );
		}
		
		override protected function createChildren():void
		{
	        // create a new image() to hold the image we'll add to the tree item
			myImage = new Image();
			
			myImage.width = imageWidth;
			myImage.height = imageHeight;
			myImage.setStyle( "verticalAlign", "middle" );

			// and apply it to the tree item
			addChild(myImage);
			
			// add the event listener to the whole tree item
			// this will let us click anywhere on the branch item to expose the children of this branch
			addEventListener( MouseEvent.CLICK, openBranch  );
			
			super.createChildren();
	    }	
	    
		override public function set data(value:Object):void
		{
				super.data = value;
				
				
				
				// get the tree that owns us
				var _tree:Tree = Tree(this.parent.parent);
				
				// if the current node is a branch node
				if( super.listData!=null && TreeListData(super.listData).hasChildren)
				{
					// set styles...
				    //setStyle("color", 0xff0000);
				    //setStyle("fontWeight", 'bold');

				    // if we don't want to show the default branch icons, let's empty them
				    if( !showDefaultBranchIcon )
				    {
				    	_tree.setStyle("folderClosedIcon", null);
				    	_tree.setStyle("folderOpenIcon", null);
				    }
				}
				else
				{
					// if we are in here, then the current node is a leaf node
					
					// set styles...
				    //setStyle("color", 0x000000);
				    //setStyle("fontWeight", 'normal');
				    
				    // if we don't want to show the default leaf icons, let's empty them
				    if( !showDefaultLeafIcon )
				    {
				    	_tree.setStyle("defaultLeafIcon", null);
				    }
				}
	    }
	 	
	   override protected function updateDisplayList(unscaledWidth:Number,
														  unscaledHeight:Number):void
	   {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
	        if(super.data)
	        {
	        	// if the current node is a branch
			    if(TreeListData(super.listData).hasChildren)
			    {
			    	// get the current node and it's children as XMLList
			        var currentNodeXMLList:XMLList = new XMLList(TreeListData(super.listData).item);
			        
	
					// set the image to be displayed in the branches
			        //myImage.source = branchImage;
			        myImage.source = TreeListData(super.listData).item.itemIcon;

			        // get the number of children under the current node
			        //var numOfImmediateChildren:int = currentNodeXMLList[0].children().length();
			        // set the label text
			        //super.label.text =  TreeListData(super.listData).label + "(" + numOfImmediateChildren + ")";
			        super.label.text =  TreeListData(super.listData).label;
			        
			    } else {
			    	// if we are in here, then the current node is a leaf node
			    	
					myImage.source = TreeListData(super.listData).item.itemIcon;
			    }
			    // reset the position of the image to be before the label
			    myImage.x = super.label.x;
			    
			    // reset the position of the label to be after the image, plus give it a margin
			    super.label.x = myImage.x + imageWidth + imageToLabelMargin;
			}
	    }
	}
}