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
	import View.ViewComponent.Visual_BtnHandle;
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
		
		[Inject]
		public var _btn:Visual_BtnHandle;
		
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
			
			var zone:MultiObject = prepare("zone", new MultiObject() , this);
			zone.container.visible = false;
			zone.container.x = 520 +750;
			zone.container.y = 450;			
			zone.Create_by_list(2, [ResName.state_evil,ResName.state_angel], 0 , 0, 2, -750, 0, "Bet_");			
			
			//_tool.SetControlMc(playerCon.ItemList[0]);
			//addChild(_tool);
			
			//var info:MultiObject = prepare(modelName.CREDIT, new MultiObject() , this);
			//info.CustomizedFun = _regular.FrameSetting;
			//info.CustomizedData =  [10,10,10,10,10,10,10,10,10,10];
			//info.Create_by_list(10, [ResName.num_gold], 0, 0, 10, 26, 0, "info_");
			//info.container.x = 1520;
			//info.container.y = 1030;
			
			var bet:MultiObject = prepare("total_betcredit", new MultiObject() , this);
			bet.CustomizedFun = _regular.FrameSetting;
			bet.CustomizedData =  [10,10,10,10,10,10,10,10,10,10];
			bet.Create_by_list(10, [ResName.num_sefi], 0, 0, 10, 26, 0, "info_");
			bet.container.x = 523;
			bet.container.y = 1033;
			
			var win:MultiObject = prepare("win_credit", new MultiObject() , this);
			win.CustomizedFun = _regular.FrameSetting;
			win.CustomizedData =  [10,10,10,10,10,10,10,10,10,10];
			win.Create_by_list(10, [ResName.num_sefi], 0, 0, 10, 26, 0, "info_");
			win.container.x = 1139;
			win.container.y = 1033;			
			
			
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
			
			var betzone:Array = _model.getValue(modelName.BET_ZONE);
			var allzone:Array =  [ResName.evilZone,ResName.angelZone,ResName.evil_small,ResName.angel_small,ResName.evil_per,ResName.angel_per]
			var avaliblezone:Array = [];
			for each (var i:int in betzone)
			{
				avaliblezone.push ( allzone[i - 1]);
			}
			
			
			
			//main bet
			var playerzone:MultiObject = prepare("betzone", new MultiObject() , this);
			playerzone.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			playerzone.Post_CustomizedData = [ [803, 0], [0, 0],  [1136, -24],[93, -24], [900, -55],[336, -57]];
			playerzone.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,3,1]);			
			playerzone.Create_by_list(allzone.length,allzone, 0, 0, allzone.length, 0, 0, "time_");			
			playerzone.container.x = 225;
			playerzone.container.y = 756;
			
			//stick cotainer  
			var coinstack:MultiObject = prepare("coinstakeZone", new MultiObject(), playerzone.container);
			coinstack.container.x = 225 ;// +250;
			coinstack.container.y = 756 ;// +140;
			coinstack.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			coinstack.Post_CustomizedData = [[673, -45], [0, 0],   [906, -144],[-127, -126],  [677, -165],[98, -150]];
			coinstack.Create_by_list(avaliblezone.length, [ResName.emptymc], 0, 0, avaliblezone.length, 0, 0, "time_");
			coinstack.container.x = 250;
			coinstack.container.y = 140;
			
			//paytable
			var paytable:MultiObject = prepare("paytable", new MultiObject() , this);
			paytable.CustomizedData = [[-240,0],[240,0]]		 
			paytable.container.y = 110;		
			paytable.Create_by_list(2, [ResName.main_paytable,ResName.side_paytable], 0, 0, 2, 1670, 0, "time_");
			paytable.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 1, 0]);
			//paytable.mousedown = sliding;
			
			//var name:MultiObject = prepare("name", new MultiObject() , this);
			//name.CustomizedFun = _regular.ascii_idx_setting;			
			//name.CustomizedData = _model.getValue(modelName.NICKNAME).split("");
			//name.container.x = 235 + (name.CustomizedData.length -1) * 37 *-0.5;
			//name.container.y = 1020;
			//name.Create_by_bitmap(name.CustomizedData.length, utilFun.Getbitmap("LableAtlas"), 0, 0, name.CustomizedData.length, 37, 51, "o_");			
			
			
			var bankerCon:MultiObject = prepare(modelName.PLAYER_POKER, new MultiObject(), this);
			//playerCon.autoClean = true;	
			bankerCon.CustomizedFun = myscale;			
			bankerCon.Create_by_list(5, [ResName.poker_back], 0 , 0, 5, 100, 0, "Bet_");
			bankerCon.container.x = 350;
			bankerCon.container.y = 550;
			//
			var playerCon:MultiObject =  prepare(modelName.BANKER_POKER, new MultiObject(), this);
			//bankerCon.autoClean = true;			
			playerCon.CustomizedFun = myscale;
			playerCon.Create_by_list(5, [ResName.poker_back], 0 , 0, 5, 100, 0, "Bet_");
			//playerCon.autoClean = true;
			playerCon.container.x = 1050;
			playerCon.container.y = 550;
			
			var paytable:MultiObject =  prepare("paytable_btn", new MultiObject(), this);
			paytable.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);				
			paytable.mousedown = _btn.cycle_reaction;
			paytable.Create_by_list(1, [ResName.b_paytable], 0 , 0, 1, 0, 0, "Bet_");			
			paytable.container.x = 868;
			paytable.container.y = 978;
			
			var mypoker:Array = _model.getValue(modelName.PLAYER_POKER);
			if ( mypoker.length == 0) paytable.ItemList[0].gotoAndStop(2);
			
			//_tool.SetControlMc(paytable.ItemList[1]);
			//_tool.SetControlMc(paytable.container);
			//addChild(_tool);			
			
		}
		
		public function myscale(mc:MovieClip, idx:int, coinstack:Array):void
		{
			utilFun.scaleXY(mc, 0.748, 0.748);
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
			var syblist:Array =  _model.getValue(modelName.SPLIT_SYMBOL)
			var result:Array = a.split(syblist[0]);
			result.pop();
			
			//TODO get from server
			var clean:Array = [1, 2, 3, 4, 5, 6];
			for ( var i:int = 0; i < result.length ; i++)
			{
				var resultinfo:Array = result[i].split(syblist[1]);
				var zone:int = parseInt( resultinfo[0]);
				var odds:int = parseInt(resultinfo[1]);
				utilFun.Log("zone =" + zone);
				utilFun.Log("odds =" + odds);
				if ( clean.indexOf(zone) != -1)
				{
					clean.splice(clean.indexOf(zone), 1);
				}
				//zone handle
				//pa 5 = 0
				if ( odds != 5)
				{
					_regular.Twinkle(GetSingleItem("betzone", zone-1), 3, 10, 2);	
				}
				else
				{
					utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone", zone-1));
				}
				
				//hint
				if ( zone == 1 || zone == 2)
				{
					Get("zone").container.visible = true;
					GetSingleItem("zone",zone -1).visible = true;
					//odd to show
					if( odds == 1) GetSingleItem("zone",zone-1).gotoAndStop(2);
					if ( odds == 2 || odds == 3 || odds == 4)
					{
						//1.無懶, 2.XX win 3. XXwin N po 4.perf
						//TODO point;						
						var mypoker:Array = [];
						if ( zone == 1 ) 
						{							
							mypoker = _model.getValue(modelName.BANKER_POKER);							
						}
						else
						{
							mypoker = _model.getValue(modelName.PLAYER_POKER);					
						}
						
						var total:Array = [0, 1, 2, 3, 4]; 							
							var newpoker:Array = pokerUtil.newnew_judge(mypoker, total);
							var selectCard:Array = newpoker.slice(0, 3);
							var rest:Array = utilFun.Get_restItem(total, selectCard);
							//utilFun.Log("selectCard =" + selectCard);
							//utilFun.Log("rest =" + rest);
							var pointar:Array  = pokerUtil.get_Point( [mypoker[ rest[0]], mypoker[rest[1]]] );
							var point:int = pokerUtil.Get_Mapping_Value([0, 1], pointar);
							//utilFun.Log("point =" + point);
							if ( point % 10 == 0) 
							{
								//per
								GetSingleItem("zone", zone-1).gotoAndStop(4);								
							}
							else 
							{
								//N point win
								GetSingleItem("zone", zone-1).gotoAndStop(3);
								var idx:int = point %10;
								if (idx == 0) point= 10;
								GetSingleItem("zone", zone-1)["_point"].gotoAndStop(idx);
							}
					}
					
					if( odds == 5) GetSingleItem("zone",zone-1).gotoAndStop(1);
				}
			}
			
			utilFun.Log("clean =" + clean);
			for ( i = 0; i < clean.length ; i++)
			{
				utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone", clean[i]-1));
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