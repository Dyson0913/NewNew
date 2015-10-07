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
		
		[Inject]
		public var _paytable:Visual_Paytable;
		
		public function Visual_Settle() 
		{
			
		}
		
		public function init():void
		{
			var zone:MultiObject = create("zone",  [ResName.state_evil, ResName.state_angel]);	
			zone.container.x = 1391;
			zone.container.y = 446;			
			zone.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			zone.Post_CustomizedData = [2, -850, 0];
			zone.Create_(2,"zone");
			
			put_to_lsit(zone);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean():void
		{		
			var a:MultiObject = Get("zone");
			for ( var i:int = 0; i <  a.ItemList.length; i++)
			{				
				GetSingleItem("zone", i).gotoAndStop(1);
			}
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function round_result_data_process():void
		{
			utilFun.Log("round_result_data_process");
			var result_list:Array = _model.getValue(modelName.ROUND_RESULT);
			var num:int = result_list.length;
			
			var name_to_idx:DI = _model.getValue("Bet_name_to_idx");
			var idx_to_name:DI = _model.getValue("Bet_idx_to_name");
			var idx_to_result_idx:DI = _model.getValue("idx_to_result_idx");
			var win_text:DI = _model.getValue(modelName.BIG_POKER_TEXT);
			var settle_amount:Array = [0, 0, 0, 0, 0, 0, 0];
			var zonebet_amount:Array = [0, 0, 0, 0, 0, 0, 0];
			var total:int = 0;
			var winst:String = "";
			
			var clean:Array = [];
			var result_str:Array = [];
			var resultframe:int = 0;
			var angelFrame:int = 1;
			var evillFrame:int = 1;
			var angel_winstate:int = 0;
			var evel_winstate:int = 0;
			var evil_winstr:String = "";
			var ang_winstr:String = "";
			var angPoint:int = pokerUtil.ca_point(_model.getValue(modelName.PLAYER_POKER));
			var eviPoint:int = pokerUtil.ca_point(_model.getValue(modelName.BANKER_POKER));
			for ( var i:int = 0; i < num; i++)
			{
				var resultob:Object = result_list[i];		
				
				//coin 清除區
				if ( resultob.win_state == "WSLost")
				{
					if ( resultob.bet_type == "BetPAAngel" )
					{
						
						angelFrame = 2;
					}
					
					if ( resultob.bet_type == "BetPAEvil" )
					{						
						evillFrame = 2;
					}
					
					clean.push (name_to_idx.getValue(resultob.bet_type));
				}
				else
				{
					
					if ( resultob.bet_type == "BetPAAngel" ) 
					{
						//point
						angelFrame = 4;
						angel_winstate = 1;						
						ang_winstr = "天使" + angPoint.toString() +"點";
						winst = resultob.win_state;						
					}
					else if ( resultob.bet_type == "BetPAEvil") 
					{
						//point
						evillFrame = 4;
						evel_winstate = 1;						
						winst = resultob.win_state;
							
						evil_winstr = "惡魔" +  eviPoint.toString() +"點";
					}
					else if ( resultob.bet_type == "BetPABigEvil")
					{
						//point
						evillFrame = 5;
						evil_winstr = "大惡魔" + eviPoint.toString() +"點";
					}
					else if ( resultob.bet_type == "BetPABigAngel")
					{
						//point
						angelFrame = 5;
						ang_winstr = "大天使" + angPoint.toString() +"點";
					}
					else if ( resultob.bet_type == "BetPAUnbeatenEvil")
					{
						evillFrame = 6;
						evil_winstr = "闇黑惡魔";
					}
					else if ( resultob.bet_type == "BetPAPerfectAngel")
					{
						angelFrame = 6;
						ang_winstr = "完美天使";
						
					}
					
				}
				
				
				settle_amount[ idx_to_result_idx.getValue( name_to_idx.getValue(resultob.bet_type) )] =  resultob.settle_amount;
				zonebet_amount[ idx_to_result_idx.getValue( name_to_idx.getValue(resultob.bet_type)) ]  = resultob.bet_amount;
				total += resultob.settle_amount;
			}		
			
			var history:Array = _model.getValue("history_win_list");
			var arr:Array = [];
			if ( evel_winstate == 1) 
			{
				arr.push(2);
				arr.push(eviPoint);
			}
			else if ( angel_winstate == 1) 
			{
				arr.push(3);
				arr.push(angPoint);
			}
			else  arr.push(5);
			
			history.push(arr);
			if ( history.length > 60) history.shift();			
			_model.putValue("history_win_list", history);
			utilFun.Log("arr = "+ arr);
			utilFun.Log("evillFrame = "+ evillFrame +" angelFrame "+angelFrame);
			utilFun.Log("angPoint = "+ angPoint +" eviPoint "+eviPoint);
			utilFun.Log("evel_winstate = "+ evel_winstate +" angel_winstate "+angel_winstate);
			
			
			_paytable.win_frame_hint(winst);
			
			GetSingleItem("zone", 0).gotoAndStop(evillFrame);
			if ( evillFrame == 2 && eviPoint != -1) 
			{
				GetSingleItem("zone", 0).gotoAndStop(4);
				GetSingleItem("zone", 0)["_point"].gotoAndStop(eviPoint);
			}
			if ( evillFrame == 6) 
			{
				GetSingleItem("zone", 0)["_wing"].rotationY = -180;					
				
			}
			if (evillFrame == 5)
			{
				GetSingleItem("zone", 0)["_point"].gotoAndStop(eviPoint);				
			}
			if ( evillFrame == 4 )
			{
				GetSingleItem("zone", 0)["_point"].gotoAndStop(eviPoint);
				
			}
			
			
			GetSingleItem("zone", 1).gotoAndStop(angelFrame);	
			if ( angelFrame == 2 && angPoint != -1)
			{
				GetSingleItem("zone", 1).gotoAndStop(4);				
				GetSingleItem("zone", 1)["_point"].gotoAndStop(angPoint);
			}
			if ( angelFrame == 6) 
			{
				GetSingleItem("zone", 1)["_wing"].rotationY = -180;			
			}
				if ( angelFrame == 5)
			{
				GetSingleItem("zone", 1)["_point"].gotoAndStop(angPoint);				
			}
			if ( angelFrame == 4)
			{
				GetSingleItem("zone", 1)["_point"].gotoAndStop(angPoint);
				
			}
		
			if ( evel_winstate == 1 ) 
			{				
				result_str.push(evil_winstr+ "贏");
			}
			if ( angel_winstate == 1 )
			{
				result_str.push(ang_winstr+"贏");
			}
			//特殊條件
			if (angelFrame == 2 && evillFrame == 2)
			{
				result_str.push("天使，惡魔無賴");
			}
			
				//押注及得分
			_model.putValue("result_settle_amount",settle_amount);
			_model.putValue("result_zonebet_amount",zonebet_amount);
			_model.putValue("result_total", total);
			_model.putValue("result_str_list", result_str);
			
			_regular.Call(this, { onComplete:this.showAni,onCompleteParams:[evel_winstate,angel_winstate] }, 1, 2, 1, "linear");
			
		}
		
		public function showAni(evel_winstate:int,angel_winstate:int):void
		{
			//return;
			//TODO       大天使,(完美)
			//                XX幾點
			if( evel_winstate ==1)
			{
				GetSingleItem("zone", 0)["ani"].gotoAndPlay(2);				
			}
			
			if ( angel_winstate == 1)
			{
				GetSingleItem("zone", 1)["ani"].gotoAndPlay(2);
			}
			
			_regular.Call(this, { onComplete:this.show_ok }, 1, 2, 1, "linear");
		}
		
		public function show_ok():void
		{
			utilFun.Log("show_ok");
			dispatcher(new ModelEvent("show_settle_table"));
		}
		
		
		
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