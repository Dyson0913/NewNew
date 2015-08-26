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
	public class Visual_betZone  extends VisualHandler
	{
		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _regular:RegularSetting;
		
		public function Visual_betZone() 
		{
			
		}
		
		public function init():void
		{			
			var avaliblezone:Array = _model.getValue(modelName.AVALIBLE_ZONE);			
			var playerzone:MultiObject = prepare("betzone", new MultiObject() ,  GetSingleItem("_view").parent.parent);
			playerzone.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			playerzone.Post_CustomizedData = [ [828, 0], [0, 0],  [1057, 60],[308, 59], [907, 101],[504, 101]];
			playerzone.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,2,1]);			
			playerzone.Create_by_list(avaliblezone.length,avaliblezone, 0, 0, avaliblezone.length, 0, 0, "time_");			
			playerzone.container.x = 134;
			playerzone.container.y = 580;
			
			//playerzone.ItemList[0].gotoAndStop(2);
			//playerzone.ItemList[1].gotoAndStop(2);
			//playerzone.ItemList[2].gotoAndStop(2);
			//playerzone.ItemList[3].gotoAndStop(2);
			//playerzone.ItemList[4].gotoAndStop(2);
			//playerzone.ItemList[5].gotoAndStop(2);
			//
			//_tool.SetControlMc(playerzone.ItemList[0]);
			//_tool.SetControlMc(playerzone.ItemList[1]);
			//_tool.SetControlMc(playerzone.ItemList[2]);
			//_tool.SetControlMc(playerzone.ItemList[3]);
			//_tool.SetControlMc(playerzone.ItemList[4]);
			//_tool.SetControlMc(playerzone.ItemList[5]);
			//_tool.SetControlMc(playerzone.container);
			//add(_tool);	
			//_tool.SetControlMc(coinob.container);
			//add(_tool);			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean():void
		{
			var a:MultiObject = Get("coinstakeZone");
			for ( var i:int = 0; i <  a.ItemList.length; i++)
			{
				utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone",i));
			}		
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			var betzone:MultiObject = Get("betzone");
			betzone.mousedown = _betCommand.empty_reaction;			
			betzone.mouseup = _betCommand.empty_reaction;
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function timer_hide():void
		{			
			var betzone:MultiObject = Get("betzone");
			betzone.mousedown = null;			
			betzone.mouseup = null;
		}
		
		
	}

}