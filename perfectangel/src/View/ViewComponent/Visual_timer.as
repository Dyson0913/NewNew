package View.ViewComponent 
{
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * poker present way
	 * @author ...
	 */
	public class Visual_timer  extends VisualHandler
	{
		
		[Inject]
		public var _opration:DataOperation;
		
		public function Visual_timer() 
		{
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			Get(modelName.REMAIN_TIME).container.visible = true;
			var time:int = _model.getValue(modelName.REMAIN_TIME);
			utilFun.SetText(GetSingleItem(modelName.REMAIN_TIME)["_Text"], utilFun.Format(time, 2));
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
			
			utilFun.SetText(GetSingleItem(modelName.REMAIN_TIME)["_Text"], utilFun.Format(time, 2));			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function timer_hide():void
		{			
			Get(modelName.REMAIN_TIME).container.visible = false;
		}
		
		
	}

}