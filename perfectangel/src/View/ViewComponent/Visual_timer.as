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
	 * timer present way
	 * @author ...
	 */
	public class Visual_timer  extends VisualHandler
	{
		
		[Inject]
		public var _opration:DataOperation;
		
		public function Visual_timer() 
		{
			
		}
		
		public function init():void
		{
			var countDown:MultiObject = prepare(modelName.REMAIN_TIME,new MultiObject()  , GetSingleItem("_view").parent.parent);
		   countDown.Create_by_list(1, [ResName.Timer], 0, 0, 1, 0, 0, "time_");
		   countDown.container.x = 1234;
		   countDown.container.y = 313;
		   countDown.container.visible = false;		
		   
		   	var timellight:MultiObject = prepare("timellight",new MultiObject()  , GetSingleItem("_view").parent.parent);
		   timellight.Create_by_list(1, ["time_light"], 0, 0, 1, 0, 0, "time_");
		   timellight.container.visible = false;
		   timellight.container.x = 1309;
		   timellight.container.y = 388;
		   
		   	//_tool.SetControlMc(playerzone.ItemList[0]);
			//_tool.SetControlMc(timellight.container);
			//_tool.y = 200;
			//add(_tool);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			Get(modelName.REMAIN_TIME).container.visible = true;
			Get("timellight").container.visible = true;
			var time:int = _model.getValue(modelName.REMAIN_TIME);			
    		var arr:Array = utilFun.arrFormat(time, 2);
			if ( arr[0] == 0 ) arr[0] = 10;
			if ( arr[1] == 0 ) arr[1] = 10;
			GetSingleItem(modelName.REMAIN_TIME)["_num0"].gotoAndStop(arr[0]);
			GetSingleItem(modelName.REMAIN_TIME)["_num1"].gotoAndStop(arr[1]);		
			Tweener.addCaller(this, { time:time , count: time, onUpdate:TimeCount , transition:"linear" } );
		}
		
		private function TimeCount():void
		{			
		var time:int  = _opration.operator(modelName.REMAIN_TIME, DataOperation.sub);
			if ( time < 0) 
			{
				GetSingleItem(modelName.REMAIN_TIME).visible = false;
				return;
			}
			
			var arr:Array = utilFun.arrFormat(time, 2);			
			if ( arr[0] == 0 ) arr[0] = 10;
			if ( arr[1] == 0 ) arr[1] = 10;		
			GetSingleItem(modelName.REMAIN_TIME)["_num0"].gotoAndStop(arr[0]);
			GetSingleItem(modelName.REMAIN_TIME)["_num1"].gotoAndStop(arr[1]);	
			
			var mc:MovieClip = GetSingleItem("timellight");
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
			Get("timellight").container.visible = false;
		}
		
		
	}

}