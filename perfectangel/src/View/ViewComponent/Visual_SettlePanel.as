package View.ViewComponent 
{
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import View.GameView.*;
	/**
	 * hintmsg present way
	 * @author ...
	 */
	public class Visual_SettlePanel  extends VisualHandler
	{	
		[Inject]
		public var _text:Visual_Text;
		
		public function Visual_SettlePanel() 
		{
			
		}
		
		public function init():void
		{
			var settletable:MultiObject = prepare("settletable", new MultiObject(), GetSingleItem("_view").parent.parent);		
			settletable.Create_by_list(1, [ResName.settletable], 0 , 0, 1, 0, 0, "Bet_");		
			settletable.container.x = 548;
			settletable.container.y = 445;
			settletable.container.visible = false;
			
			var settletable_title:MultiObject = prepare("settletable_title", new MultiObject(), settletable.container);		
			settletable_title.container.x = 70;
			settletable_title.container.y = 40;
			settletable_title.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			settletable_title.Post_CustomizedData = [[0,0],[410,0],[590]];
			settletable_title.CustomizedFun = _text.textSetting;
			settletable_title.CustomizedData = [{size:28}, "投注內容","得分","開牌結果"];
			settletable_title.Create_by_list(3, [ResName.TextInfo], 0 , 0, 3, 200, 0, "Bet_");		
			
			var settletable_zone:MultiObject = prepare("settletable_zone", new MultiObject(), settletable.container);		
			settletable_zone.container.x = 70;
			settletable_zone.container.y = 90;		
			settletable_zone.CustomizedFun = _text.textSetting;
			settletable_zone.CustomizedData = [{size:28}, "天使","惡魔","大天使8、9","大惡魔8、9","完美天使10","闇黑惡魔10","同點數","合計"];
			settletable_zone.Create_by_list(settletable_zone.CustomizedData.length-1, [ResName.TextInfo], 0 , 0, 1, 0, 50, "Bet_");		
			
			var settletable_zone_bet:MultiObject = prepare("settletable_zone_bet", new MultiObject(), settletable.container);		
			settletable_zone_bet.container.x = -250;
			settletable_zone_bet.container.y = 90;		
			settletable_zone_bet.CustomizedFun = _text.textSetting;
			settletable_zone_bet.CustomizedData = [{size:28,align:_text.align_right}, "100","100","1000","0","200","100000"];
			settletable_zone_bet.Create_by_list(6, [ResName.TextInfo], 0 , 0, 1, 0, 50, "Bet_");		
			
			
			var settletable_zone_settle:MultiObject = prepare("settletable_zone_settle", new MultiObject(), settletable.container);		
			settletable_zone_settle.container.x = -90;
			settletable_zone_settle.container.y = 90;		
			settletable_zone_settle.CustomizedFun = _text.colortextSetting;
			settletable_zone_settle.CustomizedData = [{size:28,align:_text.align_right}, "0","0","1000","0","0","100000","10000"];
			settletable_zone_settle.Create_by_list(7, [ResName.TextInfo], 0 , 0, 1, 0, 50, "Bet_");		
			
			var settletable_desh:MultiObject = prepare("settletable_desh", new MultiObject(), settletable.container);		
			settletable_desh.container.x = 70;
			settletable_desh.container.y = 418;		
			settletable_desh.CustomizedFun = _text.textSetting;
			settletable_desh.CustomizedData = [{size:24},"---------------------------------------------"];
			settletable_desh.Create_by_list(1, [ResName.TextInfo], 0 , 0, 1, 7, 0, "Bet_");			
			
			var settletable_H_desh:MultiObject = prepare("settletable_H_desh", new MultiObject(), settletable.container);		
			settletable_H_desh.container.x = 564;
			settletable_H_desh.container.y = 90;		
			settletable_H_desh.CustomizedFun = _text.textSetting;
			settletable_H_desh.CustomizedData = [ { size:24 }, "|", "|", "|", "|", "|", "|", "|", "|", "|", "|", "|", "|", "|", "|"];
			settletable_H_desh.Create_by_list(14, [ResName.TextInfo], 0 , 0, 1, 0, 26, "Bet_");
			
			
			var result_pai:MultiObject = prepare("result_pai", new MultiObject(), settletable.container);		
			result_pai.container.x = 390;
			result_pai.container.y = 110;
			result_pai.CustomizedFun = _text.textSetting;
			result_pai.CustomizedData = [{size:28,align:_text.align_center}, "天使","惡魔"];
			result_pai.Create_by_list(2, [ResName.TextInfo], 0 , 0, 1, 0, 160, "Bet_");		
			
			//開牌結果			
			var history_play_pai:MultiObject = prepare("history_Pai_list", new MultiObject() , settletable.container);			
			history_play_pai.container.x = 629;
			history_play_pai.container.y = 193;			
			history_play_pai.Create_by_bitmap(1, utilFun.Getbitmap("poker_atlas"), 0, 0, 6, 22, 25, "o_");		
			
			
			var history_Pai_list_e:MultiObject = prepare("history_Pai_list_e", new MultiObject() , settletable.container);			
			history_Pai_list_e.container.x = 629;
			history_Pai_list_e.container.y = 333;			
			history_Pai_list_e.Create_by_bitmap(1, utilFun.Getbitmap("poker_atlas"), 0, 0, 6, 22, 25, "o_");		
			
			
			
			var result_str_list:MultiObject = prepare("result_str_list", new MultiObject() , settletable.container);			
			result_str_list.container.x = 397;
			result_str_list.container.y = 404;
			result_str_list.Create_by_list(1, [ResName.TextInfo], 0 , 0,1,0 , 0, "Bet_");		
			
			//hintmsg.ItemList[0].gotoAndStop(2);	
			//_tool.SetControlMc(settletable_title.ItemList[2]);
			//_tool.SetControlMc(result_str_list.container);
			//add(_tool);
		}		
		
		public function sprite_idx_setting_player(mc:*, idx:int, data:Array):void
		{			
			var code:int  = pokerUtil.pokerTrans_s(data[idx]);			
			mc.x += 25;			
			//押暗
			//if ( history_win[Math.floor(idx / 5)] != ResName.angelball) mc.alpha =  0.5;			
			mc.drawTile(code);	
			//utilFun.scaleXY(mc, 2, 2);
		
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{				
			Get("settletable").container.visible = false;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "show_settle_table")]
		public function show_settle():void
		{
			utilFun.Log("show_settle");
			var settletable:MultiObject = Get("settletable");
			settletable.container.visible = true;
			
			//押注
			var zone_amount:Array = _model.getValue("result_zonebet_amount");			
			var font:Array = [{size:28,align:_text.align_right}];
			font = font.concat(zone_amount);			
			Get("settletable_zone_bet").CustomizedFun = _text.textSetting;
			Get("settletable_zone_bet").CustomizedData = font;
			Get("settletable_zone_bet").Create_by_list(zone_amount.length, [ResName.TextInfo], 0 , 0, 1, 0, 50, "Bet_");		
			
			//總結
			var settle_amount:Array = _model.getValue("result_settle_amount");
			settle_amount.push( _model.getValue("result_total"));
			var font2:Array = [{size:28,align:_text.align_right}];
			font2 = font2.concat(settle_amount);		
			font2 = font2.concat( _model.getValue("result_total"));			
			Get("settletable_zone_settle").CustomizedFun = _text.colortextSetting;
			Get("settletable_zone_settle").CustomizedData = font2;
			Get("settletable_zone_settle").Create_by_list(settle_amount.length, [ResName.TextInfo], 0 , 0, 1, 0, 50, "Bet_");				
			
			//小 poker
			var ppoker:Array =   _model.getValue(modelName.PLAYER_POKER);
			var bpoker:Array =   _model.getValue(modelName.BANKER_POKER);			
			
			Get("history_Pai_list").CustomizedFun = sprite_idx_setting_player;			
			Get("history_Pai_list").CustomizedData = ppoker;			
			Get("history_Pai_list").Create_by_bitmap(ppoker.length, utilFun.Getbitmap("poker_atlas"), 0, 0, 6, 22, 25, "o_");		
					
			Get("history_Pai_list_e").CustomizedFun = sprite_idx_setting_player;			
			Get("history_Pai_list_e").CustomizedData = bpoker;			
			Get("history_Pai_list_e").Create_by_bitmap(bpoker.length, utilFun.Getbitmap("poker_atlas"), 0, 0, 6, 22, 25, "o_");		
			
			//小牌結果
			var historystr_model:Array = _model.getValue("result_str_list");
			var add_parse:String = historystr_model.join("、");
			add_parse = add_parse.slice(0, 0) + "(" + add_parse.slice(0);
			add_parse = add_parse +")";
			
			Get("result_str_list").CustomizedFun =_text.textSetting;
			Get("result_str_list").CustomizedData =[{size:24,align:_text.align_center},add_parse];				
			Get("result_str_list").Create_by_list(1, [ResName.TextInfo], 0 , 0,1,0 , 0, "Bet_");		
			
			
		}	
		
		
	}

}