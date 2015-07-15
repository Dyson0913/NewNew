package View.ViewComponent 
{
	import flash.events.Event;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import View.GameView.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * coin present way
	 * @author ...
	 */
	public class Visual_Coin  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _Actionmodel:ActionQueue;
		
		public function Visual_Coin() 
		{
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean_poker():void
		{
			//TODO why not 
			//Get("coinstakeZone").Clear_itemChildren();		
			if ( GetSingleItem("coinstakeZone") != null)  utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone"));
			if ( GetSingleItem("coinstakeZone",1) != null) utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone",1));
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "updateCoin")]
		public function updateCredit():void
		{					
			var bet_ob:Object = _Actionmodel.excutionMsg();
			utilFun.Log("ob = "+bet_ob["betType"])
			_Actionmodel.dropMsg();
			//coin動畫
			if (bet_ob["betType"] == CardType.BANKER)
			{
				stack(_betCommand.Bet_type_betlist(CardType.BANKER), GetSingleItem("coinstakeZone"));
			}
			
			if ( bet_ob["betType"] == CardType.PLAYER )
			{					
				stack(_betCommand.Bet_type_betlist(CardType.PLAYER), GetSingleItem("coinstakeZone",1));
			}			
			//
			if ( bet_ob["betType"] == CardType.BANKER_bigangel )
			{
				utilFun.Log("3");
				stack(_betCommand.Bet_type_betlist(CardType.BANKER_bigangel), GetSingleItem("side_coinstakeZone"));
			}
			
			if ( bet_ob["betType"] == CardType.PLAYER_bigangel )
			{
				utilFun.Log("4");
				stack(_betCommand.Bet_type_betlist(CardType.PLAYER_bigangel), GetSingleItem("side_coinstakeZone",1));
			}
			
			if ( bet_ob["betType"] == CardType.BANKER_per ) 
			{
				utilFun.Log("5");
				stack(_betCommand.Bet_type_betlist(CardType.BANKER_per), GetSingleItem("side_coinstakeZone",2));
			}
			if ( bet_ob["betType"] == CardType.PLAYER_per )
			{
				utilFun.Log("6");
				stack(_betCommand.Bet_type_betlist(CardType.PLAYER_per), GetSingleItem("side_coinstakeZone",3));
			}
		}
		
		public function stack(coinarr:Array,contain:DisplayObjectContainer):void
		{			
			var coin:Array = [];
			var shY:int = 0;
			var shX:int = 0;
			var coinshY:int = -10;
			var ucuve:Array = [0, 40, 70, 90, 105];
			var cuve:Array = [0, 7, 14, 21, 28];
			//var t:Array = [0, 5, 10, 5, 0];
			utilFun.Log("contain = "+contain.name)
			utilFun.Log("coinarr = "+coinarr)
			for (var i:int = 0; i < 5; i++)
			{
				
			    if ( contain == GetSingleItem("coinstakeZone",1))
				{				
					shY = cuve[i];
					shX = 50;
				}
				else if ( contain == GetSingleItem("coinstakeZone"))
				{				
					shY = -cuve[i];
					shX = 50;
				}
				
				if ( contain == GetSingleItem("side_coinstakeZone"))
				 {					
					shY = ucuve[i];
					shX = 50;
				 }
			
				coin.length = 0;				
				createcoin(i, coin, coinarr.concat(), contain,shY,shX,coinshY);
			}			
		}
		
		public function createcoin(cointype:int, coin:Array, coinstack:Array, contain:DisplayObjectContainer ,shY:int,shX:int,coinshY:int):void
		{			
			coin.length = 0;
			while (coinstack.indexOf(_model.getValue("coin_list")[cointype]) != -1)
			{
				var idx:int = coinstack.indexOf( _model.getValue("coin_list")[cointype]);
				coin.push(coinstack[idx]);
				coinstack.splice(idx, 1);
			}
			
			
			var shifty:int = 0;
			var shiftx:int = 0;
			
			var secoin:MultiObject = new MultiObject()
			secoin.CleanList();
			secoin.CustomizedFun = coinput;
			secoin.CustomizedData = coin;
			secoin.Create( coin.length, "coin_" + (cointype + 1), 0 +shiftx+ (cointype * shX) , 0+shifty +shY, 1, 0, coinshY, "Bet_",  contain);					
			
		}
		
		public function coinput(mc:MovieClip, idx:int, coinstack:Array):void
		{
			utilFun.scaleXY(mc, 0.5, 0.5);
		}
		
		public function betSelect(e:Event, idx:int):Boolean
		{
			var coinob:MultiObject = Get("CoinOb");
			coinob.exclusive(idx,1);
			
			_model.putValue("coin_selectIdx", idx);
			return true;
		}
		
			
	}

}