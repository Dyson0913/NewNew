package Command 
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.events.Event;
	import Model.*;
	import util.DI;
	import util.utilFun;
	import View.GameView.*;
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
		}
		
		public function betTypePlayer(e:Event):Boolean
		{			
			//擋狀態
			if ( _model.getValue(modelName.GAMES_STATE)  != gameState.NEW_ROUND )
			{				
				return false;
			}
			
			if ( _Actionmodel.length() > 0) return false;
			
			var bet:Object = { "betType": CardType.MAIN_BET, 
			                               "bet_amount":  get_total_bet(CardType.MAIN_BET) + _opration.array_idx("coin_list", "coin_selectIdx")
			};
			
			dispatcher( new ActionEvent(bet, "bet_action"));
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET));
			
			return true;
		}		
		
		public function betTypebanker(e:Event):Boolean
		{
			//擋狀態
			if ( _model.getValue(modelName.GAMES_STATE)  != gameState.NEW_ROUND )
			{
				return false;
			}
			
			if ( _Actionmodel.length() > 0) return false;
			
			var bet:Object = { "betType": CardType.SIDE_BET,
			                               "bet_amount":  get_total_bet(CardType.SIDE_BET) +_opration.array_idx("coin_list", "coin_selectIdx")
			};
			
			dispatcher( new ActionEvent(bet, "bet_action"));
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.BET));
			return true;
		}
		
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "Betresult")]
		public function accept_bet():void
		{
			var bet_ob:Object = _Actionmodel.excutionMsg();
			bet_ob["bet_amount"] -= get_total_bet(bet_ob["betType"]);
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
		
		private function get_total_bet(type:int):Number
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
		
		public function has_Bet_type(type:int):Boolean
		{
			var bet_list:Array = _Bet_info.getValue("self");
			for (var i:int = 0; i < bet_list.length; i++)
			{
				var bet:Object = bet_list[i];
				if ( bet["betType"] == type) return true;				
			}			
			return false;
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