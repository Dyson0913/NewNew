package util 
{
	import caurina.transitions.Tweener;
	import flash.display.MovieClip;
	
	/**
	 * poker regular function
	 * @author hhg4092
	 */
	public class pokerUtil 
	{
		
		public function pokerUtil() 
		{
			
		}
		
		public static function pokerTrans_s(strpoker:String):int
		{			
			var point:String = strpoker.substr(0, 1);
			var color:String = strpoker.substr(1, 1);
			
			var myidx:int = 0;
			
			if ( color == "c") myidx = 0;
			if ( color == "d") myidx = 13;
			if ( color == "h") myidx = 26;
			if ( color == "s") myidx = 39;
				
			if ( point == "i") myidx += 9;
			else if ( point == "j") myidx += 10;
			else if ( point == "q") myidx += 11;
			else if ( point == "k") myidx += 12;
			else 	myidx +=  (parseInt(point) - 1) ;
			
			return myidx;
		}
		
		public static function pokerTrans(strpoker:String):int
		{			
			var point:String = strpoker.substr(0, 1);
			var color:String = strpoker.substr(1, 1);
			
			var myidx:int = 0;
			
			if ( color == "d") myidx = 1;
			if ( color == "h") myidx = 2;
			if ( color == "s") myidx = 3;
			if ( color == "c") myidx = 4;
				
			if ( point == "i") myidx += (9*4);
			else if ( point == "j") myidx += (10*4);
			else if ( point == "q") myidx += (11*4);
			else if ( point == "k") myidx += (12*4);
			else 	myidx +=  (parseInt(point) - 1) * 4;
			
			return myidx;
		}
		
		public static function showPoker(mc:MovieClip, idx:int, data:Array):void
		{
			var poke:String =  data[idx];
			var point:String = poke.substr(0, 1);
			var color:String = poke.substr(1, 1);
			
			var myidx:int = 0;
			
			if ( color == "d") myidx = 1;
			if ( color == "h") myidx = 2;
			if ( color == "s") myidx = 3;
			if ( color == "c") myidx = 4;
				
			if ( point == "i") myidx += (9*4);
			else if ( point == "j") myidx += (10*4);
			else if ( point == "q") myidx += (11*4);
			else if ( point == "k") myidx += (12*4);
			else 	myidx +=  (parseInt(point) - 1) * 4;
			
			utilFun.scaleXY(mc, 0.8, 0.8);
			mc.gotoAndStop(myidx);
		}	
		
		public static function newnew_judge(pok:Array,po:Array):Array
		{		
			//var pok:Array = ["kc", "1h", "jd", "9h", "jh"];
			//var pok:Array = ["3c", "4h", "kd", "3h", "1h"];
			//var po:Array = ["0", "1", "2", "3","4"];
			
			var point:Array = pokerUtil.get_Point(pok);
			var totalPoint:int = pokerUtil.Get_Mapping_Value(po, point);
			
			var arr:Array = utilFun.easy_combination(po, 3);
			var answer:Array = [];
			var restmax:int = 0;
			for (var i:int = 0; i < arr.length; i++)
			{
				var total:int = 0;
				var rest:int = 0;
				var cobination:Array = arr[i];
				//utilFun.Log("conbi=" + cobination) ;
				total = Get_Mapping_Value(cobination, point);
				rest = totalPoint - total;
				
				total %= 10;
				rest %= 10;
				//utilFun.Log( "list:" + cobination + " = " + total  +" rest ="+ rest);
				if ( total == 0)
				{
					if ( rest >= restmax )
					{
						restmax = rest;
						answer.length = 0;
						answer.push.apply(answer, cobination);						
					}
				}
			}
			
			//utilFun.Log( "answer:" + answer);
			
			if ( answer.length != 0)
			{
				answer.push.apply(answer,utilFun.Get_restItem(po, answer));
			}
			else answer = [];
			
			//utilFun.Log( "final answer:" + answer);
			return answer;
		}
		
		public static function poer_shift(pokerlist:Array,best3:Array):void
		{
			var position:Array = [];
			for (var i:int = 0; i < pokerlist.length; i++)
			{
				var shift:int= 0;
				if ( i == 1 ) shift = 20;
				if ( i == 2) shift = 40;
				if ( i == 3) shift = 20;
				if ( i == 4) shift = 40;
				position.push(pokerlist[i].x -shift);
			}
			
			for (var k:int = 0; k < pokerlist.length; k++)
			{
				Tweener.addTween(pokerlist[best3[k]], { x:position[k], transition:"easeOutQuint", time:1 } );
			}
		}
		
		/**
		 * @param	idxList  = [1,2,3]
		 * @param	mapping = [10,11,12,13,14] 
		 * @return   11+12+13
		 */
		public static function Get_Mapping_Value(idxList:Array,mapping:Array):int
		{
			var n:int = idxList.length;
			var total:int = 0;
			for (var i:int = 0;  i < n; i++)
			{
				total += mapping[idxList[i]];
			}
			return total;
		}		
		
		public static function get_Point(poke:Array):Array
		{
			var point:Array = [];
			var n:int = poke.length;
			for (var i:int = 0; i < n; i++)
			{
				point.push( pokerUtil.get_Baccarat_Point(poke[i]) );				
			}
			return point;
		}
		
		public static function get_Baccarat_Point(poke:String):int
		{
			var point:String = poke.substr(0, 1);
			
			if ( point == "i" ||  point == "j" || point == "q" || point == "k") return 10;			
			return parseInt(point);			
		}
		
	}

}