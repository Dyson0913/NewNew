package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import View.GameView.gameState;
	
	/**
	 * btn handle present way
	 * @author ...
	 */
	public class Visual_BtnHandle  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;		
		
		private var _rule_table:MultiObject ;
		
		public const rebet_btn:String = "btn_rebet";
		public const betcancel_btn:String = "btn_betcancel";
		public const paytable_btn:String = "btn_paytable";
		public const ruletable:String = "rule_table";
		
		public function Visual_BtnHandle() 
		{
			
		}
		
		public function init():void
		{
			var btnlist:Array = [paytable_btn];
			//patable說明
			var btn_group:MultiObject = create("btn_group", btnlist);
			btn_group.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,3,1]);
			btn_group.container.x = -4;
			btn_group.container.y = 952;
			btn_group.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			btn_group.Post_CustomizedData = [[0, 0], [1580, -10], [1780, -10]];
			btn_group.Create_(btnlist.length);
			btn_group.rollout = empty_reaction;
			btn_group.rollover = empty_reaction;
			btn_group.mousedown = table_true;
			btn_group.mouseup = empty_reaction;
			
			//rebet
			var mylist:Array = [ rebet_btn];// , ResName.betcancel_btn];
			var mybtn_group:MultiObject = create("mybtn_group", mylist);
			mybtn_group.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,3,1]);
			mybtn_group.container.x = 1710;
			mybtn_group.container.y = 950;		
			mybtn_group.Create_(mylist.length);
			mybtn_group.rollout = empty_reaction;
			mybtn_group.rollover = empty_reaction;
			mybtn_group.mousedown = rebet_fun;
			mybtn_group.mouseup = empty_reaction;
			
			
			_rule_table  = create("rule_table", [ruletable]);
			_rule_table.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 1]);
			_rule_table.mousedown = table_true;
			_rule_table.mouseup = empty_reaction;
			_rule_table.container.x = 30;
			_rule_table.container.y = 60;		
			_rule_table.Create_(1);
			_rule_table.container.visible = false;
			
			put_to_lsit(_rule_table);
			
			state_parse([gameState.START_BET]);
			
		}
		
		public function table_true(e:Event, idx:int):Boolean
		{
			_rule_table.container.visible = !_rule_table.container.visible;				
			return true;
		}
		
		public function rebet_fun(e:Event, idx:int):Boolean
		{			
			var betzone:MultiObject = Get("mybtn_group");
			betzone.ItemList[0].gotoAndStop(4);
			betzone.rollout = null;
			betzone.rollover = null;
			betzone.mousedown = null;
			betzone.mouseup = null;
			
			_betCommand.re_bet();
			dispatcher(new StringObject("sound_rebet","sound" ) );
			return false;
		}
		
		override public function appear():void
		{
			utilFun.Log("_betCommand.need_rebet() ="+_betCommand.need_rebet());
			if ( !_betCommand.need_rebet() )
			{
				can_not_rebet()				
			}
			else
			{
				can_rebet();
			}		
		}
		
		override public function disappear():void
		{			
			var betzone:MultiObject = Get("mybtn_group");
			betzone.container.visible = false;		
		}
		
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
			var betzone:MultiObject = Get("mybtn_group");
			betzone.container.visible = true;
			betzone.ItemList[0].gotoAndStop(4);
			betzone.rollout = null;
			betzone.rollover = null;
			betzone.mousedown = null;
			betzone.mouseup = null;
		}		
	}

}