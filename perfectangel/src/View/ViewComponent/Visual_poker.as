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
		
		public function Visual_poker() 
		{
			
		}
		
		public function init():void
		{
			
			
			var playerCon:MultiObject = prepare(modelName.PLAYER_POKER, new MultiObject(), GetSingleItem("_view").parent.parent);		
			playerCon.CustomizedFun = myscale;			
			playerCon.Create_by_list(5, [ResName.just_turnpoker], 0 , 0, 5, 140, 0, "Bet_");
			playerCon.container.x = 180;
			playerCon.container.y = 630;
			playerCon.container.alpha = 0;
			//
			var bankerCon:MultiObject =  prepare(modelName.BANKER_POKER, new MultiObject(), GetSingleItem("_view").parent.parent);
			bankerCon.CustomizedFun = myscale;
			bankerCon.Create_by_list(5, [ResName.just_turnpoker], 0 , 0, 5, 140, 0, "Bet_");			
			bankerCon.container.x = 1050;
			bankerCon.container.y = 630;
			bankerCon.container.alpha = 0;
			
				
			
			var table_hint:MultiObject = prepare("table_hint", new MultiObject(), GetSingleItem("_view").parent.parent);
			table_hint.autoClean = true;
			table_hint.CleanList();
			table_hint.Create_by_list(1, [ResName.open_tableitem], 0 , 0, 1, 0, 0, "Bet_");
			table_hint.container.x = 442;
			table_hint.container.y = 590;	
			table_hint.container.visible = false;
			
			var mipoker:MultiObject =  prepare("mipoker", new MultiObject(), GetSingleItem("_view").parent.parent);			
			mipoker.Create_by_list(1, [ResName.Mipoker_zone], 0 , 0, 1, 0, 0, "Bet_");			
			mipoker.container.x = 740;
			mipoker.container.y = 570;
			mipoker.container.alpha = 0;
			
			//_tool.SetControlMc(paytable.ItemList[1]);
			//_tool.SetControlMc(mipoker.container);
			//add(_tool);		
			
			//no clean ,half in init ,cant cleanr model
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean_poker():void
		{		
			Get(modelName.PLAYER_POKER).CleanList();
			Get(modelName.PLAYER_POKER).CustomizedFun = myscale;		
			Get(modelName.PLAYER_POKER).Create_by_list(5, [ResName.just_turnpoker], 0 , 0, 5, 140, 0, "Bet_");
			Get(modelName.PLAYER_POKER).container.alpha = 0;			
			
			Get(modelName.BANKER_POKER).CleanList();
			Get(modelName.BANKER_POKER).CustomizedFun = myscale;
			Get(modelName.BANKER_POKER).Create_by_list(5, [ResName.just_turnpoker], 0 , 0, 5, 140, 0, "Bet_");
			Get(modelName.BANKER_POKER).container.alpha = 0;
			
			Get("mipoker").CleanList();		
			Get("mipoker").Create_by_list(1, [ResName.Mipoker_zone], 0 , 0, 1, 130, 0, "Bet_");			
			Get("mipoker").container.alpha = 0;
			
			_model.putValue("playerNew", false);
			_model.putValue("bankerNew", false);
			
			_model.putValue(modelName.BANKER_POKER,[]);
			_model.putValue(modelName.PLAYER_POKER, []);
			
			Get("table_hint").container.visible = false;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function poker_display():void
		{
			
			var playerCon:MultiObject = Get(modelName.PLAYER_POKER);			
			_regular.FadeIn(playerCon.container, 1, 1,null);
			
			var bankerCon:MultiObject = Get(modelName.BANKER_POKER);
			_regular.FadeIn(bankerCon.container, 1, 1,null);		
			
			Get("table_hint").container.visible = true;
		}
		
		public function myscale(mc:MovieClip, idx:int, coinstack:Array):void
		{
			utilFun.scaleXY(mc, 0.80, 0.80);
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject", selector = "poker_No_mi")]
		public function poker_no_mi(type:Intobject):void
		{
			var mypoker:Array =   _model.getValue(type.Value);		
			utilFun.Log("mypoker ="+mypoker);
			for ( var pokernum:int = 0; pokernum < mypoker.length; pokernum++)
			{				
				var pokerid:int = pokerUtil.pokerTrans(mypoker[pokernum])
				var anipoker:MovieClip = GetSingleItem(type.Value, pokernum);
				anipoker.visible = true;
				anipoker.gotoAndStop(1);
				anipoker["_poker"].gotoAndStop(pokerid);
				//anipoker["_poker_a"].gotoAndStop(pokerid);
				anipoker.gotoAndStop(anipoker.totalFrames);
					
				if (  pokernum >= 2 && (pokernum == mypoker.length -1))
				{
					move(type.Value);
					//simple_move_push_up(type.Value);
				}
			}				
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject", selector = "poker_mi")]
		public function poker_mi(type:Intobject):void
		{						
			var mypoker:Array =   _model.getValue(type.Value);			
			var pokerid:int = pokerUtil.pokerTrans(mypoker[mypoker.length - 1])					
			
			if ( mypoker.length == 4 || mypoker.length == 5)
			{
				
				Get("mipoker").CleanList();		
				Get("mipoker").Create_by_list(1, [ResName.Mipoker_zone], 0 , 0, 1, 130, 0, "Bet_");
				Get("mipoker").container.alpha = 0;
				
				if( type.Value == modelName.PLAYER_POKER)
				{
					Get("mipoker").container.x = 1200;
					Get("mipoker").container.y = 570;
				}
				if( type.Value == modelName.BANKER_POKER)
				{
					Get("mipoker").container.x = 300;
					Get("mipoker").container.y = 570;
				}
				
				var mipoker:MultiObject = Get("mipoker");
				var mc:MovieClip = mipoker.ItemList[0];
				var pokerf:MovieClip = utilFun.GetClassByString(ResName.Poker);
				var pokerb:MovieClip = utilFun.GetClassByString(ResName.poker_back);
				var pokerm:MovieClip = utilFun.GetClassByString(ResName.pokermask);
				pokerb.x  = 140;
				pokerb.y  = 64;
				pokerf.x = 140;
				pokerf.y  = 64;
				pokerm.x = 136.35;
				pokerm.y = 185.8;
				pokerf.gotoAndStop(pokerid);
				pokerf.visible = false;
				pokerf.addChild(pokerm);
				mc.addChild(pokerf);
				mc.addChild(pokerb);
				Tweener.addTween(mipoker.container, { alpha:1, time:1, onCompleteParams:[pokerf,pokerid,type.Value],onComplete:this.poker_mi_ani } );
				
				//_tool.SetControlMc(paytable.ItemList[1]);
				//_tool.SetControlMc(mipoker.container);
				//_tool.y = 200;
				//add(_tool);			
				return;
			}
			
			
			var anipoker:MovieClip = GetSingleItem(type.Value, mypoker.length - 1);
			anipoker.visible = true;
			anipoker.gotoAndStop(1);
			anipoker["_poker"].gotoAndStop(pokerid);
			anipoker.gotoAndPlay(2);
			
			_regular.Call(anipoker, { onComplete:this.showjudge, onCompleteParams:[type.Value,mypoker.length] },1,0,1);		
			return;
			
			//old pai ani
			//anipoker["_poker_a"].gotoAndStop(pokerid);
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
			//if ( pokernum >= 3) simple_move_push_up(type); //move(type);			
		}
		
		public function poker_mi_ani(pokerf:MovieClip,pokerid:int,pokertype:int):void
		{
			pokerf.visible = true;
			Tweener.addTween(pokerf, { x: (pokerf.x +50) , time:1, transition:"easeInSine" , onCompleteParams:[pokerf,pokerid,pokertype], onComplete: this.poker_mi_ani_2 } );			
		}
		
		public function poker_mi_ani_2(pokerf:MovieClip,pokerid:int,pokertype:int):void
		{
			//see 0.5 s
			Tweener.addTween(pokerf, { x: (pokerf.x +32) , time:1, delay:0.5, transition:"easeInSine",onCompleteParams:[pokerf,pokerid,pokertype],onComplete: this.sec_wait } );			
		}
		
		public function sec_wait(pokerf:MovieClip,pokerid:int, pokertype:int):void
		{
			//see 0.5 again
			Tweener.addTween(pokerf, { delay:0.5, transition:"easeInSine",onCompleteParams:[pokerf,pokerid,pokertype],onComplete: this.sec_wait_to_see } );
		}
		
		public function sec_wait_to_see(pokerf:MovieClip, pokerid:int, pokertype:int):void
		{
			//staty 0.5 to check 
			Tweener.addTween(pokerf, { delay:0.5, transition:"easeInSine",onCompleteParams:[pokerid,pokertype],onComplete: this.showfinal } );
		}
		
		public function showfinal(pokerid:int,pokertype:int):void
		{
			var mipoker:MultiObject = Get("mipoker");
			Tweener.addTween(mipoker.container, { alpha:0, time:1 } );
			var mypoker:Array =   _model.getValue(pokertype);		
			var anipoker:MovieClip = GetSingleItem(pokertype, mypoker.length -1);
			anipoker.visible = true;
			//anipoker.gotoAndStop(23);						
			//anipoker["_poker_a"].gotoAndStop(pokerid);	
			anipoker.gotoAndStop(1);
			anipoker["_poker"].gotoAndStop(pokerid);	
			anipoker.gotoAndStop(anipoker.totalFrames);			
			
			move(pokertype);
			//simple_move_push_up(pokertype);
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
		
		public function simple_move_push_up(cardtype:int):void
		{				
			var mypoker:Array =   _model.getValue(cardtype);			
			var bnew:Boolean = true;
			if ( cardtype == modelName.PLAYER_POKER) bnew = _model.getValue("playerNew");
			if ( cardtype == modelName.BANKER_POKER) bnew = _model.getValue("bankerNew");			
			
			var po:Array = [];
			var pokerlist:MultiObject ;
			var k:int ;
			if ( mypoker.length == 3 && bnew == false)
			{
				
				//for (var i:int = 0; i < mypoker.length; i++) po.push(i);
				var point:Array = pokerUtil.get_Point(mypoker);
				var totalPoint:int = pokerUtil.Get_Mapping_Value([0,1,2], point);
				if ( totalPoint % 10 == 0)
				{
					pokerlist = Get(cardtype)
					for ( k = 0; k <3; k++)
					{
						Tweener.addTween(pokerlist.ItemList[k], { y:pokerlist.ItemList[k].y + 25, transition:"linear", time:0.1 } );			
					}
					
					//for (var k:int = 3; k <5; k++)
					//{
						//Tweener.addTween(pokerlist.ItemList[k], {  y:pokerlist.ItemList[k].y + 25, transition:"linear", time:0.1 } );						
					//}
					//shakeTween(pokerlist.ItemList[4], 200);
					if ( cardtype == modelName.PLAYER_POKER)  _model.putValue("playerNew", true);
					if ( cardtype == modelName.BANKER_POKER)  _model.putValue("bankerNew", true);
				}
			}
			
			if ( mypoker.length >= 4 && bnew == false)
			{				
				var total:Array = [0, 1, 2, 3, 4];  //num
				for (k= 0; k < mypoker.length; k++) po.push(k);				
				var newpoker:Array = pokerUtil.newnew_judge(mypoker, po);				
				if ( newpoker.length != 0)
				{					
					var selectCard:Array = newpoker.slice(0, 3);
					var rest:Array = utilFun.Get_restItem(total, selectCard)					
					//utilFun.Log("selectCard ="+selectCard);
					//utilFun.Log("rest =" + rest);
					pokerlist = Get(cardtype);
					
					for (var j:int = 0; j <selectCard.length; j++)
					{						
						Tweener.addTween(pokerlist.ItemList[selectCard[j]], { y:pokerlist.ItemList[selectCard[j]].y + 25 , transition:"linear", time:0.2 } );
					}
					//隨挑選結果不同
					//for (var k:int = 0; k <rest.length; k++)
					//{
						//Tweener.addTween(pokerlist.ItemList[rest[k]], {  y:pokerlist.ItemList[rest[k]].y + 25, transition:"linear", time:0.1 } );
					//}
					
					if ( cardtype == modelName.PLAYER_POKER)  _model.putValue("playerNew", true);
					if ( cardtype == modelName.BANKER_POKER) _model.putValue("bankerNew", true);					
				}				
				
			}
		}
		
		public function move(cardtype:int):void
		{			
			var mypoker:Array =   _model.getValue(cardtype);
			var bnew:Boolean 
			if ( cardtype == modelName.PLAYER_POKER) bnew = _model.getValue("playerNew");
			if ( cardtype == modelName.BANKER_POKER) bnew = _model.getValue("bankerNew");			
			
			var po:Array = [];
			var k:int;
			var pokerlist:MultiObject ;
			if ( mypoker.length ==3 && bnew == false)
			{				
				for (k = 0; k < mypoker.length; k++) po.push(k);
				var point:Array = pokerUtil.get_Point(mypoker);
				var totalPoint:int = pokerUtil.Get_Mapping_Value(po, point);				
				if ( totalPoint % 10 == 0)
				{
					pokerlist= Get(cardtype)
					//[160,80]
					for (k = 0; k <3; k++)
					{
						Tweener.addTween(pokerlist.ItemList[k], { y:pokerlist.ItemList[k].y + 80, x:pokerlist.ItemList[k].x +160, transition:"easeOutQuint", time:1 } );
					}
					
					//[230,-130]
					for ( k = 3; k <5; k++)
					{
						Tweener.addTween(pokerlist.ItemList[k], { y:pokerlist.ItemList[k].y - 130, x:pokerlist.ItemList[k].x - 190, transition:"easeOutQuint", time:1 } );
							//change 50 to 200 or 5 to see how it works
						
					}
					//shakeTween(pokerlist.ItemList[4], 200);
					if ( cardtype == modelName.PLAYER_POKER)  _model.putValue("playerNew", true);
					if ( cardtype == modelName.BANKER_POKER)  _model.putValue("bankerNew", true);
					
						
				}
					
				
					//_tool.SetControlMc(pokerlist.ItemList[0]);
					//_tool.SetControlMc(bankerCon.container);
					//add(_tool);		
			}
			
			if ( mypoker.length >= 4 && bnew == false)
			{
				
				var total:Array = [0, 1, 2, 3, 4];  //num
				for ( k = 0; k < mypoker.length; k++) po.push(k);				
				var newpoker:Array = pokerUtil.newnew_judge(mypoker, po);				
				if ( newpoker.length != 0)
				{									
					var selectCard:Array = newpoker.slice(0, 3);
					var rest:Array = utilFun.Get_restItem(total,selectCard)
						
					//[160,80]
					po = [ [200, 80], [340, 80], [480, 80]];
					pokerlist = Get(cardtype)					
					for ( k = 0; k <selectCard.length; k++)
					{
						Tweener.addTween(pokerlist.ItemList[selectCard[k]], {x:po[k][0], y:po[k][1] , transition:"easeOutQuint", time:1 } );
					}
					
					
					
					//隨挑選結果不同
					//[230,-130]
					var po2:Array = [ [260, -130], [400, -130]];				
					for ( k = 0; k <rest.length; k++)
					{
						Tweener.addTween(pokerlist.ItemList[rest[k]], {  x:po2[k][0] ,y:po2[k][1] , transition:"easeOutQuint", time:1 } );
					}
					//_tool.SetControlMc(pokerlist.ItemList[rest[1]]);					
					//add(_tool);	
					//var toos:AdjustTool = new AdjustTool();
						//toos.SetControlMc(pokerlist.ItemList[2]);
						//add(toos);
					//
					if ( cardtype == modelName.PLAYER_POKER)  _model.putValue("playerNew", true);
					if ( cardtype == modelName.BANKER_POKER)  _model.putValue("bankerNew", true);					
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