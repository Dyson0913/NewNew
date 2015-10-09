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
			
		}
	
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			GetSingleItem("paytable_baridx").gotoAndStop(1);
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
			
			GetSingleItem("paytable_baridx").gotoAndStop(frame);			
		}
	}

}