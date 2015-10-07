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
		
		[Inject]
		public var _betCommand:BetCommand;
		
		public function Visual_SettlePanel() 
		{
			
		}
		
		public function init():void
		{
			var settletable:MultiObject = prepare("settletable", new MultiObject(), GetSingleItem("_view").parent.parent);		
			settletable.Create_by_list(1, [ResName.emptymc], 0 , 0, 1, 0, 0, "Bet_");		
			settletable.container.x = 1208;
			settletable.container.y = 95;
			settletable.container.visible = false;
			
			
			var settletable_title:MultiObject = create("settletable_title",[ResName.TextInfo], settletable.container);		
			settletable_title.container.x = 70;
			settletable_title.container.y = 40;
			settletable_title.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			settletable_title.Post_CustomizedData = [[0,0],[260,0],[420,0]];
			settletable_title.CustomizedFun = _text.textSetting;
			settletable_title.CustomizedData = [{size:24}, "投注內容", "押分","得分"];
			settletable_title.Create_(3, "settletable_title");	
			GetSingleItem("settletable_title", 2).visible = false;
			
			var settletable_zone:MultiObject = prepare("settletable_zone", new MultiObject(), settletable.container);		
			settletable_zone.container.x = 70;
			settletable_zone.container.y = 80;		
			settletable_zone.CustomizedFun = _text.textSetting;
			settletable_zone.CustomizedData = [{size:24}, "天使","惡魔","大天使8、9","大惡魔8、9","完美天使10","闇黑惡魔10","同點數","合計"];
			settletable_zone.Create_by_list(settletable_zone.CustomizedData.length-1, [ResName.TextInfo], 0 , 0, 1, 0, 35, "Bet_");		
			
			var settletable_zone_bet:MultiObject = prepare("settletable_zone_bet", new MultiObject(), settletable.container);		
			settletable_zone_bet.container.x = -250;
			settletable_zone_bet.container.y = settletable_zone.container.y;		
			settletable_zone_bet.CustomizedFun = _text.textSetting;
			settletable_zone_bet.CustomizedData = [{size:24,align:_text.align_right,color:0xFF0000}, "0","0","0","0","0","0","0","0"];
			settletable_zone_bet.Create_by_list(8, [ResName.TextInfo], 0 , 0, 1, 0, 35, "Bet_");		
			
			
			var settletable_zone_settle:MultiObject = prepare("settletable_zone_settle", new MultiObject(), settletable.container);		
			settletable_zone_settle.container.x = -90;
			settletable_zone_settle.container.y = settletable_zone.container.y;		
			settletable_zone_settle.CustomizedFun = _text.colortextSetting;
			settletable_zone_settle.CustomizedData = [{size:24,align:_text.align_right}, "0","0","1000","0","0","100000","10000"];
			settletable_zone_settle.Create_by_list(7, [ResName.TextInfo], 0 , 0, 1, 0, 35, "Bet_");		
			settletable_zone_settle.container.visible = false;
			
			//var settletable_desh:MultiObject = prepare("settletable_desh", new MultiObject(), settletable.container);		
			//settletable_desh.container.x = 70;
			//settletable_desh.container.y = 308;		
			//settletable_desh.CustomizedFun = _text.textSetting;
			//settletable_desh.CustomizedData = [{size:24},"---------------------------------------------"];
			//settletable_desh.Create_by_list(1, [ResName.TextInfo], 0 , 0, 1, 7, 0, "Bet_");			
			
			//var settletable_H_desh:MultiObject = prepare("settletable_H_desh", new MultiObject(), settletable.container);		
			//settletable_H_desh.container.x = 564;
			//settletable_H_desh.container.y = 90;		
			//settletable_H_desh.CustomizedFun = _text.textSetting;
			//settletable_H_desh.CustomizedData = [ { size:24 }, "|", "|", "|", "|", "|", "|", "|", "|", "|", "|", "|", "|", "|", "|"];
			//settletable_H_desh.Create_by_list(14, [ResName.TextInfo], 0 , 0, 1, 0, 26, "Bet_");
			
			//var result_str_list:MultiObject = prepare("result_str_list", new MultiObject() , settletable.container);			
			//result_str_list.container.x = 397;
			//result_str_list.container.y = 404;
			//result_str_list.Create_by_list(1, [ResName.TextInfo], 0 , 0,1,0 , 0, "Bet_");		
			
			put_to_lsit(settletable_title);
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
			GetSingleItem("settletable_title", 2).visible = false;
			Get("settletable_zone_settle").container.visible = false;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function opencard_parse():void
		{
			Get("settletable").container.visible = true;			
			GetSingleItem("settletable_title", 2).visible = false;
			Get("settletable_zone_settle").container.visible = false;
			
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
			
			var font:Array = [{size:24,align:_text.align_right,color:0xFF0000}];
			font = font.concat(mylist);
			utilFun.Log("mylist = "+mylist);
			Get("settletable_zone_bet").CustomizedData = font;
			Get("settletable_zone_bet").Create_by_list(mylist.length, [ResName.TextInfo], 0 , 0, 1, 0, 35, "Bet_");	
			
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "show_settle_table")]
		public function show_settle():void
		{
			utilFun.Log("show_settle");			
			Get("settletable").container.visible = true;			
			GetSingleItem("settletable_title", 2).visible = true;
			Get("settletable_zone_settle").container.visible = true;
			
			//押注
			var zone_amount:Array = _model.getValue("result_zonebet_amount");			
			var font:Array = [ { size:24, align:_text.align_right,color:0xFF0000} ];
			zone_amount.push(_betCommand.all_betzone_totoal());
			font = font.concat(zone_amount);			
			Get("settletable_zone_bet").CustomizedFun = _text.textSetting;
			Get("settletable_zone_bet").CustomizedData = font;
			Get("settletable_zone_bet").Create_by_list(zone_amount.length, [ResName.TextInfo], 0 , 0, 1, 0, 35, "Bet_");		
			
			//總結
			var settle_amount:Array = _model.getValue("result_settle_amount");
			//TODO same point			
			settle_amount.push( _model.getValue("result_total"));
			var font2:Array = [{size:24,align:_text.align_right}];
			font2 = font2.concat(settle_amount);		
			font2 = font2.concat( _model.getValue("result_total"));			
			Get("settletable_zone_settle").CustomizedFun = _text.colortextSetting;
			Get("settletable_zone_settle").CustomizedData = font2;
			Get("settletable_zone_settle").Create_by_list(settle_amount.length, [ResName.TextInfo], 0 , 0, 1, 0, 35, "Bet_");
			
			//小牌結果
			//var historystr_model:Array = _model.getValue("result_str_list");
			//var add_parse:String = historystr_model.join("、");
			//add_parse = add_parse.slice(0, 0) + "(" + add_parse.slice(0);
			//add_parse = add_parse +")";
			//
			//Get("result_str_list").CustomizedFun =_text.textSetting;
			//Get("result_str_list").CustomizedData =[{size:24,align:_text.agit llign_center},add_parse];				
			//Get("result_str_list").Create_by_list(1, [ResName.TextInfo], 0 , 0,1,0 , 0, "Bet_");		
			
			
		}	
		
		
	}

}