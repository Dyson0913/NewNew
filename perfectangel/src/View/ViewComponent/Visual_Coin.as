package View.ViewComponent 
{
	import flash.events.Event;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import View.GameView.*;	
	import caurina.transitions.Tweener;
	
	/**
	 * coin present way
	 * @author ...
	 */
	public class Visual_Coin  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _Actionmodel:ActionQueue;		
		
		//coin seperate to N stack
		private var _stack_num:int = 1;
		
		private var _coin:MultiObject;
		
		public const Betcoin:String = "Bet_coin";
		
		public function Visual_Coin() 
		{
			
		}
		
		public function init():void
		{
			var avaliblezone:Array = _model.getValue(modelName.AVALIBLE_ZONE);
			
			_coin = create("CoinOb", [Betcoin]);
			_coin.container.x = 1080;
			_coin.container.y = 1000;
			_coin.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,2,0]);
			_coin.CustomizedFun = ocin_setup;
			_coin.CustomizedData = [0, 1, 2, 3, 4];
			_coin.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			_coin.Post_CustomizedData = [5, 85, 0];
			_coin.Create_(5);
			_coin.rollout = excusive_rollout;
			_coin.rollover = excusive_select_action;
			_coin.mousedown = betSelect;
			_coin.ItemList[0].y -= 20;
			_coin.ItemList[0].gotoAndStop(2);		
			
			state_parse([gameState.START_BET]);
		}
		
		public function ocin_setup(mc:MovieClip, idx:int, data:Array):void
		{
			mc["_coin"].gotoAndStop(idx+1);
		}
		
		override public function appear():void
		{
			_regular.FadeIn(_coin.container, 0, 1, null);	
		}
		
		override public function disappear():void
		{			
			_regular.Fadeout(_coin.container, 0, 1);
		}
		
		public function excusive_rollout(e:Event, idx:int):Boolean
		{
			var select:int = _model.getValue("coin_selectIdx");
			if ( idx == select) 
			{				
				return false;
			}
			else
			{
				_coin.ItemList[idx].gotoAndStop(1);
				_coin.ItemList[idx]["_coin"].gotoAndStop(idx+1);
				return true;
			}			
		}
		
		public function excusive_select_action(e:Event, idx:int):Boolean
		{
			var select:int = _model.getValue("coin_selectIdx");
			if ( idx == select) 
			{				
				return false;
			}
			else 
			{
				_coin.ItemList[idx].gotoAndStop(2);
				_coin.ItemList[idx]["_coin"].gotoAndStop(idx+1);
				return true;
			}
		}
		
		public function betSelect(e:Event, idx:int):Boolean
		{			
			var old_select:int = _model.getValue("coin_selectIdx");
			
			_model.putValue("coin_selectIdx", idx);			
			//position chagne 
			for (var i:int = 0; i < _coin.ItemList.length; i++)
			{
				if ( i == old_select ) 
				{				
					if ( old_select == idx) continue;
					var frame:int = _coin.ItemList[old_select]["_coin"].currentFrame;				
					_coin.ItemList[old_select].y += 20;
					_coin.ItemList[old_select].gotoAndStop(1);
					_coin.ItemList[old_select]["_coin"].gotoAndStop(frame);
				}
				if ( i == idx)
				{					
					_coin.ItemList[idx].y -= 20;						
				}
			}
			
			//frame change
			//_coin.exclusive(idx,1);			
			
			return true;
		}
		
			
	}

}