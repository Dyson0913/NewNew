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
		//res name
		public const open_tableitem:String = "open_table_item";
		public const opentable_angel:String = "open_table_angel";
		public const opentable_evil:String = "open_table_evil";
		
		public const just_turnpoker:String = "just_turn_poker"
		public const Mipoker_zone:String = "Mi_poker_zone"
		
		//down 3 up2
		private var newnew_position:Array = [ [140, 80], [280, 80], [420, 80], [210, -130], [350, -130]];
		
		public function Visual_poker() 
		{
			
		}
		
		public function init():void
		{
			
			
			var playerCon:MultiObject = create(modelName.PLAYER_POKER, [just_turnpoker]);
			playerCon.CustomizedFun = myscale;
			playerCon.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			playerCon.Post_CustomizedData = [5, 140, 0];
			playerCon.Create_(5, "playerpoker");
			playerCon.container.x = 190;
			playerCon.container.y = 680;
			playerCon.container.alpha = 0;
			//
			var bankerCon:MultiObject =  create(modelName.BANKER_POKER, [just_turnpoker]);
			bankerCon.CustomizedFun = myscale;
			bankerCon.Posi_CustzmiedFun = _regular.Posi_Row_first_Setting;
			bankerCon.Post_CustomizedData = [5, 140, 0];
			bankerCon.Create_(5, "bankerpoker");
			bankerCon.container.x = 1040;
			bankerCon.container.y = 680;
			bankerCon.container.alpha = 0;
			
			//桌面物件
			var table_hint:MultiObject = create("table_hint", [open_tableitem]);
			table_hint.autoClean = true;
			table_hint.CleanList();
			table_hint.Create_(1, "table_hint");
			table_hint.container.x = 450;
			table_hint.container.y = 590;	
			table_hint.container.visible = false;
			
			var side_symble:MultiObject = create("side_symble", [opentable_angel, opentable_evil]);
			side_symble.CustomizedFun = _regular.Posi_Row_first_Setting;
			side_symble.CustomizedData = [2, 850, 0];
			side_symble.Create_(2, "side_symble");
			side_symble.container.x = 454;
			side_symble.container.y = 950;	
			side_symble.container.visible = false;
			
			var mipoker:MultiObject =  create("mipoker",  [Mipoker_zone]);		
			mipoker.Create_(1, "mipoker");
			mipoker.container.x = 740;
			mipoker.container.y = 570;
			mipoker.container.alpha = 0;
			
			put_to_lsit(table_hint);
			put_to_lsit(mipoker);
			put_to_lsit(playerCon);
			put_to_lsit(bankerCon);
			put_to_lsit(side_symble);
			
			//no clean ,half in init ,cant cleanr model
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "clearn")]
		public function Clean_poker():void
		{		
			var ppoker:MultiObject = Get(modelName.PLAYER_POKER);
			ppoker.CleanList();
			ppoker.CustomizedFun = myscale;		
			ppoker.Create_by_list(5, [just_turnpoker], 0 , 0, 5, 140, 0, "Bet_");
			Tweener.pauseTweens(ppoker.container);
			ppoker.container.alpha = 0;			
			
			var bpoker:MultiObject = Get(modelName.BANKER_POKER);
			bpoker.CleanList();
			bpoker.CustomizedFun = myscale;
			bpoker.Create_by_list(5, [just_turnpoker], 0 , 0, 5, 140, 0, "Bet_");
			Tweener.pauseTweens(bpoker.container);
			bpoker.container.alpha = 0;
			
			Get("mipoker").CleanList();		
			Get("mipoker").Create_by_list(1, [Mipoker_zone], 0 , 0, 1, 130, 0, "Bet_");			
			Get("mipoker").container.alpha = 0;
			
			_model.putValue("playerNew", false);
			_model.putValue("bankerNew", false);
			
			_model.putValue(modelName.BANKER_POKER,[]);
			_model.putValue(modelName.PLAYER_POKER, []);
			
			Get("table_hint").container.visible = false;
			Get("side_symble").container.visible = false;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "hide")]
		public function poker_display():void
		{
			
			var playerCon:MultiObject = Get(modelName.PLAYER_POKER);			
			_regular.FadeIn(playerCon.container, 1, 1,null);
			
			var bankerCon:MultiObject = Get(modelName.BANKER_POKER);
			_regular.FadeIn(bankerCon.container, 1, 1,null);		
			
			Get("table_hint").container.visible = true;
			Get("side_symble").container.visible = true;
		}
		
		[MessageHandler(type = "Model.ModelEvent", selector = "round_result")]
		public function resut():void
		{
			Get("side_symble").container.visible = false;
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
				Get("mipoker").Create_by_list(1, [Mipoker_zone], 0 , 0, 1, 130, 0, "Bet_");
				Get("mipoker").container.alpha = 0;
				
				if( type.Value == modelName.PLAYER_POKER)
				{
					Get("mipoker").container.x = 640;
					Get("mipoker").container.y = 780;
				}
				if( type.Value == modelName.BANKER_POKER)
				{
					Get("mipoker").container.x = 930;
					Get("mipoker").container.y = 780;					
				}
				
				var mipoker:MultiObject = Get("mipoker");
				var mc:MovieClip = mipoker.ItemList[0];
				var pokerf:MovieClip = utilFun.GetClassByString(ResName.Poker);
				var pokerb:MovieClip = utilFun.GetClassByString(ResName.poker_back);
				var pokerm:MovieClip = utilFun.GetClassByString(ResName.pokermask);
				pokerb.x  = 40;
				pokerb.y  = 24;
				pokerf.x = pokerb.x;
				pokerf.y  = pokerb.y;
				pokerm.x = 136.35;
				pokerm.y = 185.8;
				pokerf.gotoAndStop(pokerid);
				pokerf.visible = false;
				pokerf.addChild(pokerm);
				mc.addChild(pokerf);
				mc.addChild(pokerb);
				
				Tweener.addTween(mipoker.container, { alpha:1, time:1, onCompleteParams:[pokerf,pokerid,type.Value],onComplete:this.poker_mi_ani } );
				
				
				//_tool.SetControlMc(pokerb);
				//_tool.y = 200;
				//add(_tool);
				
				return;
			}
			
			
			var anipoker:MovieClip = GetSingleItem(type.Value, mypoker.length - 1);
			anipoker.visible = true;
			anipoker.gotoAndStop(1);
			anipoker["_poker"].gotoAndStop(pokerid);
			anipoker.gotoAndPlay(2);
			
			dispatcher(new StringObject("sound_poker_turn","sound" ) );
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
			//Tweener.addTween(pokerf, { delay:0.5 } );
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
		}		
		
		public function move(cardtype:int):void
		{			
			var mypoker:Array =   _model.getValue(cardtype);
			var bnew:Boolean ;
			if ( cardtype == modelName.PLAYER_POKER) bnew = _model.getValue("playerNew");
			if ( cardtype == modelName.BANKER_POKER) bnew = _model.getValue("bankerNew");			
			
			if ( bnew ) return ;
			
			var total:Array = [0, 1, 2, 3, 4];
			total	= total.slice(0, mypoker.length);
			//utilFun.Log("total = "+total);
			var newpoker:Array = pokerUtil.newnew_judge(mypoker, total);				
			
			//utilFun.Log("newpoker = "+newpoker.length);
			if ( newpoker.length == 0) return;
			
			var selectCard:Array = newpoker.slice(0, 3);
			var rest:Array = utilFun.Get_restItem([0, 1, 2, 3, 4], selectCard)			
			selectCard = selectCard.concat(rest);
			//utilFun.Log("con " + selectCard);
			
			var please:Array = [];
			for ( var i:int = 0; i < selectCard.length; i++)
			{				
				please.push(newnew_position[selectCard.indexOf(i)]);
			}
			
			var pokerlist:MultiObject = Get(cardtype);					
			for (var k:int = 0; k <5; k++)
			{						
				Tweener.addTween(pokerlist.ItemList[[k]], {x:please[k][0], y:please[k][1] , transition:"easeOutCubic", time:1 } );
			}
			
			if ( cardtype == modelName.PLAYER_POKER)  _model.putValue("playerNew", true);
			if ( cardtype == modelName.BANKER_POKER)  _model.putValue("bankerNew", true);
			
			dispatcher(new StringObject("sound_msg","sound" ) );
		}
		
		[MessageHandler(type = "Model.valueObject.Intobject", selector = "Extra_poker")]
		public function extra_poker(type:Intobject):void
		{
			
			var mypoker:Array =   _model.getValue(type.Value);
			utilFun.Log("extra_poker = " + mypoker[0]);	
			var pokerid:int = 0;	
			var point:String =   mypoker[0].substr(0, 1);
			if ( point == "i") pokerid = 10;
			else if ( point == "j") pokerid = 11;
			else if ( point == "q") pokerid = 12;
			else if ( point == "k") pokerid = 13;
			else pokerid = parseInt(point);
			
			
			utilFun.Log("pokerid = "+pokerid);
			_model.putValue("light_idx", pokerid);
			
			dispatcher(new ModelEvent("run_light"));
		}
		
	}

}