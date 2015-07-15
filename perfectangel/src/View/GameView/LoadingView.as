package View.GameView
{	
	import Command.BetCommand;
	import Command.RegularSetting;
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
	import View.ViewComponent.Visual_Coin;
	import View.Viewutil.*;
	
	import caurina.transitions.Tweener;
	
	import util.utilFun;
	import util.pokerUtil;
	
	import flash.events.NetStatusEvent;
import flash.events.AsyncErrorEvent;
	import flash.net.NetStream;
import flash.net.NetConnection;
import flash.media.Video;
import flash.utils.setInterval;
	
	/**
	 * ...
	 * @author hhg
	 */

	 
	public class LoadingView extends ViewBase
	{
		private var _result:Object;
		
		public var netStreamObj:NetStream;
    public var nc:NetConnection;
    public var vid:Video;

    public var streamID:String;
    public var videoURL:String;
    public var metaListener:Object;

    public var intervalID:uint;
    public var counter:int;

		[Inject]
		public var _regular:RegularSetting;
		
		[Inject]
		public var _betCommand:BetCommand;
		
		[Inject]
		public var _visual_coin:Visual_Coin;
		
		
		public function LoadingView()  
		{
			
		}
		
			
		public function FirstLoad(result:Object):void
 		{
			_result = result;
			_model.putValue(modelName.LOGIN_INFO, _result);
			dispatcher(new Intobject(modelName.Loading, ViewCommand.SWITCH));			
		}
		
		[MessageHandler(type="Model.valueObject.Intobject",selector="EnterView")]
		override public function EnterView (View:Intobject):void
		{
			if (View.Value != modelName.Loading) return;
			super.EnterView(View);
			utilFun.Log("loading view enter");
			var view:MultiObject = prepare("_view", new MultiObject() , this);
			view.Create_by_list(1, [ResName.Bet_Scene], 0, 0, 1, 0, 0, "a_");
			_tool = new AdjustTool();
			
			_betCommand.bet_init();
			//coin
			var coinob:MultiObject = prepare("CoinOb", new MultiObject(), this);
			coinob.container.x = 708;
			coinob.container.y = 904;
			coinob.MouseFrame = utilFun.Frametype(MouseBehavior.Customized,[0,0,2,0]);
			coinob.CustomizedFun = _regular.FrameSetting;
			coinob.CustomizedData = [2, 1, 1, 1, 1];
			coinob.Posi_CustzmiedFun = _regular.Posi_y_Setting;
			coinob.Post_CustomizedData = [0,-20,-30,-20,0];
			coinob.Create_by_list(5,  [ResName.coin1,ResName.coin2,ResName.coin3,ResName.coin4,ResName.coin5], 0 , 0, 5, 100, 0, "Coin_");
			coinob.mousedown = _visual_coin.betSelect;
			
			//side bet		   	
			var sidebet:MultiObject = prepare("side_betzone", new MultiObject() , this);
			sidebet.container.x = 317;
			sidebet.container.y = 732;
			sidebet.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			sidebet.Post_CustomizedData = [ [0, 0],[1044,0],[244,-34],[808,-31]];
			sidebet.Create_by_list(4, [ResName.angel_small,ResName.evil_small,ResName.angel_per,ResName.evil_per], 0, 0, 4, 0, 0, "time_");
			sidebet.MouseFrame = utilFun.Frametype(MouseBehavior.ClickBtn);
			sidebet.mousedown = _betCommand.betTypeMain;			
			
			//side bet coint
			var side_coinstack:MultiObject = prepare("side_coinstakeZone", new MultiObject(), sidebet.container);
			side_coinstack.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			side_coinstack.Post_CustomizedData = [ [0, 0],[0,0],[0,0],[0,0]];
			side_coinstack.Create_by_list(4, [ResName.emptymc], 0, 0, 4, 0, 0, "time_");
			//
			_tool.SetControlMc(side_coinstack.container);			
			//_tool.SetControlMc(sidebet.ItemList[3]);			
			addChild(_tool);						
			
			//rtsp://184.72.239.149/vod/mp4:BigBuckBunny_115k.mov
			// streamID  = "mp4:BigBuckBunny_115k.mov";
			 //streamID  = "GB";
            //videoURL = "rtmp://192.168.1.136/live/";
            //videoURL = "rtmp://184.72.239.149/vod";


		

            //vid = new Video(); //typo! was "vid = new video();"
            //vid.width = 320;
			//vid.height = ;
            //nc = new NetConnection();
			//nc.client = {onBWDone:onNetConnectionBWDone}; 
			//
            //nc.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
            //nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
            //nc.connect(videoURL);          
			
			//utilFun.SetTime(connet, 2);
			
		}
		
		public function onNetConnectionBWDone():void{}
		
		private function onConnectionStatus(e:NetStatusEvent):void
    {
		utilFun.Log("Creating NetStream ="+e.info.code);
		
            if (e.info.code == "NetConnection.Connect.Success")
            {
                utilFun.Log("Creating NetStream");
                netStreamObj = new NetStream(nc);

                metaListener = new Object();
                metaListener.onMetaData = received_Meta;
                netStreamObj.client = metaListener;

                netStreamObj.play(streamID);
                vid.attachNetStream(netStreamObj);
				var mc:MovieClip = Get("_view");
                mc.addChild(vid);
                intervalID = setInterval(playback, 1000);
            }
    }

    private function playback():void
    {
       utilFun.Log((++counter) + " Buffer length: " + netStreamObj.bufferLength);
    }

    public function asyncErrorHandler(event:AsyncErrorEvent):void
    { trace("asyncErrorHandler.." + "\r"); }

    public function onFCSubscribe(info:Object):void
    { trace("onFCSubscribe - succesful"); }

    public function onBWDone(...rest):void
    {
        var p_bw:Number;
        if (rest.length > 0)
          { p_bw = rest[0]; }
        utilFun.Log("bandwidth = " + p_bw + " Kbps.");
    }

	public function received_Meta (data:Object):void
    {
        var _stageW:int = stage.stageWidth;
        var _stageH:int = stage.stageHeight;
        var _aspectH:int;
        var _videoW:int;
        var _videoH:int;

        var relationship:Number;
        relationship = data.height / data.width;

        //Aspect ratio calculated here..
        _videoW = _stageW;
        _videoH = _videoW * relationship;
        _aspectH = (_stageH - _videoH) / 2;

        vid.x = 0;
        vid.y = _aspectH;
        vid.width = 320;  //_videoW;
        vid.height = 240; //_videoH;
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