package View.GameView
{	
	import Command.BetCommand;
	import Command.DataOperation;
	import Command.RegularSetting;
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Multitouch;
	import Model.ModelEvent;
	import Model.valueObject.ArrayObject;
	import Model.valueObject.Intobject;
	import Model.valueObject.StringObject;
	import Res.ResName;
	import util.DI;
	import View.ViewBase.ViewBase;
	import Model.modelName;
	import Command.ViewCommand;		
	import View.ViewBase.VisualHandler;
	import View.ViewComponent.Visual_BtnHandle;
	import View.ViewComponent.Visual_Coin;
	import View.ViewComponent.Visual_Loder;
	import View.ViewComponent.Visual_stream;
	import View.Viewutil.*;
	
	import caurina.transitions.Tweener;
	
	import util.utilFun;
	import util.pokerUtil;
	
	/**
	 * ...
	 * @author hhg
	 */

	 
	public class LoadingView extends ViewBase
	{		
		
		[Inject]
		public var _regular:RegularSetting;
		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _visual_coin:Visual_Coin;
		
		[Inject]
		public var _opration:DataOperation;
		
		[Inject]
		public var _visual_stream:Visual_stream;
		
		[Inject]
		public var _btn:Visual_BtnHandle;
		
		[Inject]
		public var _loader:Visual_Loder;
		
		public function LoadingView()  
		{
			
		}
		
			//result:Object
		public function FirstLoad(para:Array ):void
 		{			
			_model.putValue(modelName.LOGIN_INFO,  para[0]);
			_model.putValue(modelName.CREDIT, para[1]);
			_model.putValue(modelName.Client_ID, para[2]);
			_model.putValue(modelName.HandShake_chanel, para[3]);
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
			_tool = new AdjustTool();
			
			//_tool.SetControlMc(view.ItemList[0]["_lay_2"]);
			//addChild(_tool);
         
			_regular.strdotloop(view.ItemList[0]["_Text"], 20, 40);
			utilFun.SetTime(connet, 2);
			//utilFun.SetTime(stre, 2);
		//
		//_visual_stream.init();
		//_loader.init();
		//
		//_visual_stream._miss_id.push(_loader.getToken());		
		//dispatcher(new ArrayObject([_visual_stream._miss_id[0],"stream_setting.txt"], "binary_file_loading"));
		//
		}
		
		private function stre():void
		{
			dispatcher(new StringObject("spider_baccarat","stream_connect"));
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