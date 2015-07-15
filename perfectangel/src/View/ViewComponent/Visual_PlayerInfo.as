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
	 * playerinfo present way
	 * @author ...
	 */
	public class Visual_PlayerInfo  extends VisualHandler
	{
		
		public function Visual_PlayerInfo() 
		{
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "updateCredit")]
		public function updateCredit():void
		{				
			
			utilFun.SetText(GetSingleItem(modelName.CREDIT)["credit"], _model.getValue("after_bet_credit").toString());
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "update_result_Credit")]
		public function update_result_Credit():void
		{	
			
			utilFun.SetText(GetSingleItem(modelName.CREDIT)["credit"], _model.getValue(modelName.CREDIT).toString());
		}
		
	}

}