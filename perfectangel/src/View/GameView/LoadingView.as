package View.GameView
{	
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Multitouch;
	import Model.valueObject.Intobject;
	import Res.ResName;
	import View.ViewBase.ViewBase;
	import Model.modelName;
	import Command.ViewCommand;	
	import View.Viewutil.MultiObject;
	
	import caurina.transitions.Tweener;
	
	import util.utilFun;
	import util.pokerUtil;
	/**
	 * ...
	 * @author hhg
	 */

	 
	public class LoadingView extends ViewBase
	{			
		public function LoadingView()  
		{
			
		}
		
			
		public function FirstLoad():void
		{
			dispatcher(new Intobject(modelName.Loading, ViewCommand.SWITCH));			
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.Loading) return;
			utilFun.Log("loading view enter");
			prepare("_view",utilFun.GetClassByString(ResName.Loading_Scene) , this);
			utilFun.SetTime(connet, 2);
			//test();
			
			
		}
		
		public function test():void
		{
			prepare(modelName.PLAYER_POKER, new MultiObject());
			var playerpoker:Array =   ["3c", "7h", "kd", "3h", "1h"];
			
			var playerCon:MovieClip = prepare("playerpokerCon", new MovieClip() , this);
			playerCon.x = 480;
			playerCon.y = 240;
			prepare(modelName.PLAYER_POKER, new MultiObject());		
			pokerlist.CleanList();
			pokerlist.CustomizedFun = pokerUtil.showPoker;
			pokerlist.CustomizedData = playerpoker;
			pokerlist.Create_by_list(playerpoker.length,  [ResName.Poker], 0 , 0, playerpoker.length, 163, 123, "Bet_", Get("playerpokerCon"));
			
			
			var best3:Array = pokerUtil.newnew_judge( playerpoker);
			var pokerlist:MultiObject = Get(modelName.PLAYER_POKER)
			pokerUtil.poer_shift(pokerlist.ItemList, best3);
			
		}		
		
		private function connet():void
		{	
			dispatcher( new WebSoketInternalMsg(WebSoketInternalMsg.CONNECT));
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="LeaveView")]
		override public function ExitView(View:Intobject):void
		{
			if (View.Value != modelName.Loading) return;
			super.ExitView(View);
			utilFun.Log("LoadingView ExitView");
		}
		
		
	}

}