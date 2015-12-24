package View.ViewBase 
{
	import flash.display.MovieClip;		
	import View.ViewBase.*
	import Model.valueObject.*;
	import Model.*;
	import util.*;	
	import Command.*;	
	
	import View.Viewutil.*;
	import Res.ResName;	
	import util.time.time_format;
	
	
	/**
	 * version present way
	 * @author Dyson0913
	 */
	public class Visual_Version  extends VisualHandler
	{	
		//res		
		public const version_text:String = "Emptymc";		
		
		//tag
		private const version_texts:int = 0;	
		
		public function Visual_Version() 
		{
			
		}
		
		public function init():void
		{
			var version_container:MultiObject = create("version_container", [ResName.emptymc]);			
			version_container.CustomizedFun = version_init;
			version_container.CustomizedData = [];
			version_container.container.x = 1780;
			version_container.container.y = 1060;
			version_container.Create_(1);
			
			put_to_lsit(version_container);
		}
		
		public function version_init(mc:MovieClip, idx:int, data:Array):void
		{
			var name:String = "version_";
			var component:Array =  [version_text];
			
			var font:Array = [ { size:15, align:_text.align_left, color:0xFFFFFF }, major_minor_build() ];
			//font = font.concat(mylist);
			var ob_cotainer:MultiObject = create(name + idx, component , mc);			
			ob_cotainer.CustomizedFun =  _text.textSetting;
			ob_cotainer.CustomizedData = font;
			//ob_cotainer.Posi_CustzmiedFun = _regular.Posi_xy_Setting;
			//ob_cotainer.Post_CustomizedData = [[0, 0], [650, 630],[860, 630], [1340, 120]];			
			ob_cotainer.Create_(component.length);
		
			//default setting
		
			//specialize setting
			//var mc:MovieClip = GetSingleItem(name + idx, version_texts);			
			
			put_to_lsit(ob_cotainer);	
		}		
		
		private function major_minor_build():String
		{
			//major.minor(.build)
			//major : mass update
			//minor : new feture
			//build : bug fix
			var major:String = "0";
			var minor:String = "1";
			var build:String = "01";
			return "V" + major + "." + minor + "." + build + "." + CONFIG::timeStamp;
		}
		
	}

}