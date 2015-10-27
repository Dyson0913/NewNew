package View.GameView
{	
	import Command.BetCommand;
	import Command.DataOperation;
	import Command.RegularSetting;
	import Command.SoundCommand;
	import ConnectModule.websocket.WebSoketInternalMsg;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Multitouch;
	import Model.ModelEvent;
	import Model.valueObject.*;	
	import Res.ResName;
	import util.DI;
	import util.math.Path_Generator;
	import View.ViewBase.ViewBase;
	import Model.modelName;
	import Command.ViewCommand;		
	import View.ViewBase.VisualHandler;
	import View.ViewComponent.*;
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
		public var _visual_stream:Visual_stream;
		
		[Inject]
		public var _test:Visual_testInterface;		
		
		[Inject]
		public var _path:Path_Generator;
		
		[Inject]
		public var _sound:SoundCommand;
		
		public function LoadingView()  
		{
			
		}
					
		public function FirstLoad(para:Array ):void
 		{					
			
			//_model.putValue(modelName.LOGIN_INFO,  para[0]);
			_model.putValue(modelName.UUID,  para[0]);
			_model.putValue(modelName.CREDIT, para[1]);
			_model.putValue(modelName.Client_ID, para[2]);
			_model.putValue(modelName.HandShake_chanel, para[3]);
			_model.putValue(modelName.Domain_Name, para[4]);			
			
			
			_betCommand.bet_init();
			_path.init();
			_sound.init();
			
			_model.putValue(modelName.Game_Name, "PerfectAngel");
			
			
			_model.putValue("light_idx", 0);
			_model.putValue("last_ligt_ball_idx", 0);
			
			_model.putValue("history_win_list", []);		
			
			dispatcher(new Intobject(modelName.Loading, ViewCommand.SWITCH));			
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.Loading) return;
			super.EnterView(View);
			utilFun.Log("loading view enter");
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.emptymc], 0, 0, 1, 0, 0, "a_");
			_tool = new AdjustTool();
			
			//utilFun.SetTime(connet, 0.1);
			_test.init();
			
			//utilFun.SetTime(stre, 2);
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