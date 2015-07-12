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
			view.Create_by_list(1, [ResName.Loading_Scene], 0, 0, 1, 0, 0, "a_");
			
			//prepare("_view", utilFun.GetClassByString(ResName.Loading_Scene) , this);
			
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
			
			utilFun.SetTime(connet, 2);
			
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