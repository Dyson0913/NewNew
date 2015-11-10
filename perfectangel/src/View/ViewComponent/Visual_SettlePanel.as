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
		
		public const extrapay:String = "extra_pay";	
		
		public function Visual_SettlePanel() 
		{
			
		}
		
		public function init():void
		{
			var settletable:MultiObject = create("settletable", [ResName.emptymc]);
			settletable.Create_(1, "settletable");		
			settletable.container.x = 1208;
			settletable.container.y = 95;
			settletable.container.visible = false;
			
			
			var settletable_title:MultiObject = create("settletable_title",[ResName.TextInfo], settletable.container);		
			settletable_title.container.x = 70;
			settletable_title.container.y = 40;
			settletable_title.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			settletable_title.Post_CustomizedData = [[0,0],[210,0],[360,0]];
			settletable_title.CustomizedFun = _text.textSetting;
			settletable_title.CustomizedData = [{size:24}, "投注內容", "押分","得分"];
			settletable_title.Create_(3, "settletable_title");	
			GetSingleItem("settletable_title", 2).visible = false;
			
			var font_config:Array = [9, 0, 30];
			var settletable_zone:MultiObject = create("settletable_zone",  [ResName.TextInfo], settletable.container);		
			settletable_zone.container.x = 70;
			settletable_zone.container.y = 80;
			settletable_zone.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			settletable_zone.Post_CustomizedData = font_config;
			settletable_zone.CustomizedFun = _text.textSetting;
			settletable_zone.CustomizedData = [{size:22}, "天使","惡魔","大天使8、9","大惡魔8、9","完美天使10","闇黑惡魔10","同點數","雙邊無賴","合計"];
			settletable_zone.Create_(settletable_zone.CustomizedData.length - 1, "settletable_zone");
			
			var settletable_zone_bet:MultiObject = create("settletable_zone_bet", [ResName.TextInfo], settletable.container);		
			settletable_zone_bet.container.x = -300;
			settletable_zone_bet.container.y = settletable_zone.container.y;		
			settletable_zone_bet.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			settletable_zone_bet.Post_CustomizedData = font_config;
			settletable_zone_bet.CustomizedFun = _text.textSetting;
			settletable_zone_bet.CustomizedData = [{size:22,align:_text.align_right,color:0xFF0000}, "0","0","0","0","0","0","0","0","0"];
			settletable_zone_bet.Create_(settletable_zone_bet.CustomizedData.length -1, "settletable_zone_bet");
			
			
			var settletable_zone_settle:MultiObject = create("settletable_zone_settle", [ResName.TextInfo], settletable.container);		
			settletable_zone_settle.container.x = -150;
			settletable_zone_settle.container.y = settletable_zone.container.y;		
			settletable_zone_settle.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			settletable_zone_settle.Post_CustomizedData = font_config;
			settletable_zone_settle.CustomizedFun = _text.colortextSetting;
			settletable_zone_settle.CustomizedData = [{size:22,align:_text.align_right}, "0","0","1000","0","0","100000","10000","0"];
			settletable_zone_settle.Create_(settletable_zone_settle.CustomizedData.length-1, "settletable_zone_settle");	
			settletable_zone_settle.container.visible = false;
			//
			//var extrapay:MultiObject = create("extrapay", [extrapay], settletable.container);
			//extrapay.Create_(1, "extrapay");		
			//extrapay.container.x = 484;
			//extrapay.container.y = 58;
			//35
			
			put_to_lsit(settletable);
			put_to_lsit(settletable_title);
			put_to_lsit(settletable_zone);
			put_to_lsit(settletable_zone_bet);
			put_to_lsit(settletable_zone_settle);
			//put_to_lsit(extrapay);
			
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
			var font:Array = [ { size:22, align:_text.align_right,color:0xFF0000} ];
			zone_amount.push(_betCommand.all_betzone_totoal());
			font = font.concat(zone_amount);			
			Get("settletable_zone_bet").CustomizedFun = _text.textSetting;
			Get("settletable_zone_bet").CustomizedData = font;
			Get("settletable_zone_bet").Create_by_list(zone_amount.length, [ResName.TextInfo], 0 , 0, 1, 0, 35, "Bet_");		
			
			//總結
			var settle_amount:Array = _model.getValue("result_settle_amount");			
			settle_amount.push( _model.getValue("result_total"));
			var font2:Array = [{size:22,align:_text.align_right}];
			font2 = font2.concat(settle_amount);		
			font2 = font2.concat( _model.getValue("result_total"));			
			Get("settletable_zone_settle").CustomizedFun = _text.colortextSetting;
			Get("settletable_zone_settle").CustomizedData = font2;
			Get("settletable_zone_settle").Create_by_list(settle_amount.length, [ResName.TextInfo], 0 , 0, 1, 0, 35, "Bet_");
			
			
			//外贈結果
			//var point:int = _model.getValue("light_idx");
			//if ( point <= 12)
			//{
				//angel extra string 
				//
				//_model.putValue("eviPoint", eviPoint);
				//_model.putValue("angPoint", angPoint);
			//}			
			//var wintype:String = _model.getValue("wintype");
			
			
			if ( _betCommand.all_betzone_totoal() == 0) return;
			
			dispatcher(new StringObject("sound_get_point","sound" ) );
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