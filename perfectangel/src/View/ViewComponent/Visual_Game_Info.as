package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.text.TextField;
	import flash.utils.Timer;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	/**
	 * Visual_Game_Info present way
	 * @author Dyson0913
	 */
	public class Visual_Game_Info  extends VisualHandler
	{
		
		[Inject]
		public var _betCommand:BetCommand;	
		
		[Inject]
		public var _text:Visual_Text;
		
		public function Visual_Game_Info() 
		{
			
		}
		
		public function init():void
		{			
			var bet:MultiObject = prepare("game_title_info", new MultiObject() , GetSingleItem("_view").parent.parent);
			bet.CustomizedFun = _text.textSetting;
			bet.CustomizedData = [{size:18}, "局號:"];
			bet.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			bet.Post_CustomizedData = [[0,0],[1020,0],[1130,0],[1300,0]];
			bet.Create_by_list(bet.CustomizedData.length-1, [ResName.TextInfo], 0, 0, bet.CustomizedData.length-1, 200, 0, "info_");			
			bet.container.x = 240;
			bet.container.y = 80;
							
			var game_info_data:MultiObject = prepare("game_title_info_data", new MultiObject() , GetSingleItem("_view").parent.parent);			
			game_info_data.CustomizedFun = _text.textSetting;
			game_info_data.CustomizedData = [{size:18} ,_model.getValue("game_round").toString()];
			game_info_data.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			game_info_data.Post_CustomizedData = [[0,0],[310,0],[1230,0],[1400,0]];
			game_info_data.Create_by_list(game_info_data.CustomizedData.length-1, [ResName.TextInfo], 0, 0, game_info_data.CustomizedData.length-1, 200, 0, "info_");
			game_info_data.container.x = 312;
			game_info_data.container.y = 80;
			
			var betlimit:MultiObject = create("betlimit", [ResName.betlimit, ResName.betstaticarrow]);	
			betlimit.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 0]);
			betlimit.mousedown = local;
			betlimit.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			betlimit.Post_CustomizedData = [[0,0],[194,164]];
			betlimit.container.x = -12;
			betlimit.container.y = 120;	
			betlimit.Create_(2, "betlimit");	
			
			var realtimeinfo:MultiObject = create("realtimeinfo", [ResName.realtimeinfo, ResName.betstaticarrow_right]);	
			realtimeinfo.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 0]);
			realtimeinfo.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			realtimeinfo.Post_CustomizedData = [[0, 0], [7, 164]];
			realtimeinfo.mousedown = local_reverse;
			realtimeinfo.container.x = 1719;
			realtimeinfo.container.y = 120;	
			realtimeinfo.Create_(2, "realtimeinfo");	
			
			put_to_lsit(betlimit);
			put_to_lsit(realtimeinfo);
			
			utilFun.SetTime(triger, 2);
		}
		
		private function triger():void
		{
			local_reverse(new MouseEvent(MouseEvent.CLICK, true, false), 0);
			local(new MouseEvent(MouseEvent.CLICK, true, false), 0);
		}
		
		public function local_reverse(e:Event, idx:int):Boolean
		{
			if( GetSingleItem("realtimeinfo",1).currentFrame == 1)
			{				
				GetSingleItem("realtimeinfo", 1).gotoAndStop(2);						
				_regular.moveTo(Get("realtimeinfo").container,1883,Get("realtimeinfo").container.y, 1, 0, shide);						
			}
			else
			{				
				GetSingleItem("realtimeinfo").visible =  true;				
				GetSingleItem("realtimeinfo", 1).gotoAndStop(1);			
				_regular.moveTo(Get("realtimeinfo").container, 1719, Get("realtimeinfo").container.y, 1, 0, null);
			}
			return false;
		}
		
		public function shide():void
		{
			GetSingleItem("realtimeinfo").visible = false;
		}
		
		public function local(e:Event, idx:int):Boolean
		{
			if( GetSingleItem("betlimit",1).currentFrame == 1)
			{				
				GetSingleItem("betlimit", 1).gotoAndStop(2);						
				_regular.moveTo(Get("betlimit").container,-195,Get("betlimit").container.y, 1, 0, hide);						
			}
			else
			{				
				GetSingleItem("betlimit").visible =  true;				
				GetSingleItem("betlimit", 1).gotoAndStop(1);			
				_regular.moveTo(Get("betlimit").container, -12, Get("betlimit").container.y, 1, 0, null);
			}
			return false;
		}
		
		public function hide():void
		{
			GetSingleItem("betlimit").visible = false;
		}
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			Get("betlimit").container.visible = true;
			Get("realtimeinfo").container.visible = true;
			
			utilFun.Clear_ItemChildren(Get("game_title_info_data").ItemList[1]);			
			var round_code:int = _opration.operator("game_round", DataOperation.add);
			var textfi:TextField = _text.dynamic_text(round_code.toString(),{size:18});
			Get("game_title_info_data").ItemList[1].addChild(textfi);	
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function opencard_parse():void
		{			
			Get("betlimit").container.visible = false;
			Get("realtimeinfo").container.visible = false;
		}
	}

}