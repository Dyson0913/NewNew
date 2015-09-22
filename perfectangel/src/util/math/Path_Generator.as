package util.math 
{
	import flash.display.DisplayObjectContainer;
	import Model.Model;
	import caurina.transitions.properties.CurveModifiers;
	import Model.valueObject.*;
	import caurina.transitions.Tweener;
	
	/**
	 * handle about Path
	 * @author hhg4092
	 */
	public class Path_Generator 
	{
		[Inject]
		public var _model:Model;		
		
		public function Path_Generator() 
		{
			
		}
		
		public function init():void
		{
			CurveModifiers.init();
			_model.putValue("path", []);
			
			var creid_recycle_point:Array = [488, -410];
			var path:Object = { "BetPAEvil":[[988, 0],creid_recycle_point],
											"BetPAAngel":[[0, 0],creid_recycle_point],
											"BetPABigEvil": [ [827, -108],creid_recycle_point],
											"BetPABigAngel":[ [147, -103],creid_recycle_point],
											"BetPAUnbeatenEvil":[ [677, -68],creid_recycle_point],
											"BetPAPerfectAngel":[[311, -62],creid_recycle_point]
			};			
										
			_model.putValue("coin_recycle_path ",path);		
							
			//contain 0,0為準, [488, -410] to dest,rest shift  e.x : [988, 0] + [x,y] = [488, -410]  => x = -500,y=-410
			var win_path:Object = { "BetPAEvil":[ [-500, -410],[60, 30]],
											"BetPAAngel":[[488, -410],[-63, 27]],
											"BetPABigEvil": [ [-340, -300], [60,30]],
											"BetPABigAngel":[ [341, -308], [-60, 30]],
											"BetPAUnbeatenEvil":[  [-189, -340],[60, 30]],
											"BetPAPerfectAngel":[[177, -346],[-50, 40]]
			};		
			
			_model.putValue("coin_Win_path ", win_path);		
			
			var creid_hid:Array = [81, 310];
			var win_path_to_credit:Object = { "BetPAEvil":[[988, 0],creid_hid],
											"BetPAAngel": [[0, 0],creid_hid],
											"BetPABigEvil": [[827, -108],creid_hid],
											"BetPABigAngel":[  [147, -103],creid_hid],
											"BetPAUnbeatenEvil":[ [677, -68],creid_hid],
											"BetPAPerfectAngel":[[311, -62],creid_hid]
			};		
			
				_model.putValue("coin_ToCredit_path ", win_path_to_credit);		
		//	_model.putValue("L_same", [[489, 653], [967,402]]);
		//	_model.putValue("R_same", [[1425, 647], [949,417]]);
			
			
		}
		
		[MessageHandler(type="Model.valueObject.ArrayObject",selector="recode_path")]
		public function path_update(arrob:ArrayObject):void
		{			
			_model.getValue("path").push(arrob.Value);			
		}
		
		public function get_recoder_path():Array
		{
			var path:Array = _model.getValue("path");
			//utilFun.Log("arr = " + path.length);
			var resultPath:Array = get_recoder_format_path(path);			
			return resultPath;
		}
		
		public function get_recoder_format_path(path:Array):Array
		{
			var path:Array = path;
			//utilFun.Log("arr = " + path.length);
			var resultPath:Array = [];
			for (var i:int = 0; i < path.length; i++)
			{
				var arr:Array = path[i];
				var obj:Object = { x: arr[0], y: arr[1] };
				resultPath.push (obj);               
				
			}
			resultPath.unshift (resultPath [0]); 
			resultPath.push (resultPath [resultPath.length -1]);
			
			return resultPath;
		}
		
		public function get_Path_isometric(pathPoint:Array,xdiff:int):Array
		{
			var path:Array = [];
			for (var i:int = 0; i < pathPoint.length; i++)
			{
				var arr:Array = pathPoint[i];
				var obj:Object = { x: arr[0] + 30 * xdiff, y: arr[1] };
				path.push (obj);
			}       
			
		    //first and last point need to tweener
			path.unshift (path [0]); 
			path.push (path [path.length -1]);
			return path;
		}
		
		public function makeBesierArray (p:Array):Array
        {
            var bezier:Array = [];
            // convert all points between p[0] and p[last]
            for (var i:int = 1; i < p.length -2; i++)
            {
                var b1:Object = {}, b2:Object = {};
                // use p[0] properties to fill bezier array
                for (var prop:String in p[0])
                {
                    b1[prop] = -p[i -1][prop]/6 +p[i][prop] +p[i +1][prop]/6;
                    b2[prop] = +p[i][prop]/6 +p[i +1][prop] -p[i +2][prop]/6;
                }
                bezier.push (b1); bezier.push (b2);
            }			
            return bezier;
        }
		
		public function follew_path(mc:DisplayObjectContainer, path:Array,completFun:Function):void
		{
			mc.x = path[0].x;
				mc.y = path[0].y;
				Tweener.addTween(mc, {
					x:path [path.length -1].x,
					y:path [path.length -1].y,
			       _bezier:makeBesierArray(path),
			time:1, transition:"easeInOutQuint",onComplete:completFun, onCompleteParams:[mc]});				
		}
		
	}

}