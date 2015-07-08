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
			super.EnterView(View);
			utilFun.Log("loading view enter");
			
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.Loading_Scene], 0, 0, 1, 0, 0, "a_");
			
			//utilFun.Log("LoadingView enter currtn view lien currentViewDI= " + _viewcom.currentViewDI.length());
			//utilFun.Log("LoadingView enter currtn view lien _curViewDi = " + _viewcom._curViewDi.length());
			//utilFun.Log("LoadingView enter currtn view lien = "+_viewcom.nextViewDI.length());
			utilFun.SetTime(connet, 2);
			
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
			//utilFun.Log("LoadingView exit currtn view lien = " + _viewcom.currentViewDI.length());
			//utilFun.Log("LoadingView exit currtn view lien = " + _viewcom.nextViewDI.length());
			
			utilFun.Log("LoadingView ExitView");
		}
		
		
	}

}