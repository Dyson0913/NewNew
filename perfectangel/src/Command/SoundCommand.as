package Command 
{
	import flash.events.Event;
	import Model.*;
	import Model.valueObject.StringObject;
	import treefortress.sound.SoundTween;
	
	import util.*;	
	
	import treefortress.sound.SoundAS;
     import treefortress.sound.SoundInstance;
     import treefortress.sound.SoundManager;

	 
	/**
	 * sound play
	 * @author hhg4092
	 */
	public class SoundCommand 
	{
		[MessageDispatcher]
        public var dispatcher:Function;
		
		[Inject]
		public var _model:Model;
		
		
		public function SoundCommand() 
		{
			
		}
		
		
		public function init():void
		{
			SoundAS.addSound("Soun_Bet_BGM", new Soun_Bet_BGM());
			SoundAS.addSound("sound_coin", new sound_coin());
			SoundAS.addSound("sound_msg", new sound_msg());
			SoundAS.addSound("sound_rebet", new sound_rebet());			
		}
		
		[MessageHandler(type="Model.valueObject.StringObject",selector="Music")]
		public function playMusic(sound:StringObject):void
		{
			
			//var s:SoundTween  = SoundAS.addTween(sound.Value);			
			
			var ss:SoundInstance = SoundAS.playLoop(sound.Value);
			
		}
		
		[MessageHandler(type="Model.valueObject.StringObject",selector="Music_pause")]
		public function stopMusic(sound:StringObject):void
		{
			SoundAS.pause(sound.Value);
		}
		
		[MessageHandler(type="Model.valueObject.StringObject",selector="sound")]
		public function playSound(sound:StringObject):void
		{
			SoundAS.playFx(sound.Value);
		}
		
	}

}