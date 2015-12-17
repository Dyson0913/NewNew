package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
	 * @author Dyson0913
	 */
	public class Visual_betZone_Sence  extends VisualHandler
	{		
		
		[Inject]
		public var _betCommand:BetCommand;	
		
		public function Visual_betZone_Sence() 
		{
			
		}
		
		public function init():void
		{			
			var zone_xy:Array = _model.getValue(modelName.AVALIBLE_ZONE_XY);
			var avaliblezone_s:Array = _model.getValue(modelName.AVALIBLE_ZONE_SENCE);			
			
			var playerzone_s:MultiObject = create("betzone_s", avaliblezone_s);
			playerzone_s.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,1,2,1]);
			playerzone_s.container.x = 1081;
			playerzone_s.container.y = 657;
			playerzone_s.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			playerzone_s.Post_CustomizedData = zone_xy;			
			playerzone_s.Create_(avaliblezone_s.length, "betzone_s");
			
			state_parse([gameState.START_BET]);
		}		
		
		override public function appear():void
		{
			var betzone:MultiObject = Get("betzone_s");			
			betzone.mousedown = bet_sencer;
			betzone.mouseup = bet_sencer;
			betzone.rollout = bet_sencer;
			betzone.rollover = bet_sencer;	
		}
		
		override public function disappear():void
		{			
			var betzone:MultiObject = Get("betzone_s");
			betzone.mousedown = null;
			betzone.mouseup = null;
			betzone.rollout = null;
			betzone.rollover = null;
		}
		
		public function bet_sencer(e:Event,idx:int):Boolean
		{			
			//玩家手動第一次下注,取消上一局的betinfo			
			if ( e.type == MouseEvent.MOUSE_DOWN)
			{
				//玩家手動第一次下注,取消上一局的betinfo
				utilFun.Log("bet_sencer = "+_betCommand.need_rebet());
				if ( _betCommand.need_rebet() )
				{
					_betCommand.clean_hisotry_bet();
				}
				
				if ( CONFIG::debug ) 
				{				
					_betCommand.bet_local(e, idx);
				}		
				else
				{				
					_betCommand.betTypeMain(e, idx);
				}
			}
			
			var betzone:MultiObject = Get("betzone");
			var mc:MovieClip = betzone.ItemList[idx];
			mc.dispatchEvent(new MouseEvent(e.type, true, false));			
			
			return true;			
		}
		
	}

}