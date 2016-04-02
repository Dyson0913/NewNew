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
			
			//rebets			
			var mybtn_group:MultiObject = create("mybtn_group",  [ ResName.rebet_btn]);
			mybtn_group.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,3,1]);
			mybtn_group.container.x = 1710;
			mybtn_group.container.y = 950;			
			mybtn_group.Create_(1,"mybtn_group");
			mybtn_group.rollout = empty_reaction;
			mybtn_group.rollover = empty_reaction;
			mybtn_group.mousedown = rebet_fun;
			mybtn_group.mouseup = empty_reaction;
			mybtn_group.container.visible = false;
			
		}		
		
		public function rebet_fun(e:Event, idx:int):Boolean
		{	
			//押下後馬上消失
			rebet_btn_disappear();
			
			_betCommand.re_bet();
			dispatcher(new StringObject("sound_rebet","sound" ) );
			return false;
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
			
			/*
			utilFun.Log("_betCommand.need_rebet() ="+_betCommand.need_rebet());
			if ( !_betCommand.need_rebet() )
			{
				can_not_rebet();
			}
			else
			{
				can_rebet();
			}	*/	
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
			can_not_rebet();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "can_rebet")]
		public function can_rebet():void
		{
			var betzone:MultiObject = Get("mybtn_group");
			betzone.container.visible = true;
			betzone.ItemList[0].gotoAndStop(1);
			betzone.rollout = _betCommand.empty_reaction;
			betzone.rollover = _betCommand.empty_reaction;
			betzone.mousedown = rebet_fun;
			betzone.mouseup = _betCommand.empty_reaction;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "can_not_rebet")]
		public function can_not_rebet():void
		{
			rebet_btn_disappear();	
		}
		
		private function rebet_btn_disappear():void
		{
			var betzone:MultiObject = Get("mybtn_group");
			betzone.container.visible = false;
			
			betzone.ItemList[0].gotoAndStop(4);
			betzone.rollout = null;
			betzone.rollover = null;
			betzone.mousedown = null;
			betzone.mouseup = null;
		}
		
	}

}