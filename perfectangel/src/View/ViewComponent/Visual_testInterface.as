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
		public var _path:Path_Generator;
		
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
		public var _text:Visual_Text;
		
		//[Inject]
		//public var _betinfo:Visual_Betinfo;
		
		[Inject]
		public var _debug:Visual_debugTool;
		
		[Inject]
		public var _settlePanel:Visual_SettlePanel;
		
		[Inject]
		public var _HistoryRecoder:Visual_HistoryRecoder;
		
		private var _script_item:MultiObject;
		
		public function Visual_testInterface() 
		{
			
		}
		
		public function init():void
		{			
			_debug.init();
			_betCommand.bet_init();
			_model.putValue("result_Pai_list", []);
			_model.putValue("game_round", 1);			
			
			//腳本
			var script_list:MultiObject = prepare("script_list", new MultiObject() ,GetSingleItem("_view").parent.parent );			
			script_list.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);			
			script_list.stop_Propagation = true;
			script_list.mousedown = script_list_test;
			script_list.CustomizedData = [{size:18},"下注腳本","開牌腳本","結算腳本","模擬封包"]
			script_list.CustomizedFun = _text.textSetting;			
			script_list.Create_by_list(script_list.CustomizedData.length -1, [ResName.TextInfo], 0, 0, script_list.CustomizedData.length-1, 100, 20, "Btn_");			
			
		
			_model.putValue("Script_idx", 0);
		
			
		}				
		
		public function script_list_test(e:Event, idx:int):Boolean
		{
			utilFun.Log("script_list_test=" + idx);
			_model.putValue("Script_idx", idx);
			
			dispatcher(new TestEvent(_model.getValue("Script_idx").toString()));
			
			
			return true;
		}
		
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "0")]
		public function betScript():void
		{
			changeBG(ResName.Bet_Scene);
			
			//=============================================gameinfo			
			_gameinfo.init();
			
			//=============================================btninfo
			_btn.init();
			
			//=============================================paytable
			fake_hisotry();
			_paytable.init();			
			
			_HistoryRecoder.init();
			
			//================================================betzone
			_betzone.init();			
			_coin_stack.init();
			_coin.init();
			_sencer.init();
			dispatcher(new ModelEvent("display"));
			
			//=============================================Hintmsg
			_hint.init();
			_hint.display();
			
			//================================================timer
			
			_model.putValue(modelName.REMAIN_TIME, 20);					
			_timer.init();
			_timer.display();
			_timer.debug();
			
		}	
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "1")]
		public function opencardScript():void
		{			
			_model.putValue(modelName.PLAYER_POKER, []);				
			_model.putValue(modelName.BANKER_POKER, []);					
			_model.putValue("scirpt_pai", ["kd","4c","4s","7s","3s","1s","3d","3s","6c","6h"]);		
			
			changeBG(ResName.Bet_Scene);
			
			//=============================================gameinfo			
			_gameinfo.init();
			//_gameinfo.opencard_parse();
			
			//=============================================paytable			
			_paytable.init();			
			
			//_betinfo.init();
			
			//=============================================Hintmsg
			_hint.init();
			_model.putValue(modelName.GAMES_STATE,gameState.END_BET);
			_hint.timer_hide();			
			
			//================================================poker
			_poker.init();
			dispatcher(new ModelEvent("hide"));
			_poker.debug();
			//settle_table
			
			//================================================settle info
			//_settle.init();
			
			_model.putValue(modelName.EXTRA_POKER, ["kd"]);
			dispatcher(new Intobject(modelName.EXTRA_POKER, "Extra_poker"));
			
			//================================================ simu deal
			var testpok:Array = ["Player", "Banker", "Player", "Banker", "Player" , "Banker", "Player" ];// , "Banker", "Player", "Banker"];
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
		
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "2")]
		public function settleScript():void
		{
			_model.putValue(modelName.PLAYER_POKER, ["9d","4c","5s","7s","9s"]);				
			_model.putValue(modelName.BANKER_POKER, ["1s","2d","3s","5c","6h"]);	
			changeBG(ResName.Bet_Scene);
			
			//=============================================gameinfo			
			_gameinfo.init();
			//_gameinfo.settle_parse();
			//
			
			
			
			//=============================================Hintmsg
			//_hint.init();			
			
			//=============================================paytable			
			fake_hisotry();
			_paytable.init();		
			//_paytable.update_history();
			
				//================================================poker
			_poker.init();
			dispatcher(new ModelEvent("hide"));
			dispatcher(new Intobject(modelName.PLAYER_POKER, "poker_No_mi"));
			dispatcher(new Intobject(modelName.BANKER_POKER, "poker_No_mi"));							
							
			
			//================================================settle info
			_settle.init();			
			
			//摸擬押注
			//_betzone.init();			
			//_coin_stack.init();
			//_betCommand.bet_local(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false), 0);
			//_betCommand.bet_local(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false), 1);
			//_betinfo.init();
			
			_settlePanel.init();
			_settlePanel.debug();
			utilFun.Log("ok");		
			
				
			
			//var fakePacket:Object = {"result_list": [{"bet_type": "BetPAAngel", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 100}, {"bet_type": "BetPAEvil", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 200}, {"bet_type": "BetPABigAngel", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 200}, {"bet_type": "BetPABigEvil", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0}, {"bet_type": "BetPAPerfectAngel", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 200}, {"bet_type": "BetPAUnbeatenEvil", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0}], "game_state": "EndRoundState", "game_result_id": "288778", "timestamp": 1443023641.580271, "remain_time": 9, "game_type": "PerfectAngel", "game_round": 318, "game_id": "PerfectAngel-1", "message_type": "MsgBPEndRound", "id": "4f17fb12620b11e5bcebf23c9189e2a9"}
			var fakePacket:Object = { "result_list": [ { "bet_type": "BetPAAngel", "settle_amount": 0, "odds": 2, "win_state": "WSLost", "bet_amount": 0 }, { "bet_type": "BetPAEvil", "settle_amount": 0, "odds": 0, "win_state": "WSPANormalWin", "bet_amount": 0 }, { "bet_type": "BetPABigAngel", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0 }, { "bet_type": "BetPABigEvil", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0 }, { "bet_type": "BetPAPerfectAngel", "settle_amount": 0, "odds": 11, "win_state": "WSWin", "bet_amount": 0 }, { "bet_type": "BetPAUnbeatenEvil", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0 } ], "game_state": "EndRoundState", "game_result_id": "289273", "timestamp": 1443063940.564476, "remain_time": 9, "game_type": "PerfectAngel", "game_round": 785, "game_id": "PerfectAngel-1", "message_type": "MsgBPEndRound", "id": "2328f8ae626911e5bcebf23c9189e2a9" }									
			_MsgModel.push(fakePacket);			
			
		}
		
		public function fake_hisotry():void
		{
			var arr:Array = _model.getValue("history_win_list");			
			for ( var i:int = 0; i < 10; i++)
			{
				var ran:int = utilFun.Random(4) +1;
				var point:int = utilFun.Random(9);			
				arr.push([ran, point]);				
			}
			_model.putValue("history_win_list", arr);
		}
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "3")]
		public function sim_package():void
		{
			//fake hisoty			
			var evel_winstate:int = utilFun.Random(2);
			var angel_winstate:int = utilFun.Random(2);			
			var eviPoint:int = utilFun.Random(9);			
			var angPoint:int = utilFun.Random(9);				
			dispatcher(new ArrayObject([evel_winstate, angel_winstate,eviPoint,angPoint],"add_history" ) );	
			
			_HistoryRecoder.update_history();
		}
	
	}

}