package View.ViewComponent 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Transform;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;	
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
		public var _MsgModel:MsgQueue;		
		
		[Inject]
		public var _regular:RegularSetting;
		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _visual_coin:Visual_Coin;
		
		[Inject]
		public var _opration:DataOperation;
		
		[Inject]
		public var _visual_stream:Visual_stream;
		
		[Inject]
		public var _btn:Visual_BtnHandle;
		
		[Inject]
		public var _loader:Visual_Loder;
		
		[Inject]
		public var _pokerhandler:Visual_poker;
		
		[Inject]
		public var _settle:Visual_Settle;
		
		[Inject]
		public var _betzone:Visual_betZone;
		
		[Inject]
		public var _coin:Visual_Coin;
		
		[Inject]
		public var _hint:Visual_Hintmsg;
		
		[Inject]
		public var _time:Visual_timer;
		
		[Inject]
		public var _sence:Visual_betZone_Sence;
		
		[Inject]
		public var _paytable:Visual_Paytable;
		
		public function Visual_testInterface() 
		{
			
		}
		
		public function init():void
		{
			
			var btn:MultiObject = prepare("aa", new MultiObject() ,GetSingleItem("_view").parent.parent );			
			btn.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);			
			btn.stop_Propagation = true;
			btn.mousedown = test;			
			btn.mouseup = up;			
			btn.container.x = 100;
			btn.Create_by_list(4, ["coin_1"], 0, 0, 4, 110, 0, "Btn_");
			
			//single item
			_hint.init();		
			_paytable.init();
			_time.init();
			
			//multi item
			
			//view item
			
		}		
		
	
		
		public function test(e:Event, idx:int):Boolean
		{
			utilFun.Log("test=" + idx);	
			
			dispatcher(new Intobject(idx, "Test_command"));
			
			if ( idx == 0) 
			{				
				
				//Tweener.addTween(GetSingleItem("paytable_baridx"), { y:47,time:0.5, transition:"easeOutCubic"} );
				//Tweener.addTween(GetSingleItem("paytable_baridx"), { y:94,time:0.5, transition:"easeOutCubic"} );
				
					//var mc:MovieClip = GetSingleItem("timellight");
				//mc.rotation = angel;
				//	Tweener.addCaller(mc, { time:1 , count: 36, onUpdate:TimeLight , onUpdateParams:[mc, 10 ], transition:"linear" } );
				//_model.putValue(modelName.PLAYER_POKER, ["qd"]);				
				//dispatcher(new Intobject(modelName.PLAYER_POKER, "poker_No_mi"));
				//dispatcher(new Intobject(modelName.PLAYER_POKER, "poker_mi"));
				//dispatcher(new Intobject(modelName.PLAYER_POKER, "poker_mi"));
				//dispatcher(new Intobject(modelName.PLAYER_POKER, "pokerupdate"));
				//dispatcher(new Intobject(modelName.BANKER_POKER, "pokerupdate"));
				//var mypoker:MovieClip = GetSingleItem("anitets");
				//mypoker.gotoAndStop(1);				
				//mypoker["_poker"].gotoAndStop(2);	
				//mypoker["_poker_a"].gotoAndStop(2);	
				//mypoker.gotoAndPlay(2);			
				//Tweener.addTween(mypoker["_poker"], { rotationZ:24.5, time:0.3,onCompleteParams:[mypoker["_poker"],0],onComplete:this.pullback} );
				
				//var mymatrix:Matrix = new Matrix(1, 1, 0, 1, 0, 0);
				//var myTransfrom:Transform = new Transform(mypoker);
				//myTransfrom.matrix = mymatrix;				
				
				//_tool.SetControlMc(coinob.ItemList[0]);
				//_tool.SetControlMc(mypoker);
				//add(_tool);
            }
			  else if (idx == 1)
			  {
				    _model.putValue(modelName.PLAYER_POKER, ["1d","2d"]);				
				dispatcher(new Intobject(modelName.PLAYER_POKER, "poker_No_mi"));
				  //_model.putValue(modelName.PLAYER_POKER, ["1d","2d","5d","3d"]);				
				//dispatcher(new Intobject(modelName.PLAYER_POKER, "poker_No_mi"));
				
				//var mypoker:MovieClip = GetSingleItem("anitets");
				//mypoker.gotoAndStop(1);				
				//mypoker["_poker"].gotoAndStop(32);
				//mypoker["_poker_a"].gotoAndStop(32);	
				//mypoker.gotoAndPlay(2);			
				//Tweener.addTween(mypoker["_poker"], { rotationZ:24.5, time:0.3,onCompleteParams:[mypoker["_poker"],0],onComplete:this.pullback} );
			  }
			   else if (idx == 2)
			  {
				  	_model.putValue(modelName.PLAYER_POKER, ["1d", "2d", "6d","1s"]);									
				dispatcher(new Intobject(modelName.PLAYER_POKER, "poker_mi"));
				//var mypoker:MovieClip = GetSingleItem("anitets");
				//mypoker.gotoAndStop(1);				
				//mypoker["_poker"].gotoAndStop(47);	
				//mypoker["_poker_a"].gotoAndStop(47);	
				//mypoker.gotoAndPlay(2);			
				//Tweener.addTween(mypoker["_poker"], { rotationZ:24.5, time:0.3, onCompleteParams:[mypoker["_poker"], 0], onComplete:this.pullback } );
				
				 //_model.putValue(modelName.PLAYER_POKER, ["1d", "2d"]);
				//_model.putValue(modelName.BANKER_POKER, ["1s","2s"]);
				//_model.putValue(modelName.BANKER_POKER, ["3d","7d"]);
				//dispatcher(new Intobject(modelName.PLAYER_POKER, "pokerupdate"));
				//dispatcher(new Intobject(modelName.BANKER_POKER, "pokerupdate"));
			  }
            else if (idx == 3)
			{				
				_model.putValue(modelName.PLAYER_POKER, ["1d", "2d", "6d", "2d", "3h"]);				
				_model.putValue(modelName.BANKER_POKER, ["1s", "2s", "7s", "7d", "5h"]);				
				
				//var fakePacket:Object =  { "result_list": [ { "bet_type": "BetPAAngel", "settle_amount": 0, "odds": 41, "win_state": "WSPAFiveWawaWin", "bet_amount": 0 }, 
																					//{"bet_type": "BetPAEvil", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0 }, 
																					//{"bet_type": "BetPABigAngel", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0 }, 
																					//{"bet_type": "BetPABigEvil", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0 }, 
																					//{"bet_type": "BetPAPerfectAngel", "settle_amount": 0, "odds": 11, "win_state": "WSWin", "bet_amount": 0 }, 
																					//{"bet_type": "BetPAUnbeatenEvil", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0 } ],
																				//"game_state": "EndRoundState", 
																				//"game_result_id": "243790",
																				//"timestamp": 1440567502.901299,
																				//"remain_time": 4, 
																				//"game_type": "PerfectAngel",
																				//"game_round": 113, 
																				//"game_id": "PerfectAngel-1",
																				//"message_type": "MsgBPEndRound",
																				//"id": "aa5bdf564bb411e59e2af23c9189e2a9"}
			
																				var fakePacket:Object =  {"result_list": [{"bet_type": "BetPAAngel", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0}, {"bet_type": "BetPAEvil", "settle_amount": 0, "odds": 3, "win_state": "WSPATwoPointWin", "bet_amount": 0}, {"bet_type": "BetPABigAngel", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0}, {"bet_type": "BetPABigEvil", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0}, {"bet_type": "BetPAPerfectAngel", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0}, {"bet_type": "BetPAUnbeatenEvil", "settle_amount": 0, "odds": 0, "win_state": "WSLost", "bet_amount": 0}], "game_state": "EndRoundState", "game_result_id": "243888", "timestamp": 1440570427.902713, "remain_time": 4, "game_type": "PerfectAngel", "game_round": 155, "game_id": "PerfectAngel-1", "message_type": "MsgBPEndRound", "id": "79cbab3a4bbb11e59e2af23c9189e2a9"}
																				
			_MsgModel.push(fakePacket);
			}
				
			
			
			
			return true;
		}			
		
		
		public function pullback(mc:MovieClip,angel:int):void
		{
			
				var mypoker:MovieClip = GetSingleItem("anitets");
				mypoker.gotoAndPlay(7);
				
				//_tool.SetControlMc(mc);
				//add(_tool);
				Tweener.addTween(mc, { rotationZ:angel, time:1, delay:1 } );			
		}
		
		public function up(e:Event, idx:int):Boolean
		{			
			return true;
		}	
		
	}

}