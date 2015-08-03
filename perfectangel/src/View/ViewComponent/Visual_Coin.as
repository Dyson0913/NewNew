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
				stack(_betCommand.Bet_type_betlist(CardType.BANKER_bigangel), GetSingleItem("coinstakeZone",2));
			}
			
			if ( bet_ob["betType"] == CardType.PLAYER_bigangel )
			{
				stack(_betCommand.Bet_type_betlist(CardType.PLAYER_bigangel), GetSingleItem("coinstakeZone",3));
			}
			
			if ( bet_ob["betType"] == CardType.BANKER_per ) 
			{
				stack(_betCommand.Bet_type_betlist(CardType.BANKER_per), GetSingleItem("coinstakeZone",4));
			}
			if ( bet_ob["betType"] == CardType.PLAYER_per )
			{
				stack(_betCommand.Bet_type_betlist(CardType.PLAYER_per), GetSingleItem("coinstakeZone",5));
			}
		}
		
		public function stack(coinarr:Array,contain:DisplayObjectContainer):void
		{			
			utilFun.Clear_ItemChildren(contain);
			var coin:Array = [];
			var shY:int = 0;
			var shX:int = 0;
			var coinshY:int = -10;			
			var cuve:Array = [0, 0.05, 6.05 , 23.1 , 47.05];
			var dcuve:Array = [0, 23.95, 41 , 47.1 , 47.05];
			var vcuve:Array = [0, 13, 15, 17 , 19];
			var upcuve:Array = [0, 1, 3, 8 , 17];
			var per_cuve:Array = [0,5, 15, 19 , 10];
			var per_evil_cuve:Array = [0,15, 10, 0 , -10];
			//var t:Array = [0, 5, 10, 5, 0];
			//utilFun.Log("contain = "+contain.name)
			//utilFun.Log("coinarr = "+coinarr)
			for (var i:int = 0; i < 5; i++)
			{
				if ( contain == GetSingleItem("coinstakeZone"))
				{				
					shY = dcuve[i];
					shX = 60;					
				}
			    else if ( contain == GetSingleItem("coinstakeZone",1))
				{				
					shY = -cuve[i];
					shX = 60;
				}
				else if ( contain == GetSingleItem("coinstakeZone",2))
				{
					shY = upcuve[i];
					shX = 40;
				}
				else if ( contain == GetSingleItem("coinstakeZone",3))
				{					
					shY = -vcuve[i];
					shX = 40;
				}
				else if ( contain == GetSingleItem("coinstakeZone",4))
				{
					shY = -per_evil_cuve[i];
					shX = 40;					
				}
				else if ( contain == GetSingleItem("coinstakeZone",5))
				{
					shY = -per_cuve[i];
					shX = 40;
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
			
			//utilFun.Log("coinstack = "+coinstack)
			var shifty:int = 0;
			var shiftx:int = 0;
			
			var secoin:MultiObject = new MultiObject()
			secoin.CleanList();
			if ( contain == GetSingleItem("coinstakeZone", 2) )
			{
				secoin.CustomizedFun = sidebetcoid;
			}
			else if  ( contain == GetSingleItem("coinstakeZone", 3))
			{
				secoin.CustomizedFun = sidebetcoid;
			}
			else if ( contain == GetSingleItem("coinstakeZone", 4))
			{
				secoin.CustomizedFun = sidebetcoid;
			}
			else if ( contain == GetSingleItem("coinstakeZone",5))
			{
				secoin.CustomizedFun = sidebetcoid;
			}
			else secoin.CustomizedFun = coinput;
			secoin.CustomizedData = coin;
			secoin.Create( coin.length, "coin_" + (cointype + 1), 0 +shiftx+ (cointype * shX) , 0+shifty +shY, 1, 0, coinshY, "Bet_",  contain);					
			
		}
		
		public function coinput(mc:MovieClip, idx:int, coinstack:Array):void
		{
			utilFun.scaleXY(mc, 0.8, 0.8);
			mc.gotoAndStop(3);
		}
		
		public function sidebetcoid(mc:MovieClip, idx:int, coinstack:Array):void
		{
			utilFun.scaleXY(mc, 0.5, 0.5);
			mc.gotoAndStop(3);
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