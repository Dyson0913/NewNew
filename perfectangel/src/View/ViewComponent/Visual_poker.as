package View.ViewComponent 
{
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	
	/**
	 * poker present way
	 * @author ...
	 */
	public class Visual_poker  extends VisualHandler
	{
		
		public function Visual_poker() 
		{
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean_poker():void
		{
			if ( Get(modelName.PLAYER_POKER) != null) Get(modelName.PLAYER_POKER).CleanList();
			if ( Get(modelName.BANKER_POKER) != null) Get(modelName.BANKER_POKER).CleanList();
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="pokerupdate")]
		public function playerpokerupdate(type:Intobject):void
		{
			var Mypoker:Array =   _model.getValue(type.Value);
			var pokerlist:MultiObject = Get(type.Value)
			pokerlist.CleanList();
			pokerlist.CustomizedFun = pokerUtil.showPoker;
			pokerlist.CustomizedData = Mypoker;
			pokerlist.Create_by_list(Mypoker.length, [ResName.Poker], 0 , 0, Mypoker.length, 163, 123, "Bet_");
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function round_effect():void
		{
			var playerpoker:Array =   _model.getValue(modelName.PLAYER_POKER);
			var best3:Array = pokerUtil.newnew_judge( playerpoker);
			utilFun.Log("best 3 = "+best3);
			var pokerlist:MultiObject = Get(modelName.PLAYER_POKER)
			pokerUtil.poer_shift(pokerlist.ItemList.concat(), best3);
			
			var banker:Array =   _model.getValue(modelName.BANKER_POKER);
			var best2:Array = pokerUtil.newnew_judge( banker);
			var bpokerlist:MultiObject = Get(modelName.BANKER_POKER)
			pokerUtil.poer_shift(bpokerlist.ItemList.concat(), best2);
		}
	}

}