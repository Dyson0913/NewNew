package View.ViewBase
{
	import Command.BetCommand;
	import Command.DataOperation;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import Model.Model;
	import Model.valueObject.Intobject;
	import util.DI;
	import util.utilFun;	
	import View.Viewutil.AdjustTool;
	import Interface.ViewComponentInterface;
	import Command.ViewCommand;
	
	/**
	 * ...
	 * @author hhg
	 */
	
	
	//[ProcessSuperclass][ProcessInterfaces]
	public class ViewBase extends Sprite
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _model:Model;
		
		[Inject]
		public var _opration:DataOperation;
		
		[Inject]
		public var _viewcom:ViewCommand;
		
		public var _tool:AdjustTool;
		
		public function ViewBase() 
		{
		
		}
		
		public function EnterView (View:Intobject):void
		{
			
		}
		
		
		public function ExitView(View:Intobject):void
		{			
			
		}
		
		protected function Get(name:*):*
		{
			return _viewcom.currentViewDI.getValue(name);
		}
		
		protected function GetSingleItem(name:*,idx:int = 0):*
		{
			var ob:* = _viewcom.currentViewDI .getValue(name);
			return ob.ItemList[idx];
		}
		
		protected function prepare(name:*, ob:ViewComponentInterface, container:DisplayObjectContainer = null):*
		{
			ob.setContainer(new Sprite());
			return utilFun.prepare(name,ob , _viewcom.currentViewDI , container);
		}
		
	}

}