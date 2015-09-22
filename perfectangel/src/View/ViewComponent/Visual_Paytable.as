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
			
			var paytable_baridx:MultiObject = prepare("paytable_baridx", new MultiObject() ,  GetSingleItem("_view").parent.parent);
			paytable_baridx.container.x = 213;
			paytable_baridx.container.y =  165;
			paytable_baridx.Create_by_list(1, [ResName.paytable_baridx], 0, 0, 1, 0, 0, "time_");			
			//paytable_baridx.ItemList[0].gotoAndStop(2);			
			
			
			//賠率提示
			var paytable:MultiObject = prepare("paytable", new MultiObject() ,  GetSingleItem("_view").parent.parent);
			paytable.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 1]);			
			paytable.container.x = 210;
			paytable.container.y =  124;
			paytable.Create_by_list(1, [ResName.paytablemain], 0, 0, 1, 0, 0, "time_");
			
			//歷史記錄bar 選項底圖
			//var itembar:MultiObject = prepare("history_select_item_bar", new MultiObject() ,  GetSingleItem("_view").parent.parent);
			//itembar.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 0]);			
			//itembar.container.x = 1353;
			//itembar.container.y =  139;
			//itembar.Create_by_list(2, [ResName.history_select_itembar], 0, 0, 2, 70, 0, "time_");
			//itembar.mousedown = historySelect;
			//itembar.ItemList[0].gotoAndStop(2);
			
			//歷史記錄bar 選項名
			//var history:MultiObject = prepare("History", new MultiObject() ,  GetSingleItem("_view").parent.parent);			
			//history.container.x = 1360;
			//history.container.y =  140;
			//history.Create_by_list(1, [ResName.history_Item_select], 0, 0, 1, 0, 0, "time_");
			
			//歷史記錄bar 點擊呈現區
			var historytable:MultiObject = prepare("Historytable", new MultiObject() ,  GetSingleItem("_view").parent.parent);
			historytable.container.x = 1310;
			historytable.container.y =  170;
			historytable.Create_by_list(1, [ResName.historytable], 0, 0, 1, 0, 0, "time_");
			
			//歷史記錄bar sencer
			//var itembar_s:MultiObject = prepare("history_select_itembar_sencer", new MultiObject() ,  GetSingleItem("_view").parent.parent);
			//itembar_s.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 1]);			
			//itembar_s.container.x = 1353;
			//itembar_s.container.y =  139;
			//itembar_s.Create_by_list(2, [ResName.history_select_item_sencebar], 0, 0, 2, 70, 0, "time_");
			//itembar_s.mousedown = history_sence;
			//itembar_s.mouseup = _betCommand.empty_reaction;		
			
			
			//var paytable_colorbar:MultiObject = prepare("paytable_colorbar", new MultiObject() ,  GetSingleItem("_view").parent.parent);						
			//paytable_colorbar.container.x = 242;
			//paytable_colorbar.container.y =  141;
			//paytable_colorbar.Create_by_list(1, [ResName.paytable_colorbar], 0, 0, 1, 0, 0, "time_");			
			
			//結果歷史記錄
			var history_model:Array = _model.getValue("history_win_list");
			var historyball:MultiObject = prepare("historyball", new MultiObject() ,   historytable.container);
			historyball.container.x = 6.35;
			historyball.container.y = 8.85;
			historyball.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			historyball.Post_CustomizedData = [6,38,38 ];
			historyball.Create_by_list(history_model.length, history_model, 0, 0, 1, 0, 0, "histor");
			
			//開牌 歷史記錄	( 閒家 )	
			//var historyPai_model:Array = _model.getValue("history_Play_Pai_list");			
			//var history_play_pai:MultiObject = prepare("history_Pai_list", new MultiObject() , GetSingleItem("_view").parent.parent);
			//history_play_pai.CustomizedFun = sprite_idx_setting_player;			
			//history_play_pai.CustomizedData = historyPai_model;			
			//history_play_pai.container.x = 1362;
			//history_play_pai.container.y = 170;
			//history_play_pai.Create_by_bitmap(historyPai_model.length, utilFun.Getbitmap("poker_atlas"), 0, 0, historyPai_model.length, 22, 25, "o_");				
			//
			//var historyPai_banker_model:Array = _model.getValue("history_banker_Pai_list");			
			//var history_bank_pai:MultiObject = prepare("history_banker_Pai_list", new MultiObject() , GetSingleItem("_view").parent.parent);
			//history_bank_pai.CustomizedFun = sprite_idx_setting_banker;			
			//history_bank_pai.CustomizedData = historyPai_model;			
			//history_bank_pai.container.x = 1528;
			//history_bank_pai.container.y = 170;
			//history_bank_pai.Create_by_bitmap(historyPai_banker_model.length, utilFun.Getbitmap("poker_atlas"), 0, 0, historyPai_banker_model.length, 22, 25, "o_");				
			
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
			//opencard_bet_amount.CustomizedData = [{size:26,align:_text.align_right}, "","","","","","",""];
			//opencard_bet_amount.Create_by_list(7, [ResName.TextInfo], 0 , 0, 1, 0, 38, "Bet_");		
			opencard_bet_amount.container.visible = false;
			
			_tool.SetControlMc(opencard_bet_amount.container);
			//.._tool.SetControlMc(paytable_baridx.ItemList[0]);
			_tool.y = 200;
			add(_tool);			
		}
	
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			GetSingleItem("paytable_baridx").gotoAndStop(1);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function opencard_parse():void
		{
			Get("Historytable").container.visible = false;
			Get("opencard_betinfo").container.visible = true;
			
			Get("opencard_bet_amount").container.visible = true;			
			var mylist:Array = ["0", "0", "0", "0", "0", "0", "0","0"];
			var font:Array = [{size:26,align:_text.align_right}];
			font = font.concat(mylist);
			Get("opencard_bet_amount").CustomizedData = font;
			Get("opencard_bet_amount").Create_by_list(font.length-1, [ResName.TextInfo], 0 , 0, 1, 0, 38, "Bet_");	
		}
		
		public function win_frame_hint(wintype:String):void
		{
			if ( wintype == "") return ;
			var y:int = 0;
			if (wintype ==  "WSWin" || wintype == "WSPANormalWin") y = 175;
			else if ( wintype == "WSPATwoPointWin") y = 133;
			else if ( wintype == "WSPAOnePointWin")	y = 89;
			else if ( wintype == "WSPAFourOfAKindWin") y=0;	
			else if ( wintype == "WSPAFiveWawaWin") y = 45;
			
			GetSingleItem("paytable_baridx").y = y;
			_regular.Twinkle(GetSingleItem("paytable_baridx"), 5, 15, 2);
			
		}
		
		public function sprite_idx_setting_player(mc:*, idx:int, data:Array):void
		{			
			var code:int  = pokerUtil.pokerTrans_s(data[idx]);
						
			var history_win:Array = _model.getValue("history_win_list");
			
			mc.x = (idx % 5 * 33	);						
			mc.y = ( Math.floor(idx / 5) * 33);	
			//押暗
			if ( history_win[Math.floor(idx / 5)] != ResName.angelball) mc.alpha =  0.5;			
			mc.drawTile(code);		
		
		}
		
		public function sprite_idx_setting_banker(mc:*, idx:int, data:Array):void
		{			
			var code:int  = pokerUtil.pokerTrans_s(data[idx]);
						
			var history_win:Array = _model.getValue("history_win_list");
			
			mc.x = (idx % 5 * 33	);						
			mc.y = ( Math.floor(idx / 5) * 33);	
			//押暗				
			if ( history_win[Math.floor(idx / 5)] != ResName.evilball) mc.alpha =  0.5;		
			mc.drawTile(code);		
		
		}
		
		public function history_sence(e:Event, idx:int):Boolean
		{			
			var betzone:MultiObject = Get("history_select_item_bar");			
			var mc:MovieClip = betzone.ItemList[idx];
			mc.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false));			
			return true;
		}
		
		public function historySelect(e:Event, idx:int):Boolean
		{			
			var betzone:MultiObject = Get("history_select_item_bar");						
			betzone.exclusive(idx, 1);
			
			var hisoty_show_info:MultiObject = Get("Historytable");		
			hisoty_show_info.ItemList[0].gotoAndStop(idx+1);
			hisoty_show_info.customized();
			
			history_display(idx + 1);
			return true;
			
		}
		
		public function history_display(select:int):void
		{
			if ( select == 1)
			{
				Get("history_Pai_list").container.visible = false;
				Get("history_banker_Pai_list").container.visible = false;
				
				var history_model:Array = _model.getValue("history_win_list");
				Get("historyball").container.visible = true;
				Get("historyball").Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
				Get("historyball").Post_CustomizedData = [6, 33, 33 ];
				Get("historyball").Create_by_list(history_model.length, history_model, 0, 0, 1, 0, 0, "histor");
				//Get("historyball").customized();
			}
			else if (select == 2)
			{
				Get("historyball").container.visible = false;
				
				var historyPai_model:Array = _model.getValue("history_Play_Pai_list");
				Get("history_Pai_list").container.visible = true;
				Get("history_Pai_list").CustomizedFun = sprite_idx_setting_player;			
				Get("history_Pai_list").CustomizedData = historyPai_model;				
				Get("history_Pai_list").Create_by_bitmap(historyPai_model.length, utilFun.Getbitmap("poker_atlas"), 0, 0, historyPai_model.length, 22, 25, "o_");				
				
				
				var historyPai_banker_model:Array = _model.getValue("history_banker_Pai_list");
				Get("history_banker_Pai_list").container.visible = true;			
				Get("history_banker_Pai_list").CustomizedFun = sprite_idx_setting_banker;			
				Get("history_banker_Pai_list").CustomizedData = historyPai_banker_model;				
				Get("history_banker_Pai_list").Create_by_bitmap(historyPai_banker_model.length, utilFun.Getbitmap("poker_atlas"), 0, 0, historyPai_banker_model.length, 22, 25, "o_");		
			
			}
			
		}		
		
		//滑入bar 效果
		//public function paytable_sence(e:Event, idx:int):Boolean
		//{			
			//if ( idx == 0)
			//{
				//GetSingleItem("paytable").gotoAndStop(idx+1);
				//Tweener.addTween(GetSingleItem("paytable_colorbar"), { x:0,time:0.5, transition:"easeOutCubic"} );
			//}
			//else if (idx  == 1)
			//{
				//GetSingleItem("paytable").gotoAndStop(idx+1);
				//Tweener.addTween(GetSingleItem("paytable_colorbar"), { x:220,time:0.5, transition:"easeOutCubic"} );
			//}
			//return false;
		//}		
		
	}

}