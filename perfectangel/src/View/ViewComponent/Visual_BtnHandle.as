package View.ViewComponent 
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import View.GameView.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import View.Viewutil.*;
	
	/**
	 * btn handle present way
	 * @author ...
	 */
	public class Visual_BtnHandle  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		private var _rule_table:MultiObject ;
		
		public function Visual_BtnHandle() 
		{
			
		}
		
		public function init():void
		{
			var btnlist:Array = [ResName.paytable_btn];// , ResName.rebet_btn, ResName.betcancel_btn];
			//下注區
			var btn_group:MultiObject = prepare("btn_group", new MultiObject() , GetSingleItem("_view").parent.parent);
			btn_group.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,3,1]);
			btn_group.container.x = -4;
			btn_group.container.y = 952;
			btn_group.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			btn_group.Post_CustomizedData = [[0, 0], [1580, -10], [1780, -10]];
			btn_group.Create_by_list(btnlist.length, btnlist, 0, 0, btnlist.length, 200, 0, "time_");		
			btn_group.rollout = test_reaction;
			btn_group.rollover = test_reaction;
			btn_group.mousedown = table_true;
			btn_group.mouseup = test_reaction;
			
			
			_rule_table = prepare("rule_table", new MultiObject() , GetSingleItem("_view").parent.parent);			
			_rule_table.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 1]);
			_rule_table.mousedown = table_true;
			_rule_table.mouseup = test_reaction;
			_rule_table.container.x = 30;
			_rule_table.container.y = 60;			
			_rule_table.Create_by_list(1,[ResName.ruletable], 0, 0, 1, 0, 0, "time_");		
			_rule_table.container.visible = false;
			
			//_tool.SetControlMc(btn_group.ItemList[1]);
			//_tool.SetControlMc(_rule_table.container);
			//add(_tool);
		}		
		
		public function test_reaction(e:Event, idx:int):Boolean
		{
			return true;
		}	
		
		public function table_true(e:Event, idx:int):Boolean
		{
			_rule_table.container.visible = !_rule_table.container.visible;				
			return true;
		}
		
		public function Game_iconclick_down(e:Event, idx:int):Boolean
		{
			if ( e.currentTarget.currentFrame == 3 || e.currentTarget.currentFrame == 4) return false;
			else
			{
				//dispatcher(new Intobject(idx, "Load_flash") );				
				//e.currentTarget.gotoAndStop(2);
				//loading game
				e.currentTarget.y += 10;
			}
			return true;
		}
		
		public function Game_iconclick_up(e:Event, idx:int):Boolean
		{
			if ( e.currentTarget.currentFrame == 3 || e.currentTarget.currentFrame == 4) return false;
			else
			{
				//loading game
				e.currentTarget.y -= 10;
			}
			return true;
		}
		
		
		public function BtnHint(e:Event, idx:int):Boolean
		{
			e.currentTarget.gotoAndStop(2);
			e.currentTarget["_hintText"].gotoAndStop(idx+1);
			return true;
		}
		
		public function gonewpage(e:Event, idx:int):Boolean
		{
			var request:URLRequest = new URLRequest("https://www.google.com.tw/");			
			navigateToURL( request, "_blank" );
			return true;
		}
			
	}

}