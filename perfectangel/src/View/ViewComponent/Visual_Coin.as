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
		
		//coin seperate to N stack
		private var _stack_num:int = 1;
		
		private var _coin:MultiObject;
		
		public function Visual_Coin() 
		{
			
		}
		
		public function init():void
		{
			var avaliblezone:Array = _model.getValue(modelName.AVALIBLE_ZONE);
			
			_coin = prepare("CoinOb", new MultiObject(), GetSingleItem("_view").parent.parent);
			_coin.container.x = 1080;
			_coin.container.y = 980;
			_coin.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,2,0]);
			_coin.CustomizedFun = ocin_setup;			
			_coin.Create_by_list(8,  [ResName.Betcoin], 0 , 0, 8, 85, 0, "Coin_");
			_coin.rollout = excusive_rollout;
			_coin.rollover = excusive_select_action;
			_coin.mousedown = betSelect;
			
			//_tool.SetControlMc(coinstack.ItemList[7]);
			//_tool.SetControlMc(_coin.container);
			//_tool.y = 200;
			//add(_tool);	
			//_tool.SetControlMc(coinob.container);
			//add(_tool);			
			
		}
		
		public function ocin_setup(mc:MovieClip, idx:int, data:Array):void
		{
			mc["_coin"].gotoAndStop(idx+1);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "start_bet")]
		public function display_coin():void
		{			
			_regular.FadeIn(_coin.container, 0, 1, null);
			
			setCoinLimit();
		}
		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function hide_coin():void
		{			
			_regular.Fadeout(_coin.container, 0, 1);			
		}
		
		public function excusive_rollout(e:Event, idx:int):Boolean
		{
			var select:int = _model.getValue("coin_selectIdx");
			if ( idx == select) 
			{				
				return false;
			}
			else 
			{
				_coin.ItemList[idx].gotoAndStop(1);
				_coin.ItemList[idx]["_coin"].gotoAndStop(idx+1);
				return true;
			}			
		}
		
		public function excusive_select_action(e:Event, idx:int):Boolean
		{
			var select:int = _model.getValue("coin_selectIdx");
			if ( idx == select) 
			{				
				return false;
			}
			else 
			{
				_coin.ItemList[idx].gotoAndStop(2);
				_coin.ItemList[idx]["_coin"].gotoAndStop(idx+1);
				return true;
			}
		}
		
		public function betSelect(e:Event, idx:int):Boolean
		{			
			var old_select:int = _model.getValue("coin_selectIdx");
			
			_model.putValue("coin_selectIdx", idx);			
			//position chagne 
			for (var i:int = 0; i < _coin.ItemList.length; i++)
			{
				if ( i == old_select ) 
				{				
					if ( old_select == idx) continue;
					var frame:int = _coin.ItemList[old_select]["_coin"].currentFrame;				
					_coin.ItemList[old_select].y += 20;
					_coin.ItemList[old_select].gotoAndStop(1);
					_coin.ItemList[old_select]["_coin"].gotoAndStop(frame);
				}
				if ( i == idx)
				{					
					_coin.ItemList[idx].y -= 20;						
				}
			}
			
			//frame change
			//_coin.exclusive(idx,1);			
			
			return true;
		}
		
		private function setCoinLimit():void {
			var creadit:int = _model.getValue(modelName.CREDIT);
			var coin_limit:Array = null; 
			if (creadit <= 1000) {
				coin_limit = _model.getValue("coin_limit_1000");
			}else if (creadit <= 5000) {
				coin_limit = _model.getValue("coin_limit_5000");
			}else if (creadit <= 10000) {
				coin_limit = _model.getValue("coin_limit_10000");
			}else {
				coin_limit = _model.getValue("coin_limit_50000");
			}
			
			var rePosi_mc:Array = [];
			var coin_selectIdx:int;
			for (var i:int = 0; i < coin_limit.length; i++) {
				GetSingleItem("CoinOb", i).visible = coin_limit[i];
				if (coin_limit[i] == true) {
					rePosi_mc.push(GetSingleItem("CoinOb", i));
					if (rePosi_mc.length == 3) {
						coin_selectIdx =  i;
					}
				}
			}
			
			var xy:Array = _model.getValue(modelName.COIN_SELECT_XY);
			for ( i = 0; i < xy.length; i++) {
				rePosi_mc[i].x = xy[i][0];
				rePosi_mc[i].y = xy[i][1];
			}
			
			var sele_idx:int = _model.getValue("coin_selectIdx");
			if (GetSingleItem("CoinOb", sele_idx).visible == true) {
				GetSingleItem("CoinOb", sele_idx).y -= 20;
				GetSingleItem("CoinOb", sele_idx).gotoAndStop(2);	
				GetSingleItem("CoinOb", sele_idx)["_coin"].gotoAndStop(sele_idx + 1);
			}else{
				_model.putValue("coin_selectIdx", coin_selectIdx);
				rePosi_mc[2].y -= 20;
				rePosi_mc[2].gotoAndStop(2);			
				rePosi_mc[2]["_coin"].gotoAndStop(coin_selectIdx + 1);
			}
		}
			
	}

}