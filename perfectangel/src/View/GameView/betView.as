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
		public var _pokerhandler:Visual_poker;
		
		[Inject]
		public var _time:Visual_timer;
		
		[Inject]
		public var _hint:Visual_Hintmsg;
		
		[Inject]
		public var _settle:Visual_Settle;
		
		[Inject]
		public var _betzone:Visual_betZone;
		
		[Inject]
		public var _sencer:Visual_betZone_Sence;
		
		//[Inject]
		//public var _playinfo:Visual_PlayerInfo;
		[Inject]
		public var _mask:Visual_Mask;
		
		[Inject]
		public var _sence:Visual_betZone_Sence;
		
		[Inject]
		public var _paytable:Visual_Paytable;
		
		
		
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
			
			_mask.init();
			
			_paytable.init();
			_settle.init();
			
			
		
			//_playinfo.init();
			_time.init();			
		   _hint.init();
			
			_betzone.init();
			_coin.init();
			_sencer.init();
			
			//paytable
			//var paytable:MultiObject = prepare("paytable", new MultiObject() , this);
			//paytable.CustomizedData = [[-240,0],[240,0]]		 
			//paytable.container.y = 110;		
			//paytable.Create_by_list(2, [ResName.main_paytable,ResName.side_paytable], 0, 0, 2, 1670, 0, "time_");
			//paytable.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 1, 0]);
			//paytable.mousedown = sliding;
			
			//var name:MultiObject = prepare("name", new MultiObject() , this);
			//name.CustomizedFun = _regular.ascii_idx_setting;			
			//name.CustomizedData = _model.getValue(modelName.NICKNAME).split("");
			//name.container.x = 235 + (name.CustomizedData.length -1) * 37 *-0.5;
			//name.container.y = 1020;
			//name.Create_by_bitmap(name.CustomizedData.length, utilFun.Getbitmap("LableAtlas"), 0, 0, name.CustomizedData.length, 37, 51, "o_");			
			
			
			_pokerhandler.init();
			
			//var paytable:MultiObject =  prepare("paytable_btn", new MultiObject(), this);
			//paytable.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);				
			//paytable.mousedown = _btn.cycle_reaction;
			//paytable.Create_by_list(1, [ResName.b_paytable], 0 , 0, 1, 0, 0, "Bet_");			
			//paytable.container.x = 868;
			//paytable.container.y = 978;
			//
			//var mypoker:Array = _model.getValue(modelName.PLAYER_POKER);
			//if ( mypoker.length == 0) paytable.ItemList[0].gotoAndStop(2);
			
			//_tool.SetControlMc(paytable.ItemList[1]);
			//_tool.SetControlMc(paytable.container);
			//addChild(_tool);			
			
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