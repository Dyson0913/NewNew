package View.ViewComponent 
{	
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;	
	import caurina.transitions.Tweener;
	import View.GameView.gameState;
	
	/**
	 * betzone present way
	 * @author Dyson0913
	 */
	public class Visual_betZone  extends VisualHandler
	{
		public const bet_tableitem:String = "bet_table_item";
		
		private var _betzone:MultiObject;
		
		public function Visual_betZone() 
		{
			
		}
		
		public function init():void
		{			
			var tableitem:MultiObject = create("tableitem",[bet_tableitem]);			
			tableitem.container.x = 193;
			tableitem.container.y = 655;
			tableitem.Create_(1, "tableitem");
			
			var zone_xy:Array = _model.getValue(modelName.AVALIBLE_ZONE_XY);
			
			var avaliblezone:Array = _model.getValue(modelName.AVALIBLE_ZONE);			
			_betzone = create("betzone", avaliblezone);
			_betzone.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			_betzone.Post_CustomizedData = zone_xy;
			_betzone.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[1,2,2,0]);			
			_betzone.Create_(avaliblezone.length, "betzone");
			_betzone.container.x = 1081;
			_betzone.container.y = 657;
			
			put_to_lsit(_betzone);
			
			state_parse([gameState.NEW_ROUND,gameState.START_BET]);
		}		
		
		override public function appear():void
		{	
			Get("tableitem").container.visible = true;
			
			var state:int = _model.getValue(modelName.GAMES_STATE);			
			if ( state  == gameState.NEW_ROUND) return;
			
			_betzone.mousedown = empty_reaction;					
			_betzone.rollout = empty_reaction;
			_betzone.rollover = empty_reaction;
			
		}
		
		override public function disappear():void
		{
			Get("tableitem").container.visible = false;
			
			_betzone.mousedown = null;
			_betzone.rollout = null;			
			_betzone.rollover = null;			
			
			setFrame("betzone", 1);
		}		
		
	}

}