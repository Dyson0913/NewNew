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
			
			//bet區容器
			//coin
			var coinob:MultiObject = prepare("CoinOb", new MultiObject(), this);
			coinob.container.x = 640;
			coinob.container.y = 730;
			coinob.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,3,0]);
			coinob.CustomizedFun = _regular.FrameSetting;
			coinob.CustomizedData = [3,1,1,1,1];
			coinob.Create_by_list(5,  [ResName.coin1,ResName.coin2,ResName.coin3,ResName.coin4,ResName.coin5], 0 , 0, 5, 130, 0, "Coin_");
			coinob.mousedown = betSelect;		
			
			//下注區容器
			var playerzone:MultiObject = prepare("betzone", new MultiObject() , this);
			playerzone.Create_by_list(2, [ResName.betzone_player,ResName.betzone_banker], 0, 0, 2, 570, 0, "time_");
			playerzone.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);
			playerzone.mousedown = _betCommand.betTypeMain;
			playerzone.container.x = 540;
			playerzone.container.y = 490;
			
			//stick cotainer  
			var coinstack:MultiObject = prepare("coinstakeZone", new MultiObject(), playerzone.container);	
			//coinstack.autoClean = true;
			coinstack.Create_by_list(2, [ResName.emptymc, ResName.emptymc], 0, 0, 2, 570, 0, "time_");
			
			_tool.SetControlMc(GetSingleItem("coinstakeZone",1));
			addChild(_tool);		
			
			//_tool.SetControlMc(bankzone)			
			//update_remain_time();			
			
		}	
		
		public function betSelect(e:Event, idx:int):Boolean
		{
			var coinob:MultiObject = Get("CoinOb");
			coinob.exclusive(idx);
			
			_model.putValue("coin_selectIdx", idx);
			return true;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function round_result():void
		{			
			var customizedData:Array = [];
			var a:String = _model.getValue(modelName.ROUND_RESULT);
			var result:Array = a.split(_model.getValue(modelName.SPLIT_SYMBOL));
			result.pop();
			var betresult:int = parseInt( result[0])
			//player win
			if ( betresult % 2 ==0) 
			{				
			   _regular.Twinkle(GetSingleItem("betzone"), 3, 10, 2);	
			   utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone",1));
			    
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
				  if ( betresult == CardType.WINTYPE_NO_NEW)
				  {
					customizedData =  ["無妞"];
				  }		
				  else {
					   if ( betresult == CardType.WINTYPE_BANKER_FIVE_WAWA_WIN )
						  {
							customizedData =  ["莊 五公 win"];  
						  }
						  else if ( betresult == CardType.WINTYPE_BANKER_FOUR_OF_A_KIND_WIN )
						  {
							customizedData =  ["莊 鐵支 win"];
						  }
						   else if ( betresult == CardType.WINTYPE_BANKER_NEWNEW_WIN)
						  {
							customizedData =  ["莊 perfect angel win"];
						  }
						   else if ( betresult == CardType.WINTYPE_BANKER_NORMAL_WIN)
						  {
							customizedData =  ["莊 贏"];
						  }			
							_regular.Twinkle(GetSingleItem("betzone", 1), 3, 10, 2);							
							utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone"));
				  }
				
				
				
			}			
			
			//採用這種方式,呼叫與事件,包成control?
			utilFun.SetText(GetSingleItem(modelName.CREDIT)["credit"],_model.getValue(modelName.CREDIT).toString());
			
			//updateCredit();
			
			//dispatcher(new BoolObject(true, "Msgqueue"));
			//Tweener.addCaller(this, { time:4 , count: 1, onUpdate: this.clearn } );
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "updateCredit")]
		public function updateCredit():void
		{
			utilFun.SetText(GetSingleItem(modelName.CREDIT)["credit"], _model.getValue("after_bet_credit").toString());
			
			//coin動畫
			if (_betCommand.has_Bet_type(CardType.BANKER ))
			{							
				stack(_betCommand.Bet_type_betlist(CardType.BANKER), GetSingleItem("coinstakeZone"));
			}
			
			if ( _betCommand.has_Bet_type(CardType.PLAYER ) )
			{					
				stack(_betCommand.Bet_type_betlist(CardType.PLAYER), GetSingleItem("coinstakeZone",1));
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
			secoin.CleanList();
			secoin.CustomizedFun = coinput;
			secoin.CustomizedData = coin;
			secoin.Create( coin.length, "coin_" + (cointype + 1), -25 +shiftx + (cointype * 60), -10 + shifty, 1, 0, -10, "Bet_",  contain);			
			
		}
		
		public function coinput(mc:MovieClip, idx:int, coinstack:Array):void
		{
			utilFun.scaleXY(mc, 0.5, 0.5);
		}
		
		[MessageHandler(type = "ConnectModule.websocket.WebSoketInternalMsg", selector = "CreditNotEnough")]
		public function no_credit():void
		{
			GetSingleItem(modelName.HINT_MSG).gotoAndStop(3);
			_regular.FadeIn( GetSingleItem(modelName.HINT_MSG), 2, 2, _regular.Fadeout);	
		}
		
		private function clearn():void
		{				
			dispatcher(new ModelEvent("clearn"));
			//TODO why not 
			//Get("coinstakeZone").Clear_itemChildren();		
			utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone"));
			utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone",1));
			
			//dispatcher(new BoolObject(false, "Msgqueue"));
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Bet) return;
			super.ExitView(View);
		}
		
		
	}

}