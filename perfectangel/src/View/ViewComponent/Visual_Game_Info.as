package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;

	import View.GameView.gameState;
	
	/**
	 * Visual_Game_Info present way
	 * @author Dyson0913
	 */
	public class Visual_Game_Info  extends VisualHandler
	{
		
		[Inject]
		public var _betCommand:BetCommand;	
		
		public function Visual_Game_Info() 
		{
			
		}
		
		public function init():void
		{			
			var bet:MultiObject = prepare("game_title_info", new MultiObject() , GetSingleItem("_view").parent.parent);
			bet.CustomizedFun = _text.textSetting;
			bet.CustomizedData = [{size:18}, "局號:",_model.getValue("game_round").toString()];
			bet.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			bet.Post_CustomizedData = [bet.CustomizedData.length - 1, 50, 0];
			bet.Create_by_list(bet.CustomizedData.length-1, [ResName.TextInfo], 0, 0, bet.CustomizedData.length-1, 200, 0, "info_");			
			bet.container.x = 240;
			bet.container.y = 100;			
			
			var betlimit:MultiObject = create("betlimit", [ResName.betlimit, ResName.betstaticarrow]);	
			betlimit.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 0]);
			betlimit.mousedown = local;
			betlimit.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			betlimit.Post_CustomizedData = [[0,0],[194,164]];
			betlimit.container.x = -12;
			betlimit.container.y = 120;	
			betlimit.Create_(2, "betlimit");	
			
			var realtimeinfo:MultiObject = create("realtimeinfo", [ResName.realtimeinfo, ResName.betstaticarrow_right]);	
			realtimeinfo.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 2, 0]);
			realtimeinfo.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			realtimeinfo.Post_CustomizedData = [[0, 0], [7, 164]];
			realtimeinfo.mousedown = local_reverse;
			realtimeinfo.container.x = 1719;
			realtimeinfo.container.y = 120;	
			realtimeinfo.Create_(2, "realtimeinfo");	
			
			var lightqueue:MultiObject = create("lightqueue", [ResName.lightqueue]);			
			lightqueue.container.x =  652.65;
			lightqueue.container.y = 135.9;
			lightqueue.Create_(1, "lightqueue");	
			
			var light_wintype:MultiObject = create("lightqueue_wintype",  [ResName.light_wintype]);
			light_wintype.container.x = 179.45;
			light_wintype.container.y = 453.95;
			light_wintype.Create_(1,  "lightqueue_wintype");	
			
		
			
			put_to_lsit(betlimit);
			put_to_lsit(realtimeinfo);
			//put_to_lsit(lightqueue);
			
			utilFun.SetTime(triger, 2);
		}
		
		private function triger():void
		{
			local_reverse(new MouseEvent(MouseEvent.CLICK, true, false), 0);
			local(new MouseEvent(MouseEvent.CLICK, true, false), 0);
		}
		
		public function local_reverse(e:Event, idx:int):Boolean
		{
			if( GetSingleItem("realtimeinfo",1).currentFrame == 1)
			{				
				GetSingleItem("realtimeinfo", 1).gotoAndStop(2);						
				_regular.moveTo(Get("realtimeinfo").container,1883,Get("realtimeinfo").container.y, 1, 0, shide);						
			}
			else
			{				
				GetSingleItem("realtimeinfo").visible =  true;				
				GetSingleItem("realtimeinfo", 1).gotoAndStop(1);			
				_regular.moveTo(Get("realtimeinfo").container, 1719, Get("realtimeinfo").container.y, 1, 0, null);
			}
			return false;
		}
		
		public function shide():void
		{
			GetSingleItem("realtimeinfo").visible = false;
		}
		
		public function local(e:Event, idx:int):Boolean
		{
			if( GetSingleItem("betlimit",1).currentFrame == 1)
			{				
				GetSingleItem("betlimit", 1).gotoAndStop(2);						
				_regular.moveTo(Get("betlimit").container,-195,Get("betlimit").container.y, 1, 0, hide);						
			}
			else
			{				
				GetSingleItem("betlimit").visible =  true;				
				GetSingleItem("betlimit", 1).gotoAndStop(1);			
				_regular.moveTo(Get("betlimit").container, -12, Get("betlimit").container.y, 1, 0, null);
			}
			return false;
		}
		
		public function hide():void
		{
			GetSingleItem("betlimit").visible = false;
		}
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			Get("betlimit").container.visible = true;
			Get("realtimeinfo").container.visible = true;
						
			//round code
			var round_code:int = _model.getValue("game_round");
			GetSingleItem("game_title_info", 1).getChildByName("Dy_Text").text = round_code.toString();
			
			//跑燈
			GetSingleItem("lightqueue").gotoAndStop(1);			
			GetSingleItem("lightqueue")["_light_" + _model.getValue("last_ligt_ball_idx")].gotoAndStop(1);
			
			//倍率跑馬
			Tweener.pauseTweens(GetSingleItem("lightqueue_wintype"));
			GetSingleItem("lightqueue_wintype").gotoAndStop(1);
			
		}		
		
		public function light_queue_effect(stop_point:int):void
		{			
			GetSingleItem("lightqueue_wintype").gotoAndStop(2);
			
			//normal
			Tweener.addCaller( this, { time:1 , count: 48 , transition:"easeOutQuint", onUpdateParams:[], onUpdate: this.light_effect, onComplete:this.randon_loop } );
			
			//起動 effect easeOutQuint
			//stop  effect easeInQuint
			
			
		}
		
		private function randon_loop():void
		{
			utilFun.Log("randon_loop");
			//var ra:int = 4;// utilFun.Random(4) + 1;
			Tweener.addCaller( this, { time:1 , count: 60 , transition:"linear", onUpdateParams:[], onUpdate: this.light_effect, onComplete:this.ready_reduce } );
		}
		
		private function ready_reduce():void
		{			
			
			utilFun.Log("ready_reduce");
			var target:int = _model.getValue("light_idx");
			utilFun.Log("target =" + target);
			if ( target == 13) target = 12;
			Tweener.addCaller( this, { time:5 , count: 60 + target, transition:"easeInExpo", onUpdateParams:[], onUpdate: this.light_effect, onComplete:this.ready_to_stop } );
			//best easeInQuint
		}
		
		private function ready_to_stop():void
		{
			lligth_start();
		}
		
		private function light_effect():void
		{
			var idx:int = _model.getValue("lightqueue_idx");
			idx++;			
			if ( idx == 12) idx = 0;
			//utilFun.Log("light idx ="+idx);
			_model.putValue("lightqueue_idx", idx);
			GetSingleItem("lightqueue")["_light_" + idx].gotoAndPlay(3);
			
			//sound
			dispatcher(new StringObject("sound_light_stop","sound" ) );
			
		}
		
		private function lligth_start():void
		{			
			var idx:int = _model.getValue("light_idx");
			
			if (idx < 13)
			{
				GetSingleItem("lightqueue_wintype").gotoAndStop(3);
				GetSingleItem("lightqueue_wintype")["_win_type"].gotoAndStop(idx);
				var frame:int = 0;
				if ( idx <= 7) frame = 5;
				else if ( idx == 8 || idx ==9) frame = 4;
				else if ( idx == 10 ) frame = 3;
				else if ( idx == 11 ) frame = 2;
				else if ( idx == 12 ) frame = 1;
				GetSingleItem("lightqueue_wintype")["_win_odds"].gotoAndStop(frame);
				
				utilFun.Log("libht idx = "+idx);
				//light ball up
				if ( idx == 12) idx = 0;
				_model.putValue("last_ligt_ball_idx", idx);
				GetSingleItem("lightqueue")["_light_" + idx].gotoAndStop(2);
				
				//normal frequen
				_regular.Twinkle_by_JumpFrame(GetSingleItem("lightqueue_wintype"), 30, 30, 3, 4);
				
				if (  _model.getValue("effect_sound") )
				{
					//sound
					dispatcher(new StringObject("sound_odd_show", "sound" ) );
				}
				
				//win
				//_regular.Twinkle_by_JumpFrame(GetSingleItem("lightqueue_wintype"), 20, 180, 3, 4);
			}
			else
			{
				GetSingleItem("lightqueue_wintype").gotoAndStop(5);
			}			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function opencard_parse():void
		{			
			Get("betlimit").container.visible = false;
			Get("realtimeinfo").container.visible = false;	
			
		}
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "run_light")]
		public function run():void
		{
			var check:Array =   _model.getValue(modelName.PLAYER_POKER);	
			
			if ( check.length == 0)
			{
				GetSingleItem("lightqueue").gotoAndStop(2);
				_model.putValue("effect_sound", 1);
			}
			else
			{
				GetSingleItem("lightqueue").gotoAndStop(2);			
				_model.putValue("effect_sound", 0);
				lligth_start();
				return;
			}
			//var state:int = _model.getValue(modelName.GAMES_STATE);		
			//if ( state == gameState.START_OPEN)
			//{			
				//GetSingleItem("lightqueue").gotoAndStop(2);
			//}
			//else 
			//{				
				//GetSingleItem("lightqueue").gotoAndStop(2);			
				//lligth_start();
				//return;
			//}
			
			//跑馬effect 1~13
			var rand:int = _model.getValue("light_idx");			
			light_queue_effect(rand);
			
			//TEMP idx
			_model.putValue("lightqueue_idx", 0);
		}
			
		
	}

}