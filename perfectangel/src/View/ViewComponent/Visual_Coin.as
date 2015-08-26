package View.ViewComponent 
{
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
	public class Visual_Coin  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _Actionmodel:ActionQueue;
		
		[Inject]
		public var _regular:RegularSetting;
		
		//coin seperate to N stack
		private var _stack_num:int = 1;
		
		public function Visual_Coin() 
		{
			
		}
		
		public function init():void
		{
			var avaliblezone:Array = _model.getValue(modelName.AVALIBLE_ZONE);
			
			var coinob:MultiObject = prepare("CoinOb", new MultiObject(), GetSingleItem("_view").parent.parent);
			coinob.container.x = 1148;
			coinob.container.y = 954;
			coinob.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,2,0]);
			coinob.CustomizedFun = ocin_setup;
			coinob.CustomizedData = [1, 1, 1, 1, 1];
			coinob.Create_by_list(5,  [ResName.coin1,ResName.coin2,ResName.coin3,ResName.coin4,ResName.coin5], 0 , 0, 5, 90, 0, "Coin_");
			coinob.rollout = excusive_select_action;
			coinob.rollover = excusive_select_action;
			coinob.mousedown = betSelect;
			coinob.ItemList[0].y -= 20;
			coinob.ItemList[0].gotoAndStop(2);
			
			//stick cotainer  
			//var coinstack:MultiObject = prepare("coinstakeZone", new MultiObject(), playerzone.container);
			var coinstack:MultiObject = prepare("coinstakeZone", new MultiObject(), GetSingleItem("_view").parent.parent);
			coinstack.container.x = 440 ;
			coinstack.container.y = 808 ;
			coinstack.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			coinstack.Post_CustomizedData =  [ [948, 10], [0, 0],  [847, -148], [67, -153], [677, -98], [291, -92]];
			coinstack.Create_by_list(avaliblezone.length, [ResName.emptymc], 0, 0, avaliblezone.length, 0, 0, "time_");		
			
			//_tool.SetControlMc(coinstack.ItemList[3]);
			//_tool.SetControlMc(coinstack.container);
			//add(_tool);	
			//_tool.SetControlMc(coinob.container);
			//add(_tool);			
			
		}
		
		public function ocin_setup(mc:MovieClip, idx:int, data:Array):void
		{
			utilFun.scaleXY(mc, 0.8, 0.8);
			mc.gotoAndStop(data[idx]);
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
		public function display_coin():void
		{
			var a:MultiObject = Get("CoinOb");			
			_regular.FadeIn(a.container, 0, 1,null);
		}
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function hide_coin():void
		{
			var a:MultiObject = Get("CoinOb");
			_regular.Fadeout(a.container, 0, 1);			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "updateCoin")]
		public function updateCredit():void
		{					
			var bet_ob:Object = _Actionmodel.excutionMsg();			
			_Actionmodel.dropMsg();
			//coin動畫
			stack(_betCommand.Bet_type_betlist(bet_ob["betType"]), GetSingleItem("coinstakeZone",bet_ob["betType"] ),bet_ob["betType"]);	
			//if (bet_ob["betType"] == CardType.BANKER)
			//{
				//stack(_betCommand.Bet_type_betlist(CardType.BANKER), GetSingleItem("coinstakeZone"));
			//}
			//
			//if ( bet_ob["betType"] == CardType.PLAYER )
			//{	
				//stack(_betCommand.Bet_type_betlist(CardType.PLAYER), GetSingleItem("coinstakeZone",1));
			//}			
			//
			//if ( bet_ob["betType"] == CardType.BANKER_bigangel )
			//{
				//stack(_betCommand.Bet_type_betlist(CardType.BANKER_bigangel), GetSingleItem("coinstakeZone",2));
			//}
			//
			//if ( bet_ob["betType"] == CardType.PLAYER_bigangel )
			//{
				//stack(_betCommand.Bet_type_betlist(CardType.PLAYER_bigangel), GetSingleItem("coinstakeZone",3));
			//}
			//
			//if ( bet_ob["betType"] == CardType.BANKER_per ) 
			//{
				//stack(_betCommand.Bet_type_betlist(CardType.BANKER_per), GetSingleItem("coinstakeZone",4));
			//}
			//if ( bet_ob["betType"] == CardType.PLAYER_per )
			//{
				//stack(_betCommand.Bet_type_betlist(CardType.PLAYER_per), GetSingleItem("coinstakeZone",5));
			//}
		}
		
		public function stack(Allcoin:Array,contain:DisplayObjectContainer,bettype:int):void
		{			
			utilFun.Clear_ItemChildren(contain);
			var coin:Array = [];
			var shY:int = 0;
			var shX:int = 0;
			var coinshY:int = -5;		
			
			for (var i:int = 0; i < _stack_num ; i++)
			{				
				//每疊coin 的multiobject
				createcoin(i, Allcoin.concat(), contain,shY,shX,coinshY,bettype);
			}			
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
			var reslist:Array = [];
			var coin:Array = _model.getValue("coin_list");
			for ( var i:int = 0; i < Allcoin.length ; i++)
			{
				var idx:int = coin.indexOf(Allcoin[i]);			
				if ( idx != -1) reslist.push("coin_" + (idx + 1) );
			}
			
			var shifty:int = 0;
			var shiftx:int = 0;
			
			Allcoin.unshift(bettype);
			var secoin:MultiObject = new MultiObject();
			secoin.CleanList();
			secoin.CustomizedFun = coinput;
			secoin.CustomizedData = Allcoin;
			secoin.setContainer(contain);
			secoin.Create_by_list( Allcoin.length, reslist , 0 +shiftx+ (cointype * shX) , 0+shifty +shY, 1, 0, coinshY, "Bet_");			
		}
		
	public function coinput(mc:MovieClip, idx:int, bettype:Array):void
		{
			//utilFun.Log("coinstack = "+coinstack);
			//utilFun.Log("coinstack[0] = "+coinstack[0]);
			//utilFun.Log("coinstack.length = "+coinstack.length);
			utilFun.scaleXY(mc, 0.7, 0.7);
			mc.gotoAndStop(3);
			mc["_text"].text = "";
			
			if ( idx ==  bettype.length -1)
			{
				var total:int = _betCommand.get_total_bet(bettype[0]);
				mc["_text"].text = total.toString();
			}			
		}	
		
		public function excusive_select_action(e:Event, idx:int):Boolean
		{
			var select:int = _model.getValue("coin_selectIdx");
			if ( idx == select) return false;
			else return true;
		}
		
		public function betSelect(e:Event, idx:int):Boolean
		{			
			utilFun.Log("betselect = " + idx);
			var old_select:int = _model.getValue("coin_selectIdx");
			
			_model.putValue("coin_selectIdx", idx);		
			var coinob:MultiObject = Get("CoinOb");			
			
			//position chagne 
			for (var i:int = 0; i < coinob.ItemList.length; i++)
			{
				if ( i == old_select ) 
				{				
					coinob.ItemList[old_select].y += 20;					
				}
				if ( i == idx)
				{					
					coinob.ItemList[idx].y -= 20;				
				}
			}
			
			//frame change
			coinob.exclusive(idx,1);
			
			
			return true;
		}
		
			
	}

}