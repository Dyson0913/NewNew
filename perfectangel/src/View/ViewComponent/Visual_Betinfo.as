package View.ViewComponent 
{
	import asunit.framework.Assert;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	
	/**
	 * betinfo present way
	 * @author ...
	 */
	public class Visual_Betinfo  extends VisualHandler
	{
		[Inject]
		public var _text:Visual_Text;
		
		[Inject]
		public var _betCommand:BetCommand;
		
		public function Visual_Betinfo() 
		{
			
		}
		
		public function init():void
		{
			var settletable_zone:MultiObject = prepare("opencard_betinfo", new MultiObject(), GetSingleItem("_view").parent.parent);		
			settletable_zone.container.x = 1320;
			settletable_zone.container.y =  140;	
			settletable_zone.CustomizedFun = _text.textSetting;
			settletable_zone.CustomizedData = [{size:28}, "天使","惡魔","大天使8、9","大惡魔8、9","完美天使10","闇黑惡魔10","同點數","總計"];
			settletable_zone.Create_by_list(settletable_zone.CustomizedData.length-1, [ResName.TextInfo], 0 , 0, 1, 0, 38, "Bet_");		
			settletable_zone.container.visible = false;			
			
			var opencard_bet_amount:MultiObject = create("opencard_bet_amount", [ResName.TextInfo]);
			opencard_bet_amount.container.x = 1001;
			opencard_bet_amount.container.y =  145;	
			opencard_bet_amount.CustomizedFun = _text.textSetting;
			opencard_bet_amount.CustomizedData = [{size:26,align:_text.align_right,color:0xFF0000},"100","0","0","0","0","0","0","0"];
			opencard_bet_amount.Create_(8, "opencard_bet_amount");
			opencard_bet_amount.container.visible = false;
			
			put_to_lsit(opencard_bet_amount);
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			Get("opencard_betinfo").container.visible = false;
			Get("opencard_bet_amount").container.visible = false;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function opencard_parse():void
		{
			//下注單
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
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function settle_parse():void
		{
			Get("opencard_betinfo").container.visible = false;
			Get("opencard_bet_amount").container.visible = false;	
		}
		
	}
	
	

}