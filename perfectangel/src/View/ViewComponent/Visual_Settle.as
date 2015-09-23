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
			var zone:MultiObject = prepare("zone", new MultiObject() , GetSingleItem("_view").parent.parent);			
			zone.container.x = 1450;
			zone.container.y = 450;			
			zone.Create_by_list(2, [ResName.state_evil, ResName.state_angel], 0 , 0, 2, -1014, 0, "Bet_");		
			
			//_tool.SetControlMc(zone.container);
			//_tool.SetControlMc(zone.ItemList[1]);
			//add(_tool);
			//Clean();
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
			var result_list:Array = _model.getValue(modelName.ROUND_RESULT);
			var num:int = result_list.length;
			
			var name_to_idx:DI = _model.getValue("Bet_name_to_idx");
			var idx_to_name:DI = _model.getValue("Bet_idx_to_name");
			var idx_to_result_idx:DI = _model.getValue("idx_to_result_idx");
			//var win_text:DI = _model.getValue(modelName.BIG_POKER_TEXT);
			var settle_amount:Array = [0, 0, 0, 0, 0, 0, 0];
			var zonebet_amount:Array = [0, 0, 0, 0, 0, 0, 0];
			var total:int = 0;
			var winst:String = "";
			
			var clean:Array = [];
			var resultframe:int = 0;
			var angelFrame:int = 1;
			var evillFrame:int = 1;
			var angel_winstate:int = 0;
			var evel_winstate:int = 0;
			var angPoint:int = pokerUtil.ca_point(_model.getValue(modelName.PLAYER_POKER));
			var eviPoint:int = pokerUtil.ca_point(_model.getValue(modelName.BANKER_POKER));
			for ( var i:int = 0; i < num; i++)
			{
				var resultob:Object = result_list[i];		
				
				//coin 清除區
				if ( resultob.win_state == "WSLost")
				{
					if ( resultob.bet_type == "BetPAAngel" )  angelFrame = 2;
					if ( resultob.bet_type == "BetPAEvil" )  evillFrame = 2;
					clean.push (name_to_idx.getValue(resultob.bet_type));
				}
				else
				{
					
					if ( resultob.bet_type == "BetPAAngel" ) 
					{
						//point
						angelFrame = 4;
						angel_winstate = 1;						
						//result_str.push("天使");
						winst = resultob.win_state;
					}
					else if ( resultob.bet_type == "BetPAEvil") 
					{
						//point
						evillFrame = 4;
						evel_winstate = 1;						
						winst = resultob.win_state;
						//if( bigwin == -1) result_str.push("惡魔贏");
					}
					else if ( resultob.bet_type == "BetPABigEvil")
					{
						//point
						evillFrame = 5;
					}
					else if ( resultob.bet_type == "BetPABigAngel")
					{
						//point
						angelFrame = 5;
					}
					else if ( resultob.bet_type == "BetPAUnbeatenEvil")
					{
						evillFrame = 6;
					}
					else if ( resultob.bet_type == "BetPAPerfectAngel")
					{
						angelFrame = 6;
					}
					
				}
				
				
				settle_amount[ idx_to_result_idx.getValue( name_to_idx.getValue(resultob.bet_type) )] =  resultob.settle_amount;
				zonebet_amount[ idx_to_result_idx.getValue( name_to_idx.getValue(resultob.bet_type)) ]  = resultob.bet_amount;
				total += resultob.settle_amount;
			}
			
			//押注及得分
			_model.putValue("result_settle_amount",settle_amount);
			_model.putValue("result_zonebet_amount",zonebet_amount);
			_model.putValue("result_total", total);
			
			var history:Array = _model.getValue("history_win_list");
			var arr:Array = [];
			if ( evel_winstate == 1) 
			{
				arr.push(2);
				arr.push(angPoint);
			}
			else if ( angel_winstate == 1) 
			{
				arr.push(3);
				arr.push(eviPoint);
			}
			else  arr.push(5);
			
			history.push(arr);
			if ( history.length > 60) history.shift();			
			_model.putValue("history_win_list", history);
			utilFun.Log("arr = "+ arr);
			utilFun.Log("evillFrame = "+ evillFrame +" angelFrame "+angelFrame);
			utilFun.Log("angPoint = "+ angPoint +" eviPoint "+eviPoint);
			
			
			_paytable.win_frame_hint(winst);
			
			GetSingleItem("zone", 0).gotoAndStop(evillFrame);
			GetSingleItem("zone", 1).gotoAndStop(angelFrame);
			
			
			_regular.Call(this, { onComplete:this.showAni,onCompleteParams:[evel_winstate,angel_winstate] }, 1, 2, 1, "linear");
			
		}
		
		public function showAni(evel_winstate:int,angel_winstate:int):void
		{
			//TODO       大天使,(完美)
			//                XX幾點
			if( evel_winstate ==1)
			{
				GetSingleItem("zone", 0).gotoAndStop(3);				
			}
			
			if ( angel_winstate == 1)
			{
				GetSingleItem("zone", 1).gotoAndStop(3);
			}
			
			_regular.Call(this, { onComplete:this.show_ok }, 1, 2, 1, "linear");
		}
		
		public function show_ok():void
		{
			utilFun.Log("show_ok");
			dispatcher(new ModelEvent("show_settle_table"));
		}
		
		//[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function old_round_result_data_process():void
		{
			var result_list:Array = _model.getValue(modelName.ROUND_RESULT);
			var num:int = result_list.length;
			
			var result:Array = [];			
			var total_settle_amount:int = 0;
			var name_to_idx:DI = _model.getValue("Bet_name_to_idx");
			var clean:Array = [];
			var settle_amount:Array = [];// [0, 0, 0, 0, 0, 0];
		
			
			
			var angel_frame:int = 1;
			var angel_winstate:int = 0;
			var evel_frame:int = 1;
			var evel_winstate:int = 0;
			var winst:String = "";			
			for ( var i:int = 0; i < num; i++)
			{
				var resultob:Object = result_list[i];				
				//var result:Array  = [];				
				//result.push(name_to_idx.getValue(resultob.bet_type));
				if ( resultob.bet_type == "BetPAAngel")
				{
					if ( resultob.win_state != "WSLost") 
					{
						angel_frame = 3;
						angel_winstate = 1;						
						winst = resultob.win_state;
					}
					else
					{
						//有妞但輸,會傳lost,frame 先切3 check 顥示幾點
						angel_frame = 3;
						clean.push(name_to_idx.getValue(resultob.bet_type));						
					}
					
				}
				
				if ( resultob.bet_type == "BetPABigAngel")
				{
					if ( resultob.win_state == "WSWin") angel_frame = 4;					
					else
					{
						clean.push(name_to_idx.getValue(resultob.bet_type));
					}
				}
				
				if ( resultob.bet_type == "BetPAPerfectAngel")
				{
					if ( resultob.win_state == "WSWin") angel_frame = 5;
					else
					{
						clean.push(name_to_idx.getValue(resultob.bet_type));
					}
				}
			
				if ( resultob.bet_type == "BetPAEvil")
				{
					if ( resultob.win_state != "WSLost")
					{
						evel_frame = 3;					
						evel_winstate = 1;
						winst = resultob.win_state;
					}
					else
					{
						//有妞但輸,會傳lost,frame 先切3 check 顥示幾點
						evel_frame = 3;
						clean.push(name_to_idx.getValue(resultob.bet_type));						
					}
				}
				
				if ( resultob.bet_type == "BetPABigEvil")
				{
					if ( resultob.win_state == "WSWin") evel_frame = 4;					
					else
					{
						clean.push(name_to_idx.getValue(resultob.bet_type));
					}
				}
				
				if ( resultob.bet_type == "BetPAUnbeatenEvil")
				{
					if ( resultob.win_state == "WSWin") evel_frame = 5;
					else
					{
						clean.push(name_to_idx.getValue(resultob.bet_type));
					}
					
				}				
				
				total_settle_amount += resultob.settle_amount;
				//settle_amount.push(resultob.settle_amount);
				settle_amount.splice( name_to_idx.getValue(resultob.bet_type), 0, resultob.settle_amount);
				
				utilFun.Log("resultob  =  " + resultob.bet_type +" win_state  =  " + resultob.win_state);	
				utilFun.Log("result  =  " + result);				
				
				//TODO coin ani
				if ( resultob.win_state != "WSLost") 
				{
					utilFun.Log("clean name=  " + resultob.bet_type);				
					utilFun.Log("clean =  " +  name_to_idx.getValue(resultob.bet_type));				
					_regular.Twinkle(GetSingleItem("betzone", name_to_idx.getValue(resultob.bet_type)), 3, 10, 2);	
				}
				else 
				{
					//lost not clean 
					//utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone", name_to_idx.getValue(resultob.bet_type)));
				}
			}
			
			_model.putValue("Settle_amount",settle_amount );
			
			
			utilFun.Log("clean zone=" + clean);
			utilFun.Log("angel_frame  =  " + angel_frame +"  "+" evel_frame  =  " + evel_frame);				
			utilFun.Log("angel_winstate  =  " + angel_winstate +"  "+" evel_winstate  =  " + evel_winstate);				
			
			//history recode 
			var arr:Array = _model.getValue("history_win_list");
			if ( angel_winstate == 1) arr.push(ResName.angelball);
			else if ( evel_winstate == 1) arr.push(ResName.evilball);
			else arr.push(ResName.Noneball);
			
			if ( arr.length > 60) arr.shift();			
			_model.putValue("history_win_list",arr);
			
			_model.putValue(modelName.SETTLE_AMOUNT, total_settle_amount);
			
			
			
			//caulate point frame
			Get("zone").container.visible = true;
			GetSingleItem("zone",0 ).visible = true;
			GetSingleItem("zone", 1 ).visible = true;
			
			if ( angel_frame == 1) GetSingleItem("zone", 1).gotoAndStop(angel_frame);
			else  if ( angel_frame == 5)
			{
				GetSingleItem("zone", 1).gotoAndStop(angel_frame);
				GetSingleItem("zone", 1)["_wing"].rotationY = -180;				
			}
			else  if ( angel_frame == 4)
			{
			//	var apoint:int = ca_point(modelName.PLAYER_POKER);
				GetSingleItem("zone", 1).gotoAndStop(angel_frame);
				//GetSingleItem("zone", 1)["_point"].gotoAndStop(apoint);
			}
			else if ( angel_frame == 3)
			{
					//var apoint:int = ca_point(modelName.PLAYER_POKER);
					//utilFun.Log("apoint  =  " + apoint); 
					//check 沒點 切無懶
					//if ( apoint != -1) 
					{ 						
						GetSingleItem("zone", 1).gotoAndStop(angel_frame);		
						//if (apoint !=0) GetSingleItem("zone", 1)["_point"].gotoAndStop(apoint);
					}
					//else 
					{
					    //有妞但輸,會傳lost,frame 先切3 check 後還是輸,先切到無懶
						angel_frame = 1;
						GetSingleItem("zone", 1).gotoAndStop(angel_frame);		
					}
					
			}
			Tweener.addTween(GetSingleItem("zone", 1), { time:1.5, onCompleteParams:[GetSingleItem("zone", 1),angel_winstate],onComplete:fanout } );
		
			if ( evel_frame == 1) GetSingleItem("zone", 0).gotoAndStop(evel_frame);
			else  if ( evel_frame == 5)
			{
				GetSingleItem("zone", 0).gotoAndStop(evel_frame);
				GetSingleItem("zone", 0)["_wing"].rotationY = -180;					
				//_tool.SetControlMc(GetSingleItem("zone", 0)["_wing"]);
			//add(_tool);
			}
			else  if ( evel_frame == 4)
			{
				//var epoint:int = ca_point(modelName.BANKER_POKER);
				GetSingleItem("zone", 0).gotoAndStop(evel_frame);
			//	GetSingleItem("zone", 0)["_point"].gotoAndStop(epoint);
			}
			else if ( evel_frame == 3)
			{
				//var epoint:int = ca_point(modelName.BANKER_POKER);
				//utilFun.Log(" epoint  =  " + epoint);		
			//if ( epoint != -1)
				{
					GetSingleItem("zone", 0).gotoAndStop(evel_frame);
					//if ( epoint != 0 )  GetSingleItem("zone", 0)["_point"].gotoAndStop(epoint);					
				}
				//else
				{
					evel_frame = 1;
					GetSingleItem("zone", 0).gotoAndStop(evel_frame);
				}
				
			}
			
			Tweener.addTween(GetSingleItem("zone", 0), { time:1.5, onCompleteParams:[GetSingleItem("zone", 0), evel_winstate], onComplete:fanout } );
			
			
			utilFun.Log("clean zone=" + clean);
			_model.putValue("clean_coin_num", clean.length);
			_model.putValue("clean_coin_Count", 0);
			_model.putValue("CleanZone", clean);
			
			if( _betCommand.get_my_betlist().length !=0)
			{
				_regular.Call(Get("coinstakeZone").container, { onComplete:this.start_settle }, 1, 2);
				_paytable.win_frame_hint(winst);
			}
			
			//poker hisotry
			//var arr:Array = _model.getValue("history_Play_Pai_list");				
			//var arr2:Array = _model.getValue("history_banker_Pai_list");				
			//
			//var playerpoker:Array = _model.getValue(modelName.PLAYER_POKER);			
			//var cobi:Array = playerpoker.concat(arr);
			//if ( cobi.length > 30)  cobi = cobi.slice(0, 30);
			//
			//var bankerpoker:Array = _model.getValue(modelName.BANKER_POKER);
			//var cobi2:Array = bankerpoker.concat(arr2);	
			//if ( cobi2.length > 30) cobi2 = cobi2.slice(0, 30);
			//
			//_model.putValue("history_Play_Pai_list", cobi);
			//_model.putValue("history_banker_Pai_list", cobi2);
			
			//simu click item 
			//_paytable.history_sence(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false), 0);
			
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
		
		//[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function new_round_result():void
		{			
			var result_list:Array = _model.getValue(modelName.ROUND_RESULT);
			var num:int = result_list.length;
			
			//var result:Array = [];
			var clean:Array = [];
			var total_settle_amount:int = 0;
			var name_to_idx:DI = _model.getValue("Bet_name_to_idx");
			for ( var i:int = 0; i < num; i++)
			{
				var resultob:Object = result_list[i];
				
				var result:Array  = [];
				utilFun.Log("result  =  " + name_to_idx.getValue(resultob.bet_type));	
				result.push(name_to_idx.getValue(resultob.bet_type));			
				
				//frame
				if ( resultob.win_state == "WSLost") result.push(1);
				if ( resultob.win_state == "WSWin") result.push(2);
				if ( resultob.win_state == "WSPANormalWin") result.push(2);
				if ( resultob.win_state == "WSPATwoPointWin") result.push(3);
				if ( resultob.win_state == "WSPAOnePointWin") result.push(3);
				if ( resultob.win_state == "WSPAFourOfAKindWin") result.push(4);
				if ( resultob.win_state == "WSPAFiveWawaWin") result.push(4);
				
				
				total_settle_amount += resultob.settle_amount;
				
				var zone:int = parseInt( result[0]);
				var winstate:int = parseInt(result[1]);
				
				utilFun.Log("resultob  =  " + resultob.bet_type +" win_state  =  " + resultob.win_state);	
				utilFun.Log("result  =  " + result);				
				if ( winstate == 1)
				{
					clean.push(zone);
				}			
				
				//coin show or disapear
				if ( winstate != 1) _regular.Twinkle(GetSingleItem("betzone", zone), 3, 10, 2);	
				else utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone", zone));
				
				if ( zone == 0 || zone == 1)
				{					
					Get("zone").container.visible = true;
					GetSingleItem("zone",zone ).visible = true;
					
					var mypoker:Array = [];
					if ( zone == 0 ) mypoker = _model.getValue(modelName.BANKER_POKER);							
					else  mypoker = _model.getValue(modelName.PLAYER_POKER);				
					
					var total:Array = [0, 1, 2, 3, 4]; 					
					var newpoker:Array = pokerUtil.newnew_judge(mypoker, total);
					var selectCard:Array = newpoker.slice(0, 3);
					var rest:Array = utilFun.Get_restItem(total, selectCard);
					//utilFun.Log("selectCard =" + selectCard);
					var point:int = 0;
					if ( selectCard.length == 0) GetSingleItem("zone", zone).gotoAndStop(1);	
					else
					{
						//utilFun.Log("rest =" + rest);
						var pointar:Array  = pokerUtil.get_Point( [mypoker[ rest[0]], mypoker[rest[1]]] );
						point = pokerUtil.Get_Mapping_Value([0, 1], pointar);
						
						if ( selectCard.length != 3 && winstate == 1)  GetSingleItem("zone", zone).gotoAndStop(1);					
						//1.無懶, 2.XX win 3. XX N po 4.perf						
						point %= 10;
						//N point win then who win
						GetSingleItem("zone", zone).gotoAndStop(3);				
						GetSingleItem("zone", zone)["_point"].gotoAndStop(point);
							
							
						Tweener.addTween(GetSingleItem("zone", zone), { time:1.5, onCompleteParams:[GetSingleItem("zone", zone),winstate],onComplete:fanout } );
					}
				}
				
				_model.putValue(modelName.SETTLE_AMOUNT,total_settle_amount);	
			}
			
			utilFun.Log("clean zone=" + clean);
			for ( i = 0; i < clean.length ; i++)
			{
				utilFun.Clear_ItemChildren(GetSingleItem("coinstakeZone", clean[i]));
			}
		}
		
		public function fanout(hint:MovieClip,winstate:int):void
		{			
			if ( winstate ) hint.gotoAndStop(2);
		}
	
	}
	
	

}