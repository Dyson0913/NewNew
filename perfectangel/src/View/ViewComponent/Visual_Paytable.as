package View.ViewComponent 
{
	import asunit.errors.AbstractError;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import View.ViewBase.Visual_Text;
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
		public var _text:Visual_Text;;
		
		public function Visual_Paytable() 
		{
			
		}
		
		public function init():void
		{
			
			
			//賠率提示
			var paytable:MultiObject = prepare("paytable", new MultiObject() ,  GetSingleItem("_view").parent.parent);
			paytable.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 1]);			
			paytable.container.x = 240;
			paytable.container.y =  124;
			paytable.Create_by_list(1, [ResName.paytablemain], 0, 0, 1, 0, 0, "time_");
		
			var paytable_baridx:MultiObject = prepare("paytable_baridx", new MultiObject() ,  GetSingleItem("_view").parent.parent);
			paytable_baridx.container.x = 240;
			paytable_baridx.container.y =  134;
			paytable_baridx.Create_by_list(1, [ResName.paytable_baridx], 0, 0, 1, 0, 0, "time_");			
			//paytable_baridx.ItemList[0].gotoAndStop(2);		
			
			
			//歷史記錄bar 點擊呈現區
			var historytable:MultiObject = prepare("Historytable", new MultiObject() ,  GetSingleItem("_view").parent.parent);
			historytable.container.x = 1310;
			historytable.container.y =  170;
			historytable.Create_by_list(1, [ResName.historytable], 0, 0, 1, 0, 0, "time_");
			
			//結果歷史記錄
			var history_model:Array = _model.getValue("history_win_list");
			var historyball:MultiObject = prepare("historyball", new MultiObject() ,   historytable.container);
			historyball.container.x = 6.35;
			historyball.container.y = 8.85;
			historyball.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			historyball.Post_CustomizedData = [6,38,38 ];
			historyball.Create_by_list(60, [ResName.historyball], 0, 0, 1, 0, 0, "histor");			
			//historyball.container.visible = true;				
			
			var settletable_zone:MultiObject = prepare("opencard_betinfo", new MultiObject(), GetSingleItem("_view").parent.parent);		
			settletable_zone.container.x = 1320;
			settletable_zone.container.y =  140;	
			settletable_zone.CustomizedFun = _text.textSetting;
			settletable_zone.CustomizedData = [{size:28}, "天使","惡魔","大天使8、9","大惡魔8、9","完美天使10","闇黑惡魔10","同點數","總計"];
			settletable_zone.Create_by_list(settletable_zone.CustomizedData.length-1, [ResName.TextInfo], 0 , 0, 1, 0, 38, "Bet_");		
			settletable_zone.container.visible = false;			
			
			var opencard_bet_amount:MultiObject = prepare("opencard_bet_amount", new MultiObject(), GetSingleItem("_view").parent.parent);		
			opencard_bet_amount.container.x = 1001;
			opencard_bet_amount.container.y =  139;	
			opencard_bet_amount.CustomizedFun = _text.textSetting;
			opencard_bet_amount.container.visible = false;
			
			//_tool.SetControlMc(paytable.container);
			//.._tool.SetControlMc(paytable_baridx.ItemList[0]);
			//_tool.y = 200;
			//add(_tool);			
		}
	
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			GetSingleItem("paytable_baridx").gotoAndStop(1);
			
			Get("Historytable").container.visible = true;
			Get("opencard_betinfo").container.visible = false;
			Get("opencard_bet_amount").container.visible = false;	
			
			update_history();
		}
		
		public function update_history():void
		{
			var history_model:Array = _model.getValue("history_win_list");
			Get("historyball").CustomizedData = history_model;
			Get("historyball").CustomizedFun = history_ball_Setting;
			Get("historyball").FlushObject();
		}
		
		public function history_ball_Setting(mc:MovieClip, idx:int, data:Array):void
		{			
			var info:Array =  data[idx];
			utilFun.Log("history_ball_Setting " + data[idx]);
			if ( data[idx] == undefined ) return;
			var frame:int = info[0];
			if ( info[0] != 4)
			{				
				mc["_Text"].text = info[1];
			}
			mc.gotoAndStop(frame);
		}
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function opencard_parse():void
		{
			Get("Historytable").container.visible = false;
			Get("opencard_betinfo").container.visible = true;			
			Get("opencard_bet_amount").container.visible = true;	
			
			
			var mylist:Array = [];// ["0", "0", "0", "0", "0", "0", "0", "0"];
			var zone:Array = _model.getValue(modelName.AVALIBLE_ZONE_IDX);
			var maping:DI = _model.getValue("idx_to_result_idx");
			for ( var i:int = 0; i < zone.length; i++)
			{				
				var map:int = maping.getValue(zone[i]);				 
				mylist.splice(map, 0,_betCommand.get_total_bet(zone[i]));
			}
			//同點數
			mylist.push(0);
			mylist.push(_betCommand.all_betzone_totoal());
			
			
			
			var font:Array = [{size:26,align:_text.align_right,color:0xFF0000}];
			font = font.concat(mylist);
			Get("opencard_bet_amount").CustomizedData = font;
			Get("opencard_bet_amount").Create_by_list(font.length-1, [ResName.TextInfo], 0 , 0, 1, 0, 38, "Bet_");	
		}
		
		public function win_frame_hint(wintype:String):void
		{
			if ( wintype == "") return ;			
			var frame:int = 1;
			if (wintype ==  "WSWin" || wintype == "WSPANormalWin") frame = 6
			else if ( wintype == "WSPATwoPointWin") frame = 5
			else if ( wintype == "WSPAOnePointWin")	frame = 4
			else if ( wintype == "WSPAFourOfAKindWin") frame = 2
			else if ( wintype == "WSPAFiveWawaWin") frame = 3;
			
			//GetSingleItem("paytable_baridx").y = y;
			GetSingleItem("paytable_baridx").gotoAndStop(frame);
			
			//TODO frame Twinkel
			//_regular.Twinkle(GetSingleItem("paytable_baridx"), 5, 15, 2);
			
		}
		
		

	}

}