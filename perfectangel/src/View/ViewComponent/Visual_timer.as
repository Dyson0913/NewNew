package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * timer present way
	 * @author ...
	 */
	public class Visual_timer  extends VisualHandler
	{
		public var already_countDown:Boolean;
		public var Waring_sec:int;
		
		public function Visual_timer() 
		{
			
		}
		
		public function init():void
		{
			var countDown:MultiObject = prepare(modelName.REMAIN_TIME,new MultiObject()  , GetSingleItem("_view").parent.parent);
		   countDown.Create_by_list(1, [ResName.Timer], 0, 0, 1, 0, 0, "timer");
		   countDown.container.x = 1183;
		   countDown.container.y = 340;
		   countDown.container.visible = false;
		   
		   
		   	var timellight:MultiObject = prepare("timellight",new MultiObject()  , countDown.container);
		   timellight.Create_by_list(1, ["time_light"], 0, 0, 1, 0, 0, "time_");		   
		   timellight.container.x = 75;
		   timellight.container.y = 75;
		   
		   //TODO item test model put in here ?
		   //_model.putValue(modelName.REMAIN_TIME, 10);
		   	
		   	//_tool.SetControlMc(playerzone.ItemList[0]);
			//_tool.SetControlMc(countDown.container);
			//_tool.x = 100;
			//add(_tool);
			already_countDown = false;
			Waring_sec = 7;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{			
			Get(modelName.REMAIN_TIME).container.visible = true;			
			var time:int = _model.getValue(modelName.REMAIN_TIME);
			utilFun.SetText(GetSingleItem(modelName.REMAIN_TIME)["_Text"], utilFun.Format(time, 2) );
			
			if ( !already_countDown) 
			{
				already_countDown = true;
				Tweener.addCaller(this, { time:time , count: time, onUpdate:TimeCount , transition:"linear" } );
			}
		}
		
		private function TimeCount():void
		{			
			var time:int  = _opration.operator(modelName.REMAIN_TIME, DataOperation.sub, 1);
			
			if ( time <= 0) 
			{
				//may be the timer bug
				//GetSingleItem(modelName.REMAIN_TIME).visible = false;				
				//_regular.Call(Get(modelName.REMAIN_TIME).container, { onComplete:this.timer_hide }, 1, 1.5, 1, "linear")	
				//return;
			}
			
			var mc:MovieClip = GetSingleItem("timellight");
			if ( time == Waring_sec ) 
			{
				GetSingleItem(modelName.REMAIN_TIME)["_Text"].textColor = 0xFF0000;
				GetSingleItem(modelName.REMAIN_TIME).gotoAndStop(2);
				mc.gotoAndStop(2);
			}
			
			utilFun.SetText(GetSingleItem(modelName.REMAIN_TIME)["_Text"], utilFun.Format(time, 2) );			
			
			
			Tweener.addCaller(mc, { time:1 , count: 36, onUpdate:TimeLight , onUpdateParams:[mc, 10 ], transition:"linear" } );			
		}
		
		private function TimeLight(mc:MovieClip,angel:int):void
		{
		   mc.rotation += angel;
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function timer_hide():void
		{			
			Get(modelName.REMAIN_TIME).container.visible = false;
			
			GetSingleItem(modelName.REMAIN_TIME)["_Text"].textColor = 0x0099CC;
			GetSingleItem(modelName.REMAIN_TIME).gotoAndStop(1);
			GetSingleItem("timellight").gotoAndStop(1);
			
			already_countDown = false;
		}
		
		
	
		
	}

}