package View.GameView
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import Model.valueObject.Intobject;
	import util.DI;
	import View.ViewBase.ViewBase;
	import View.Viewutil.MultiObject;	
	import View.Viewutil.MouseBehavior;;
	import Model.modelName;
	import util.utilFun;
	
	/**
	 * ...
	 * @author hhg
	 */
	public class HudView extends ViewBase
	{
		
		public function HudView()  
		{
			utilFun.Log("HudView");
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.Hud) return;
			
			var back_btn:MultiObject = prepare("back_to_lobby", new MultiObject() , this);
			back_btn.Create_by_list(1, ["Back_to_lobby"], 0, 0, 1, 0, 0, "a");
			back_btn.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);
			back_btn.mousedown = LeaveGame;
			back_btn.container.x = 1840;
			
	
			// 1ob ,inside ob
			//var back_game:SingleObject  = prepare("back_game", new SingleObject());
			//back_game.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);
			//back_game.Create(hint["_back"]);
			//back_game.mousedown = backGame;
			//
			//var back_Leave:SingleObject  = prepare("back_Leave", new SingleObject());
			//back_Leave.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);
			//back_Leave.Create(hint["_leave"]);
			//back_Leave.mousedown = backLobby;
			
			
			//addChild(_tool);
		}
		
		private function LeaveGame(e:Event):Boolean 
		{
			Get("leavehint").visible = true;
			return true;
		}
		
		private function backGame(e:Event):Boolean 
		{
			Get("leavehint").visible = false;
			return true;
		}
		
		private function backLobby(e:Event):Boolean 
		{
			
			return true;
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Hud) return;
		}
		
		
	}

}