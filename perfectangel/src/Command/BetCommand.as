package Command 
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.events.Event;
	import Model.*;
	
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
			Clean_bet();					
		}
		
		public function bet_init():void
		{
			_model.putValue("coin_selectIdx", 0);
			_model.putValue("coin_list", [100, 500, 1000, 5000, 10000]);
			_model.putValue("after_bet_credit", 0);
			
		    var bet_name_to_idx:DI = new DI()
		    bet_name_to_idx.putValue("BetPAEvil", 0);
		    bet_name_to_idx.putValue("BetPAAngel", 1);			
		    bet_name_to_idx.putValue("BetPABigEvil", 2);
			bet_name_to_idx.putValue("BetPABigAngel", 3);
			bet_name_to_idx.putValue("BetPAUnbeatenEvil", 4);
			bet_name_to_idx.putValue("BetPAPerfectAngel", 5);		
			
			_model.putValue("Bet_name_to_idx", bet_name_to_idx);		
			
			var bet_idx_to_name:DI = new DI();
			bet_idx_to_name.putValue(0, "BetPAEvil");
			bet_idx_to_name.putValue(1, "BetPAAngel");
			bet_idx_to_name.putValue(2, "BetPABigEvil");
			bet_idx_to_name.putValue(3, "BetPABigAngel");
			bet_idx_to_name.putValue(4, "BetPAUnbeatenEvil");			
			bet_idx_to_name.putValue(5, "BetPAPerfectAngel");
			
			_model.putValue("Bet_idx_to_name", bet_idx_to_name);
			
			
			var betzone:Array = [1,2,3,4,5,6];
			var allzone:Array =  [ResName.evilZone,ResName.angelZone,ResName.evil_big,ResName.angel_big,ResName.evil_per,ResName.angel_per]
			var allzone_s:Array =  [ResName.evilZone_s,ResName.angelZone_s,ResName.evil_big_s,ResName.angel_big_s,ResName.evil_per_s,ResName.angel_per_s]
			var avaliblezone:Array = [];
			var avaliblezone_s:Array = [];
			for each (var i:int in betzone)
			{
				avaliblezone.push ( allzone[i - 1]);
				avaliblezone_s.push( allzone_s[i - 1]);
				
			}
			_model.putValue(modelName.AVALIBLE_ZONE, avaliblezone);
			_model.putValue(modelName.AVALIBLE_ZONE_SENCE, avaliblezone_s);
				
		}
		
		public function betTypeMain(e:Event,idx:int):Boolean
		{
			if ( _Actionmodel.length() > 0) return false;
			
			//押注金額判定
			if ( all_betzone_totoal() + _opration.array_idx("coin_list", "coin_selectIdx") > _model.getValue(modelName.CREDIT))
			{
				dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.NO_CREDIT));
				return false;
			}	
			
			var bet:Object = { "betType": idx, 
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
			var betzone:Array = [1,2,3,4,5,6]; _model.getValue(modelName.BET_ZONE);
			
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
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean_bet():void
		{
			_Bet_info.clean();
		}
	}

}