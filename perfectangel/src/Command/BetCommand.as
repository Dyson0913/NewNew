package Command 
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.events.Event;
	import Model.*;
	import Model.valueObject.StringObject;
	
	import util.*;
	import View.GameView.*;
	import Res.ResName;
	import com.laiyonghao.Uuid;
	import ConnectModule.websocket.WebSoketComponent;
	/**
	 * user bet action
	 * @author hhg4092
	 */
	public class BetCommand 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _Actionmodel:ActionQueue;
		
		[Inject]
		public var _opration:DataOperation;
		
		[Inject]
		public var _model:Model;
		
		public var _Bet_info:DI = new DI();
		
		[Inject]
		public var _socket:WebSoketComponent;
		
		public function BetCommand() 
		{
			
		}
		
		public function bet_init():void
		{
			_model.putValue("coin_selectIdx", 2);
			_model.putValue("coin_list", 				[5, 10, 50, 100, 500, 1000, 5000, 10000]);
			_model.putValue("coin_limit_1000", [true, true, true, true, true, false, false, false]);
			_model.putValue("coin_limit_5000", [true, false, true, true, true, true, false, false]);
			_model.putValue("coin_limit_10000", [true, false, false, true, true, true, true, false]);
			_model.putValue("coin_limit_50000", [true, false, false, false, true, true, true, true]);
			//_model.putValue("after_bet_credit", 0);
			
			//顥示與注區mapping
			var _idx_to_result_idx:DI = new DI();			
			_idx_to_result_idx.putValue("0", 1);
			_idx_to_result_idx.putValue("1", 0);
			_idx_to_result_idx.putValue("2", 3);
			_idx_to_result_idx.putValue("3", 2);
			_idx_to_result_idx.putValue("4", 5);
			_idx_to_result_idx.putValue("5", 4);
			_idx_to_result_idx.putValue("6", 6);
			_idx_to_result_idx.putValue("7", 7);
			_model.putValue("idx_to_result_idx", _idx_to_result_idx);
			
			var betzone:Array = [0, 1, 2, 3, 4, 5 , 6 , 7];
			var betzone_name:Array = ["BetPAEvil", "BetPAAngel", "BetPABigEvil", "BetPABigAngel", "BetPAUnbeatenEvil", "BetPAPerfectAngel","BetPATiePoint","BetPABothNone"];
			
		    var bet_name_to_idx:DI = new DI();
			var bet_idx_to_name:DI = new DI();
			for ( var i:int = 0; i < betzone.length ; i++)
			{
				bet_name_to_idx.putValue(betzone_name[i], i);
				bet_idx_to_name.putValue(i, betzone_name[i]);
			}
			
			_model.putValue("Bet_name_to_idx", bet_name_to_idx);		
			_model.putValue("Bet_idx_to_name", bet_idx_to_name);			
			
			
			var allzone:Array =  [ResName.evilZone, ResName.angelZone, ResName.evil_big, ResName.angel_big, ResName.evil_per, ResName.angel_per,ResName.samepoint,ResName.bothNone];			
			var avaliblezone:Array = [];
			var avaliblezone_s:Array = [];
			for each (var k:int in betzone)
			{
				avaliblezone.push ( allzone[k]);
				avaliblezone_s.push( allzone[k]+"_sence");
				
			}
			_model.putValue(modelName.AVALIBLE_ZONE, avaliblezone);
			_model.putValue(modelName.AVALIBLE_ZONE_SENCE, avaliblezone_s);
			_model.putValue(modelName.AVALIBLE_ZONE_IDX, betzone);
			
			_model.putValue(modelName.COIN_SELECT_XY, [ [0, 0], [85, 0], [170, 0], [255, 0], [340, 0] ]);
			
			var betzone_po:Array = [ [0, 0], [-623, 0],  [318, 10], [-840, 14], [341, 164], [-880, 167] ,[-274,148],[-264,18]];
			_model.putValue(modelName.AVALIBLE_ZONE_XY, betzone_po);
			_model.putValue(modelName.COIN_STACK_XY,   [ [140, 210], [ -483, 210],  [408, 80], [ -760, 94], [451, 264], [ -800, 267] , [ -174, 238], [ -174, 68]]);			
			_model.putValue(modelName.COIN_CANCEL_XY,  [ [ 140, 191], [ -483, 191],  [408, 61], [ -760, 75], [451, 245], [ -800, 248] , [ -174, 220], [ -174, 49]]);			
			
			var state:DI = new DI();
			state.putValue("NewRoundState", gameState.NEW_ROUND);
			state.putValue("StartBetState", gameState.START_BET);
			state.putValue("EndBetState", gameState.END_BET);
			state.putValue("OpenState", gameState.START_OPEN);
			state.putValue("EndRoundState", gameState.END_ROUND);			
			_model.putValue("state_mapping", state);		
			
			_Bet_info.putValue("self", []);
			_model.putValue("history_bet",[]);
		}
		
		public function sendBet(betType:int):void {
			
			var bet_msg:Object = createBet(betType);
			if ( CONFIG::debug ) 
				{				
					//本機測試，不送封包
					/*var r:int = int(Math.random() * 5);
					if (r == 0 ) { 
						//測試下注失敗
						cleanBetUUID(bet_msg.id);
					}*/
					//_socket.SendMsg(bet_msg);
				}		
				else
				{				
					_socket.SendMsg(bet_msg);
				}
			
		}
		
		//新增注單
		private function createBet(betType:int):Object {
			var uuid:Uuid = new Uuid();
			var total_bet_amount:int = get_total_bet(betType);
			var bet_amount:int = 0;
			var obs:Array = _Bet_info.getValue("self");
			for each(var ob:Object in obs) {
				if (ob["betType"] == betType && ob["id"] == "") {
					bet_amount += ob["bet_amount"];
					
					//寫入uuid，代表資料將被發送
					ob["id"] = uuid.toString();
				}
			}
				
			var idx_to_name:DI = _model.getValue("Bet_idx_to_name");					
			
			//一個注區一張單
			var bet:Object = {  
			                                "timestamp":1111,
											"message_type":"MsgPlayerBet", 
			                               "game_id":_model.getValue("game_id"),
										   "game_type":_model.getValue(modelName.Game_Name),
										   "game_round":_model.getValue("game_round"),
										   
										    "bet_type": idx_to_name.getValue( betType),
										    "bet_amount":bet_amount,
											"total_bet_amount":total_bet_amount,
											"id":uuid.toString()
										   
											};
			
			return bet;
		}
		
		//清除無uuid的注單(玩家按下取消鈕)
		public function cleanBetNoUUID(betType:int):void {
			var obs:Array = _Bet_info.getValue("self");
			var obs_new:Array = [];
			for each(var obj:Object in obs) {
				if (obj["betType"] == betType && obj["id"] == "") {
					//nothing
				}else {
					obs_new.push(obj);
				}
			}
			
			_Bet_info.putValue("self", obs_new);
			
			//刷新籌碼元件
			dispatcher(new ModelEvent("refreshCoin", betType));
		}
		
		//清除有uuid的注單(投注失敗)
		public function cleanBetUUID(uuid:String):void {
			var obs:Array = _Bet_info.getValue("self");
			var obs_new:Array = [];
			var betType:int = 0;
			for each(var obj:Object in obs) {
				if (obj["id"] == uuid) {
					betType = obj["betType"];
				}else {
					obs_new.push(obj);
					
				}
			}
			
			_Bet_info.putValue("self", obs_new);
			
			//刷新籌碼元件
			dispatcher(new ModelEvent("refreshCoin", betType));
			//餘額不足訊息
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.NO_CREDIT));
		}
		
		public function betTypeMain(e:Event,idx:int):Boolean
		{
			if ( _Actionmodel.length() > 0) return false;
			
			//該區未送出金額加總
			var obs:Array = _Bet_info.getValue("self");
			var unconfim_amount:int = 0;
			for each(var ob:Object in obs) {
				if (ob["betType"] == idx && ob["id"] == "") {
					unconfim_amount += ob["bet_amount"];
				}
			}
			
			//押注金額判定(該區未送出金額不得超過餘額)
			if ( unconfim_amount + _opration.array_idx("coin_list", "coin_selectIdx") > _model.getValue(modelName.CREDIT))
			{
				utilFun.Log("unconfim_amount: " + unconfim_amount);
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.NO_CREDIT));
				return false;
			}	
			
			var bet:Object = { "betType": idx,
											"bet_idx":_model.getValue("coin_selectIdx"),
			                               "bet_amount":  _opration.array_idx("coin_list", "coin_selectIdx"),
										   "total_bet_amount": get_total_bet(idx) +_opration.array_idx("coin_list", "coin_selectIdx"),
										   "id":""
			};
			
			dispatcher( new ActionEvent(bet, "bet_action"));
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));
			dispatcher(new ModelEvent("updateCoin"));
			
			return true;
		}	
		
		public function bet_local(e:Event,idx:int):Boolean
		{			
			var bet:Object = { "betType": idx, 
											 "bet_idx":_model.getValue("coin_selectIdx"),
			                               "bet_amount":  _opration.array_idx("coin_list", "coin_selectIdx"),
										   "total_bet_amount": get_total_bet(idx) +_opration.array_idx("coin_list", "coin_selectIdx"),
										   "id":""
			};
			
			dispatcher( new ActionEvent(bet, "bet_action"));
			
			//fake bet proccess
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BETRESULT));
			dispatcher(new ModelEvent("updateCoin"));
			
			return true;
		}		
		
		public function empty_reaction(e:Event, idx:int):Boolean
		{
			return true;
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "Betresult")]
		public function accept_bet():void
		{
			var bet_ob:Object = _Actionmodel.excutionMsg();
			//bet_ob["bet_amount"] -= get_total_bet(bet_ob["betType"]);
			if ( _Bet_info.getValue("self") == null)
			{
				_Bet_info.putValue("self", [bet_ob]);
				
			}
			else
			{
				var bet_list:Array = _Bet_info.getValue("self");
				bet_list.push(bet_ob);
				_Bet_info.putValue("self", bet_list);
			}
			//self_show_credit()
			//var bet_list:Array = _Bet_info.getValue("self");
			//for (var i:int = 0; i < bet_list.length; i++)
			//{
				//var bet:Object = bet_list[i];
				//
				//utilFun.Log("bet_info  = "+bet["betType"] +" amount ="+ bet["bet_amount"]);
			//}
		}
		
		/*private function self_show_credit():void
		{
			var total:Number = get_total_bet(-1);
			
			var credit:int = _model.getValue(modelName.CREDIT);
			_model.putValue("after_bet_credit", credit - total);
		}*/
		
		public function all_betzone_totoal():Number
		{
			var betzone:Array = _model.getValue(modelName.AVALIBLE_ZONE_IDX); //_model.getValue(modelName.BET_ZONE);
			
			var total:Number = 0;
			for each (var i:int in betzone)
			{
				total +=get_total_bet(i);
			}
			return total;
		}
		
		public function get_total_bet(type:int):int
		{
			if ( _Bet_info.getValue("self") == null) return 0;
			var total:Number = 0;
			var bet_list:Array = _Bet_info.getValue("self");
			for (var i:int = 0; i < bet_list.length; i++)
			{
				var bet:Object = bet_list[i];
				if ( type == -1)
				{
					total += bet["bet_amount"];
					continue;
				}
				else if( type == bet["betType"])
				{
					total += bet["bet_amount"];
				}
			}
			
			return total;
		}		
		
		public function Bet_type_betlist(type:int):Array
		{
			var bet_list:Array = _Bet_info.getValue("self");
			var arr:Array = [];
			for (var i:int = 0; i < bet_list.length; i++)
			{
				var bet:Object = bet_list[i];
				if ( bet["betType"] == type)
				{
					arr.push( bet["bet_amount"]);
				}
			}			
			return arr;
		}
		
		public function get_my_betlist():Array
		{		
			return _Bet_info.getValue("self");		
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function Clean_bet():void
		{
			save_bet();
			_Bet_info.clean();			
			
			_Bet_info.putValue("self", [] ) ;
		}
		
		public function save_bet():void
		{
			/*var bet_list:Array = _Bet_info.getValue("self");
			utilFun.Log("save_bet bet_list  = "+bet_list.length );
			if ( bet_list.length ==0) return;
			_model.putValue("history_bet", bet_list);*/

			var bet_list:Array = _Bet_info.getValue("self");
			utilFun.Log("save_bet bet_list  = "+bet_list.length );
			if ( bet_list.length == 0) {
				clean_hisotry_bet();
				return;
			}
			_model.putValue("history_bet", bet_list);
			dispatcher(new ModelEvent("can_rebet"));
		}
		
		public function clean_hisotry_bet():void
		{
			_model.putValue("history_bet", []);
			dispatcher(new ModelEvent("can_not_rebet"));
		}
		
		public function need_rebet():Boolean
		{
			var bet_list:Array  = _model.getValue("history_bet");			
			if ( bet_list.length ==0) return false;
			
			return true;
		}
		
		public function re_bet():void
		{
			var bet_list:Array  = _model.getValue("history_bet");
			
			utilFun.Log("check bet_list  = " + bet_list );
			if ( bet_list == null) return;
			
			//續押總金額
			var total_rebet_amount:int = 0;
			for each (var re_ob:Object in bet_list) {
				total_rebet_amount += re_ob["bet_amount"];
			}
			
			if (total_rebet_amount >_model.getValue(modelName.CREDIT)) {
				//餘額不足訊息
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.NO_CREDIT));
				return;
			}
			
			//與賓果不同,同一注區會分多筆,必需要等上一筆注單確認,再能再下第二筆,不然total_bet_amount,值會錯
			utilFun.Log("bet_list  = " + bet_list.length );
			while (bet_list.length > 0) {		
				var coin_list:Array = _model.getValue("coin_list");
				var bet:Object = bet_list[0];				
				var mybet:Object = { "betType": bet["betType"],
													  "bet_idx":bet["bet_idx"],
														"bet_amount": coin_list[ bet["bet_idx"]] ,
														"total_bet_amount": ( get_total_bet( bet["betType"]) + coin_list[ bet["bet_idx"]] ),
														"id":""
				};
			
				utilFun.Log("bet_info  = " + mybet["betType"] +" amount =" + mybet["bet_amount"] + " idx = " + bet["bet_idx"] +" total_bet_amount " + (get_total_bet( bet["betType"]) +coin_list[ bet["bet_idx"]] ) );
				bet_list.shift();
				_Actionmodel.push(new ActionEvent(mybet, "bet_action"));
				accept_bet();
				_Actionmodel.dropMsg();
			}
			_model.putValue("history_bet", bet_list);
			
			var betTypes:Array = [];
			var zone:Array = _model.getValue(modelName.AVALIBLE_ZONE_IDX);
			for (var i:int = 0; i < zone.length; i++) {
				var betType:int = zone[i];
				if (get_total_bet(betType) > 0) {
					sendBet(betType);
					betTypes.push(betType);
				}
			}
			
			//刷新籌碼元件
			dispatcher(new ModelEvent("refreshMutiCoin", betTypes));
		}
		
	}

}