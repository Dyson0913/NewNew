package View.ViewComponent 
{
	import flash.display.MovieClip;
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
		public var _regular:RegularSetting;
		
		public function Visual_Settle() 
		{
			
		}
		
		public function init():void
		{
			var zone:MultiObject = prepare("zone", new MultiObject() , GetSingleItem("_view").parent.parent);
			zone.container.visible = false;
			zone.container.x = 1390;
			zone.container.y = 410;			
			zone.Create_by_list(2, [ResName.state_evil, ResName.state_angel], 0 , 0, 2, -844, 0, "Bet_");		
			
			//_tool.SetControlMc(zone.container);
			//_tool.SetControlMc(zone.ItemList[1]);
			//add(_tool);
			//Clean();
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean():void
		{
			Get("zone").container.visible = false;
			GetSingleItem("zone",0).visible = false;
			GetSingleItem("zone", 1).visible = false;
			
			var a:MultiObject = Get("zone");
			for ( var i:int = 0; i <  a.ItemList.length; i++)
			{
				GetSingleItem("zone", i).visible = false;
				GetSingleItem("zone", i).gotoAndStop(1);
			}
		}
		
		//[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		//public function round_result_data_process():void
		//{
			//var result_list:Array = _model.getValue(modelName.ROUND_RESULT);
			//var num:int = result_list.length;
			//
			//var result:Array = [];			
			//var name_to_idx:DI = _model.getValue("Bet_name_to_idx");
			//for ( var i:int = 0; i < num; i++)
			//{
				//var resultob:Object = result_list[i];				
				//var result:Array  = [];				
				//result.push(name_to_idx.getValue(resultob.bet_type));			
				//
				//frame
				//if ( resultob.win_state == "WSLost") result.push(1);
				//if ( resultob.win_state == "WSWin") result.push(2);
				//if ( resultob.win_state == "WSPANormalWin") result.push(2);
				//if ( resultob.win_state == "WSPATwoPointWin") result.push(3);
				//if ( resultob.win_state == "WSPAOnePointWin") result.push(3);
				//if ( resultob.win_state == "WSPAFourOfAKindWin") result.push(4);
				//if ( resultob.win_state == "WSPAFiveWawaWin") result.push(4);
				//
				//
				//total_settle_amount += resultob.settle_amount;
				//
				//utilFun.Log("resultob  =  " + resultob.bet_type +" win_state  =  " + resultob.win_state);	
				//utilFun.Log("result  =  " + result);				
				//
			//}
			//
			//_model.putValue(modelName.SETTLE_AMOUNT,total_settle_amount);
		//}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function new_round_result():void
		{			
			var result_list:Array = _model.getValue(modelName.ROUND_RESULT);
			var num:int = result_list.length;
			
			var result:Array = [];
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
		
		public function fanout(hint:MovieClip,winstate):void
		{			
			if ( winstate == 1) hint.visible = false;
			if ( winstate == 4) hint.gotoAndStop(4);
			if ( winstate ==2) hint.gotoAndStop(2);			
		}
	
	}
	
	

}