package View.ViewComponent 
{
	import flash.display.MovieClip;
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
	
	import View.Viewutil.MultiObject;
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
			
			//_tool.SetControlMc(game_info_data.container);			
			//_tool.SetControlMc(game_info_data.ItemList[3]);			
			//_tool.y = 200;
			//add(_tool);	
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			utilFun.Clear_ItemChildren(Get("game_title_info_data").ItemList[1]);			
			var round_code:int = _opration.operator("game_round", DataOperation.add);
			var textfi:TextField = _text.dynamic_text(round_code.toString(),{size:18});
			Get("game_title_info_data").ItemList[1].addChild(textfi);	
		}		
		
	}

}