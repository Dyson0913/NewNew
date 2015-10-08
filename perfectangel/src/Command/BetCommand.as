package Command 
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.events.Event;
	import Model.*;
	import Model.valueObject.StringObject;
	
	import util.*;
	import View.GameView.*;
	import Res.ResName;
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
		
		public function BetCommand() 
		{
			
		}
		
		public function bet_init():void
		{
			_model.putValue("coin_selectIdx", 0);
			_model.putValue("coin_list", [100, 500, 1000, 5000, 10000]);
			_model.putValue("after_bet_credit", 0);
			
			var betzone:Array = [0, 1, 2, 3, 4, 5];
			var betzone_name:Array = ["BetPAEvil", "BetPAAngel", "BetPABigEvil", "BetPABigAngel", "BetPAUnbeatenEvil", "BetPAPerfectAngel"];// , 6, 7, 8];
			
		    var bet_name_to_idx:DI = new DI();
			var bet_idx_to_name:DI = new DI();
			for ( var i:int = 0; i < betzone.length ; i++)
			{
				bet_name_to_idx.putValue(betzone_name[i], i);
				bet_idx_to_name.putValue(i, betzone_name[i]);
			}
		    //bet_name_to_idx.putValue("BetPAEvil", 0);
		    //bet_name_to_idx.putValue("BetPAAngel", 1);			
		    //bet_name_to_idx.putValue("BetPABigEvil", 2);
			//bet_name_to_idx.putValue("BetPABigAngel", 3);
			//bet_name_to_idx.putValue("BetPAUnbeatenEvil", 4);
			//bet_name_to_idx.putValue("BetPAPerfectAngel", 5);		
			
			_model.putValue("Bet_name_to_idx", bet_name_to_idx);		
			_model.putValue("Bet_idx_to_name", bet_idx_to_name);
			//
			//bet_idx_to_name.putValue(0, "BetPAEvil");
			//bet_idx_to_name.putValue(1, "BetPAAngel");
			//bet_idx_to_name.putValue(2, "BetPABigEvil");
			//bet_idx_to_name.putValue(3, "BetPABigAngel");
			//bet_idx_to_name.putValue(4, "BetPAUnbeatenEvil");			
			//bet_idx_to_name.putValue(5, "BetPAPerfectAngel");			
			
			
			var allzone:Array =  [ResName.evilZone, ResName.angelZone, ResName.evil_big, ResName.angel_big, ResName.evil_per, ResName.angel_per,ResName.samepoint];			
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
			
			var betzone_po:Array = [ [0, 0], [-623, 0],  [318, 10], [-840, 14], [341, 164], [-880, 167] ,[-274,28]];
			_model.putValue(modelName.AVALIBLE_ZONE_XY, betzone_po);
			_model.putValue(modelName.COIN_STACK_XY,   [ [140, 210], [-483, 210],  [408, 80], [-760, 94], [451, 264], [-800, 267] ,[-174,238]]);
			
			var _idx_to_result_idx:DI = new DI();
			
			_idx_to_result_idx.putValue("0", 1);
			_idx_to_result_idx.putValue("1", 0);
			_idx_to_result_idx.putValue("2", 3);
			_idx_to_result_idx.putValue("3", 2);
			_idx_to_result_idx.putValue("4", 5);
			_idx_to_result_idx.putValue("5", 4);
			_model.putValue("idx_to_result_idx", _idx_to_result_idx);		
			
			var poer_msg:DI = new DI();		
			poer_msg.putValue("WSLost", "無賴");
			poer_msg.putValue("WSWin", "點贏");
			poer_msg.putValue("WSPANormalWin", "點贏");
			poer_msg.putValue("WSPAOnePointWin", "一點贏");
			poer_msg.putValue("WSPATwoPointWin", "二點贏");
			poer_msg.putValue("WSPAFiveWawaWin", "五公贏");
			poer_msg.putValue("WSPAFourOfAKindWin", "四條贏");		
			_model.putValue(modelName.BIG_POKER_TEXT , poer_msg);
			
			var state:DI = new DI();
			state.putValue("NewRoundState", gameState.NEW_ROUND);
			state.putValue("EndBetState", gameState.END_BET);
			state.putValue("OpenState", gameState.START_OPEN);
			state.putValue("EndRoundState", gameState.END_ROUND);			
			_model.putValue("state_mapping", state);		
			
			_Bet_info.putValue("self", []);
			_model.putValue("history_bet",[]);
		}
		
		
		
		public function betTypeMain(e:Event,idx:int):Boolean
		{
			if ( _Actionmodel.length() > 0) return false;
			
			//押注金額判定
			//if ( all_betzone_totoal() + _opration.array_idx("coin_list", "coin_selectIdx") > _model.getValue(modelName.CREDIT))
			//{
				//dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.NO_CREDIT));
				//return false;
			//}	
			
			var bet:Object = { "betType": idx,
											"bet_idx":_model.getValue("coin_selectIdx"),
			                               "bet_amount":  _opration.array_idx("coin_list", "coin_selectIdx"),
										   "total_bet_amount": get_total_bet(idx) +_opration.array_idx("coin_list", "coin_selectIdx")
			};
			
			dispatcher( new ActionEvent(bet, "bet_action"));
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET));
			
			return true;
		}	
		
		public function bet_local(e:Event,idx:int):Boolean
		{			
			var bet:Object = { "betType": idx, 
											 "bet_idx":_model.getValue("coin_selectIdx"),
			                               "bet_amount":  _opration.array_idx("coin_list", "coin_selectIdx"),
										   "total_bet_amount": get_total_bet(idx) +_opration.array_idx("coin_list", "coin_selectIdx")
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
			self_show_credit()
			//var bet_list:Array = _Bet_info.getValue("self");
			//for (var i:int = 0; i < bet_list.length; i++)
			//{
				//var bet:Object = bet_list[i];
				//
				//utilFun.Log("bet_info  = "+bet["betType"] +" amount ="+ bet["bet_amount"]);
			//}
		}
		
		private function self_show_credit():void
		{
			var total:Number = get_total_bet(-1);
			
			var credit:int = _model.getValue(modelName.CREDIT);
			_model.putValue("after_bet_credit", credit - total);
		}		
		
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
		
		public function get_my_bet_info(type:String):Array
		{
			var arr:Array = _Bet_info.getValue("self");			
			var data:Array = [];
			
			for ( var i:int = 0; i < arr.length ; i++)
			{
				var bet_ob:Object = arr[i];
				if ( type == "Type") data.push(bet_ob["betType"]);				
			}
			return data;
		}
		
		public function get_my_betlist():Array
		{		
			return _Bet_info.getValue("self");		
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean_bet():void
		{
			save_bet();
			_Bet_info.clean();			
			
			_Bet_info.putValue("self", [] ) ;
		}
		
		public function save_bet():void
		{
			var bet_list:Array = _Bet_info.getValue("self");
			utilFun.Log("save_bet bet_list  = "+bet_list.length );
			if ( bet_list.length ==0) return;
			_model.putValue("history_bet", bet_list);
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
			
			//與賓果不同,同一注區會分多筆,必需要等上一筆注單確認,再能再下第二筆,不然total_bet_amount,值會錯
			utilFun.Log("bet_list  = " + bet_list.length );
			if ( bet_list.length != 0)
			{			
				var coin_list:Array = _model.getValue("coin_list");
				var bet:Object = bet_list[0];				
				var mybet:Object = { "betType": bet["betType"],
													  "bet_idx":bet["bet_idx"],
														"bet_amount": coin_list[ bet["bet_idx"]] ,
														"total_bet_amount": ( get_total_bet( bet["betType"]) + coin_list[ bet["bet_idx"]] )
				};
			
				utilFun.Log("bet_info  = " + mybet["betType"] +" amount =" + mybet["bet_amount"] + " idx = " + bet["bet_idx"] +" total_bet_amount " + (get_total_bet( bet["betType"]) +coin_list[ bet["bet_idx"]] ) );
				bet_list.shift();
				_model.putValue("history_bet",bet_list);
				dispatcher( new ActionEvent(mybet, "bet_action"));
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET));
			}
		}
		
	}

}