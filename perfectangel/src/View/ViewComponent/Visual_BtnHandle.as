package View.ViewComponent 
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import View.GameView.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	/**
	 * btn handle present way
	 * @author ...
	 */
	public class Visual_BtnHandle  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		
		public function Visual_BtnHandle() 
		{
			
		}
		
		public function test_reaction(e:Event, idx:int):Boolean
		{
			return true;
		}
		
		public function cycle_reaction(e:Event, idx:int):Boolean
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.gotoAndStop( utilFun.cycleFrame(mc.currentFrame,mc.totalFrames) )	
			return false;
		}
		
		public function Game_iconhandle(e:Event, idx:int):Boolean
		{			
			if ( e.currentTarget.currentFrame == 3 || e.currentTarget.currentFrame == 4) return false;
			else
			{
				e.currentTarget.gotoAndStop(2);
			}
			return true;
		}
		
		public function Game_iconclick_down(e:Event, idx:int):Boolean
		{
			if ( e.currentTarget.currentFrame == 3 || e.currentTarget.currentFrame == 4) return false;
			else
			{
				//dispatcher(new Intobject(idx, "Load_flash") );				
				//e.currentTarget.gotoAndStop(2);
				//loading game
				e.currentTarget.y += 10;
			}
			return true;
		}
		
		public function Game_iconclick_up(e:Event, idx:int):Boolean
		{
			if ( e.currentTarget.currentFrame == 3 || e.currentTarget.currentFrame == 4) return false;
			else
			{
				//loading game
				e.currentTarget.y -= 10;
			}
			return true;
		}
		
		
		public function BtnHint(e:Event, idx:int):Boolean
		{
			e.currentTarget.gotoAndStop(2);
			e.currentTarget["_hintText"].gotoAndStop(idx+1);
			return true;
		}
		
		public function gonewpage(e:Event, idx:int):Boolean
		{
			var request:URLRequest = new URLRequest("https://www.google.com.tw/");			
			navigateToURL( request, "_blank" );
			return true;
		}
			
	}

}