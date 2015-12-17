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
	import View.GameView.gameState;
	/**
	 * betzone present way
	 * @author ...
	 */
	public class Visual_HistoryRecoder  extends VisualHandler
	{
		public const historytable:String = "history_table";
		public const historyball:String = "history_ball";
		
		[Inject]
		public var _betCommand:BetCommand;
		
		
		
		public function Visual_HistoryRecoder() 
		{
			
		}
		
		public function init():void
		{			
			var historytable:MultiObject = create("Historytable", [historytable]);
			historytable.container.x = 1310;
			historytable.container.y =  140;
			historytable.Create_(1, "Historytable");
			
			//結果歷史記錄			
			var historyball:MultiObject = create("historyball",[historyball] ,   historytable.container);
			historyball.container.x = 6.35;
			historyball.container.y = 8.85;
			historyball.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;
			historyball.Post_CustomizedData = [6,38,38 ];
			historyball.Create_(60, "historyball");			
			
			put_to_lsit(historytable);	
			put_to_lsit(historyball);
			
			state_parse([gameState.NEW_ROUND, gameState.START_BET]);
		}
		
		override public function appear():void
		{
			Get("Historytable").container.visible = true;
			update_history();
		}
		
		override public function disappear():void
		{
			Get("Historytable").container.visible = false;	
		}		
		
		public function update_history():void
		{			
			for ( var i:int = 0; i < 60; i ++)
			{
				GetSingleItem("historyball", i).gotoAndStop(1);
				GetSingleItem("historyball", i)["_Text"].text = "";				
			}
			
			Get("historyball").CustomizedData = _model.getValue("history_list");
			Get("historyball").CustomizedFun = history_ball_Setting;
			Get("historyball").FlushObject();
		}
		
		//{"winner": "BetPAAngel", "point": 1}
		public function history_ball_Setting(mc:MovieClip, idx:int, data:Array):void
		{			
			//2,player  3,banker,non
			var info:Object = data[idx];
			
			var frame:int = 0;
			if ( info.winner == "BetPAAngel") frame = 3;			
			if ( info.winner == "BetPAEvil") frame = 2;
			if ( info.winner == "None") frame = 5;
			mc.gotoAndStop(frame);
			
			if ( frame == 5) return;
			mc["_Text"].text =  info.point;
		}
		
	}

}