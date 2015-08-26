package View.ViewComponent 
{
	import flash.display.MovieClip;
	import View.ViewBase.VisualHandler;
	import Model.valueObject.*;
	import Model.*;
	import util.*;
	import View.Viewutil.AdjustTool;
	
	import View.Viewutil.MultiObject;
	import Res.ResName;
	import caurina.transitions.Tweener;
	import Command.*;
	
	/**
	 * poker present way
	 * @author ...
	 */
	public class Visual_poker  extends VisualHandler
	{
		[Inject]
		public var _regular:RegularSetting;
		
		public function Visual_poker() 
		{
			
		}
		
		public function init():void
		{
			var playerCon:MultiObject = prepare(modelName.PLAYER_POKER, new MultiObject(), GetSingleItem("_view").parent.parent);		
			playerCon.CustomizedFun = myscale;			
			playerCon.Create_by_list(5, [ResName.flippoker], 0 , 0, 5, 130, 0, "Bet_");
			playerCon.container.x = 230;
			playerCon.container.y = 500;
			playerCon.container.alpha = 0;
			//
			var bankerCon:MultiObject =  prepare(modelName.BANKER_POKER, new MultiObject(), GetSingleItem("_view").parent.parent);
			bankerCon.CustomizedFun = myscale;
			bankerCon.Create_by_list(5, [ResName.flippoker], 0 , 0, 5, 130, 0, "Bet_");			
			bankerCon.container.x = 1050;
			bankerCon.container.y = 500;
			bankerCon.container.alpha = 0;
			
			//_tool.SetControlMc(paytable.ItemList[1]);
			//_tool.SetControlMc(playerCon.container);
			//add(_tool);			
			
			//no clean ,half in init ,cant cleanr model
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean_poker():void
		{		
			Get(modelName.PLAYER_POKER).CleanList();
			Get(modelName.PLAYER_POKER).CustomizedFun = myscale;		
			Get(modelName.PLAYER_POKER).Create_by_list(5, [ResName.flippoker], 0 , 0, 5, 130, 0, "Bet_");
			Get(modelName.PLAYER_POKER).container.x = 230;
			Get(modelName.PLAYER_POKER).container.y = 500;
			Get(modelName.PLAYER_POKER).container.alpha = 0;			
			
			Get(modelName.BANKER_POKER).CleanList();
			Get(modelName.BANKER_POKER).CustomizedFun = myscale;
			Get(modelName.BANKER_POKER).Create_by_list(5, [ResName.flippoker], 0 , 0, 5, 130, 0, "Bet_");
			Get(modelName.BANKER_POKER).container.x = 1050;
			Get(modelName.BANKER_POKER).container.y = 500;		
			Get(modelName.BANKER_POKER).container.alpha = 0;
			
			_model.putValue("playerNew", false);
			_model.putValue("bankerNew", false);
			
			_model.putValue(modelName.BANKER_POKER,[]);
			_model.putValue(modelName.PLAYER_POKER,[]);
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function poker_display():void
		{
			
			var playerCon:MultiObject = Get(modelName.PLAYER_POKER);			
			_regular.FadeIn(playerCon.container, 1, 1,null);
			
			var bankerCon:MultiObject = Get(modelName.BANKER_POKER);
			_regular.FadeIn(bankerCon.container, 1, 1,null);		
			
		}
		
		public function myscale(mc:MovieClip, idx:int, coinstack:Array):void
		{
			utilFun.scaleXY(mc, 0.76, 0.76);
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject", selector = "poker_No_mi")]
		public function poker_no_mi(type:Intobject):void
		{
			var mypoker:Array =   _model.getValue(type.Value);			
			for ( var pokernum:int = 0; pokernum < mypoker.length; pokernum++)
			{				
				var pokerid:int = pokerUtil.pokerTrans(mypoker[pokernum])
				var anipoker:MovieClip = GetSingleItem(type.Value, pokernum);
				anipoker.visible = true;
				anipoker.gotoAndStop(1);
				anipoker["_poker"].gotoAndStop(pokerid);
				anipoker["_poker_a"].gotoAndStop(pokerid);
				anipoker.gotoAndStop(anipoker.totalFrames);
					
				if (  mypoker.length > 2)
				{
					move(type.Value);
				}
			}				
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject", selector = "poker_mi")]
		public function poker_mi(type:Intobject):void
		{						
			var mypoker:Array =   _model.getValue(type.Value);			
			var pokerid:int = pokerUtil.pokerTrans(mypoker[mypoker.length - 1])					
			var anipoker:MovieClip = GetSingleItem(type.Value, mypoker.length - 1);
			anipoker.visible = true;
			anipoker.gotoAndStop(1);
			anipoker["_poker"].gotoAndStop(pokerid);
			anipoker["_poker_a"].gotoAndStop(pokerid);
			anipoker.gotoAndPlay(2);
			Tweener.addTween(anipoker["_poker"], { rotationZ:24, time:0.3,onCompleteParams:[anipoker,anipoker["_poker"],0,mypoker.length,type.Value],onComplete:this.pullback} );			
		}
		
		public function pullback(anipoker:MovieClip,mc:MovieClip,angel:int,pokerle:int,type:int):void
		{			
			if ( pokerle <=4)	Tweener.addCaller( anipoker, { time:1 , count: 1 , transition:"linear", onCompleteParams:[anipoker, mc, angel,type,pokerle], onComplete: this.dis } );	
			else Tweener.addCaller( anipoker, { time:2 , count: 1 , transition:"linear", onCompleteParams:[anipoker, mc, angel,type,pokerle], onComplete: this.dis } );						
		}
		
		public function dis(anipoker:MovieClip, mc:MovieClip, angel:int, type:int, lenth:int ):void
		{	
			anipoker.gotoAndPlay(7);				
			Tweener.addTween(mc, { rotationZ:angel, time:1, delay:1 } );
			Tweener.addCaller( anipoker, { time:1 , count: 1 , transition:"linear", onCompleteParams:[type,lenth], onComplete: this.showjudge } );	
		}
		
		public function showjudge(type:int,pokernum:int):void
		{		
			if ( pokernum >= 3) move(type);			
		}
		
		//[MessageHandler(type = "Model.valueObject.Intobject",selector="pokerupdate")]
		//public function playerpokerupdate(type:Intobject):void
		//{
			//var Mypoker:Array =   _model.getValue(type.Value);
			//var pokerlist:MultiObject = Get(type.Value)
			//pokerlist.CleanList();
			//pokerlist.CustomizedFun = pokerUtil.showPoker;
			//pokerlist.CustomizedData = Mypoker;
			//pokerlist.Create_by_list(Mypoker.length, [ResName.Poker], 0 , 0, Mypoker.length, 163, 123, "Bet_");
		//}
		
		//[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		//public function round_effect():void
		//{
			//var playerpoker:Array =   _model.getValue(modelName.PLAYER_POKER);
			//var best3:Array = pokerUtil.newnew_judge( playerpoker);
			//utilFun.Log("best 3 = "+best3);
			//var pokerlist:MultiObject = Get(modelName.PLAYER_POKER)
			//pokerUtil.poer_shift(pokerlist.ItemList.concat(), best3);
			//
			//var banker:Array =   _model.getValue(modelName.BANKER_POKER);
			//var best2:Array = pokerUtil.newnew_judge( banker);
			//var bpokerlist:MultiObject = Get(modelName.BANKER_POKER)
			//pokerUtil.poer_shift(bpokerlist.ItemList.concat(), best2);
		//}
		
		[MessageHandler(type= "Model.ModelEvent",selector = "playerpokerAni_half")]
		public function playerpoker_half():void
		{		
			var playerpoker:Array =   _model.getValue(modelName.PLAYER_POKER);
			
			for ( var i:int = 0; i < playerpoker.length; i++)
			{
				var pokerid:int = pokerUtil.pokerTrans(playerpoker[i]);
				static_poker(pokerid, modelName.PLAYER_POKER,i);
				if ( i >= 2)
				{
					move(modelName.PLAYER_POKER);
				}
			}			
		}
		
		[MessageHandler(type= "Model.ModelEvent",selector = "playerpokerAni2_half")]
		public function bankerpoker_half():void
		{			
			var playerpoker:Array =   _model.getValue(modelName.BANKER_POKER);
			
			for ( var i:int = 0; i < playerpoker.length; i++)
			{
				var pokerid:int = pokerUtil.pokerTrans(playerpoker[i]);
				static_poker(pokerid, modelName.BANKER_POKER,i);
				if ( i >= 2)
				{
					move(modelName.BANKER_POKER);
				}
			}			
		}
		
		
		public function static_poker(pokerid:int,cardtype:int,i:int):void
		{
			//fun
			var mypoker:MovieClip = utilFun.GetClassByString(ResName.Poker);
			mypoker.rotationY = -180
			mypoker.x = 125;
			utilFun.scaleXY(mypoker, 0.748, 0.748);			
			mypoker.gotoAndStop(pokerid);
			
			//取得畫面的牌別
			var Mypoker:Array =   _model.getValue(cardtype);
			var pokerlist:MultiObject = Get(cardtype)
			
			var pokerbac:MovieClip = pokerlist.ItemList[i];
			pokerbac.addChild(mypoker);
			pokerbac.rotationY = -180
			pokerbac.x += 90;
		}
		
		[MessageHandler(type= "Model.ModelEvent",selector = "playerpokerAni")]
		public function playerpokerani():void
		{		
			var playerpoker:Array =   _model.getValue(modelName.PLAYER_POKER);		
			var pokerid:int = pokerUtil.pokerTrans(playerpoker[playerpoker.length - 1])
			paideal(pokerid,modelName.PLAYER_POKER);
		}
		
		[MessageHandler(type= "Model.ModelEvent",selector = "playerpokerAni2")]
		public function playerpokerani2():void
		{	
			var bank:Array =   _model.getValue(modelName.BANKER_POKER);		
			var pokerid:int = pokerUtil.pokerTrans(bank[bank.length - 1])		
			paideal(pokerid,modelName.BANKER_POKER);
		}
		
		public function paideal(pokerid:int,cardtype:int):void
	   {
		   //牌背	
		   var mypoker:MovieClip = utilFun.GetClassByString(ResName.Poker);
			mypoker.rotationY = -180
			mypoker.x = 125;
			utilFun.scaleXY(mypoker, 0.748, 0.748);
			mypoker.visible = false;
			mypoker.gotoAndStop(pokerid);
			
			//取得畫面的牌別
			var Mypoker:Array =   _model.getValue(cardtype);
			var pokerlist:MultiObject = Get(cardtype)			
			
			//var toos:AdjustTool = new AdjustTool();
			//toos.SetControlMc(mypoker);
			//add(toos);
			
			var pokerbac:MovieClip = pokerlist.ItemList[Mypoker.length - 1];
			pokerbac.addChild(mypoker);		
			
			//翻牌
			Tweener.addTween(pokerbac, { rotationY: -180, x:pokerbac.x + 90 , time:0.5, transition:"linear", onUpdate:this.show, onUpdateParams:[pokerbac, mypoker],onComplete:this.move,onCompleteParams:[cardtype] } )
			
		}
		
		public function show(pokerbac:MovieClip,mypoker:MovieClip):void
		{			
			if ( pokerbac.rotationY <= -100)
			{
				mypoker.visible = true;
			}
		}
		
		public function move(cardtype:int):void
		{			
			var mypoker:Array =   _model.getValue(cardtype);
			var bnew:Boolean 
			if ( cardtype == modelName.PLAYER_POKER) bnew = _model.getValue("playerNew");
			if ( cardtype == modelName.BANKER_POKER) bnew = _model.getValue("bankerNew");			
			if ( mypoker.length ==3 && bnew == false)
			{
				var po:Array = [];
				for (var k:int = 0; k < mypoker.length; k++) po.push(k);
				var point:Array = pokerUtil.get_Point(mypoker);
				var totalPoint:int = pokerUtil.Get_Mapping_Value(po, point);				
				if ( totalPoint % 10 == 0)
				{
					var pokerlist:MultiObject = Get(cardtype)
					for (var k:int = 0; k <3; k++)
					{
						Tweener.addTween(pokerlist.ItemList[k], { y:pokerlist.ItemList[k].y + 200, x:pokerlist.ItemList[k].x +120, transition:"easeOutQuint", time:1 } );
					}
					
					for (var k:int = 3; k <5; k++)
					{
						Tweener.addTween(pokerlist.ItemList[k], {  x:pokerlist.ItemList[k].x -200, transition:"easeOutQuint", time:1 } );
							//change 50 to 200 or 5 to see how it works
						
					}
					//shakeTween(pokerlist.ItemList[4], 200);
					if ( cardtype == modelName.PLAYER_POKER) bnew = _model.putValue("playerNew", true);
					if ( cardtype == modelName.BANKER_POKER) bnew = _model.putValue("bankerNew", true);
					
						
				}
			}
			
			if ( mypoker.length >= 4 && bnew == false)
			{
				var po:Array = [];
				var total:Array = [0, 1, 2, 3, 4];  //num
				for (var k:int = 0; k < mypoker.length; k++) po.push(k);				
				var newpoker:Array = pokerUtil.newnew_judge(mypoker, po);				
				if ( newpoker.length != 0)
				{									
					var selectCard:Array = newpoker.slice(0, 3);
					var rest:Array = utilFun.Get_restItem(total,selectCard)
						
					var po:Array = [ [120, 200], [250, 200], [380, 200]];
					var pokerlist:MultiObject = Get(cardtype)					
					for (var k:int = 0; k <selectCard.length; k++)
					{
						Tweener.addTween(pokerlist.ItemList[selectCard[k]], {x:po[k][0], y:po[k][1] , transition:"easeOutQuint", time:1 } );
					}
					
					//隨挑選結果不同
					var po2:Array = [ [190, 0], [320, 0]];				
					for (var k:int = 0; k <rest.length; k++)
					{
						Tweener.addTween(pokerlist.ItemList[rest[k]], {  x:po2[k][0] , transition:"easeOutQuint", time:1 } );
					}
					
					//var toos:AdjustTool = new AdjustTool();
						//toos.SetControlMc(pokerlist.ItemList[2]);
						//add(toos);
					//
					if ( cardtype == modelName.PLAYER_POKER) bnew = _model.putValue("playerNew", true);
					if ( cardtype == modelName.BANKER_POKER) bnew = _model.putValue("bankerNew", true);					
				}				
				
			}
			
		}
	   
		
		public function shakeTween(item:MovieClip, repeatCount:int):void
		{			
			Tweener.addCaller(item, { time: 10, count: repeatCount ,onUpdateParams:[item,item.x,item.y], onUpdate: this.shade,delay:0.1, transition:"linear"  } );
		}
		
		private function shade(mc:MovieClip,x:Number,y:Number):void
		{			
			
		    mc.y =  y+(1 + Math.random() * 5);
			mc.x = x+(1 + Math.random() * 5 );		
		}	
		
	}

}