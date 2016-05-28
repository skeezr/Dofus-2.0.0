package com.ankamagames.dofus.kernel.sound.manager
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.datacenter.ambientSounds.AmbientSound;
   import com.ankamagames.tubul.interfaces.ISound;
   import com.ankamagames.dofus.kernel.sound.utils.SoundUtil;
   import com.ankamagames.dofus.kernel.sound.TubulSoundConfiguration;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.tubul.factory.SoundFactory;
   import com.ankamagames.tubul.enum.EnumSoundType;
   import com.ankamagames.dofus.kernel.sound.type.SoundDofus;
   
   public class AmbientSoundsManager
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(AmbientSoundsManager));
       
      private var _useCriterion:Boolean = false;
      
      private var _criterionID:uint;
      
      private var _ambientSounds:Vector.<AmbientSound>;
      
      private var _music:ISound;
      
      private var _previousMusic:ISound;
      
      private var _ambience:ISound;
      
      private var _previousAmbience:ISound;
      
      private var _musicA:AmbientSound;
      
      private var _ambienceA:AmbientSound;
      
      private var _previousMusicId:int;
      
      private var _previousAmbienceId:int;
      
      public function AmbientSoundsManager()
      {
         super();
         this.init();
      }
      
      public function get music() : ISound
      {
         return this._music;
      }
      
      public function get ambience() : ISound
      {
         return this._ambience;
      }
      
      public function get criterionID() : uint
      {
         return this._criterionID;
      }
      
      public function set criterionID(pCriterionID:uint) : void
      {
         this._criterionID = pCriterionID;
      }
      
      public function get ambientSounds() : Vector.<AmbientSound>
      {
         return this._ambientSounds;
      }
      
      public function setAmbientSounds(pSubAreaSounds:Vector.<AmbientSound>, pMapSounds:Vector.<AmbientSound>) : void
      {
         var aSoundSub:AmbientSound = null;
         var aSoundMap:AmbientSound = null;
         if(pSubAreaSounds.length == 0)
         {
            this._ambientSounds = pMapSounds;
         }
         else
         {
            for each(aSoundSub in pSubAreaSounds)
            {
               for each(aSoundMap in pMapSounds)
               {
                  if(aSoundSub.channel == aSoundMap.channel && (aSoundSub.criterionId == aSoundMap.criterionId || !this._useCriterion))
                  {
                     pSubAreaSounds.splice(pSubAreaSounds.indexOf(aSoundSub),1);
                  }
               }
            }
            this._ambientSounds = pSubAreaSounds.concat(pMapSounds);
         }
      }
      
      public function selectValidSounds() : void
      {
         var ambientSound:AmbientSound = null;
         for each(ambientSound in this._ambientSounds)
         {
            if(!this._useCriterion || ambientSound.criterionId == this._criterionID)
            {
               ambientSound.channel = SoundUtil.getBusIdBySoundId(ambientSound.id.toString());
               if(ambientSound.channel == TubulSoundConfiguration.BUS_AMBIENT_2D_ID)
               {
                  this._ambienceA = ambientSound;
               }
               if(ambientSound.channel == TubulSoundConfiguration.BUS_MUSIC_ID)
               {
                  this._musicA = ambientSound;
               }
            }
         }
      }
      
      public function playMusicAndAmbient() : void
      {
         var soundPathA:String = null;
         var soundUriA:Uri = null;
         var f:Number = NaN;
         var soundPathM:String = null;
         var soundUriM:Uri = null;
         if(!SoundManager.getInstance().manager.soundIsActivate)
         {
            return;
         }
         if(SoundManager.getInstance().manager is RegSoundManager && !RegConnectionManager.getInstance().isMain)
         {
            return;
         }
         if(this._ambienceA == null)
         {
            _log.warn("It\'s seems that we haven\'t any ambience for this area");
         }
         else
         {
            if(this._previousAmbienceId == this._ambienceA.id)
            {
               _log.warn("The ambiance is the same that previously");
            }
            else
            {
               if(this._previousAmbience != null)
               {
                  this._previousAmbience.stop(0,2);
               }
               soundPathA = SoundUtil.getConfigEntryByBusId(this._ambienceA.channel);
               soundUriA = new Uri(soundPathA + this._ambienceA.id + ".mp3");
               if(SoundManager.getInstance().manager is ClassicSoundManager)
               {
                  this._ambience = SoundFactory.getSound(EnumSoundType.UNLOCALIZED_SOUND,soundUriA);
                  this._ambience.bus = this._ambienceA.channel;
               }
               if(SoundManager.getInstance().manager is RegSoundManager)
               {
                  this._ambience = new SoundDofus(String(this._ambienceA.id));
               }
               this._ambience.setSilence(this._ambienceA.silenceMin * 60,this._ambienceA.silenceMax * 60);
               this._ambience.volume = this._ambienceA.volume / 100;
               this._ambience.fadeVolume = 0;
               this._ambience.play(true);
               this._ambience.fadeSound(1,2);
            }
            this._previousAmbienceId = this._ambienceA.id;
         }
         this._previousAmbience = this._ambience;
         if(this._musicA == null)
         {
            _log.warn("It\'s seems that we haven\'t any music for this area");
         }
         else
         {
            if(this._previousMusicId == this._musicA.id)
            {
               _log.warn("The music is the same that previously");
            }
            else
            {
               if(this._previousMusic != null)
               {
                  this._previousMusic.stop(0,2);
               }
               soundPathM = SoundUtil.getConfigEntryByBusId(this._musicA.channel);
               soundUriM = new Uri(soundPathM + this._musicA.id + ".mp3");
               if(SoundManager.getInstance().manager is ClassicSoundManager)
               {
                  this._music = SoundFactory.getSound(EnumSoundType.UNLOCALIZED_SOUND,soundUriM);
                  this._music.bus = this._musicA.channel;
               }
               if(SoundManager.getInstance().manager is RegSoundManager)
               {
                  this._music = new SoundDofus(String(this._musicA.id));
               }
               this._music.setSilence(this._musicA.silenceMin * 60,this._musicA.silenceMax * 60);
               this._music.volume = this._musicA.volume / 100;
               this._music.fadeVolume = 0;
               this._music.play(true,2,true);
               this._music.fadeSound(1,2);
            }
            this._previousMusicId = this._musicA.id;
         }
         this._previousMusic = this._music;
      }
      
      public function stopMusicAndAmbient() : void
      {
         if(this.ambience)
         {
            this.ambience.stop();
         }
         if(this.music)
         {
            this.music.stop();
         }
      }
      
      public function mergeSoundsArea(pAmbientSounds:Vector.<AmbientSound>) : void
      {
      }
      
      public function clear(pFade:Number = 0, pFadeTime:Number = 0) : void
      {
         this.stopMusicAndAmbient();
      }
      
      private function init() : void
      {
      }
   }
}
