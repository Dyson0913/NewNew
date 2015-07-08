package View.GameView
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import Model.valueObject.*;
	import Model.*;
	import Res.ResName;
	import util.DI;
	import View.Viewutil.*;
	import View.ViewBase.ViewBase;

	import util.*;
	import Command.*;
	import caurina.transitions.Tweener;
	
	/**
	 * ...
	 * @author hhg
	 */
	public class betView extends ViewBase
	{	
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _regular:RegularSetting;		
		
		public function betView()  
		{
			utilFun.Log("betView");
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.Bet) return;
			super.EnterView(View);
			//清除前一畫面
			utilFun.Log("in to EnterBetview=");
			_tool = new AdjustTool();
			
			_betCommand.bet_init();
			
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.Bet_Scene], 0, 0, 1, 0, 0, "a_");
			
			var playerCon:MultiObject = prepare(modelName.PLAYER_POKER, new MultiObject(), this);
			playerCon.autoClean = true;
			playerCon.container.x = 70;
			playerCon.container.y = 240;
				
			var bankerCon:MultiObject =  prepare(modelName.BANKER_POKER, new MultiObject(), this);
			bankerCon.autoClean = true;
			bankerCon.container.x = 1100;
			bankerCon.container.y = 240;
			
			var zone:MultiObject = prepare("zone", new MultiObject() ,this);
			zone.container.x = 610;
			zone.CustomizedFun = _regular.textSetting;
			zone.CustomizedData = ["閒","莊"];
			zone.Create_by_list(2, [ResName.Text], 0 , 0, 2, 500, 0, "Bet_");
						
			//addChild(_tool);
			 
			var info:MultiObject = prepare(modelName.CREDIT, new MultiObject() , this);
			info.Create_by_list(1, [ResName.playerInfo], 0, 0, 1, 0, 0, "info_");
			info.container.y = 830;
			utilFun.SetText(info.ItemList[0]["_Account"], _model.getValue(modelName.UUID) );
			utilFun.SetText(info.ItemList[0]["nickname"], _model.getValue(modelName.NICKNAME) );			
			utilFun.SetText(info.ItemList[0]["credit"], _model.getValue(modelName.CREDIT).toString());
			
		   var countDown:MultiObject = prepare(modelName.REMAIN_TIME,new MultiObject()  , this);
		   countDown.Create_by_list(1, [ResName.Timer], 0, 0, 1, 0, 0, "time_");
		   countDown.container.x = 300;
		   countDown.container.y = 400;
		   countDown.container.visible = false;
		   		
			var hintmsg:MultiObject = prepare(modelName.HINT_MSG, new MultiObject()  , this);
			hintmsg.Create_by_list(1, [ResName.Hint], 0, 0, 1, 0, 0, "time_");
			hintmsg.container.x = 850;			
			hintmsg.container.y = 430;			
			
			//coin
			var coinob:MultiObject = prepare("CoinOb", new MultiObject(), this);
			coinob.container.x = 640;
			coinob.container.y = 730;
			coinob.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,3,0]);
			coinob.CustomizedFun = _regular.FrameSetting;
			coinob.CustomizedData = [3,1,1,1,1];
			coinob.Create_by_list(5,  [ResName.coin1,ResName.coin2,ResName.coin3,ResName.coin4,ResName.coin5], 0 , 0, 5, 130, 0, "Coin_");
			coinob.mousedown = betSelect;			
			
			//下注區
			var playerzone:MultiObject = prepare("playerbetzone", new MultiObject() , this);
			playerzone.Create_by_list(1, [ResName.betzone_player], 0, 0, 1, 0, 0, "time_");
			playerzone.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);
			playerzone.mousedown = _betCommand.betTypeMain;
			playerzone.container.x = 840;
			playerzone.container.y = 490;
			
			//stick cotainer
			var coinstack:MultiObject = prepare("playercoinstack", new MultiObject(), playerzone.container);
			coinstack.autoClean = true;
			coinstack.Create_by_list(1, [ResName.emptymc], 0, 0, 1, 0, 0, "time_");
			
			var finacon:MultiObject = prepare("finalresult", new MultiObject(), this);
			finacon.autoClean = true;
			finacon.container.x = 820;
			finacon.container.y = 140;
			
			update_remain_time();
			//utilFun.Log("bet view enter currtn view lien = " + _viewcom.currentViewDI.length());
			//utilFun.Log("bet enter currtn view lien = "+_viewcom.nextViewDI.length());
		}	
		
		public function betSelect(e:Event, idx:int):Boolean
		{
			//seperate from _viewDI
			var coinob:MultiObject = Get("CoinOb");
			coinob.exclusive(idx);
			
			_model.putValue("coin_selectIdx", idx);
			return true;
		}
		
		[MessageHandler(type= "Model.ModelEvent",selector = "playerpoker")]
		public function playerpokerupdate():void
		{
			var playerpoker:Array =   _model.getValue(modelName.PLAYER_POKER);
			var pokerlist:MultiObject = Get(modelName.PLAYER_POKER);
			pokerlist.CustomizedFun = pokerUtil.showPoker;
			pokerlist.CustomizedData = playerpoker;
			pokerlist.Create_by_list(playerpoker.length, [ResName.Poker], 0 , 0, playerpoker.length, 163, 123, "Bet_");
		}
		
		[MessageHandler(type= "Model.ModelEvent",selector = "bankerpoker")]
		public function pokerupdate():void
		{
			var bankerpoker:Array =   _model.getValue(modelName.BANKER_POKER);
			var pokerlist:MultiObject = Get(modelName.BANKER_POKER)			
			pokerlist.CustomizedFun = pokerUtil.showPoker;
			pokerlist.CustomizedData =  bankerpoker;
			pokerlist.Create_by_list(bankerpoker.length, [ResName.Poker], 0 , 0, bankerpoker.length, 163, 123, "Bet_");		
		}		
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function round_result():void
		{			
			var customizedData:Array = [];
			var betresult:int = _model.getValue(modelName.ROUND_RESULT);
			//player win
			if ( betresult % 2 ==0) 
			{			   
			   _regular.Twinkle(GetSingleItem("playerbetzone"), 3, 10,2);			
			  
			  if ( betresult == CardType.WINTYPE_PLAYER_FIVE_WAWA_WIN )
			  {
				customizedData =  ["閒 五公 win"];  
			  }
			  else if ( betresult == CardType.WINTYPE_PLAYER_FOUR_OF_A_KIND_WIN )
			  {
				customizedData =  ["閒 鐵支 win"];
			  }
			   else if ( betresult == CardType.WINTYPE_PLAYER_NEWNEW_WIN)
			  {
				customizedData =  ["閒 perfect angel win"];
			  }
			   else if ( betresult == CardType.WINTYPE_PLAYER_NORMAL_WIN)
			  {
				customizedData =  ["閒 贏"];
			  }
		    }
			else
			{
				customizedData =  ["莊 贏"];
			}			
			
			var finresult:MultiObject = Get("finalresult");
			finresult.CustomizedFun = _regular.textSetting;
			finresult.CustomizedData = customizedData;
			finresult.Create_by_list(customizedData.length, [ResName.Text], 0 , 0, customizedData.length, 610, 0, "Bet_");
			
			//poker ani
			var playerpoker:Array =   _model.getValue(modelName.PLAYER_POKER);
			var best3:Array = pokerUtil.newnew_judge( playerpoker);
			utilFun.Log("best 3 = "+best3);
			var pokerlist:MultiObject = Get(modelName.PLAYER_POKER)
			pokerUtil.poer_shift(pokerlist.ItemList.concat(), best3);
			
			var banker:Array =   _model.getValue(modelName.BANKER_POKER);
			var best2:Array = pokerUtil.newnew_judge( banker);
			var bpokerlist:MultiObject = Get(modelName.BANKER_POKER)
			pokerUtil.poer_shift(bpokerlist.ItemList.concat(), best2);
			
			//採用這種方式,呼叫與事件,包成control?
			utilFun.SetText(GetSingleItem(modelName.CREDIT)["credit"],_model.getValue(modelName.CREDIT).toString());
			
			//updateCredit();
			
			dispatcher(new BoolObject(true, "Msgqueue"));
			Tweener.addCaller(this, { time:4 , count: 1, onUpdate: this.clearn } );
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "updateCredit")]
		public function updateCredit():void
		{
			utilFun.SetText(GetSingleItem(modelName.CREDIT)["credit"], _model.getValue("after_bet_credit").toString());
			
			//coin動畫
			if (_betCommand.has_Bet_type(CardType.MAIN_BET ))
			{			    
				stack(_betCommand.Bet_type_betlist(CardType.MAIN_BET), GetSingleItem("playercoinstack"));
			}
			
			if ( _betCommand.has_Bet_type(CardType.SIDE_BET ) )
			{				
				stack(_betCommand.Bet_type_betlist(CardType.SIDE_BET), Get("bankcoinstack"));
			}			
		}
		
		public function stack(coinarr:Array,contain:DisplayObjectContainer):void
		{
			var coin:Array = [];			
			for (var i:int = 0; i < 5; i++)
			{
				coin.length = 0;				
				createcoin(i, coin, coinarr.concat(), contain);
			}			
		}
		
		public function createcoin(cointype:int, coin:Array, coinstack:Array, contain:DisplayObjectContainer ):void
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
			secoin.CustomizedFun = coinput;
			secoin.CustomizedData = coin;			
			secoin.Create( coin.length, "coin_" + (cointype + 1), -25 +shiftx + (cointype * 60), -10 + shifty, 1, 0, -10, "Bet_", contain);			
		}
		
		public function coinput(mc:MovieClip, idx:int, coinstack:Array):void
		{
			utilFun.scaleXY(mc, 0.5, 0.5);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "update_remain_time")]
		public function update_remain_time():void
		{			
			var state:int = _model.getValue(modelName.GAMES_STATE);		
			if ( state  == gameState.NEW_ROUND)
			{
				Get(modelName.REMAIN_TIME).container.visible = true;
				var time:int = _model.getValue(modelName.REMAIN_TIME);
				utilFun.SetText(GetSingleItem(modelName.REMAIN_TIME)["_Text"], utilFun.Format(time, 2));
				Tweener.addCaller(this, { time:time , count: time, onUpdate:TimeCount , transition:"linear" } );	
				
				GetSingleItem(modelName.HINT_MSG).gotoAndStop(1);	
				_regular.FadeIn( GetSingleItem(modelName.HINT_MSG), 2, 2, _regular.Fadeout);
				
				//new round create
				Get("playercoinstack").Create_by_list(1, [ResName.emptymc], 0, 0, 1, 0, 0, "time_");				
			}
			else if ( state == gameState.END_BET)
			{
				Get(modelName.REMAIN_TIME).container.visible = false;
				
				GetSingleItem(modelName.HINT_MSG).gotoAndStop(2);
				_regular.FadeIn( GetSingleItem(modelName.HINT_MSG), 2, 2, _regular.Fadeout);				
			}
			else if ( state == gameState.START_OPEN)
			{
				
			}
			else if ( state == gameState.END_ROUND)
			{
				
			}
		}				
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "CreditNotEnough")]
		public function no_credit():void
		{
			GetSingleItem(modelName.HINT_MSG).gotoAndStop(3);
			_regular.FadeIn( GetSingleItem(modelName.HINT_MSG), 2, 2, _regular.Fadeout);	
		}
		
		private function TimeCount():void
		{			
			var time:int  = _opration.operator(modelName.REMAIN_TIME, DataOperation.sub);
			if ( time < 0) 
			{
				GetSingleItem(modelName.REMAIN_TIME).visible = false;
				return;
			}
			
			utilFun.SetText(GetSingleItem(modelName.REMAIN_TIME)["_Text"], utilFun.Format(time, 2));			
		}
		
		private function clearn():void
		{				
			dispatcher(new ModelEvent("clearn"));
			
			//handle auto clean
			
			Get(modelName.PLAYER_POKER).CleanList();
			Get(modelName.BANKER_POKER).CleanList();
			
			Get("finalresult").CleanList();			
			Get("playercoinstack").CleanList();
			
			dispatcher(new BoolObject(false, "Msgqueue"));
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Bet) return;
			super.ExitView(View);
		}
		
		
	}

}