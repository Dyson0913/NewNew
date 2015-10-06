package View.ViewComponent 
{
	import asunit.runner.TestSuiteLoader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.*;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import flash.events.MouseEvent;
	import com.adobe.serialization.json.JSON;
	import flash.net.URLLoaderDataFormat;
	
	
	/**
	 * loader file
	 * URLLoader  for binary data or test or binary encode date
	 * Loader  for swf or image file only
	 * @author ...
	 */
	public class Visual_Loder  extends VisualHandler
	{
		[Inject]
		public var _betCommand:BetCommand;
		
		public function Visual_Loder() 
		{
			
		}
		
		public function init():void
		{
			_model.putValue("Loading_Serial",0);			
			_model.putValue("loader", new DI());			
			_model.putValue("loadermap", new DI());			
			
		}
		
		public function getToken():int
		{			
			return _opration.operator("Loading_Serial", DataOperation.add, 1);
		}
		
		[MessageHandler(type="Model.valueObject.ArrayObject",selector="binary_file_loading")]
		public function loading(token:ArrayObject):void
		{
			var serial:int = token.Value[0];
			var filename:String = token.Value[1];
			//create new loader processing		
			_model.getValue("loader").putValue(serial, new URLLoader());
			
			utilFun.Log("game = " + serial);
			utilFun.Log("filename = " + filename);
				
			startup(serial,filename);
			
		}
		
		private function startup(serial:int,filename:String):void 
		{
			var _loader:URLLoader =  _model.getValue("loader").getValue(serial.toString());
			
			utilFun.Log("startup = " + filename + " serial = " + serial);			
			
			//mapping for complete identify
			_model.getValue("loadermap").putValue(_loader, serial );
			
			
			_loader.addEventListener(Event.COMPLETE, loadend);
			_loader.addEventListener(ProgressEvent.PROGRESS, gameprogress);
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.load(new URLRequest(filename));
			
			//put back
			_model.getValue("loader").putValue(serial, _loader);
		}
		
		private function gameprogress(e:ProgressEvent):void 
		{
			// TODO update loader
			var serial:int = _model.getValue("loadermap").getValue(e.currentTarget );
			utilFun.Log("progress= " + serial);			
			var total:Number = Math.round( e.bytesTotal/ 1024);
			var loaded:Number = Math.round(e.bytesLoaded / 1024);
			//var percent:Number = Math.round(loaded / total * 100);
			//utilFun.Log("total = total" +total);
			//loadingPro._Progress.gotoAndStop(percent);
			//loadingPro._Progress._Percent._TextFild.text = percent.toString()+"%";
		}
		
		private function loadend(event:Event):void
		{			
			//TODO clean
			var serial:int = _model.getValue("loadermap").getValue(event.currentTarget );
			utilFun.Log("loadend = " + serial);
			var _loader:URLLoader =  _model.getValue("loader").getValue(serial.toString());			
			//
			//
			_loader.removeEventListener(Event.COMPLETE, loadend);
			_loader.removeEventListener(ProgressEvent.PROGRESS, gameprogress);
			
			var ba:ByteArray = ByteArray(URLLoader(event.target).data);
		    var utf8Str:String = ba.readMultiByte(ba.length, 'utf8');			
			//utilFun.Log("jsonarr = " +utf8Str);
			var jsonob:Object = JSON.decode(utf8Str); 
			
			//TODO loading ok
			//utilFun.Log("jsonarr = " + jsonob.online.stream_link);
			
			dispatcher(new ArrayObject([serial,jsonob], "urlLoader_complete"));
		}
	}

}