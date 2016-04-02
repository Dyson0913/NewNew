package View.ViewComponent 
{	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import View.ViewBase.VisualHandler;		
	import util.*;
	
	import View.Viewutil.*;
	import Res.ResName;	
	import View.GameView.gameState;
	import Model.modelName;
	
	import Command.*;
	
	import caurina.transitions.Tweener;
	
	/**
	 * Visual_betTimer
	 * @author David
	 */
	public class Visual_betTimer  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;	
		
		public const NEW_SECOND:int = 3;
		private var sec_array:Array = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];
		
		public var current_idx:int = -1;		
		
		public function Visual_betTimer() 
		{
			
		}
		
		public function init():void
		{			
			var cancel_xy:Array = _model.getValue(modelName.COIN_CANCEL_XY);			
			
			//取消+倒數秒數
			var coin_cancel:MultiObject = create("coin_cancel" , ["bet_cancel"]);
			coin_cancel.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [2, 3, 2, 2]);
			coin_cancel.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			coin_cancel.Post_CustomizedData = cancel_xy;
			coin_cancel.Create_(cancel_xy.length,"coin_cancel");
			coin_cancel.container.x = 1151;
			coin_cancel.container.y = 683;			
			coin_cancel.rollover = empty_reaction;
			coin_cancel.rollout = empty_reaction;			
			
			//取消感應
			var coincancel_trans:MultiObject = create("coin_cancel_trans" , ["bet_trans"]);
			coincancel_trans.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [2, 2, 2, 0]);
			coincancel_trans.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			coincancel_trans.Post_CustomizedData = cancel_xy;
			coincancel_trans.Create_(cancel_xy.length,"coin_cancel_trans");
			coincancel_trans.container.x = coin_cancel.container.x;
			coincancel_trans.container.y = coin_cancel.container.y;
			coincancel_trans.mousedown = cancel_sencer_;
			coin_cancel.rollover = bet_sencer;
			coin_cancel.rollout = bet_sencer;			
			
			//state_parse([gameState.START_BET]);
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function appear():void
		{			
			setFrame("coin_cancel", 1);
			setFrame("coin_cancel_trans", 2);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]			
		public function opencard_parse():void
		{
			disappear();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function hide():void
		{
			disappear();
		}
		
		public function disappear():void
		{			
			//停止所有Timer
			for each(var timer_mc:* in Get("coin_cancel").ItemList) {
				Tweener.removeTweens(timer_mc);
			}
			//初始秒數資料
			 sec_array = [ -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];			 
		
			setFrame("coin_cancel", 1);			
			setFrame("coin_cancel_trans", 1);
		}
		
		public function bet_sencer(e:Event, idx:int):Boolean
		{			
			var betzone:MultiObject = Get("coin_cancel");
			var mc:MovieClip = betzone.ItemList[idx];
			mc.dispatchEvent(new MouseEvent(e.type, true, false));		
			return false;
		}
		
		public function cancel_sencer_(e:Event, idx:int):Boolean
		{			
			//停止計時器
			StopCurrentTimer_tick();			
			
			//取消注單
			_betCommand.cleanBetNoUUID(idx);
			return false;
		}
		
		public function TimerStart(idx:int):void 
		{
			setFrame("coin_cancel", 1);
			
			//顯示取消
			GetSingleItem("coin_cancel", idx).gotoAndStop(2);
			
			//(點別的注區) 送出前一次押注的注單
			if ( current_idx !=-1 && current_idx != idx)
			{
				//current_idx 為上一次點擊idx				
				Tweener.removeTweens(GetSingleItem("coin_cancel", current_idx));
				_betCommand.sendBet(current_idx);
			}
			else if ( current_idx == idx)
			{				
				Tweener.removeTweens(GetSingleItem("coin_cancel", idx));
			}
			
			sec_array[idx] = NEW_SECOND;
			var time:int = sec_array[idx];
			frame_setting_way(idx, time);
			
			//return;
			//讓秒數計到-1
			var update_count:int = time + 1;
			Tweener.addCaller(GetSingleItem("coin_cancel", idx), {  time:update_count , count: update_count, onUpdate:TimeCount , onUpdateParams:[idx],  transition:"linear" } );
				
			current_idx = idx;
		}
		
		private function TimeCount(idx:int):void
		{
			var time:int  = sec_array[idx] - 1;
			if ( time < 0) 
			{
				send_bet(idx);
				return;
			}
			
			frame_setting_way(idx, time);			
			sec_array[idx] = time;
		}
		
		public function send_bet(idx:int ):void 
		{
			if ( idx == -1) return;
			
			//倒數結束送單
			StopCurrentTimer_tick();
			_betCommand.sendBet(idx);
			current_idx = -1;
		}
		
		public function StopCurrentTimer_tick():void 
		{
			utilFun.Log("StopCurrentTimer_tick  = " + current_idx );
			Tweener.removeTweens(GetSingleItem("coin_cancel", current_idx));
			GetSingleItem("coin_cancel", current_idx).gotoAndStop(1);
		}
		
		
		
		public function frame_setting_way(idx:int, time:int):void
		{
			var arr:Array = [time];
			if ( arr[0] == 0 ) arr[0] = 10;			
			GetSingleItem("coin_cancel", idx)["_num_0"].gotoAndStop(arr[0]);
			
		}		
		
	}

}