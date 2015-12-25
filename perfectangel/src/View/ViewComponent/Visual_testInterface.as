package View.ViewComponent 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Transform;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import util.math.Path_Generator;
	import View.ViewBase.Visual_Text;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	import View.Viewutil.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import View.GameView.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import com.adobe.serialization.json.JSON;
	/**
	 * testinterface to fun quick test
	 * @author ...
	 */
	public class Visual_testInterface  extends VisualHandler
	{		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _MsgModel:MsgQueue;		
		
		[Inject]
		public var _paytable:Visual_Paytable;
		
		[Inject]
		public var _gameinfo:Visual_Game_Info;
		
		[Inject]
		public var _hint:Visual_Hintmsg;
		
		[Inject]
		public var _timer:Visual_timer;
		
		[Inject]
		public var _poker:Visual_poker;
		
		[Inject]
		public var _betzone:Visual_betZone;	
		
		[Inject]
		public var _coin:Visual_Coin;
		
		[Inject]
		public var _sencer:Visual_betZone_Sence;
		
		[Inject]
		public var _coin_stack:Visual_Coin_stack;
		
		[Inject]
		public var _settle:Visual_Settle;	
		
		[Inject]
		public var _btn:Visual_BtnHandle;
		
		[Inject]
		public var _debug:Visual_debugTool;
		
		[Inject]
		public var _settlePanel:Visual_SettlePanel;
		
		[Inject]
		public var _fileStream:fileStream;
		
		[Inject]
		public var _HistoryRecoder:Visual_HistoryRecoder;
		
		private var _script_item:MultiObject;
		
		public function Visual_testInterface() 
		{
			
		}
		
		public function init():void
		{			
			_model.putValue("test_init", false);
			
			_debug.init();
			_betCommand.bet_init();
			_model.putValue("result_Pai_list", []);
			_model.putValue("game_round", 1);			
			
			var script:DI = new DI();
			script.putValue("新局",0);
			script.putValue("開始下注",1);
			script.putValue("停止下注",2);
			script.putValue("開牌",3);
			script.putValue("結算",4);
			script.putValue("封包",5);
			script.putValue("單一功能測試",6);
			
			_model.putValue("name_map", script);
			
			//腳本
			var script_list:MultiObject = create("script_list", [ResName.TextInfo]);			
			script_list.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);			
			script_list.stop_Propagation = true;
			script_list.mousedown = script_list_test;
			script_list.CustomizedData = [{size:18},"新局","開始下注", "停止下注","開牌", "結算","封包","單一功能測試"]
			script_list.CustomizedFun = _text.textSetting;
			script_list.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			script_list.Post_CustomizedData = [6, 100, 50];	
			script_list.Create_(script_list.CustomizedData.length -1);			
			
		
			_model.putValue("Script_idx", 0);
		
			
		}				
		
		public function view_init():void		
		{
			if ( _model.getValue("test_init")) return;
			changeBG(ResName.Bet_Scene);
			
			_btn.init();			
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
			
			
			_model.putValue("test_init",true);
		}
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "0")]
		public function newround():void
		{
			fake_hisotry();			
			_model.putValue(modelName.PLAYER_POKER, []);
			
			_model.putValue(modelName.GAMES_STATE,gameState.NEW_ROUND);			
			dispatcher(new ModelEvent("update_state"));			
		}
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "1")]
		public function start_bet():void
		{		
			fake_hisotry();
			_model.putValue(modelName.REMAIN_TIME, 20);
			
			_model.putValue(modelName.GAMES_STATE,gameState.START_BET);			
			dispatcher(new ModelEvent("update_state"));
		}	
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "2")]
		public function stop_bet():void
		{
			fake_hisotry();
			_model.putValue(modelName.GAMES_STATE,gameState.END_BET);			
			dispatcher(new ModelEvent("update_state"));
		}
		
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "3")]
		public function opencardScript():void
		{			
			_model.putValue(modelName.PLAYER_POKER, []);				
			_model.putValue(modelName.BANKER_POKER, []);					
			_model.putValue("scirpt_pai", ["kd","4c","4s","7s","3s","1s","3d","3s","6c","6h"]);		
			
			_model.putValue(modelName.GAMES_STATE,gameState.START_OPEN);			
			dispatcher(new ModelEvent("update_state"));
			
			_model.putValue(modelName.EXTRA_POKER, ["3d"]);
			dispatcher(new Intobject(modelName.EXTRA_POKER, "Extra_poker"));
			
			//================================================ simu deal
			var testpok:Array = ["Player", "Banker", "Player", "Banker", "Player" , "Banker", "Player" , "Banker", "Player", "Banker"];
			_regular.Call(this, { onUpdate:this.fackeDeal, onUpdateParams:[testpok] }, 30, 0, 10, "linear");						
		}
		
		public function fackeDeal(type:Array):void
		{			
			var cardlist:Array = _model.getValue("scirpt_pai");
			
			var card_type:String = type[0];
			var card:String = cardlist[0];
			type.shift();
			cardlist.shift();
			utilFun.Log("card = " + card);
			var mypoker:Array;
			if ( card_type == "Player")
			{										
				mypoker= _model.getValue(modelName.PLAYER_POKER);										
				mypoker.push(card);
				_model.putValue(modelName.PLAYER_POKER, mypoker);										
				dispatcher(new Intobject(modelName.PLAYER_POKER, "poker_mi"));				
			}
			else if ( card_type == "Banker")
			{							
				mypoker = _model.getValue(modelName.BANKER_POKER);										
				mypoker.push( card);										
				_model.putValue(modelName.BANKER_POKER, mypoker);									
				dispatcher(new Intobject(modelName.BANKER_POKER, "poker_mi"));
			}					
			
		}
		
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "4")]
		public function settleScript():void
		{
			_model.putValue(modelName.PLAYER_POKER, ["9d","4c","5s","7s","9s"]);				
			_model.putValue(modelName.BANKER_POKER, ["1s","2d","3s","5c","6h"]);	
			
			var fakePacket:Object = { "result_list": [ { "bet_type": "BetPAAngel", "settle_amount": 0, "odds": 2, "win_state": "WSLost", "bet_amount": 0 }, { "bet_type": "BetPAEvil", "settle_amount": 0, "odds": 0, "win_state": "WSPANormalWin", "bet_amount": 0 }, { "bet_type": "BetPABigAngel", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0 }, { "bet_type": "BetPABigEvil", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0 }, { "bet_type": "BetPAPerfectAngel", "settle_amount": 0, "odds": 11, "win_state": "WSWin", "bet_amount": 0 }, { "bet_type": "BetPAUnbeatenEvil", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0 } ], "game_state": "EndRoundState", "game_result_id": "289273", "timestamp": 1443063940.564476, "remain_time": 9, "game_type": "PerfectAngel", "game_round": 785, "game_id": "PerfectAngel-1", "message_type": "MsgBPEndRound", "id": "2328f8ae626911e5bcebf23c9189e2a9" }									
			_MsgModel.push(fakePacket);
		}
		
		//{"winner": "BetPAAngel", "point": 1}
		public function fake_hisotry():void
		{
			var arr:Array = [];		
			for ( var i:int = 0; i < 60; i++)
			{
			var p:int = utilFun.Random(3);
				var str:String = "";
				if ( p == 0)  str = "BetPAAngel";
				if ( p == 1)  str = "BetPAEvil";
				if ( p == 2)  str = "None";
				var ob:Object = { "winner":str, "point": utilFun.Random(10) };
				arr.push(ob);				
			}
			_model.putValue("history_list", arr);
		}
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "5")]
		public function pack_sim():void
		{
			_fileStream.load();
		}
		
		public function script_list_test(e:Event, idx:int):Boolean
		{
			var clickname:String = GetSingleItem("script_list", idx).getChildByName("Dy_Text").text;
			var idx:int = _opration.getMappingValue("name_map",clickname);
			if (clickname == "封包") 
			{
				view_init();
				_model.putValue(modelName.GAMES_STATE,gameState.NEW_ROUND);			
				dispatcher(new ModelEvent("update_state"));
				
				dispatcher(new TestEvent(idx.toString()));
				return true;
			}
			
			
			view_init();
			dispatcher(new TestEvent(idx.toString()));
			return true;
		}
		
		
	}

}