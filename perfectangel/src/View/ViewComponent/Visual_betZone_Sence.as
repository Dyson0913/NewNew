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
	
	/**
	 * betzone present way
	 * @author ...
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
			//感應區
			var avaliblezone_s:Array = _model.getValue(modelName.AVALIBLE_ZONE_SENCE);
			var playerzone_s:MultiObject = prepare("betzone_s", new MultiObject() , GetSingleItem("_view").parent.parent);
			playerzone_s.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,1,2,1]);
			playerzone_s.container.x = 1081;
			playerzone_s.container.y = 657;
			playerzone_s.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			playerzone_s.Post_CustomizedData = zone_xy;
		
			playerzone_s.Create_by_list(avaliblezone_s.length, avaliblezone_s, 0, 0, avaliblezone_s.length, 0, 0, "bet_sence");			
			
			//_tool.SetControlMc(coinob.ItemList[0]);
			//_tool.SetControlMc(coinob.container);
			//add(_tool);
			utilFun.Log("betzone snece ok");
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			var betzone:MultiObject = Get("betzone_s");
			betzone.mousedown = bet_sencer;
			betzone.mouseup = bet_sencer_up;	
			betzone.rollout = bet_sencer_rollout;	
			betzone.rollover = bet_sencer_rollover;	
		}
		
		public function bet_sencer_rollout(e:Event,idx:int):Boolean
		{				
			var betzone:MultiObject = Get("betzone");			
			var mc:MovieClip = betzone.ItemList[idx];
			mc.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT, true, false));			
			
			return true;
		}
		
		public function bet_sencer_rollover(e:Event,idx:int):Boolean
		{			
			var betzone:MultiObject = Get("betzone");			
			var mc:MovieClip = betzone.ItemList[idx];
			mc.dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER, true, false));			
			
			return true;
		}
		
		public function bet_sencer(e:Event,idx:int):Boolean
		{			
			//玩家手動第一次下注,取消上一局的betinfo
			utilFun.Log("bet_sencer = "+_betCommand.need_rebet());
			if ( _betCommand.need_rebet() )
			{
				_betCommand.clean_hisotry_bet();
			}
			
			if ( CONFIG::debug ) 
			{
				_betCommand.betTypeMain(e, idx);
			}		
			else
			{
				dispatcher(new StringObject("sound_coin","sound" ) );
				_betCommand.betTypeMain(e, idx);
			}
			
			var betzone:MultiObject = Get("betzone");			
			var mc:MovieClip = betzone.ItemList[idx];
			mc.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false));			
			
			return true;
		}
		
		public function bet_sencer_up(e:Event, idx:int):Boolean
		{			
			var betzone:MultiObject = Get("betzone");			
			var mc:MovieClip = betzone.ItemList[idx];
			mc.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, true, false));			
			
			return true;
		}	
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function timer_hide():void
		{
			var betzone:MultiObject = Get("betzone_s");
			betzone.mousedown = null;
			betzone.mouseup = null;
			betzone.rollout = null;
			betzone.rollover = null;
		}
		
		
	}

}