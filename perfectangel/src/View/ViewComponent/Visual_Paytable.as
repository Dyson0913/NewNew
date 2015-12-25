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
			var paytable:MultiObject = create(paytablemain, [paytablemain]);
			paytable.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 1]);			
			paytable.container.x = 251.8;
			paytable.container.y =  126.35;
			paytable.Create_(1);
			
			var paytable_baridx:MultiObject = create(paytable_baridx,  [paytable_baridx]);
			paytable_baridx.container.x = paytable.container.x;
			paytable_baridx.container.y = paytable.container.y;
			paytable_baridx.Create_(1);				
			
			state_parse([gameState.NEW_ROUND]);
		}
		
		override public function appear():void
		{			
			GetSingleItem(paytable_baridx).gotoAndStop(1);
			Tweener.pauseTweens( GetSingleItem(paytable_baridx) );
		}	
		
		[MessageHandler(type = "Model.valueObject.StringObject",selector="winstr_hint")]
		public function win_frame_hint():void
		{
			var wintype:int = _model.getValue("winstr");
			_regular.Twinkle_by_JumpFrame(GetSingleItem(paytable_baridx), 25, 60, 1, wintype);
		}
		
		
	}

}