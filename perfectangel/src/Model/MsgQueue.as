package Model 
{	
	import util.utilFun;
	
	/**
	 * queue package msg
	 * @author hhg4092
	 */
	public class MsgQueue 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		private var _queueMsg:Array = [];
		
		private var _isqueueing:Boolean;
		
		//[MessageBinding(type="Model.valueObject.BoolObject",messageProperty="Value",selector="Msgqueue")]
		public function set Isqueueing(value:Boolean):void
		{
			_isqueueing = value;
			//utilFun.Log("set  " +_isqueueing);			
		}
		
		public function MsgQueue() 
		{			
			_isqueueing = false;			
		}
		
		public function push(msg:Object):void
		{
			_queueMsg.push(msg);			
			checkqueue();
			
		}
		
		public function getMsg():Object
		{
			var msg:Object = _queueMsg[0];			
			_queueMsg.shift();
			return msg;
		}
		
		private function checkqueue():void
		{
			//utilFun.Log("checkqueue" +_queueMsg.length);
			
			if ( _queueMsg.length != 0)
			{
				if (_isqueueing) 
				{
					utilFun.Log("is queing retu");
					return;
				}
				
				//utilFun.Log("before excusive lock");
				Isqueueing =  true;
				dispatcher(new ModelEvent("popmsg"));
				//utilFun.Log("after pop set false");
				Isqueueing =  false;
				
				utilFun.SetTime(checkqueue, 0.01);				
			}
			
		}
		
	}

}