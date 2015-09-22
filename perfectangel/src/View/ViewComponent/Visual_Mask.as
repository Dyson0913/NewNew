package View.ViewComponent 
{
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * mask
	 * @author Dyson0913
	 */
	public class Visual_Mask  extends VisualHandler
	{
		public function Visual_Mask() 
		{
			
		}
		
		public function init():void
		{
			var mask:MultiObject = prepare("mask", new MultiObject()  , GetSingleItem("_view").parent.parent);
			mask.Create_by_list(1, [ResName.BGMask], 0, 0, 1, 0, 0, "time_");		
			mask.container.visible = false;
			
			//_tool.SetControlMc(playerzone.ItemList[0]);
			//_tool.SetControlMc(hintmsg.container);
			//add(_tool);
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			Get("mask").container.visible = false;			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function timer_hide():void
		{
			Get("mask").container.visible = true;			
		}		
	}

}