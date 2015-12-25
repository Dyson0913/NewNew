package View.ViewComponent 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import util.math.Path_Generator;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import View.GameView.gameState;
	
	/**
	 * hintmsg present way
	 * @author ...
	 */
	public class Visual_Settle  extends VisualHandler
	{	
		[Inject]
		public var _path:Path_Generator;
		
		[Inject]
		public var _coin_stack:Visual_Coin_stack;
		
		[Inject]
		public var _betCommand:BetCommand;		
		
		public const state_angel:String = "angel_state"
		public const state_evil:String = "evil_state"
		
		public function Visual_Settle() 
		{
			
		}
		
		public function init():void
		{
			var zone:MultiObject = create("zone",  [state_evil, state_angel]);	
			zone.container.x = 1391;
			zone.container.y = 486;			
			zone.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			zone.Post_CustomizedData = [2, -850, 0];
			zone.Create_(2);
			
			put_to_lsit(zone);
			
			state_parse([gameState.END_ROUND]);
		}
		
		override public function disappear():void
		{			
			setFrame("zone", 1);
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="settle_step")]
		public function settles(v:Intobject):void
		{			
			dispatcher(new Intobject(1, "show_who_win"));
			
			_regular.Call(this, { onComplete:this.showAni}, 1, 0, 1, "linear");	
		}
		
		public function showAni():void
		{
			var settle_win:Array = _model.getValue("settle_win");
			var idx:int = settle_win.indexOf(1);
			if ( idx != -1) 	
			{
				_regular.Call(this, { onComplete:this.angel_show, onCompleteParams:[idx] }, 1, 2, 1, "linear");
				play_sound("sound_angel_win");
			}
			else play_sound("sound_None_win");
			
			_regular.Call(this, { onComplete:this.show_ok }, 1, 2, 1, "linear");
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject", selector = "show_who_win")]
		public function show_who_win():void
		{
			var angPoint:int = pokerUtil.ca_point(_model.getValue(modelName.PLAYER_POKER));
			var eviPoint:int = pokerUtil.ca_point(_model.getValue(modelName.BANKER_POKER));
			
			var zone_frame:Array = _model.getValue("settle_frame");
			
			var zone:MultiObject = Get("zone");
			zone.CustomizedFun = _regular.FrameSetting;
			zone.CustomizedData = zone_frame;			
			zone.FlushObject();
			
			zone.CustomizedFun = frame_filter;
			zone.CustomizedData = [eviPoint, angPoint];			
			zone.FlushChild("_point");
			
		}
		
		public function frame_filter(mc:MovieClip, idx:int, data:Array):void
		{
			if ( mc.currentFrame == 4 || mc.currentFrame == 5) mc.gotoAndStop(data[idx]);
		}
		
		private function angel_show(type:int):void
		{
			GetSingleItem("zone", type)["ani"].gotoAndPlay(2);
		}
		
		public function show_ok():void
		{
			dispatcher(new ModelEvent("show_settle_table"));
		}
		
		//--------------------------------coin ani TODO
		
		private function start_settle():void
		{
			var clean:Array = _model.getValue("CleanZone")
			for (var i:int = 0; i < clean.length ; i++)
			{				
				var idx_to_name:DI = _model.getValue("Bet_idx_to_name");
				var allPath:Object =  _model.getValue("coin_recycle_path ");				
				var path:Array = allPath[idx_to_name.getValue(clean[i])];
				var path_format:Array = _path.get_recoder_format_path(path);
				_path.follew_path(GetSingleItem("coinstakeZone", clean[i]), path_format,this.recycle_ok);
				
				//utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone", clean[i]));
			}
		}
		
		public function recycle_ok(mc:DisplayObjectContainer):void
		{
			utilFun.Clear_ItemChildren(mc);
			
			var ok_num:int = _opration.operator("clean_coin_Count", DataOperation.add);
			if ( ok_num == _model.getValue("clean_coin_num"))
			{				
				_model.putValue("clean_coin_Count", 0);			
				_regular.Call(Get("coinstakeZone").container, { onComplete:this.give_credit }, 1, 2);
			}
		}
		
		
		public function give_credit():void
		{
			var total:Array = _model.getValue(modelName.AVALIBLE_ZONE_IDX);					
			var rest:Array = utilFun.Get_restItem(total, _model.getValue("CleanZone"));
			utilFun.Log("rest=" + rest);
			_model.putValue("clean_coin_num", rest.length);
				
			var win_coin:Array = _model.getValue("Settle_amount");
			utilFun.Log("rest give_credit=" + win_coin);
			for ( var i:int = 0; i <rest.length ; i++)
			{
				var idx_to_name:DI = _model.getValue("Bet_idx_to_name");
				var allPath:Object =  _model.getValue("coin_Win_path ");				
				var path:Array = allPath[idx_to_name.getValue(rest[i])];					
				var path_format:Array = _path.get_recoder_format_path(path);
				utilFun.Log("rest path=" + path);
					
				//貼到同item 上,不清除container		
				var total_amount:int = win_coin[rest[i]];
				utilFun.Log("total_amount=" + total_amount);
				
				//var new_coin:MultiObject =  _coin_stack.Dynaimic_stack(_betCommand.Bet_type_betlist(rest[i]), GetSingleItem("coinstakeZone", rest[i]), rest[i], path[0]);
				var new_coin:MultiObject =  _coin_stack.one_stack(total_amount, GetSingleItem("coinstakeZone", rest[i]), rest[i], path[0]);
				_path.follew_path(new_coin.container, path_format, ready_to_credit);
				
			}
		}
		
		public function ready_to_credit(mc:DisplayObjectContainer):void
		{
			//utilFun.Clear_ItemChildren(mc);
			
			var ok_num:int = _opration.operator("clean_coin_Count", DataOperation.add);
			if ( ok_num == _model.getValue("clean_coin_num"))
			{
				utilFun.Log("give ok, ready to ");				
//				move_to_credit();
				_regular.Call(Get("coinstakeZone").container, { onComplete:this.move_to_credit }, 1, 2);
			}
			
			
		}
		
		public function move_to_credit():void
		{
				  var total:Array = _model.getValue(modelName.AVALIBLE_ZONE_IDX);					
				var rest:Array = utilFun.Get_restItem(total, _model.getValue("CleanZone"))
				utilFun.Log("rest=" + rest);
				for ( var i:int = 0; i <rest.length ; i++)
				{
					var idx_to_name:DI = _model.getValue("Bet_idx_to_name");
					var allPath:Object =  _model.getValue("coin_ToCredit_path ");				
					var path:Array = allPath[idx_to_name.getValue(rest[i])];					
					var path_format:Array = _path.get_recoder_format_path(path);
						utilFun.Log("rest path=" + path);
				
					//if ( i == 2)
					//{
						//_tool.SetControlMc( GetSingleItem("coinstakeZone", rest[i]));
						//_tool.y  = 200;
						//add(_tool);
					//}
					_path.follew_path(GetSingleItem("coinstakeZone", rest[i]), path_format,over_credit_ani);					
				}
		}
		
		public function over_credit_ani(mc:DisplayObjectContainer):void
		{
			
		}		
		
	}
	
	

}