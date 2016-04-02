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
		public var _debug:Visual_debugTool;
		
		[Inject]
		public var _settlePanel:Visual_SettlePanel;
		
		[Inject]
		public var _HistoryRecoder:Visual_HistoryRecoder;
		
		[Inject]
		public var _visual_stream:Visual_stream;
		
		[Inject]
		public var _fileStream:fileStream;
		
		[Inject]
		public var _betTimer:Visual_betTimer;
		
		private var _script_item:MultiObject;
		
		[Inject]
		public var _bg:Visual_bg;
		
		[Inject]
		public var _pokerhandler:Visual_poker;
		
		[Inject]
		public var _time:Visual_timer;
		
		public function Visual_testInterface() 
		{
			
		}
		
		public var script_list:MultiObject;
		
		public function init():void
		{			
			_debug.init();
			_betCommand.bet_init();
			_model.putValue("test_init", false);
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
			script_list = create("script_list", [ResName.TextInfo]);			
			script_list.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);			
			script_list.stop_Propagation = true;
			script_list.mousedown = script_list_test;
			script_list.CustomizedData = [{size:18},"新局","開始下注", "停止下注","開牌", "結算","封包","單一功能測試"]
			script_list.CustomizedFun = _text.textSetting;
			script_list.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			script_list.Post_CustomizedData = [6, 100, 50];	
			script_list.Create_(script_list.CustomizedData.length -1,"test_btn");	
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
			
			_betTimer.init();
			
		
			
			_model.putValue("test_init", true);
		
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
			
			
			
			dispatcher(new TestEvent(idx.toString()));
			return true;
		}	
		
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "0")]
		public function betScript():void
		{
			dispatcher(new ModelEvent("hide"));
			
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
		public function start_bet():void
		{		
			dispatcher(new ModelEvent("start_bet"));
			dispatcher(new ModelEvent("display"));
			dispatcher(new ModelEvent("clearn"));
			//fake_hisotry();
			changeBG(ResName.Bet_Scene);
			
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
																					{"stream_name":"live1", "strem_url":"52.69.102.66/live", "channel_ID":" /BG", "size": { "itemwidth":800, "itemheight":600 }},
																					{"stream_name":"live2", "strem_url":"52.69.102.66/live", "channel_ID":" /lw2", "size": { "itemwidth":800, "itemheight":600 }}
															                         ]
															
															   }
												}
			dispatcher(new ArrayObject([1, jsonob], "urlLoader_complete"));
			dispatcher(new StringObject("live1","stream_connect"));
			
			_model.putValue(modelName.REMAIN_TIME, 20);
			_model.putValue(modelName.GAMES_STATE,gameState.START_BET);			
			dispatcher(new ModelEvent("update_state"));	
		}	
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "4")]
		public function settleScript():void
		{
			dispatcher(new ModelEvent("hide"));
			
			changeBG(ResName.Bet_Scene);
			
			_settlePanel.init();
			
			//結算
			var fakePacket:Object = {"timestamp":1454401685.258399,"result_list":[{"bet_amount":0,"bet_attr":"BetAttrMain","odds":2,"real_win_amount":0,"bet_type":"BetBWPlayer","settle_amount":0,"win_state":"WSBWStraight"},{"bet_amount":0,"bet_attr":"BetAttrMain","odds":2,"real_win_amount":0,"bet_type":"BetBWBanker","settle_amount":0,"win_state":"WSBWStraight"},{"bet_amount":0,"bet_attr":"BetAttrSide","odds":9,"real_win_amount":0,"bet_type":"BetBWTiePoint","settle_amount":0,"win_state":"WSWin"},{"bet_amount":0,"bet_attr":"BetAttrSide","odds":5,"real_win_amount":0,"bet_type":"BetBWSpecial","settle_amount":0,"win_state":"WSBWStraight"},{"bet_amount":0,"bet_attr":"BetAttrSide","odds":0,"real_win_amount":0,"bet_type":"BetBWPlayerPair","settle_amount":0,"win_state":"WSLost"},{"bet_amount":0,"bet_attr":"BetAttrSide","odds":0,"real_win_amount":0,"bet_type":"BetBWBankerPair","settle_amount":0,"win_state":"WSLost"},{"bet_amount":0,"bet_attr":"BetAttrBonus","odds":0,"real_win_amount":0,"bet_type":"BetBWBonusTripple","settle_amount":0,"win_state":"WSLost"},{"bet_amount":0,"bet_attr":"BetAttrBonus","odds":0,"real_win_amount":0,"bet_type":"BetBWBonusTwoPair","settle_amount":0,"win_state":"WSLost"}],"game_state":"EndRoundState","id":"e19c438ec98611e58f9ef23c9189e2a9","remain_time":9,"game_result_id":"485880","message_type":"MsgBPEndRound","game_round":2224,"game_type":"BigWin","game_id":"BigWin-1"}
			
			_MsgModel.push(fakePacket);	
			//
			
			_model.putValue(modelName.GAMES_STATE,gameState.END_ROUND);			
			dispatcher(new ModelEvent("update_state"));
			
		}
		/*[MessageHandler(type = "View.Viewutil.TestEvent", selector = "1")]
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
		}*/
		
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
		public function stopScript():void
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
			//fake_hisotry();
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
			//var fakePacket:Object = { "result_list": [ { "bet_type": "BetPAAngel", "settle_amount": 0, "odds": 2, "win_state": "WSLost", "bet_amount": 0 }, { "bet_type": "BetPAEvil", "settle_amount": 0, "odds": 0, "win_state": "WSPANormalWin", "bet_amount": 0 }, { "bet_type": "BetPABigAngel", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0 }, { "bet_type": "BetPABigEvil", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0 }, { "bet_type": "BetPAPerfectAngel", "settle_amount": 0, "odds": 11, "win_state": "WSWin", "bet_amount": 0 }, { "bet_type": "BetPAUnbeatenEvil", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0 } ], "game_state": "EndRoundState", "game_result_id": "289273", "timestamp": 1443063940.564476, "remain_time": 9, "game_type": "PerfectAngel", "game_round": 785, "game_id": "PerfectAngel-1", "message_type": "MsgBPEndRound", "id": "2328f8ae626911e5bcebf23c9189e2a9" }									
			
			//var fakePacket:Object = { "result_list": [ { "bet_attr": "BetAttrMain", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetPAAngel", "settle_amount": 0 }, { "bet_attr": "BetAttrMain", "bet_amount": 0, "odds": 2, "win_state": "WSPANormalWin", "real_win_amount": 0, "bet_type": "BetPAEvil", "settle_amount": 0 }, { "bet_attr": "BetAttrSide", "bet_amount": 0, "odds": 6, "win_state": "WSWin", "real_win_amount": 0, "bet_type": "BetPABigAngel", "settle_amount": 0 }, { "bet_attr": "BetAttrSide", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetPABigEvil", "settle_amount": 0 }, { "bet_attr": "BetAttrSide", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetPAPerfectAngel", "settle_amount": 0 }, { "bet_attr": "BetAttrSide", "bet_amount": 0, "odds": 11, "win_state": "WSWin", "real_win_amount": 0, "bet_type": "BetPAUnbeatenEvil", "settle_amount": 0 }, { "bet_attr": "BetAttrSide", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetPATiePoint", "settle_amount": 0 }, { "bet_attr": "BetAttrSide", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetPABothNone", "settle_amount": 0 } ], "game_state": "EndRoundState", "game_result_id": "442902", "timestamp": 1451900036.931441, "remain_time": 9, "game_type": "PerfectAngel", "game_round": 9740, "game_id": "PerfectAngel-1", "message_type": "MsgBPEndRound", "id": "4702f600b2c611e5b0ccf23c9189e2a9" }
			var fakePacket:Object =  {"result_list": [{"bet_attr": "BetAttrMain", "bet_amount": 0, "odds": 2, "win_state": "WSPANormalWin", "real_win_amount": 0, "bet_type": "BetPAAngel", "settle_amount": 0}, {"bet_attr": "BetAttrMain", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetPAEvil", "settle_amount": 0}, {"bet_attr": "BetAttrSide", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetPABigAngel", "settle_amount": 0}, {"bet_attr": "BetAttrSide", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetPABigEvil", "settle_amount": 0}, {"bet_attr": "BetAttrSide", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetPAPerfectAngel", "settle_amount": 0}, {"bet_attr": "BetAttrSide", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetPAUnbeatenEvil", "settle_amount": 0}, {"bet_attr": "BetAttrSide", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetPATiePoint", "settle_amount": 0}, {"bet_attr": "BetAttrSide", "bet_amount": 0, "odds": 0, "win_state": "WSLost", "real_win_amount": 0, "bet_type": "BetPABothNone", "settle_amount": 0}], "game_state": "EndRoundState", "game_result_id": "444435", "timestamp": 1451961674.931792, "remain_time": 9, "game_type": "PerfectAngel", "game_round": 10368, "game_id": "PerfectAngel-1", "message_type": "MsgBPEndRound", "id": "ca1f6d18b35511e5b0ccf23c9189e2a9"}
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
			_gameinfo.init();
			dispatcher(new ModelEvent("display"));
			_model.putValue(modelName.PLAYER_POKER, ["c3"]);	
			dispatcher(new ModelEvent("run_light"));
			
			//_visual_stream.hide();
			//fake hisoty			
			//var evel_winstate:int = utilFun.Random(2);
			//var angel_winstate:int = utilFun.Random(2);			
			//var eviPoint:int = utilFun.Random(9);			
			//var angPoint:int = utilFun.Random(9);				
			//dispatcher(new ArrayObject([evel_winstate, angel_winstate,eviPoint,angPoint],"add_history" ) );	
			//
			//_HistoryRecoder.update_history();
		}
	
	}

}