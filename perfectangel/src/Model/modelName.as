package Model 
{
	/**
	 * variable in game
	 * @author hhg
	 */
	public class modelName 
	{
		static public var Num:int = 0;
		
		public static const LOGIN_INFO:int = Num++;
		public static const CREDIT:int = Num++;
		public static const NICKNAME:int = Num++;
		public static const UUID:int = Num++;
		
		public static const HINT_MSG:int = Num++;
		public static const REMAIN_TIME:int = Num++;
		public static const GAMES_STATE:int = Num++;
		public static const SPLIT_SYMBOL:int = Num++;
		
		public static const PLAYER_POKER:int = Num++;
		public static const BANKER_POKER:int = Num++;		
		
		public static const BET_AMOUNT:int = Num++;
		public static const SETTLE_AMOUNT:int = Num++;
		public static const ROUND_RESULT:int = Num++;
		
		
		//view
		public static const Loading:int  = Num++;		
		public static const Bet:int  = Num++;		
		public static const Hud:int  = Num++;
		
		public function modelName() 
		{
			
		}
		
	}

}