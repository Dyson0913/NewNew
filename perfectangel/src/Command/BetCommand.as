package Command 
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.events.Event;
	import Model.*;
	import Model.valueObject.Intobject;
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
			
			var betzone_po:Array = [ [0, 0], [-623, 0],  [318, 10], [-840, 14], [341, 164], [-880, 167] ,[-274,148],[-264,18]];
			_model.putValue(modelName.AVALIBLE_ZONE_XY, betzone_po);
			_model.putValue(modelName.COIN_STACK_XY,   [ [140, 210], [-483, 210],  [408, 80], [-760, 94], [451, 264], [-800, 267] ,[-174,238],[-174,68]]);
			
			var poermapping:DI = new DI();
			poermapping.putValue("WSWin", 1);
			poermapping.putValue("WSPAFourOfAKindWin", 2);
			poermapping.putValue("WSPAExFourOfAKindWin", 2);
			poermapping.putValue("WSPAFiveWawaWin", 3);
			poermapping.putValue("WSPAExFiveWawaWin", 3);
			poermapping.putValue("WSPAExPerfectAngelWin", 4);
			poermapping.putValue("WSPAExUnbeatenEvilWin", 4);
			poermapping.putValue("WSPAExBigAngelWin", 5);
			poermapping.putValue("WSPAExBigEvilWin", 5);
			poermapping.putValue("WSPANormalWin", 6);
			poermapping.putValue("WSPAExSmallWin", 6);			
			_model.putValue(modelName.BIG_POKER_MSG , poermapping);
			
			
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
		
		public function bet_zone_amount():Array
		{
			var zone:Array = _model.getValue(modelName.AVALIBLE_ZONE_IDX);
			var mylist:Array = [];
			for ( var i:int = 0; i < zone.length; i++)
			{
				mylist.push(0);
			}
			
			var total:int = 0;
			for (  i = 0; i < zone.length; i++)
			{				
				var map:int = _opration.getMappingValue("idx_to_result_idx", zone[i]);
				var amount:int = get_total_bet(zone[i]);
				mylist.splice(map, 1, amount);
				total += amount;
			}
			mylist.push(total);
			return mylist;
		}
		
		public function get_my_betlist():Array
		{		
			return _Bet_info.getValue("self");		
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function settle_data_parse():void
		{
			var settle_amount:Array = [];
			var zonebet_amount:Array = [];			
			
			_model.putValue("clean_zone", []);
			_model.putValue("wintype",null);			
			_model.putValue("win_odd", -1);
			_model.putValue("winstr", "");			
			
			_model.putValue("settle_frame", [7,7]);			
			_model.putValue("settle_win", [0,0]);
			
			var total_bet:int = 0;
			var total_settle:int = 0;
			var result_list:Array = _model.getValue(modelName.ROUND_RESULT);
			var betZone:Array = _model.getValue(modelName.AVALIBLE_ZONE_IDX);			
			var num:int = result_list.length;	
			for ( var i:int = 0; i < num; i++)
			{
				var resultob:Object = result_list[i];				
				utilFun.Log("bet_type=" + resultob.bet_type  + "  " + resultob.win_state );
				
				var betzon_idx:int = _opration.getMappingValue("Bet_name_to_idx", resultob.bet_type);
				
				check_lost(resultob, betzon_idx);
				check_wintype(resultob);
				
				//總押注和贏分
				var display_idx:int = _opration.getMappingValue("idx_to_result_idx", betzon_idx);
				settle_amount[ display_idx] =  resultob.settle_amount;				
				zonebet_amount[ display_idx ]  = resultob.bet_amount;				
				total_settle += resultob.settle_amount;
				total_bet += resultob.bet_amount;
			}			
			
			settle_amount.push(total_settle);
			zonebet_amount.push(total_bet);
			
			_model.putValue("result_settle_amount",settle_amount);
			_model.putValue("result_zonebet_amount",zonebet_amount);
			_model.putValue("result_total", total_settle);
			_model.putValue("result_total_bet", total_bet);
			
			utilFun.Log("result_settle_amount =" + settle_amount);
			utilFun.Log("result_zonebet_amount =" + zonebet_amount);
			utilFun.Log("total_settle =" + total_settle);
			utilFun.Log("zonebet_amount =" + zonebet_amount);
			
			if ( _model.getValue("wintype") != null)
			{
				//dispatcher(new ModelEvent("settle_bigwin"));
				dispatcher(new ModelEvent("winstr_hint"));
				dispatcher(new Intobject(1, "settle_step"));				
			}			
		}
		
		public function check_lost(resultob:Object,betzon_idx:int):void
		{
			if ( resultob.win_state == "WSLost") 
			{
				var clean:Array = _model.getValue("clean_zone");
				clean.push (betzon_idx);
				_model.putValue("clean_zone", clean);				
			}			
		}	
		
		public function check_wintype(resultob:Object):void
		{			
			if ( resultob.bet_type == "BetPAEvil" ||  resultob.bet_type == "BetPAAngel" || resultob.bet_type == "BetPABothNone")
			{
				var frame:Array = _model.getValue("settle_frame");
				var idx:int = _opration.getMappingValue("Bet_name_to_idx", resultob.bet_type);
					
				if ( resultob.win_state != "WSLost" )
				{
					var wintype:int = _opration.getMappingValue(modelName.BIG_POKER_MSG, resultob.win_state);
					_model.putValue("wintype", wintype);
					_model.putValue("winstr", wintype);
					_model.putValue("win_odd", resultob.odds);
					
					//雙邊無懶
					if (idx == 7) return;
					
					frame[idx] = wintype;
					var win:Array = _model.getValue("settle_win");
					win[idx] = 1;
				}
				else
				{
					//有點 但輸 ,調到大天使或天使N點
					var Point:int = 0;
					if ( resultob.bet_type == "BetPAEvil") Point= pokerUtil.ca_point(_model.getValue(modelName.BANKER_POKER));
					if ( resultob.bet_type == "BetPAAngel") Point = pokerUtil.ca_point(_model.getValue(modelName.PLAYER_POKER));	
					if (  Point != -1)
					{					
						if( Point == 8 || Point ==9) frame[idx] = 5;
						if ( Point <8 && Point >=1) frame[idx] = 6;
						//TODO check 完美天使還輸
						
					}
				}
			}
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