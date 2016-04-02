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
	import View.ViewBase.Visual_Version;
	
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
		
		[Inject]
		public var _visual_stream:Visual_stream;
		
		[Inject]
		public var _bg:Visual_bg;
		
		[Inject]
		public var _betTimer:Visual_betTimer;
		
		[Inject]
		public var _Version:Visual_Version;
		
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
			
			_bg.init();
			_HistoryRecoder.init();
			_gameinfo.init();
			_settlePanel.init();
			_paytable.init();
			
			_time.init();			
		   _hint.init();
			
		  
		   _pokerhandler.init();
			_betzone.init();
			_coin_stack.init();
			
			
			_settle.init();
			_sencer.init();	
			_coin.init();
			_btn.init();			
			
			_betTimer.init();
			
			_Version.init();
			
			_visual_stream.init();
			
				var jsonob:Object = {
												  "online":{
															 "stream_link":[{"stream_name":"pa_stream","strem_url":"192.168.1.136/live/","channel_ID":"livestream","size":{"itemwidth":320,"itemheight":240}}]
														   },
												 "development":{
															 "stream_link":[ 
															                         { "stream_name":"pa_stream", "strem_url":"52.69.102.66/live/", "channel_ID":"livestream", "size": { "itemwidth":1920, "itemheight":1080 }},
																					 {"stream_name":"test2", "strem_url":"cp67126.edgefcs.net/ondemand/", "channel_ID":"mp4:mediapm/ovp/content/test/video/spacealonehd_sounas_640_300.mp4", "size": { "itemwidth":320, "itemheight":240 }},
																					{"stream_name":"test", "strem_url":"184.72.239.149/vod", "channel_ID":"BigBuckBunny_115k.mov", "size": { "itemwidth":800, "itemheight":600 }},
																					{"stream_name":"live1", "strem_url":"52.69.102.66/live", "channel_ID":" /livestream", "size": { "itemwidth":800, "itemheight":600 }},
																					{"stream_name":"live2", "strem_url":"52.69.102.66/live", "channel_ID":" /lw2", "size": { "itemwidth":800, "itemheight":600 }}
															                         ]
															
															   }
												}
			dispatcher(new ArrayObject([1, jsonob], "urlLoader_complete"));
			dispatcher(new StringObject("live1","stream_connect"));
			
			
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