package View.ViewComponent 
{
	import flash.display.MovieClip;
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
		public var _betCommand:BetCommand;
		
		public const extrapay:String = "extra_pay";	
		
		public static const R_settleLine:String = "settle_line";
		
		public function Visual_SettlePanel() 
		{
			
		}
		
		public function init():void
		{
			var settletable:MultiObject = create("settletable", [ResName.emptymc]);
			settletable.Create_(1, "settletable");		
			settletable.container.x = 1198;
			settletable.container.y = 125;
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
			
			//var font_config:Array = [9, 0, 30];
			var settletable_zone:MultiObject = create("settletable_zone",  [ResName.TextInfo], settletable.container);		
			settletable_zone.container.x = 70;
			settletable_zone.container.y = 80;		
			settletable_zone.Posi_CustzmiedFun = _regular.Posi_xy_Setting
			settletable_zone.Post_CustomizedData = [[0, 0], [0, 31], [0, 62], [0, 93], [0, 124], [0, 155], [0, 186], [0, 217], [0, 258]];			
			settletable_zone.CustomizedFun = _text.textSetting;
			settletable_zone.CustomizedData = [{size:22}, "天使","惡魔","大天使8、9","大惡魔8、9","完美天使10","闇黑惡魔10","同點數","雙邊無賴","合計"];
			settletable_zone.Create_(settletable_zone.CustomizedData.length - 1, "settletable_zone");
			
			var settletable_zone_bet:MultiObject = create("settletable_zone_bet", [ResName.TextInfo], settletable.container);		
			settletable_zone_bet.container.x = -300;
			settletable_zone_bet.container.y = settletable_zone.container.y;		
			settletable_zone_bet.Posi_CustzmiedFun = _regular.Posi_xy_Setting
			settletable_zone_bet.Post_CustomizedData =[[0, 0], [0, 31], [0, 62], [0, 93], [0, 124], [0, 155], [0, 186], [0, 217], [0, 258]];	
			settletable_zone_bet.CustomizedFun = _text.textSetting;
			settletable_zone_bet.CustomizedData = [{size:22,align:_text.align_right,color:0xFFFFFF}, "0","0","0","0","0","0","0","0","0"];
			settletable_zone_bet.Create_(settletable_zone_bet.CustomizedData.length -1, "settletable_zone_bet");
			
			
			var settletable_zone_settle:MultiObject = create("settletable_zone_settle", [ResName.TextInfo], settletable.container);		
			settletable_zone_settle.container.x = -180;
			settletable_zone_settle.container.y = settletable_zone.container.y;		
			settletable_zone_settle.Posi_CustzmiedFun = _regular.Posi_xy_Setting
			settletable_zone_settle.Post_CustomizedData = [[0, 0], [0, 31], [0, 62], [0, 93], [0, 124], [0, 155], [0, 186], [0, 217], [0, 258]];
			settletable_zone_settle.CustomizedFun = _text.colortextSetting;
			settletable_zone_settle.CustomizedData = [{size:22,align:_text.align_right}, "0","0","1000","0","0","100000","10000","0"];
			settletable_zone_settle.Create_(settletable_zone_settle.CustomizedData.length-1, "settletable_zone_settle");	
			settletable_zone_settle.container.visible = false;
			
			var extrapay:MultiObject = create("extrapay", [extrapay], settletable.container);
			extrapay.Create_(1, "extrapay");
			extrapay.container.x = 484;
			extrapay.container.y = 58;
			
			
			var settleline:MultiObject = create("settletable_line",  [R_settleLine], settletable.container);		
			settleline.container.x = 40;
			settleline.container.y = settletable_zone.container.y + 250;
			settleline.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			settleline.Post_CustomizedData = [2, 100, 0];
			settleline.Create_(2, "settletable_line");
			
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{				
			Get("settletable").container.visible = false;
			GetSingleItem("settletable_title", 2).visible = false;
			Get("settletable_zone_settle").container.visible = false;
			Get("extrapay").container.visible = false;
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function opencard_parse():void
		{
			Get("settletable").container.visible = true;			
			GetSingleItem("settletable_title", 2).visible = false;
			Get("settletable_zone_settle").container.visible = false;
			Get("extrapay").container.visible = false;
			
			var mylist:Array = [];// ["0", "0", "0", "0", "0", "0", "0", "0"];
			var zone:Array = _model.getValue(modelName.AVALIBLE_ZONE_IDX);
			var maping:DI = _model.getValue("idx_to_result_idx");
			for ( var i:int = 0; i < zone.length; i++)
			{				
				var map:int = maping.getValue(zone[i]);				 
				mylist.splice(map, 0,_betCommand.get_total_bet(zone[i]));
			}
			
			mylist.push(_betCommand.all_betzone_totoal());
			
			//會計符號
			for (  i = 0; i < mylist.length; i++)
			{
				mylist[i] = utilFun.Accounting_Num(mylist[i]);
			}
			
			var font:Array = [{size:22,align:_text.align_right,color:0xFFFFFF}];
			font = font.concat(mylist);			
			var zone_bet:MultiObject = Get("settletable_zone_bet");
			zone_bet.CleanList();
			zone_bet.CustomizedData = font;			
			zone_bet.Create_(mylist.length,"settletable_zone_bet");			
			
			var special_handle:MovieClip = GetSingleItem("settletable_zone_bet", zone_bet.ItemList.length - 1);
			utilFun.Clear_ItemChildren(special_handle);
			_text.textSetting_s(special_handle, [ { size:24, align:_text.align_right, color:0xFF0000 } , mylist[mylist.length-1]]);			
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
			var font:Array = [ { size:22, align:_text.align_right,color:0xFFFFFF} ];
			zone_amount.push(_betCommand.all_betzone_totoal());
			
			//會計符號
			for ( var i:int = 0; i < zone_amount.length; i++)
			{
				zone_amount[i] = utilFun.Accounting_Num(zone_amount[i]);
			}
			
			font = font.concat(zone_amount);
			var zone_bet:MultiObject = Get("settletable_zone_bet");
			zone_bet.CleanList();
			zone_bet.CustomizedData = font;
			zone_bet.Create_(zone_amount.length,"settletable_zone_bet");		
			
			var special_handle:MovieClip = GetSingleItem("settletable_zone_bet", zone_bet.ItemList.length - 1);
			utilFun.Clear_ItemChildren(special_handle);
			_text.textSetting_s(special_handle, [ { size:22, align:_text.align_right, color:0xFF0000 } , zone_amount[zone_amount.length-1]]);			
			
			//總結
			var settle_amount:Array = _model.getValue("result_settle_amount");			
			settle_amount.push( _model.getValue("result_total"));
			
			//會計符號
			for (  i = 0; i < settle_amount.length; i++)
			{
				settle_amount[i] = utilFun.Accounting_Num(settle_amount[i]);
			}
			
			var font2:Array = [{size:22,align:_text.align_right}];
			font2 = font2.concat(settle_amount);		
			font2 = font2.concat( _model.getValue("result_total"));
			var zone_settle:MultiObject = Get("settletable_zone_settle");
			zone_settle.CleanList();
			zone_settle.CustomizedFun = _text.colortextSetting;
			zone_settle.CustomizedData = font2;
			zone_settle.Create_(settle_amount.length,"settletable_zone_bet");		
			
			special_handle = GetSingleItem("settletable_zone_settle", zone_settle.ItemList.length - 1);
			utilFun.Clear_ItemChildren(special_handle);
			_text.textSetting_s(special_handle, [ { size:22, align:_text.align_right, color:0xFF0000 } , settle_amount[settle_amount.length-1]]);			
			
			if ( _betCommand.all_betzone_totoal() == 0) return;
			
			//外贈結果
			if ( _model.getValue("extra_type_angle") != -1)
			{
				GetSingleItem("extrapay")["_odds"].gotoAndStop( _model.getValue("extra_type_angle"));				
				Get("extrapay").container.visible = true;				
				Get("extrapay").container.y = 58;
			}
			
			if ( _model.getValue("extra_type_evil") != -1)
			{
				GetSingleItem("extrapay")["_odds"].gotoAndStop( _model.getValue("extra_type_evil"));
				Get("extrapay").container.visible = true;				
				Get("extrapay").container.y = 88;
			}			
			
			dispatcher(new StringObject("sound_get_point","sound" ) );
			
			
		}	
		
		
	}

}