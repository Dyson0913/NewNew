package ConnectModule.websocket 
{	
	import com.worlize.websocket.WebSocket
	import com.worlize.websocket.WebSocketEvent
	import com.worlize.websocket.WebSocketMessage
	import com.worlize.websocket.WebSocketErrorEvent
	import com.adobe.serialization.json.JSON	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.system.Security;	
	import Model.*;
	import Model.valueObject.Intobject;
	import util.DI;
	
	import Command.ViewCommand;
	import View.GameView.CardType;
	
	import util.utilFun;
	import ConnectModule.websocket.Message
	import View.GameView.gameState

	
	/**
	 * socket 連線元件
	 * @author hhg4092
	 */
	public class WebSoketComponent 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _msgModel:MsgQueue;
		
		[Inject]
		public var _actionqueue:ActionQueue;
		
		[Inject]
		public var _model:Model;		
		
		private var websocket:WebSocket;
		
		public function WebSoketComponent() 
		{
			
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="connect")]
		public function Connect():void
		{
			//var object:Object = _model.getValue(modelName.LOGIN_INFO);			
			var uuid:String = _model.getValue(modelName.UUID);			
			websocket = new WebSocket("ws://106.186.116.216:8101/gamesocket/token/" + uuid, "");
			//websocket = new WebSocket("ws://106.186.116.216:9003/gamesocket/token/" + object.accessToken, "");
			//websocket = new WebSocket("ws://106.186.116.216:9003/gamesocket/token/123", "");
			websocket.addEventListener(WebSocketEvent.OPEN, handleWebSocket);
			websocket.addEventListener(WebSocketEvent.CLOSED, handleWebSocket);
			websocket.addEventListener(WebSocketErrorEvent.CONNECTION_FAIL, handleConnectionFail);
			websocket.addEventListener(WebSocketEvent.MESSAGE, handleWebSocketMessage);
			websocket.connect();
		}
		
		private function handleWebSocket(event:WebSocketEvent):void 
		{			
			if ( event.type == WebSocketEvent.OPEN)
			{
				utilFun.Log("Connected open="+ event.type );
			}
			else if ( event.type == WebSocketEvent.CLOSED)
			{
				utilFun.Log("Connected close pa="+ event.type );
			}
		}
		
		private function handleConnectionFail(event:WebSocketErrorEvent):void 
		{
			utilFun.Log("Connected= fale"+ event.type);
		}
		
		
		private function handleWebSocketMessage(event:WebSocketEvent):void 
		{
			var result:Object ;
			if (event.message.type === WebSocketMessage.TYPE_UTF8) 
			{
				utilFun.Log("pa before"+event.message.utf8Data)
				result = JSON.decode(event.message.utf8Data);			
			}
			
			_msgModel.push(result);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "popmsg")]
		public function msghandler():void
		{			
			   var result:Object  = _msgModel.getMsg();			   
				switch(result.message_type)
				{				
					case "MsgBPInitialInfo":
						{
							if ( result.game_type == "PerfectAngel")
							{
								
									//dispatcher(new ValueObject( result.inside_game_info.player_info.nickname, modelName.NICKNAME) );
									//dispatcher(new ValueObject( result.inside_game_info.player_info.userid, modelName.UUID) );
						
									//from lobby or single server
									if( _model.getValue(modelName.HandShake_chanel) == null )  dispatcher(new ValueObject( result.inside_game_info.player_info.credit, modelName.CREDIT) );					
									
									var state:int = 0;
									if (  result.game_state == "NewRoundState") state = gameState.NEW_ROUND;
									if (  result.game_state == "EndBetState") state = gameState.END_BET;
									if (  result.game_state == "OpenState") state = gameState.START_OPEN;
									if (  result.game_state == "EndRoundState") state = gameState.END_ROUND;									
									
									dispatcher(new ValueObject(  result.remain_time,modelName.REMAIN_TIME) );						
									dispatcher(new ValueObject(  state, modelName.GAMES_STATE) );						
									//dispatcher(new ValueObject(  result.inside_game_info.split_symbol, modelName.SPLIT_SYMBOL) );
									//dispatcher(new ValueObject(  result.inside_game_info.bet_zone, modelName.BET_ZONE) );
									
									dispatcher(new ValueObject(  result.game_round, "game_round") );
									dispatcher(new ValueObject(  result.game_id, "game_id") );
									
									//dispatcher( new ValueObject(result.cards_info["player_card_list"], modelName.PLAYER_POKER) );
									//dispatcher( new ValueObject(result.cards_info["banker_card_list"], modelName.BANKER_POKER) );                        
									_model.putValue(modelName.PLAYER_POKER, result.cards_info["player_card_list"]);
									_model.putValue(modelName.BANKER_POKER, result.cards_info["banker_card_list"]);
									
									dispatcher(new Intobject(modelName.Bet, ViewCommand.SWITCH) );
									//dispatcher(new Intobject(modelName.Hud, ViewCommand.ADD)) ;
									
									dispatcher(new ModelEvent("update_state"));
									dispatcher(new Intobject(modelName.PLAYER_POKER, "poker_No_mi"));
									dispatcher(new Intobject(modelName.BANKER_POKER, "poker_No_mi"));
									dispatcher(new ModelEvent("update_result_Credit"));
							}
						
						
						}
						break;
					case "MsgBPOpenCard":
						{
							if ( result.game_type == "PerfectAngel")
							{
									var state:int = 0;
									if (  result.game_state == "OpenState") state = gameState.START_OPEN;
									if (  result.game_state == "EndBetState") state = gameState.END_BET;		
									dispatcher(new ValueObject(  state, modelName.GAMES_STATE) );			
									
									dispatcher(new ValueObject(  result.game_round, "game_round") );
									dispatcher(new ValueObject(  result.game_id, "game_id") );
									
									var card:Array = result.card_list;
									var card_type:String = result.card_type
									
									if ( card_type == "Player")
									{
										//dispatcher( new ValueObject( card, modelName.PLAYER_POKER) );
										var mypoker:Array = _model.getValue(modelName.PLAYER_POKER);										
										mypoker.push(card[0]);
										_model.putValue(modelName.PLAYER_POKER, mypoker);
										
										dispatcher(new Intobject(modelName.PLAYER_POKER, "poker_mi"));
										//dispatcher(new Intobject(modelName.PLAYER_POKER, "pokerupdate"));
									}
									else if ( card_type == "Banker")
									{							
										var mypoker:Array = _model.getValue(modelName.BANKER_POKER);										
										mypoker.push( card[0]);
										//utilFun.Log("mypoker banker" + mypoker);
											_model.putValue(modelName.BANKER_POKER, mypoker);
										//dispatcher( new ValueObject(card, modelName.BANKER_POKER) );
										dispatcher(new Intobject(modelName.BANKER_POKER, "poker_mi"));
										//dispatcher(new Intobject(modelName.BANKER_POKER, "pokerupdate"));
									}					
						
							}
						}
						break;
						
					case "MsgPlayerBet":
					{
						if ( result.game_type == "PerfectAngel")
						{				
							if (result.result == 0)
							{
								dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));
								dispatcher(new ModelEvent("updateCredit"));
								dispatcher(new ModelEvent("updateCoin"));
							}
							else
							{
								_actionqueue.dropMsg();
								//error handle
							}
							break;						
						}
					}
					break;
						
					case "MsgBPState":
					{
						if ( result.game_type == "PerfectAngel")
						{							
							var state:int = 0;
							dispatcher(new ValueObject(  result.remain_time, modelName.REMAIN_TIME) );						
							if (  result.game_state == "NewRoundState") state = gameState.NEW_ROUND;
							if (  result.game_state == "EndBetState") state = gameState.END_BET;
							if (  result.game_state == "OpenState") state = gameState.START_OPEN;
							if (  result.game_state == "EndRoundState") state = gameState.END_ROUND;							
							dispatcher(new ValueObject(  state, modelName.GAMES_STATE) );			
								
							  dispatcher(new ModelEvent("update_state"));
						}
					}
					break;
					
					case "MsgBPEndRound":
					{						
						if ( result.game_type == "PerfectAngel")
						{
							utilFun.Log("MsgBPEndRound ");
								var state:int = 0;
									if (  result.game_state == "NewRoundState") state = gameState.NEW_ROUND;
									if (  result.game_state == "EndBetState") state = gameState.END_BET;
									if (  result.game_state == "OpenState") state = gameState.START_OPEN;
									if (  result.game_state == "EndRoundState") state = gameState.END_ROUND;
									dispatcher(new ValueObject(  state, modelName.GAMES_STATE) );			
									
									//dispatcher(new ModelEvent("update_state"));
									
									//dispatcher( new ValueObject(result.bet_amount,modelName.BET_AMOUNT));
									//dispatcher( new ValueObject(result.settle_amount, modelName.SETTLE_AMOUNT));
							//
									dispatcher( new ValueObject(result.result_list, modelName.ROUND_RESULT));
									dispatcher(new ModelEvent("round_result"));
									dispatcher(new ModelEvent("update_result_Credit"));
							}
					}
					break;
						
						
					case Message.MSG_TYPE_LOBBY:
					{
						
						//接收大廳資料
						
						//dispatcher(new ViewState(ViewState.Lobb,ViewState.ENTER) );
						//dispatcher(new ViewState(ViewState.Loading,ViewState.LEAVE) );
						
						//模擬點擊某遊戲ICON (單一遊戲都1
						var lobby:Object = {"message_type":Message.MSG_TYPE_SELECT_GAME, "game_type":1};
						SendMsg(lobby);
						break;
					}
					case Message.MSG_TYPE_GAME_LOBBY:
					{						
						//接收特定遊戲大廳資料
						//dispatcher(new ViewState(ViewState.Lobb,ViewState.ENTER) );
						//dispatcher(new ViewState(ViewState.Loading,ViewState.LEAVE) );
						
						//模擬點擊進入遊戲
						var gamelobby:Object = {"message_type":Message.MSG_TYPE_INTO_GAME, "game_room":3};
						SendMsg(gamelobby);
						break;
					}
					
					case Message.MSG_TYPE_INTO_GAME:
					{						
						//進入 遊戲,得到第一個畫面(不論半途或一開始						
						
						
						//dispatcher(new ValueObject( result.inside_game_info.player_info.nickname,modelName.NICKNAME) );
						
						//dispatcher(new ValueObject( result.inside_game_info.player_info.userid, modelName.UUID) );
						
						//from lobby or single server
						if( _model.getValue(modelName.HandShake_chanel) == null )  dispatcher(new ValueObject( result.inside_game_info.player_info.credit, modelName.CREDIT) );					
						
						dispatcher(new ValueObject(  result.inside_game_info.remain_time,modelName.REMAIN_TIME) );						
						dispatcher(new ValueObject(  result.inside_game_info.games_state, modelName.GAMES_STATE) );						
						//dispatcher(new ValueObject(  result.inside_game_info.split_symbol, modelName.SPLIT_SYMBOL) );
						//ispatcher(new ValueObject(  result.inside_game_info.bet_zone, modelName.BET_ZONE) );
						
						dispatcher( new ValueObject(result.inside_game_info.game_info["player_card_list"], modelName.PLAYER_POKER) );
                        dispatcher( new ValueObject(result.inside_game_info.game_info["banker_card_list"], modelName.BANKER_POKER) );                        
						
						dispatcher(new Intobject(modelName.Bet, ViewCommand.SWITCH) );
						//dispatcher(new Intobject(modelName.Hud, ViewCommand.ADD)) ;
						
						dispatcher(new ModelEvent("update_state"));					
						//dispatcher(new Intobject(modelName.PLAYER_POKER, "pokerupdate"));
						//dispatcher(new Intobject(modelName.BANKER_POKER, "pokerupdate"));
						dispatcher(new ModelEvent("update_result_Credit"));
						
						break;
					}
					
					case Message.MSG_TYPE_STATE_INFO:
					{					  
					  
					  dispatcher(new ValueObject(  result.games_state, modelName.GAMES_STATE) );
					  dispatcher(new ValueObject(  result.remain_time,modelName.REMAIN_TIME) );					  
					  //dispatcher(new ModelEvent("update_remain_time"));
					   dispatcher(new ModelEvent("update_state"));
					   break;
					}
					
					case Message.MSG_TYPE_GAME_OPEN_INFO:
					{
						dispatcher(new ValueObject(  result.games_state, modelName.GAMES_STATE) );
                        var card:Array = result.card_info["card_list"];
                        //var card_type:int = result.card_type["card_type"];
						
						//if ( card_type == CardType.PLAYER)
						//{
							//dispatcher( new ValueObject( card, modelName.PLAYER_POKER) );
							//dispatcher(new ModelEvent("playerpokerAni"));
							//dispatcher(new Intobject(modelName.PLAYER_POKER, "pokerupdate"));
						//}
						//else if ( card_type == CardType.BANKER)
						//{							
						    //dispatcher( new ValueObject(card, modelName.BANKER_POKER) );
							//dispatcher(new ModelEvent("playerpokerAni2"));
							//dispatcher(new Intobject(modelName.BANKER_POKER, "pokerupdate"));
						//}					
						
						break;
					}					
					case Message.MSG_TYPE_BET_INFO:
					{
						if (result.result)
						{
							dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));
							dispatcher(new ModelEvent("updateCredit"));
							dispatcher(new ModelEvent("updateCoin"));
						}
						else
						{
							_actionqueue.dropMsg();
							//error handle
						}
						break;
					}
					case Message.MSG_TYPE_ROUND_INFO:
					{						
						dispatcher( new ValueObject(result.bet_amount,modelName.BET_AMOUNT));
						dispatcher( new ValueObject(result.settle_amount,modelName.SETTLE_AMOUNT));
						dispatcher(new ValueObject( result.player_info.credit,modelName.CREDIT) );						
						
						dispatcher( new ValueObject(result.result_list, modelName.ROUND_RESULT));
						dispatcher(new ModelEvent("round_result"));
						dispatcher(new ModelEvent("update_result_Credit"));
						
						break;
					}
				}
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="Bet")]
		public function SendBet():void
		{			
			var ob:Object = _actionqueue.getMsg();
			var idx_to_name:DI = _model.getValue("Bet_idx_to_name");
			
			var bet:Object = {  "id": String(_model.getValue(modelName.UUID)),
			                                "timestamp":1111,
											"message_type":"MsgPlayerBet", 
			                               "game_id":_model.getValue("game_id"),
										   "game_type":"PerfectAngel",
										   "game_round":_model.getValue("game_round"),
										   "bet_type":  idx_to_name.getValue( ob["betType"]),
										    "bet_amount":ob["bet_amount"],
											"total_bet_amount":ob["total_bet_amount"]
											};
										   
			SendMsg(bet);
		}
		
		public function SendMsg(msg:Object):void 
		{
			var jsonString:String = JSON.encode(msg);			
			websocket.sendUTF(jsonString);
		}
		
	}
}