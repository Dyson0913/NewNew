package View.ViewBase
{
	import Command.BetCommand;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import Model.Model;
	import Command.*;
	import Interface.ViewComponentInterface;
	import Model.valueObject.ArrayObject;
	import util.*;
	import Model.*;
	import View.Viewutil.AdjustTool;
	import View.Viewutil.MultiObject;
	import View.Viewutil.TestEvent;
	import View.Viewutil.Visual_debugTool;
	
	/**
	 * handle display item how to presentation
	 * * @author hhg
	 */
	

	public class VisualHandler
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _model:Model;
		
		[Inject]
		public var _viewcom:ViewCommand;
		
		[Inject]
		public var _regular:RegularSetting;
		
		[Inject]
		public var _opration:DataOperation;
		
		[Inject]
		public var _debugTool:Visual_debugTool;
		
		private var _miss_id:Array = [];
		
		public var _tool:AdjustTool;
		
		public function VisualHandler() 
		{
			_tool = new AdjustTool();
		}
		
		public function set_mission_id(id:int ):void
		{
			_miss_id.push(id);
		}
		
		public function mission_id( ):int
		{
			if ( _miss_id.length == 0) return -1;
			//TODO multi mission
			return _miss_id[0];
		}
		
		
		public function put_to_lsit(viewcompo:ViewComponentInterface):void
		{
			if ( CONFIG::release ) return;
			
			dispatcher(new ArrayObject([viewcompo], "debug_item"));			
		}
		
		public function debug():void
		{
			if ( CONFIG::release ) return;	
			
			dispatcher(new TestEvent("debug_start"));			
		}
		
		//only for same view clean item
		protected function Del(name:*):void
		{			
			_viewcom.currentViewDI.Del(name);
		}
		
		protected function Get(name:*):*
		{			
			return _viewcom.currentViewDI.getValue(name);
		}
		
		protected function GetSingleItem(name:*,idx:int = 0):*
		{
			if( _viewcom.currentViewDI .getValue(name) )
			{
				var ob:* = _viewcom.currentViewDI .getValue(name);
				return ob.ItemList[idx];
			}
			return null;
		}
		
		protected function changeBG(name:String):void
		{
			utilFun.Clear_ItemChildren(GetSingleItem("_view"));
			GetSingleItem("_view").addChild(utilFun.GetClassByString(name) );
		}
		
		protected function add(item:*):void
		{
			//item ->container ->view
			GetSingleItem("_view").parent.parent.addChild(item);
		}
		
		protected function removie(item:*):void
		{
			GetSingleItem("_view").parent.parent.removeChild(item);
		}
		
		protected function prepare(name:*, ob:ViewComponentInterface, container:DisplayObjectContainer = null):*
		{
			ob.setContainer(new Sprite());
			return utilFun.prepare(name,ob , _viewcom.currentViewDI , container);
		}
		
		//========================= better way		
		protected function create(name:*,resNameArr:Array, Stick_in_container:DisplayObjectContainer = null):*
		{
			if ( Stick_in_container == null) Stick_in_container = GetSingleItem("_view").parent.parent;
			var ob:MultiObject = new MultiObject();
			ob.resList = resNameArr;
			
			var sp:Sprite = new Sprite();
			sp.name  = name;
			ob.setContainer(sp);
			return utilFun.prepare(name,ob , _viewcom.currentViewDI , Stick_in_container);
		}		
	}

}