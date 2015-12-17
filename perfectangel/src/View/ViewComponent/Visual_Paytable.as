package View.ViewComponent 
{
	import flash.display.MovieClip;
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
	public class Visual_Paytable  extends VisualHandler
	{
		public const paytablemain:String = "paytable_main"		
		public const paytable_baridx:String = "paytable_bar_idx";
		
		public function Visual_Paytable() 
		{
			
		}
		
		public function init():void
		{			
			//賠率提示
			var paytable:MultiObject = create("paytable", [paytablemain]);
			paytable.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 1]);			
			paytable.container.x = 251.8;
			paytable.container.y =  126.35;
			paytable.Create_(1, "paytable");
			
			var paytable_baridx:MultiObject = create("paytable_baridx",  [paytable_baridx]);
			paytable_baridx.container.x = paytable.container.x;
			paytable_baridx.container.y = paytable.container.y;
			paytable_baridx.Create_(1,  "paytable_baridx");				
			
			state_parse([gameState.NEW_ROUND]);
		}
		
		override public function appear():void
		{			
			GetSingleItem("paytable_baridx").gotoAndStop(1);
		}		
		
		public function win_frame_hint(wintype:String):void
		{
			if ( wintype == "") return ;
			
			var frame:int = 1;
			if (wintype ==  "WSWin" || wintype == "WSPANormalWin" || wintype == "WSPAExSmallWin") frame = 6
			else if ( wintype == "WSPAExSmallWin" ||  wintype == "WSPAExBigAngelWin" || wintype == "WSPAExBigEvilWin") frame = 5
			else if ( wintype == "WSPAExPerfectAngelWin" || wintype == "WSPAExUnbeatenEvilWin")	frame = 4
			else if ( wintype == "WSPAFourOfAKindWin" || wintype == "WSPAExFourOfAKindWin") frame = 2
			else if ( wintype == "WSPAFiveWawaWin" || wintype == "WSPAExFiveWawaWin") frame = 3;
			
			GetSingleItem("paytable_baridx").gotoAndStop(frame);			
		}
		
		
	}

}