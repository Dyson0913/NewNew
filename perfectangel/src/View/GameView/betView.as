package View.GameView
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import Model.valueObject.*;
	import Model.*;
	import Res.ResName;
	import util.DI;	
	import View.ViewComponent.*;
	import View.Viewutil.*;
	import View.ViewBase.ViewBase;

	import util.*;
	import Command.*;
	import caurina.transitions.Tweener;
	
	/**
	 * ...
	 * @author hhg
	 */
	public class betView extends ViewBase
	{	
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _regular:RegularSetting;		
		
		[Inject]
		public var _coin:Visual_Coin;
		
		[Inject]
		public var _btn:Visual_BtnHandle;
		
		[Inject]
		public var _poker:Visual_poker;
		
		[Inject]
		public var _timer:Visual_timer;
		
		[Inject]
		public var _hint:Visual_Hintmsg;
		
		[Inject]
		public var _settle:Visual_Settle;
		
		[Inject]
		public var _betzone:Visual_betZone;
		
		[Inject]
		public var _sencer:Visual_betZone_Sence;
		
		[Inject]
		public var _sence:Visual_betZone_Sence;
		
		[Inject]
		public var _paytable:Visual_Paytable;
		
		[Inject]
		public var _coin_stack:Visual_Coin_stack;
		
		[Inject]
		public var _gameinfo:Visual_Game_Info;	
		
		[Inject]
		public var _HistoryRecoder:Visual_HistoryRecoder;
		
		[Inject]
		public var _settlePanel:Visual_SettlePanel;
		
		public function betView()  
		{
			utilFun.Log("betView");
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.Bet) return;
			super.EnterView(View);
			//清除前一畫面
			utilFun.Log("in to EnterBetview=");
			
			_tool = new AdjustTool();			
			
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.Bet_Scene], 0, 0, 1, 0, 0, "a_");
			
			_HistoryRecoder.init();
			_gameinfo.init();
			_settlePanel.init();
			_paytable.init();
			
			_timer.init();			
		   _hint.init();
			
		  
		   _poker.init();
			_betzone.init();
			_coin_stack.init();
			
			
			_settle.init();
			_sencer.init();	
			_coin.init();
			_btn.init();			
			
			
			//dispatcher(new StringObject("Soun_Bet_BGM","Music" ) );
		}
		
		public function sliding(e:Event, idx:int):Boolean
		{
			var paytable:MultiObject = Get("paytable");
			//paytable.ItemList[idx]
			var data:Array = paytable.CustomizedData[idx];
			_regular.sliding(paytable.ItemList[idx],1, data[0]);
			return true;
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Bet) return;
			super.ExitView(View);
		}
		
		
	}

}