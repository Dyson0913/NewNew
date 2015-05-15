package View.GameView
{
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
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
			
			//清除前一畫面
			utilFun.Log("in to EnterBetview=");
			_tool = new AdjustTool();
			
			_betCommand.bet_init();
			
			prepare("_view",utilFun.GetClassByString(ResName.Bet_Scene) , this);			
			
			var playerCon:MovieClip = prepare("playerpokerCon", new MovieClip() , this);
			playerCon.x = 70;
			playerCon.y = 240;
			prepare(modelName.PLAYER_POKER, new MultiObject());
			
			
			var bankerCon:MovieClip = prepare("bankerpokerCon", new MovieClip() , this);
			bankerCon.x = 1100;
			bankerCon.y = 240;
			prepare(modelName.BANKER_POKER, new MultiObject());
			
			var zoneCon:MovieClip = prepare("ZoneContainer", new MovieClip() , this);
			zoneCon.x = 610;
			
			
			
			//元件事件及畫面更新
			var zone:MultiObject = prepare("zone", new MultiObject() );
			zone.CustomizedFun = _regular.textSetting;
			zone.CustomizedData = ["閒","莊"];
			zone.Create_by_list(2, [ResName.Text], 0 , 0, 2, 500, 0, "Bet_", zoneCon);
			
			
			addChild(_tool);
			
			var info:MovieClip = prepare(modelName.CREDIT, utilFun.GetClassByString(ResName.playerInfo) , this);			
			info.y = 830;
			utilFun.SetText(info["_Account"], _model.getValue(modelName.UUID) );
			utilFun.SetText(info["nickname"], _model.getValue(modelName.NICKNAME) );			
			utilFun.SetText(info["credit"], _model.getValue(modelName.CREDIT).toString());
			
		   var countDown:MovieClip = prepare(modelName.REMAIN_TIME, utilFun.GetClassByString(ResName.Timer) , this);
			countDown.visible = false;
			countDown.x = 300;
			countDown.y = 400;
			//utilFun.GetClassByString(ResName.Hint) ,
			//new HintMsg(850,430)
			var hintmsg:MovieClip = prepare(modelName.HINT_MSG, utilFun.GetClassByString(ResName.Hint) , this);
			hintmsg.alpha = 0;
			hintmsg.x = 850;
			hintmsg.y = 430;
			
			//bet區容器
			var coinzone:MovieClip = prepare("coinzone",  new MovieClip() , this);
			coinzone.x = 640;
			coinzone.y = 730;
			
			var coinob:MultiObject = prepare("CoinOb", new MultiObject());			
			coinob.CleanList();
			coinob.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,3,0]);
			coinob.CustomizedFun = _regular.FrameSetting;
			coinob.CustomizedData = [3,1,1,1,1];
			coinob.Create_by_list(5,  [ResName.coin1,ResName.coin2,ResName.coin3,ResName.coin4,ResName.coin5], 0 , 0, 5, 130, 0, "Coin_", coinzone);
			coinob.mousedown = betSelect;
			
			//下注區容器
			var betzone:MovieClip = prepare("betzone",  new MovieClip() , this);
			betzone.x = 540;
			betzone.y = 490;
			
			var playerzone:MovieClip = prepare("playerbetzone",  utilFun.GetClassByString(ResName.betzone_player) , betzone);
			playerzone.x = 300;
			prepare("playercoinstack",  utilFun.GetClassByString(ResName.emptymc) , playerzone);
			var _playerzone:SingleObject = prepare("_playerzone", new SingleObject());
			_playerzone.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);
			_playerzone.mousedown = _betCommand.betTypeMain;
			_playerzone.Create(playerzone );
			
			
			
			//var bankzone:MovieClip = prepare("bankerbetzone",  utilFun.GetClassByString(ResName.betzone_banker) , betzone);
			//bankzone.x = 580;
			//prepare("bankcoinstack",  utilFun.GetClassByString(ResName.emptymc) , bankzone);			
			//var _bankerzone:SingleObject = prepare("_bankerzone", new SingleObject());
			//_bankerzone.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);
			//_bankerzone.mousedown = _betCommand.betTypebanker;
			//_bankerzone.Create(bankzone );
			
			
			var finacon:MovieClip = prepare("finalresultCon", new MovieClip() , this);
			finacon.x = 820;
			finacon.y = 140;
			
			prepare("finalresult", new MultiObject());
			
			update_remain_time();			
				
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
			var pokerlist:MultiObject = Get(modelName.PLAYER_POKER)
			pokerlist.CleanList();
			pokerlist.CustomizedFun = pokerUtil.showPoker;
			pokerlist.CustomizedData = playerpoker;
			pokerlist.Create_by_list(playerpoker.length, [ResName.Poker], 0 , 0, playerpoker.length, 163, 123, "Bet_", Get("playerpokerCon"));
		}
		
		[MessageHandler(type= "Model.ModelEvent",selector = "bankerpoker")]
		public function pokerupdate():void
		{
			var bankerpoker:Array =   _model.getValue(modelName.BANKER_POKER);
			var pokerlist:MultiObject = Get(modelName.BANKER_POKER)
			pokerlist.CleanList();
			pokerlist.CustomizedFun = pokerUtil.showPoker;
			pokerlist.CustomizedData =  bankerpoker;
			pokerlist.Create_by_list(bankerpoker.length, [ResName.Poker], 0 , 0, bankerpoker.length, 163, 123, "Bet_", Get("bankerpokerCon"));		
		}		
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function round_result():void
		{			
			var customizedData:Array = [];
			var betresult:int = _model.getValue(modelName.ROUND_RESULT);
			//player win
			if ( betresult % 2 ==0) 
			{		     
			   //Get("playerbetzone").gotoAndStop(2);	
			   _regular.Twinkle(Get("playerbetzone"), 3, 10,2);			
			  
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
			finresult.CleanList();
			finresult.CustomizedFun = _regular.textSetting;
			finresult.CustomizedData = customizedData;
			finresult.Create_by_list(customizedData.length, [ResName.Text], 0 , 0, customizedData.length, 610, 0, "Bet_", Get("finalresultCon"));
			
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
			utilFun.SetText(Get(modelName.CREDIT)["credit"],_model.getValue(modelName.CREDIT).toString());
			
			//updateCredit();
			
			dispatcher(new BoolObject(true, "Msgqueue"));
			Tweener.addCaller(this, { time:4 , count: 1, onUpdate: this.clearn } );
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "updateCredit")]
		public function updateCredit():void
		{
			utilFun.SetText(Get(modelName.CREDIT)["credit"], _model.getValue("after_bet_credit").toString());
			
			//coin動畫
			if (_betCommand.has_Bet_type(CardType.MAIN_BET ))
			{				
				stack(_betCommand.Bet_type_betlist(CardType.MAIN_BET), Get("playercoinstack"));
			}
			
			if ( _betCommand.has_Bet_type(CardType.SIDE_BET ) )
			{				
				stack(_betCommand.Bet_type_betlist(CardType.SIDE_BET), Get("bankcoinstack"));
			}			
		}
		
		public function stack(coinarr:Array,contain:MovieClip):void
		{
			var coin:Array = [];			
			for (var i:int = 0; i < 5; i++)
			{
				coin.length = 0;				
				createcoin(i, coin, coinarr.concat(), contain);
			}			
		}
		
		public function createcoin(cointype:int, coin:Array, coinstack:Array, contain:MovieClip ):void
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
			secoin.Create( coin.length, "coin_" + (cointype + 1), -25 +shiftx + (cointype * 60), -10 + shifty, 1, 0, -10, "Bet_",  contain);			
			
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
				Get(modelName.REMAIN_TIME).visible = true;
				var time:int = _model.getValue(modelName.REMAIN_TIME);
				utilFun.SetText(Get(modelName.REMAIN_TIME)["_Text"], utilFun.Format(time, 2));
				Tweener.addCaller(this, { time:time , count: time, onUpdate:TimeCount , transition:"linear" } );	
				
				Get(modelName.HINT_MSG).gotoAndStop(1);	
				_regular.FadeIn( Get(modelName.HINT_MSG), 2, 2, _regular.Fadeout);							
			}
			else if ( state == gameState.END_BET)
			{
				Get(modelName.REMAIN_TIME).visible = false;
				
				Get(modelName.HINT_MSG).gotoAndStop(2);
				_regular.FadeIn( Get(modelName.HINT_MSG), 2, 2, _regular.Fadeout);
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
			Get(modelName.HINT_MSG).gotoAndStop(3);
			_regular.FadeIn( Get(modelName.HINT_MSG), 2, 2, _regular.Fadeout);	
		}
		
		private function TimeCount():void
		{			
			var time:int  = _opration.operator(modelName.REMAIN_TIME, DataOperation.sub);
			if ( time < 0) 
			{
				Get(modelName.REMAIN_TIME).visible = false;
				return;
			}
			
			utilFun.SetText(Get(modelName.REMAIN_TIME)["_Text"], utilFun.Format(time, 2));			
		}
		
		private function clearn():void
		{				
			dispatcher(new ModelEvent("clearn"));
			
			Get(modelName.PLAYER_POKER).CleanList();
			Get(modelName.BANKER_POKER).CleanList();
			Get("finalresult").CleanList();
			
			utilFun.ClearContainerChildren( Get("playercoinstack"));
			//utilFun.ClearContainerChildren( Get("bankcoinstack"));
			
			
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