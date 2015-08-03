package View.ViewComponent 
{
	import flash.display.Sprite;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	
	import flash.events.NetStatusEvent;
	import flash.events.AsyncErrorEvent;
	import flash.net.NetStream;
	import flash.net.NetConnection;
	import flash.media.Video;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	/**
	 * timer present way
	 * @author ...
	 */
	public class Visual_stream  extends VisualHandler
	{		
		public var netStreamObj:NetStream;
		public var nc:NetConnection;
		public var vid:Video;

		public var streamID:String;
		public var videoURL:String;
		public var metaListener:Object;

		public var intervalID:uint;
		public var counter:int;

		public var _miss_id:Array = [];
		
		public function Visual_stream() 
		{
		
		}
		
		public function init():void
		{
			_model.putValue("stream_Serial",0);
			_model.putValue("current_Serial",0);
			_model.putValue("stream_container", new DI());
			_model.putValue("stream_url", new DI());
			_model.putValue("stream_ID", new DI());
			_model.putValue("stream_name", new DI());			
			_model.putValue("size", new DI());
		}
		
		
		[MessageHandler(type="Model.valueObject.ArrayObject",selector="urlLoader_complete")]
		public function config_Setting(token:ArrayObject):void
		{
			if ( token.Value[0] == _miss_id[0])
			{
				var object:Object =  token.Value[1];
				var config:Array = object.development.stream_link;
				
				for ( var i:int = 0; i < config.length ; i++)
				{
					var idx:int = _model.getValue("stream_Serial");					
					_model.getValue("stream_url").putValue(idx, config[i].strem_url);
					_model.getValue("stream_ID").putValue(idx, config[i].channel_ID);
					//for mapping					
					_model.getValue("stream_name").putValue(config[i].stream_name,idx);
					_model.getValue("stream_container").putValue(idx,new Sprite());
					
					var ob:Object = { "width":config[i].size.itemwidth, "height":config[i].size.itemheight };					
					_model.getValue("size").putValue(idx, ob);
					_model.putValue("stream_Serial", idx +1);
				}
			}
			
			//nexi mission
			_miss_id.shift();			
		}
		
		
		[MessageHandler(type="Model.valueObject.StringObject",selector="stream_connect")]
		public function display(streamname:StringObject):void
		{
			var idx:int = _model.getValue("stream_name").getValue(streamname.Value);			
			var link:String = _model.getValue("stream_url").getValue(idx.toString());			
			_model.putValue("current_Serial", idx);			
			
			vid = new Video(); 
            vid.width = 320;
			vid.height = 460;
            nc = new NetConnection();
			nc.client = {onBWDone:onNetConnectionBWDone}; 
			
            nc.addEventListener(NetStatusEvent.NET_STATUS, onConnectionStatus);
            nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
            nc.connect(link);          
			
			
			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "stream_disconnect")]
		public function disconnect():void
		{				
			netStreamObj.close();			
			clearInterval(intervalID);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "stream_play")]
		public function play():void
		{						
			netStreamObj.resume();			
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "stream_pause")]
		public function pause():void
		{				
			netStreamObj.pause();			
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
				
				var idx:int = _model.getValue("current_Serial");
				utilFun.Log("idx = " + idx);
				
				var ID:String =  _model.getValue("stream_ID").getValue(idx.toString());
				utilFun.Log("ID = " + ID);
				
                netStreamObj.play(ID);
                vid.attachNetStream(netStreamObj);
				
				var sp:Sprite = _model.getValue("stream_container").getValue(idx.toString());
				sp.addChild(vid);
				add(sp);				
                intervalID = setInterval(playback, 1000);
				
            }
			else
			{
				//TODO error handle
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
			//var _stageW:int = stage.stageWidth;
			//var _stageH:int = stage.stageHeight;
			//var _aspectH:int;
			//var _videoW:int;
			//var _videoH:int;
//
			//var relationship:Number;
			//relationship = data.height / data.width;
//
			//Aspect ratio calculated here..
			//_videoW = _stageW;
			//_videoH = _videoW * relationship;
			//_aspectH = (_stageH - _videoH) / 2;

			vid.x = 0;
			vid.y = 100; //_aspectH;
			vid.width = 320;  //_videoW;
			vid.height = 240; //_videoH;
		}

		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function timer_hide():void
		{			
			Get(modelName.REMAIN_TIME).container.visible = false;
		}
		
		
	}

}