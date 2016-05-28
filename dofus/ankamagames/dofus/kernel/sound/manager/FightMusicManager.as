package com.ankamagames.dofus.kernel.sound.manager
{
   import com.ankamagames.jerakine.BalanceManager.BalanceManager;
   import com.ankamagames.tubul.interfaces.ISound;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.dofus.kernel.sound.utils.SoundUtil;
   import com.ankamagames.dofus.kernel.sound.TubulSoundConfiguration;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.tubul.factory.SoundFactory;
   import com.ankamagames.tubul.enum.EnumSoundType;
   import com.ankamagames.dofus.kernel.sound.type.SoundDofus;
   
   public class FightMusicManager
   {
       
      private var _fightMusicsId:Array;
      
      private var _fightMusicBalanceManager:BalanceManager;
      
      private var _actualFightMusic:ISound;
      
      private var _actualFightMusicId:String;
      
      public function FightMusicManager()
      {
         super();
         this.init();
      }
      
      public function playFightMusic() : void
      {
         if(!SoundManager.getInstance().manager.soundIsActivate)
         {
            return;
         }
         if(SoundManager.getInstance().manager is RegSoundManager && !RegConnectionManager.getInstance().isMain)
         {
            return;
         }
         var soundId:String = this._fightMusicBalanceManager.callItem() as String;
         var busId:uint = SoundUtil.getBusIdBySoundId(soundId);
         if(busId != TubulSoundConfiguration.BUS_MUSIC_ID)
         {
            trace("FightMusicManager");
         }
         var soundPath:String = SoundUtil.getConfigEntryByBusId(busId);
         var soundUri:Uri = new Uri(soundPath + soundId + ".mp3");
         if(SoundManager.getInstance().manager is ClassicSoundManager)
         {
            this._actualFightMusic = SoundFactory.getSound(EnumSoundType.UNLOCALIZED_SOUND,soundUri);
         }
         if(SoundManager.getInstance().manager is RegSoundManager)
         {
            this._actualFightMusic = new SoundDofus(soundId);
         }
         this._actualFightMusic.bus = busId;
         this._actualFightMusic.volume = 1;
         this._actualFightMusic.fadeVolume = 0;
         this._actualFightMusic.play(true);
         this._actualFightMusic.fadeSound(1,2);
         SoundManager.getInstance().manager.fadeBusVolume(TubulSoundConfiguration.BUS_AMBIENT_2D_ID,0,2);
         SoundManager.getInstance().manager.fadeBusVolume(TubulSoundConfiguration.BUS_MUSIC_ID,0,2);
      }
      
      public function stopFightMusic() : void
      {
         if(!SoundManager.getInstance().manager.soundIsActivate || this._actualFightMusic == null)
         {
            return;
         }
         if(SoundManager.getInstance().manager is RegSoundManager && !RegConnectionManager.getInstance().isMain)
         {
            return;
         }
         this._actualFightMusic.stop(0,2);
         SoundManager.getInstance().manager.fadeBusVolume(TubulSoundConfiguration.BUS_AMBIENT_2D_ID,1,2);
         SoundManager.getInstance().manager.fadeBusVolume(TubulSoundConfiguration.BUS_MUSIC_ID,1,2);
      }
      
      private function init() : void
      {
         this._fightMusicsId = new Array("29001");
         this._fightMusicBalanceManager = new BalanceManager(this._fightMusicsId);
      }
   }
}
