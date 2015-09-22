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
		
		private var _betzone:MultiObject;
		
		public function Visual_betZone() 
		{
			
		}
		
		public function init():void
		{			
			var tableitem:MultiObject = prepare("tableitem", new MultiObject() , GetSingleItem("_view").parent.parent);			
			tableitem.container.x = 193;
			tableitem.container.y = 655;
			tableitem.Create_by_list(1, [ResName.bet_tableitem], 0, 0, 1, 50, 0, "betzone_");	
			
			var zone_xy:Array = _model.getValue(modelName.AVALIBLE_ZONE_XY);
			
			var avaliblezone:Array = _model.getValue(modelName.AVALIBLE_ZONE);			
			_betzone= prepare("betzone", new MultiObject() ,  GetSingleItem("_view").parent.parent);
			_betzone.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			_betzone.Post_CustomizedData = zone_xy;
			_betzone.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,2,0]);			
			_betzone.Create_by_list(avaliblezone.length,avaliblezone, 0, 0, avaliblezone.length, 0, 0, "time_");			
			_betzone.container.x = 1081;
			_betzone.container.y = 657;
			
			//_betzone.ItemList[0].gotoAndStop(2);
			//_betzone.ItemList[1].gotoAndStop(2);
			//_betzone.ItemList[2].gotoAndStop(2);
			//_betzone.ItemList[3].gotoAndStop(2);
			//_betzone.ItemList[4].gotoAndStop(2);
			//_betzone.ItemList[5].gotoAndStop(2);
			//_betzone.ItemList[6].gotoAndStop(2);
			//_betzone.ItemList[7].gotoAndStop(2);
			//_betzone.ItemList[8].gotoAndStop(2);
			
			//_tool.SetControlMc(_betzone.ItemList[6]);
			//_tool.SetControlMc(_betzone.container);		
			//add(_tool);						
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{			
			_betzone.mousedown = _betCommand.empty_reaction;					
			_betzone.rollout = _betCommand.empty_reaction;
			_betzone.rollover = _betCommand.empty_reaction;
			
			Get("tableitem").container.visible = true;
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function timer_hide():void
		{		
			_betzone.mousedown = null;
			_betzone.rollout = _betCommand.empty_reaction;
			_betzone.rollover = _betCommand.empty_reaction;
			
			var frame:Array = [];
			for ( var i:int = 0; i  <  _betzone.ItemList.length; i++) frame.push(1);
			_betzone.CustomizedFun = _regular.FrameSetting;
			_betzone.CustomizedData = frame;
			_betzone.FlushObject();
			
			Get("tableitem").container.visible = false;
		}
		
		
	}

}