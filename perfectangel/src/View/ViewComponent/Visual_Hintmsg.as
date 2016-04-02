package View.ViewComponent 
{
	import flash.display.MovieClip;
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
	public class Visual_Hintmsg  extends VisualHandler
	{	
		
		public function Visual_Hintmsg() 
		{
			
		}
		
		public function init():void
		{
			var hintmsg:MultiObject = prepare(modelName.HINT_MSG, new MultiObject()  , GetSingleItem("_view").parent.parent);
			hintmsg.Create_by_list(1, [ResName.Hint], 0, 0, 1, 0, 0, "time_");
			hintmsg.container.x = 960;
			hintmsg.container.y =  530;
			hintmsg.container.visible = false;
			
			
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			Get(modelName.HINT_MSG).container.visible = true;
			GetSingleItem(modelName.HINT_MSG).gotoAndStop(1);	
			_regular.FadeIn( GetSingleItem(modelName.HINT_MSG), 2, 2, _regular.Fadeout);
			dispatcher(new StringObject("sound_start_bet","sound" ) );
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function timer_hide():void
		{
			Get(modelName.HINT_MSG).container.visible = true;
			var state:int = _model.getValue(modelName.GAMES_STATE);
			if( state == gameState.START_OPEN) GetSingleItem(modelName.HINT_MSG).gotoAndStop(5);
			if( state == gameState.NEW_ROUND) GetSingleItem(modelName.HINT_MSG).gotoAndStop(2);
			if ( state == gameState.END_BET) 
			{
				GetSingleItem(modelName.HINT_MSG).gotoAndStop(3);
				dispatcher(new StringObject("sound_stop_bet","sound" ) );
			}
			_regular.FadeIn( GetSingleItem(modelName.HINT_MSG), 2, 2, _regular.Fadeout);
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function start_bet():void
		{
			Get(modelName.HINT_MSG).container.visible = true;
			GetSingleItem(modelName.HINT_MSG).gotoAndStop(2);
			_regular.FadeIn( GetSingleItem(modelName.HINT_MSG), 2, 2, _regular.Fadeout);
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "CreditNotEnough")]
		public function no_credit():void
		{
			Get(modelName.HINT_MSG).container.visible = true;
			GetSingleItem(modelName.HINT_MSG).gotoAndStop(4);
			_regular.FadeIn( GetSingleItem(modelName.HINT_MSG), 2, 2, _regular.Fadeout);	
		}
		
	}

}