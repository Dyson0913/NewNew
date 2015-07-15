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
	import View.ViewComponent.Visual_Coin;
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
		
		[Inject]
		public var _visual_coin:Visual_Coin;
		
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
			
			
			_betCommand.bet_init();
			
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.Bet_Scene], 0, 0, 1, 0, 0, "a_");			
			
			//var playerCon:MultiObject = prepare(modelName.PLAYER_POKER, new MultiObject(), this);
			//playerCon.autoClean = true;
			//playerCon.container.x = 70;
			//playerCon.container.y = 240;
			//
			//var bankerCon:MultiObject =  prepare(modelName.BANKER_POKER, new MultiObject(), this);
			//bankerCon.autoClean = true;
			//bankerCon.container.x = 1100;
			//bankerCon.container.y = 240;
			
			var zone:MultiObject = prepare("zone", new MultiObject() ,this);
			zone.container.x = 520;
			zone.container.y = 450;			
			zone.Create_by_list(2, [ResName.state_angel, ResName.state_evil], 0 , 0, 2, 750, 0, "Bet_");
			zone.container.visible = false;
			
			//addChild(_tool);
			
			//var info:MultiObject = prepare(modelName.CREDIT, new MultiObject() , this);
			//info.Create_by_list(1, [ResName.playerInfo], 0, 0, 1, 0, 0, "info_");
			//info.container.y = 830;
			//utilFun.SetText(info.ItemList[0]["_Account"], _model.getValue(modelName.UUID) );
			//utilFun.SetText(info.ItemList[0]["nickname"], _model.getValue(modelName.NICKNAME) );			
			//utilFun.SetText(info.ItemList[0]["credit"], _model.getValue(modelName.CREDIT).toString());
			
			var countDown:MultiObject = prepare(modelName.REMAIN_TIME,new MultiObject()  , this);
		   countDown.Create_by_list(1, [ResName.Timer], 0, 0, 1, 0, 0, "time_");
		   countDown.container.x = 894;
		   countDown.container.y = 653;
		   countDown.container.visible = false;
		   
			//var hintmsg:MultiObject = prepare(modelName.HINT_MSG, new MultiObject()  , this);
			//hintmsg.Create_by_list(1, [ResName.Hint], 0, 0, 1, 0, 0, "time_");
			//hintmsg.container.x = 850;			
			//hintmsg.container.y = 430;
			
			//bet區容器
			//coin
			var coinob:MultiObject = prepare("CoinOb", new MultiObject(), this);
			coinob.container.x = 708;
			coinob.container.y = 904;
			coinob.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,2,0]);
			coinob.CustomizedFun = _regular.FrameSetting;
			coinob.CustomizedData = [2, 1, 1, 1, 1];
			coinob.Posi_CustzmiedFun = _regular.Posi_y_Setting;
			coinob.Post_CustomizedData = [0,-20,-30,-20,0];
			coinob.Create_by_list(5,  [ResName.coin1,ResName.coin2,ResName.coin3,ResName.coin4,ResName.coin5], 0 , 0, 5, 100, 0, "Coin_");
			coinob.mousedown = _visual_coin.betSelect;
			
			//main bet
			var playerzone:MultiObject = prepare("betzone", new MultiObject() , this);
			playerzone.Create_by_list(2, [ResName.angelZone,ResName.evilZone], 0, 0, 2, 803, 0, "time_");
			playerzone.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);
			playerzone.mousedown = _betCommand.betTypeMain;
			playerzone.container.x = 225;
			playerzone.container.y = 756;
			
			//stick cotainer  
			var coinstack:MultiObject = prepare("coinstakeZone", new MultiObject(), playerzone.container);
			//coinstack.container.x = 250;
			//coinstack.container.y = 140;
			coinstack.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			coinstack.Post_CustomizedData = [ [0, 0],[710,-40]];
			coinstack.Create_by_list(2, [ResName.emptymc], 0, 0, 2, 0, 0, "time_");
			
			//side bet		   	
			var sidebet:MultiObject = prepare("side_betzone", new MultiObject() , this);
			sidebet.container.x = 317;
			sidebet.container.y = 732;
			sidebet.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			sidebet.Post_CustomizedData = [ [0, 0],[1044,0],[808,-31],[244,-34]];
			sidebet.Create_by_list(4, [ResName.angel_small,ResName.evil_small,ResName.evil_per,ResName.angel_per], 0, 0, 4, 0, 0, "time_");
			sidebet.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);
			sidebet.mousedown = _betCommand.fake_test_fun;			
			
			//side bet coint
			var side_coinstack:MultiObject = prepare("side_coinstakeZone", new MultiObject(), sidebet.container);
			side_coinstack.container.x = 250;
			side_coinstack.container.y = 140;
			side_coinstack.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			side_coinstack.Post_CustomizedData = [ [0, 0],[710,-40]];
			side_coinstack.Create_by_list(2, [ResName.emptymc], 0, 0, 2, 0, 0, "time_");
			
			//paytable
			var paytable:MultiObject = prepare("paytable", new MultiObject() , this);
			paytable.CustomizedData = [[-240,0],[240,0]]		 
			paytable.container.y = 110;		
			paytable.Create_by_list(2, [ResName.main_paytable,ResName.side_paytable], 0, 0, 2, 1670, 0, "time_");
			paytable.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 1, 0]);
			//paytable.mousedown = sliding;
			
			//_tool.SetControlMc(paytable.ItemList[1]);
			_tool.SetControlMc(paytable.container);
			
			addChild(_tool);			
			
		}
		
		public function sliding(e:Event, idx:int):Boolean
		{
			var paytable:MultiObject = Get("paytable");
			//paytable.ItemList[idx]
			var data:Array = paytable.CustomizedData[idx];
			_regular.sliding(paytable.ItemList[idx],1, data[0]);
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
				_regular.Twinkle(GetSingleItem("betzone", 1), 3, 10, 2);
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
			   //else if ( betresult == CardType.WINTYPE_PLAYER_NORMAL_WIN)
			   else //if ( betresult == CardType.WINTYPE_PLAYER_NORMAL_WIN)
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
						//   else if ( betresult == CardType.WINTYPE_BANKER_NORMAL_WIN)
						   else //if ( betresult == CardType.WINTYPE_BANKER_NORMAL_WIN)
						  {
							customizedData =  ["莊 贏"];
						  }			
							_regular.Twinkle(GetSingleItem("betzone"), 3, 10, 2);
							utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone"));
				  }
			}		
			
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Bet) return;
			super.ExitView(View);
		}
		
		
	}

}