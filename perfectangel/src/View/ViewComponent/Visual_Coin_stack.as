package View.ViewComponent 
{
	import flash.display.Sprite;
	import flash.events.Event;
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
	
	/**
	 * coin present way
	 * @author ...
	 */
	public class Visual_Coin_stack  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _Actionmodel:ActionQueue;	
		
		[Inject]
		public var _betTimer:Visual_betTimer;
		
		//coin seperate to N stack
		private var _stack_num:int = 1;		
		
		public function Visual_Coin_stack() 
		{
			
		}
		
		public function init():void
		{
			var avaliblezone:Array = _model.getValue(modelName.AVALIBLE_ZONE);
			//stick cotainer  			
			var coin_xy:Array = _model.getValue(modelName.COIN_STACK_XY);
			var coinstack:MultiObject = create("coinstakeZone",  [ResName.emptymc]);
			coinstack.container.x = 1081 ;
			coinstack.container.y = 657 ;
			coinstack.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			coinstack.Post_CustomizedData = coin_xy ;
			coinstack.Create_(avaliblezone.length, "coinstakeZone");	
			
			put_to_lsit(coinstack);
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean_poker():void
		{
			//TODO why not 
			//Get("coinstakeZone").Clear_itemChildren();		
			var a:MultiObject = Get("coinstakeZone");
			for ( var i:int = 0; i <  a.ItemList.length; i++)
			{
				utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone",i));
			}
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{					
			Get("coinstakeZone").container.visible = true;			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function timer_hide():void
		{					
			Get("coinstakeZone").container.visible = false;
		}
		
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "updateCoin")]
		public function updateCredit():void
		{					
			var bet_ob:Object = _Actionmodel.excutionMsg();			
			_Actionmodel.dropMsg();
			
			//TODO  一次一次pop
			//_betCommand.re_bet();
			
			//顯示下注倒數
			_betTimer.TimerStart(bet_ob["betType"]);
			
			dispatcher(new StringObject("sound_coin","sound" ) );
			
			//coin動畫
			stack(_betCommand.Bet_type_betlist(bet_ob["betType"]), GetSingleItem("coinstakeZone",bet_ob["betType"] ),bet_ob["betType"]);	
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "refreshCoin")]
		public function refreshCoin(msg:ModelEvent):void
		{
			var betType:int = msg.Value;
			
			//coin動畫
			stack(_betCommand.Bet_type_betlist(betType), GetSingleItem("coinstakeZone",betType ),betType);	
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "refreshMutiCoin")]
		public function refreshMutiCoin(msg:ModelEvent):void
		{
			var betTypes:Array = msg.Value[0];
			for each(var betType:int in betTypes) {
				//coin動畫
				stack(_betCommand.Bet_type_betlist(betType), GetSingleItem("coinstakeZone",betType ),betType);	
			}
		}
		
		public function stack(Allcoin:Array,contain:DisplayObjectContainer,bettype:int):void
		{			
			utilFun.Clear_ItemChildren(contain);
			var coin:Array = [];
			var shY:int = 0;
			var shX:int = 0;
			var coinshY:int = -5;		
			
			var allCoin:Array = getAllcoinData(bettype);
			for (var i:int = 0; i < _stack_num ; i++)
			{				
				//每疊coin 的multiobject
				//createcoin(i, Allcoin.concat(), contain,shY,shX,coinshY,bettype);
				createcoin(i, allCoin, contain,shY,shX,coinshY,bettype);
			}			
		}
		
		//籌碼面額換算
		public function getAllcoinData(betType:int):Array {
			var total:int = _betCommand.get_total_bet(betType);			
			var allcoinData:Array = [];
			var coin:Array = _model.getValue("coin_list").concat();
			//由大到小
			coin.reverse();
			
			for each(var chipValue:int in coin){
				var coinNum:int = total / chipValue;
				for (var i:int = 0; i < coinNum; i++ ) {
					allcoinData.push(chipValue);
				}
				
				total = total % chipValue;
			}
			
			return allcoinData;
		}
		
		public function createcoin(cointype:int, Allcoin:Array, contain:DisplayObjectContainer ,shY:int,shX:int,coinshY:int,bettype:int):void
		{			
			//var coin:Array = [];			
			//while (coinstack.indexOf(_model.getValue("coin_list")[cointype]) != -1)
			//{
				//var idx:int = coinstack.indexOf( _model.getValue("coin_list")[cointype]);
				//coin.push(coinstack[idx]);
				//coinstack.splice(idx, 1);
			//}
			//			
			
			var shifty:int = 0;
			var shiftx:int = 0;
			
			//push bet_type in first
			Allcoin.unshift(bettype);
			
			var secoin:MultiObject = new MultiObject();
			secoin.CleanList();
			secoin.CustomizedFun = coinput;
			secoin.CustomizedData = Allcoin;
			secoin.setContainer(contain);
			secoin.Create_by_list( Allcoin.length-1, [ResName.Betcoin] , 0 +shiftx+ (cointype * shX) , 0+shifty +shY, 1, 0, coinshY, "Bet_1");			
		}
		
		public function coinput(mc:MovieClip, idx:int, betlist_with_type_in_first:Array):void
		{
			mc.gotoAndStop(3);
			
			var coin:Array = _model.getValue("coin_list");		
			var frame:int = coin.indexOf(betlist_with_type_in_first[idx + 1]);		
			mc["_coin"].gotoAndStop(frame+1);
			mc["_text"].text = "";
			
			
			if ( idx ==  (betlist_with_type_in_first.length-2))
			{
				var total:int = _betCommand.get_total_bet(betlist_with_type_in_first[0]);			
				mc["_text"].text = total.toString();
			}			
		}	
		
		
		public function Dynaimic_stack(Allcoin:Array, contain:DisplayObjectContainer,bettype:int,path:Array):MultiObject
		{						
			var coin:Array = [];		
			
			Allcoin.unshift(bettype);		
			utilFun.Log("Allcoin=" + Allcoin);			
			var secoin:MultiObject = new MultiObject();			
			secoin.CustomizedFun = coinput;
			secoin.CustomizedData = Allcoin;			
			secoin.setContainer(new Sprite());
			//Get("coinstakeZone").container.addChild(secoin.container);
			secoin.container.x = path[0];
			secoin.container.y = path[1];
			contain.addChild(secoin.container);
			secoin.Create_by_list( Allcoin.length - 1, [ResName.Wincoin] , 0  , 0, 1, 0, -5, "Bet_"+bettype);			
			
			return secoin;
		}	
		
		public function one_stack(totalamount:int, contain:DisplayObjectContainer,bettype:int,path:Array):MultiObject
		{						
			var coin:Array = [];		
			
			var secoin:MultiObject = new MultiObject();			
			secoin.CustomizedFun = just_setting;
			secoin.CustomizedData = [totalamount];
			secoin.setContainer(new Sprite());			
			secoin.container.x = path[0];
			secoin.container.y = path[1];
			contain.addChild(secoin.container);
			secoin.Create_by_list( 1, [ResName.Wincoin] , 0  , 0, 1, 0, -5, "Bet_");			
			
			return secoin;
		}	
		
		public function just_setting(mc:MovieClip, idx:int, totalamount:Array):void
		{			
			mc["_text"].text = totalamount[0];			
		}		
		
	}

}