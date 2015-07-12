package View.ViewBase
{
	import Command.BetCommand;
	import Model.Model;
	import Command.ViewCommand;
	
	/**
	 * handle display item how to presentation
	 * * @author hhg
	 */
	

	public class VisualHandler
	{
		[Inject]
		public var _model:Model;
		
		[Inject]
		public var _viewcom:ViewCommand;
		
		
		public function VisualHandler() 
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
		
	}

}