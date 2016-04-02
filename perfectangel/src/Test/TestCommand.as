package Test 
{
	import flash.events.Event;
	import Model.*;
	import Model.valueObject.Intobject;
	
	import util.*;
	import View.GameView.*;
	/**
	 * test event
	 * @author hhg4092
	 */
	public class TestCommand 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _model:Model;
		
		
		public function TestCommand() 
		{
			
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject",selector="Test_command")]
		public function Test_Command(testCommand:Intobject):void		
		{
			
			if ( testCommand.Value == 0)
			{
				dispatcher(new ModelEvent("clearn"));
				dispatcher(new ModelEvent("display"));
			}
				
			
		}
	}

}