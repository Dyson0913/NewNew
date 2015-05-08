package util 
{
	import caurina.transitions.Tweener;
	
	/**
	 * poker regular function
	 * @author hhg4092
	 */
	public class pokerUtil 
	{
		
		public function pokerUtil() 
		{
			
		}
		
		public static function newnew_judge(pok:Array):Array
		{		
			//var pok:Array = ["kc", "1h", "jd", "9h", "jh"];
			//var pok:Array = ["3c", "4h", "kd", "3h", "1h"];
			var po:Array = ["0", "1", "2", "3", "4"];
			
			var pointA:Array = [];
			var totalPoint:int = 0;
			for (var i:int = 0; i < po.length; i++)
			{
				var point:int = pokerUtil.get_Baccarat_Point(pok[i])
				pointA.push( point );
				totalPoint += point;
			}
			var arr:Array = utilFun.combinations(po, 3);
			var answer:Array = [];
			var restmax:int = 0;
			for (var i:int = 0; i < arr.length; i++)
			{
				var total:int = 0;
				var rest:int = 0;
				var cobination:Array = arr[i];
				//utilFun.Log("conbi=" + cobination) ;
				total = Get_Mapping_Value(cobination, pointA);
				rest = totalPoint - total;
//				utilFun.Log( "list:" + cobination + " = " + total  +" rest ="+ rest);
				total %= 10;
				rest %= 10;
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
			
			utilFun.Log( "answer:" + answer);
			
			if ( answer.length !=0)
			{
				var arr:Array = pokerUtil.Get_restItem(po, answer);			
				answer.push.apply(answer, arr);
			}
			else answer = ["0", "1", "2", "3", "4"];
			
			utilFun.Log( "final answer:" + answer);
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
			
			for (var i:int = 0; i < pokerlist.length; i++)
			{
				Tweener.addTween(pokerlist[best3[i]], {x:position[i], transition:"easeOutQuint", time:1});
			}
		}
		
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
		
		public static function Get_restItem(origi:Array,own:Array):Array
		{
			var rest_item:Array = [];
			var n:int = origi.length
		  	for (var i:int = 0; i < n; i++)
			{
				if (  own.indexOf(origi[i]) == -1 ) rest_item.push(i);
			}
			
			return rest_item;
		}
		
		public static function get_Baccarat_Point(poke:String):int
		{
			var point:String = poke.substr(0, 1);
			
			if ( point == "i" ||  point == "j" || point == "q" || point == "k") return 10;			
			return parseInt(point);			
		}
	}

}