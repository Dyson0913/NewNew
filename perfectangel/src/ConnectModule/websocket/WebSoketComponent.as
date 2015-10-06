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
	import Model.valueObject.ArrayObject;
	import Model.valueObject.Intobject;
	import util.DI;
	
	import Command.*;
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
		public var _opration:DataOperation;
		
		[Inject]
		public var _model:Model;		
		
		private var websocket:WebSocket;
		
		public function WebSoketComponent() 
		{
			
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="connect")]
		public function Connect():void
		{			
			var uuid:String = _model.getValue(modelName.UUID);						
			websocket = new WebSocket("ws://" + _model.getValue(modelName.Domain_Name) +":8101/gamesocket/token/" + uuid, "");			
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
			   
			   	if ( result.game_type != _model.getValue(modelName.Game_Name) ) return;
				switch(result.message_type)
				{				
					case Message.MSG_TYPE_INTO_GAME:
					{						
						if( _model.getValue(modelName.HandShake_chanel) == null )  dispatcher(new ValueObject( result.inside_game_info.player_info.credit, modelName.CREDIT) );					
						
						
						dispatcher(new ValueObject(  result.remain_time,modelName.REMAIN_TIME) );						
						dispatcher(new ValueObject(  _opration.getMappingValue("state_mapping", result.game_state) , modelName.GAMES_STATE) );
						
						dispatcher(new ValueObject(  result.game_round, "game_round") );
						dispatcher(new ValueObject(  result.game_id, "game_id") );
						
						//dispatcher( new ValueObject(result.cards_info["player_card_list"], modelName.PLAYER_POKER) );
						//dispatcher( new ValueObject(result.cards_info["banker_card_list"], modelName.BANKER_POKER) );                        
						_model.putValue(modelName.PLAYER_POKER, result.cards_info["player_card_list"]);
						_model.putValue(modelName.BANKER_POKER, result.cards_info["banker_card_list"]);
						
						dispatcher(new Intobject(modelName.Bet, ViewCommand.SWITCH) );							
						
						dispatcher(new ModelEvent("update_state"));
						dispatcher(new Intobject(modelName.PLAYER_POKER, "poker_No_mi"));
						dispatcher(new Intobject(modelName.BANKER_POKER, "poker_No_mi"));						
					}
					break;		
					
					case Message.MSG_TYPE_GAME_OPEN_INFO:
					{
						
						dispatcher(new ValueObject(  _opration.getMappingValue("state_mapping", result.game_state) , modelName.GAMES_STATE) );
						
						dispatcher(new ValueObject(  result.game_round, "game_round") );
						dispatcher(new ValueObject(  result.game_id, "game_id") );
						
						var card:Array = result.card_list;
						var card_type:String = result.card_type
						var mypoker:Array;
						if ( card_type == "Player")
						{										
							mypoker = _model.getValue(modelName.PLAYER_POKER);										
							mypoker.push(card[0]);
							_model.putValue(modelName.PLAYER_POKER, mypoker);										
							dispatcher(new Intobject(modelName.PLAYER_POKER, "poker_mi"));									
						}
						else if ( card_type == "Banker")
						{							
							mypoker = _model.getValue(modelName.BANKER_POKER);										
							mypoker.push( card[0]);
							
							_model.putValue(modelName.BANKER_POKER, mypoker);
							//dispatcher( new ValueObject(card, modelName.BANKER_POKER) );
							dispatcher(new Intobject(modelName.BANKER_POKER, "poker_mi"));
							
						}
					}
					break;
						
					case Message.MSG_TYPE_BET_INFO:
					{
						if (result.result == 0)
						{
							dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));							
							dispatcher(new ModelEvent("updateCoin"));
						}
						else
						{
							_actionqueue.dropMsg();
							//error handle
						}
					}
					break;
						
					case Message.MSG_TYPE_STATE_INFO:
					{
						
						dispatcher(new ValueObject(  result.remain_time, modelName.REMAIN_TIME) );						
						dispatcher(new ValueObject(  _opration.getMappingValue("state_mapping", result.game_state) , modelName.GAMES_STATE) );								
							
						dispatcher(new ModelEvent("update_state"));					
					}
					break;
					
					case Message.MSG_TYPE_ROUND_INFO:
					{							
						dispatcher(new ValueObject(  _opration.getMappingValue("state_mapping", result.game_state) , modelName.GAMES_STATE) );
						
						//dispatcher(new ModelEvent("update_state"));
						
						//dispatcher( new ValueObject(result.bet_amount,modelName.BET_AMOUNT));
						//dispatcher( new ValueObject(result.settle_amount, modelName.SETTLE_AMOUNT));
						
						dispatcher( new ValueObject(result.result_list, modelName.ROUND_RESULT));
						dispatcher(new ModelEvent("round_result"));						
					}
					break;					
				}
				
				dispatcher(new ArrayObject([result], "pack_recoder"));
		}
		
		[MessageHandler(type="ConnectModule.websocket.WebSoketInternalMsg",selector="Bet")]
		public function SendBet():void
		{			
			var ob:Object = _actionqueue.getMsg();
			var idx_to_name:DI = _model.getValue("Bet_idx_to_name");
			
			var bet:Object = {  "id": String(_model.getValue(modelName.UUID)),
			                                "timestamp":1111,
											"message_type":Message.MSG_TYPE_BET, 
			                               "game_id":_model.getValue("game_id"),
										   "game_type":_model.getValue(modelName.Game_Name),
										   "game_round":_model.getValue("game_round"),
										   "bet_type":  idx_to_name.getValue( ob["betType"]),
										    "bet_amount":ob["bet_amount"],
											"total_bet_amount":ob["total_bet_amount"]
											};
										   
			SendMsg(bet);
		}
		
		public function SendMsg(msg:Object):void 
		{
			dispatcher(new ArrayObject([msg], "pack_recoder"));
			var jsonString:String = JSON.encode(msg);			
			websocket.sendUTF(jsonString);
		}
		
	}
}