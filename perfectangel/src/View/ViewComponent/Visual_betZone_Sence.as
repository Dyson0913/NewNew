package View.ViewComponent 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * betzone present way
	 * @author ...
	 */
	public class Visual_betZone_Sence  extends VisualHandler
	{
		[Inject]
		public var _regular:RegularSetting;
		
		[Inject]
		public var _betCommand:BetCommand;	
		
		public function Visual_betZone_Sence() 
		{
			
		}
		
		public function init():void
		{
			
			//感應區
			var avaliblezone_s:Array = _model.getValue(modelName.AVALIBLE_ZONE_SENCE);
			
			var playerzone_s:MultiObject = prepare("betzone_s", new MultiObject() , GetSingleItem("_view").parent.parent);
			playerzone_s.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,2,1]);
			playerzone_s.container.x = 134;
			playerzone_s.container.y = 580;
			playerzone_s.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			playerzone_s.Post_CustomizedData = [ [828, 0], [0, 0],  [1057, 60], [308, 59], [907, 101], [504, 101]];
			playerzone_s.Create_by_list(avaliblezone_s.length, avaliblezone_s, 0, 0, avaliblezone_s.length, 0, 0, "bet_sence");		
			
			
			//_tool.SetControlMc(coinob.ItemList[0]);
			//_tool.SetControlMc(coinob.container);
			//add(_tool);
		}		
		
		[MessageHandler(type = "Model.ModelEvent", selector = "display")]
		public function display():void
		{
			var betzone:MultiObject = Get("betzone_s");
			betzone.mousedown = bet_sencer;
			betzone.mouseup = bet_sencer_up;	
		}
		
		public function bet_sencer(e:Event,idx:int):Boolean
		{	
			if ( CONFIG::debug ) 
			{
				_betCommand.bet_local(e, idx);
			}		
			else
			{
				_betCommand.betTypeMain(e, idx);
			}
			
			var betzone:MultiObject = Get("betzone");			
			var mc:MovieClip = betzone.ItemList[idx];
			mc.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false));			
			
			return true;
		}
		
		public function bet_sencer_up(e:Event, idx:int):Boolean
		{
			var betzone:MultiObject = Get("betzone");			
			var mc:MovieClip = betzone.ItemList[idx];
			mc.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, true, false));			
			
			return true;
		}	
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function timer_hide():void
		{
			var betzone:MultiObject = Get("betzone_s");
			betzone.mousedown = null;
			betzone.mouseup = null;
		}
		
		
	}

}