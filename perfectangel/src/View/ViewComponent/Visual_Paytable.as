package View.ViewComponent 
{
	import flash.events.Event;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * betzone present way
	 * @author ...
	 */
	public class Visual_Paytable  extends VisualHandler
	{
		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _regular:RegularSetting;
		
		public function Visual_Paytable() 
		{
			
		}
		
		public function init():void
		{					
			//var paytable_baridx:MultiObject = prepare("paytable_baridx", new MultiObject() ,  GetSingleItem("_view").parent.parent);
			//paytable_baridx.container.x = 233;
			//paytable_baridx.container.y =  195;
			//paytable_baridx.Create_by_list(1, [ResName.paytable_baridx], 0, 0, 1, 0, 0, "time_");			
			//paytable_baridx.ItemList[0].gotoAndStop(2);
			
			var paytable:MultiObject = prepare("paytable", new MultiObject() ,  GetSingleItem("_view").parent.parent);
			paytable.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 1]);			
			paytable.container.x = 250;
			paytable.container.y =  190;
			paytable.Create_by_list(1, [ResName.paytablemain], 0, 0, 1, 0, 0, "time_");
			
			
			
			var paytable_select:MultiObject = prepare("paytable_select", new MultiObject() ,  GetSingleItem("_view").parent.parent);
			paytable_select.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 1, 1, 0]);			
			paytable_select.rollover = paytable_sence;
			paytable_select.container.x = 260;
			paytable_select.container.y =  150;
			paytable_select.CustomizedFun = _regular.FrameSetting;
			paytable_select.CustomizedData = [1, 2];			
			paytable_select.Create_by_list(2, [ResName.paytable_selectbar], 0, 0, 2, 220, 0, "time_");
			
			var paytable_colorbar:MultiObject = prepare("paytable_colorbar", new MultiObject() ,  GetSingleItem("_view").parent.parent);						
			paytable_colorbar.container.x = 242;
			paytable_colorbar.container.y =  141;
			paytable_colorbar.Create_by_list(1, [ResName.paytable_colorbar], 0, 0, 1, 0, 0, "time_");			
			
		
			
			//_tool.SetControlMc(paytable_baridx.container);
			//_tool.SetControlMc(paytable_baridx.ItemList[0]);
			//add(_tool);			
		}
		
		public function paytable_sence(e:Event, idx:int):Boolean
		{			
			if ( idx == 0)
			{
				GetSingleItem("paytable").gotoAndStop(idx+1);
				Tweener.addTween(GetSingleItem("paytable_colorbar"), { x:0,time:0.5, transition:"easeOutCubic"} );
			}
			else if (idx  == 1)
			{
				GetSingleItem("paytable").gotoAndStop(idx+1);
				Tweener.addTween(GetSingleItem("paytable_colorbar"), { x:220,time:0.5, transition:"easeOutCubic"} );
			}
			return false;
		}		
		
	}

}