package util 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.getDefinitionByName;
	import flash.utils.setTimeout;
	
	import com.hexagonstar.util.debug.Debug;
	import View.Viewutil.MouseBehavior;
	import Res.ResName;
	
	/**
	 * 常用功能
	 * @author hhg
	 */
	public class utilFun
	{		
		
		public function utilFun() 
		{
			
		}
		
		//由link名取得類別
		public static function GetClassByString(sClassName:String):MovieClip 
		{			
			var Temp:Class = getDefinitionByName(sClassName) as Class;
			var mc:MovieClip = new Temp();	
			mc.name = sClassName;
			return mc;
		}
		
		public static function prepare(name:*, ob:*,di:DI, container:DisplayObjectContainer = null):*
		{
			if (di.getValue(name)== null) 
			{
				if ( container != null) container.addChild(ob);
				di.putValue(name, ob);
			}
			else
			{
				return di.getValue(name);
			}
			
			return ob;
		}
		
		public	static function Createitem(text:String,color:uint,align:String = TextFieldAutoSize.LEFT):TextField
		{
			var tx:TextField = new TextField();
			tx.background = true;
			tx.backgroundColor  = color;
			tx.text = text;
			tx.width = tx.textWidth;
			tx.height = tx.height;
			tx.selectable = false;
			tx.autoSize = align;
			return tx;
		}
		
		/**
		 * log Facade
		 * @param	msg
		 * @param	Level 用原本列舉有run time comiler error,用mapping方式
		 */
		public static function Log(msg:String):void
		{			
			Debug.trace(msg);			
		}
		
		/******************** 元件操作功能 ********************/
		
		//縮放
		public static function scaleXY(mc:MovieClip,x:Number = 1.0, y:Number = 1.0):void
		{
			mc.scaleX = x;
			mc.scaleY = y;
		}	
		
		//清空容器標記
		public static function ClearContainerChildren(Container:MovieClip):void
		{	
			while (Container.numChildren > 0)
			{
				Container.removeChildAt(0);
			}
		}
		
		public static function SetText(Container:TextField,Text:String):void
		{			
			Container.text = Text;
		}	
		
		public static function SetTime(listen:Function,sec:int):void
		{			
			setTimeout(listen, sec*1000);
		}	
		
		//滑鼠監聽
		public static function AddMouseListen(mc:DisplayObject,listen:Function):void
		{			
			mc.addEventListener(MouseEvent.ROLL_OUT,listen);
			mc.addEventListener(MouseEvent.ROLL_OVER, listen);
			mc.addEventListener(MouseEvent.MOUSE_DOWN, listen);
			mc.addEventListener(MouseEvent.MOUSE_UP,listen);
		}
		
		//list滑鼠監聽
		public static function AddMultiMouseListen(Itemlist:Array,listen:Function,mouseFrame:Array):void
		{
			var N:int =  Itemlist.length;
			for (var i:int = 0 ;  i < N ;  i++)
			{
				if ( mouseFrame[0] != 0) Itemlist[i].addEventListener(MouseEvent.ROLL_OUT, listen);
				if ( mouseFrame[1] != 0) Itemlist[i].addEventListener(MouseEvent.ROLL_OVER, listen);
				if ( mouseFrame[2] != 0) Itemlist[i].addEventListener(MouseEvent.MOUSE_DOWN, listen);
				if ( mouseFrame[3] != 0) Itemlist[i].addEventListener(MouseEvent.MOUSE_UP, listen);
			}			
		}
		
		//移除滑鼠監聽
		public static function ReMoveMouseListen(mc:DisplayObject,listen:Function):void
		{			
			mc.removeEventListener(MouseEvent.ROLL_OUT,listen);
			mc.removeEventListener(MouseEvent.ROLL_OVER, listen);
			mc.removeEventListener(MouseEvent.MOUSE_DOWN, listen);
			mc.removeEventListener(MouseEvent.MOUSE_UP,listen);
		}
		
		//list移除滑鼠監聽
		public static function ReMoveMultiMouseListen(Itemlist:Array,listen:Function,mouseFrame:Array):void
		{			
			var N:int =  Itemlist.length;
			for (var i:int = 0 ;  i < N ;  i++)
			{				
				if ( mouseFrame[0] != 0) Itemlist[i].removeEventListener(MouseEvent.ROLL_OUT,listen);
				if ( mouseFrame[1] != 0) Itemlist[i].removeEventListener(MouseEvent.ROLL_OVER, listen);
				if ( mouseFrame[2] != 0) Itemlist[i].removeEventListener(MouseEvent.MOUSE_DOWN,listen);
				if ( mouseFrame[3] != 0) Itemlist[i].removeEventListener(MouseEvent.MOUSE_UP, listen);
			}			
		}
		
		public static function GotoAndStop(e:Event,frame:int):void
		{			
			if ( frame == 0 )
			{				
				return;
			}			
			e.currentTarget.gotoAndStop(frame);		
		}
		
		public static function Frametype(type:int,customized:Array = null):Array
		{
			var BtnMouseFrame:Array;
			if ( type == MouseBehavior.ClickBtn) BtnMouseFrame = [0, 0, 2, 1];
			if ( type == MouseBehavior.SencetiveBtn) BtnMouseFrame = [1, 2, 2, 1];
			if (type == MouseBehavior.Customized ) BtnMouseFrame = customized;
			
			return BtnMouseFrame;
		}
		
		public static function combinations(values:Array, length:uint):Array 
	   {
            var i:uint, j:uint, result:Array, start:Array, end:Array, len:uint, innerLen:uint;
            if (length > values.length || length <= 0) {
                return [];
            }
            if (length == values.length) {
                return values;
            }
            if (length == 1) {
                result = [];
                len = values.length;
                for (i = 0; i < len; ++i) {
                    result[i] = [values[i]];
                }
                return result;
            }
            result = [];
            len = values.length - length;
            for (i = 0; i < len; ++i) {
                start = values.slice(i, i + 1);
                end = combinations(values.slice(i + 1), length - 1);
                innerLen = end.length;
                for (j = 0; j < innerLen; ++j) {
                    result.push(start.concat(end[j]));
                }
            }
            return result;
        }		
		
		//條件 0 base (flash為1base 影格 , CurFrame -1和 Frame + 1在於調整為0 base 
		//FrameCycle = 有幾格在循環
		//
		//複合按鍵用法 : click時還原成cycleFrame影格,做完後再shift到對應的RollOver
		public static function cycleFrame(CurFrame:int,FrameCycle:int):int
		{
			var Frame:int = CurFrame -1;
			Frame = ( Frame +1 ) % FrameCycle;
			return Frame + 1;
		}
		
		
		//回傳match完patten後的字串
		public static function Regex_CutPatten(str:String, pattern:RegExp):String
		{
			var sName:String = str;
			var pattern:RegExp = pattern;
			sName = sName.replace(pattern, "");
			return sName;
		}
		
		//檢查字串是否match 條件
		public static function Regex_MatchPatten(str:String, pattern:RegExp):Boolean
		{
			return pattern.test(str);
		}
		
		public static function Regex_Match(str:String, pattern:RegExp):Array
		{
			return str.match(pattern);			
		}
		
		//n個字後變...
		public static function SubString_len(str:String,len:Number):String
		{
			var newstr:String = str;
			if ( newstr.length > len)
			{
				newstr = newstr.substr(0, len) + "...";
			}
			return newstr;
		}
		
		//隨機亂數
		public static function Random(Range:int):int
		{
			return Math.random() * Range;
		}
		
		//補零到幾位數
		public static function Format(digit:int,lenth:int):String
		{
			var str:String = "";
			var digLenth:int = digit.toString().length;
			var len:int = lenth - digLenth;
			for ( var i:int = 0 ; i < len; i++)
			{
				str += "0";
			}
			return str + digit.toString();
		}
		
		//將數字轉成會計符號計法  12345 -> 12,345
		public static function Accounting_Num(digit:int):String
		{
			var str:String = "";
			var arr:Array = [];
			
			var num:int = 0; 
			while (digit >= 10)
			{
				num = digit % 10;
				arr.push(num);
				digit /= 10;
			}
			arr.push(digit);
			
			for (var i:int = 0 ; i< arr.length ;  i++)
			{
				if ( i>0 &&  i  % 3 == 0) str = "," + str;
				
				str = arr[i] + str;
			}
			arr.length = 0;
			return str;
		}				
		
		/**
		 * 線性內插等距N個點
		 * @param	amount 第N個點的位置
		 * @param	start
		 * @param	end
		 * @return
		 */
		public static function NPointInterpolate( amount:Number , start:Number, end:Number ):Number 
		{
			if ( start == end ) 
			{
				return start ;
			}
			//return ( ( 1 - amount ) * start ) + ( amount * end ) ;
			return start + amount * (end - start)
		}
		
		
		public static function NPointInterpolateDistance( N:int , start:Number, end:Number ):Number
		{
			//正常版
			//var N1:Number =  NPointInterpolate(0/N, start, end);
			//var N2:Number =  NPointInterpolate(1/N, start, end);
			//return N2 - N1;
			
			//簡化版
			var N1:Number =  start + (1 / N) * (end - start)			
			return N1;
		}
		
	}

}