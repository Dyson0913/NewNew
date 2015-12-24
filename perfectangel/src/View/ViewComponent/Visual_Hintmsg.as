package View.ViewComponent 
{
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import View.GameView.gameState;
	
	/**
	 * hintmsg present way
	 * @author ...
	 */
	public class Visual_Hintmsg  extends VisualHandler
	{
		public const Hint:String = "HintMsg";
		
		private var frame_start_bet:int = 2;
		private var frame_stop_bet:int = 3;
		private var frame_credit_not_enough:int = 4;
		private var frame_open_card:int = 5;		
		
		public function Visual_Hintmsg() 
		{
			
		}
		
		public function init():void
		{
			var hintmsg:MultiObject = create(modelName.HINT_MSG, [Hint]);
			hintmsg.Create_(1);
			hintmsg.container.x = 960;
			hintmsg.container.y = 410;
			
			state_parse([gameState.START_BET]);
		}
		
		override public function appear():void
		{
			set_frame(frame_start_bet);
			dispatcher(new StringObject("sound_start_bet","sound" ) );
		}
		
		override public function disappear():void
		{			
			var state:int = _model.getValue(modelName.GAMES_STATE);
			var frame:int = 1;
			if ( state == gameState.END_BET)
			{
				frame = frame_stop_bet;				
				dispatcher(new StringObject("sound_stop_bet","sound" ) );
			}
			if ( state == gameState.START_OPEN) frame = frame_open_card;
			set_frame(frame);			
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "CreditNotEnough")]
		public function no_credit():void
		{
			set_frame(frame_credit_not_enough);	
		}
		
		private function set_frame(frame:int):void
		{
			GetSingleItem(modelName.HINT_MSG).gotoAndStop(frame);
			_regular.FadeIn( GetSingleItem(modelName.HINT_MSG), 2, 2, _regular.Fadeout);
		}
		
	}

}