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
			_betzone = create("betzone", avaliblezone);
			_betzone.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			_betzone.Post_CustomizedData = zone_xy;
			_betzone.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,2,0]);			
			_betzone.Create_(avaliblezone.length, "betzone");
			_betzone.container.x = 1081;
			_betzone.container.y = 657;
			
			//setFrame("betzone", 2);
			
			put_to_lsit(_betzone);
			
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{			
			Get("tableitem").container.visible = true;			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function start_bet():void
		{
			_betzone.mousedown = _betCommand.empty_reaction;					
			_betzone.rollout = _betCommand.empty_reaction;
			_betzone.rollover = _betCommand.empty_reaction;			
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