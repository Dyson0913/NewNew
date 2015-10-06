package View.Viewutil 
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Timer;
	import Interface.ViewComponentInterface;
	import View.Viewutil.AdjustTool;
	
	import View.ViewBase.*;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import Command.*;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import flash.events.MouseEvent;
	
	/**
	 * Visual_text present way
	 * @author Dyson0913
	 */
	public class Visual_debugTool extends VisualHandler
	{		
		private var  _list:Array = [];
		
		[Inject]
		public var _text:Visual_Text;
		
		public var s_tool:AdjustTool;
		
		public var _select_idx:int = 0;		
		
		private  var debug_list:MultiObject;
		
		private var _childList:Sprite;
		
		public function Visual_debugTool() 
		{
			
		}
		
		public function init():void
		{
			//_list = new MultiObject();
			//_tool.setContainer(this);
			s_tool = new AdjustTool();
			_childList = new Sprite();
		}
		
		[MessageHandler(type="Model.valueObject.ArrayObject",selector="debug_item")]		
		public function lsit(debugitem:ArrayObject):void
		{			
			var item:ViewComponentInterface = debugitem.Value[0];
			utilFun.Log("putin no "+item.getName());
			
			//"View.ViewComponent.FinancialGraph"
			_list.push(item);
			
		}
		
		[MessageHandler(type = "View.Viewutil.TestEvent", selector = "debug_start")]
		public function create_tool():void
		{
			utilFun.Log("create_tool " +_list.length);
			var n:int = _list.length;
			var name:Array = [];
			var po:Array = [];
			for ( var i:int = 0; i < n; i++)
			{
				name.push(_list[i].getName());
				po.push(50);
			}
			var font:Array = [{size:24}];
			font = font.concat(name);
			debug_list= create("debug", [ResName.TextInfo]);
			debug_list.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 1, 0]);
			debug_list.mousedown = test_reaction;			
			debug_list.CustomizedFun = _text.textSetting;
			debug_list.CustomizedData = font;	
			debug_list.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;	
			debug_list.Post_CustomizedData = [name.length,50,25];				
			debug_list.Create_(name.length,"debugItem");
			debug_list.container.x = 372;
			debug_list.container.y = 90;
			
			_childList.x = debug_list.container.x;
			_childList.y = debug_list.container.y;
			
			add(_childList);
			
		}		
		
		public function test_reaction(e:Event, idx:int):Boolean
		{
			for ( var i:int = 0; i < _list.length; i++)
			{
				var myitem:MultiObject = _list[i];
				if ( idx == i) continue;
				else
				{
					var cleaniteam:MultiObject = create("debug_" + myitem.getName(), [ResName.TextInfo]);	
					cleaniteam.CleanList();
				}
			}
			
			_select_idx = idx;
			var item:MultiObject = _list[idx];			
			var name:Array = [];
			for ( var k:int = 0; k < item.ItemList.length; k++)
			{
				name.push(item.ItemList[k].name);				
			}
			var font:Array = [{size:24}];
			font = font.concat(name);
			
			
			var game_info_data:MultiObject = create("debug_" + item.getName(), [ResName.TextInfo],_childList);			
			game_info_data.MouseFrame = utilFun.Frametype(MouseBehavior.Customized, [0, 0, 1, 0]);
			game_info_data.mousedown = child_reaction;
			game_info_data.CustomizedFun = _text.textSetting;
			game_info_data.CustomizedData = font;	
			game_info_data.Posi_CustzmiedFun = _regular.Posi_Colum_first_Setting;	
			game_info_data.Post_CustomizedData = [10,50,50];				
			game_info_data.Create_( item.ItemList.length,"debugItem");
			game_info_data.container.x = debug_list.container.x + 100;			
			
			s_tool.SetControlMc(item.container);
			add(s_tool);
			
			var sRect:Rectangle = new Rectangle(0,0,1920,1080);
			var sp:Sprite = debug_list.container as Sprite;
			sp.startDrag(false, sRect);
			sp.addEventListener(MouseEvent.MOUSE_MOVE, ScrollDrag);
			sp.addEventListener(MouseEvent.MOUSE_UP, ScrollDrag);
					
			return true;
		}
	
		private function ScrollDrag(e:Event):void
		{
			utilFun.Log("e =" + e.currentTarget.name);
			switch (e.type)
			{				
				case "mouseUp":
					var sp:Sprite = debug_list.container as Sprite;
					
					sp.stopDrag();
					sp.removeEventListener(MouseEvent.MOUSE_MOVE, ScrollDrag);
					sp.removeEventListener(MouseEvent.MOUSE_UP, ScrollDrag);
				break;
			}
		}
		
		public function child_reaction(e:Event, idx:int):Boolean
		{
			var item:MultiObject = _list[_select_idx];
			item.ItemList[idx];			
			s_tool.SetControlMc(item.ItemList[idx]);
			add(s_tool);
			return true;
		}
		
	}

}