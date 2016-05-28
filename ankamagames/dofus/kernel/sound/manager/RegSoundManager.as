package com.ankamagames.dofus.kernel.sound.manager
{
   import flash.events.EventDispatcher;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.Dictionary;
   import com.ankamagames.tubul.types.PlayList;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.atouin.data.map.Map;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.kernel.sound.type.SoundDofus;
   import com.ankamagames.tubul.interfaces.ISound;
   import com.ankamagames.jerakine.protocolAudio.ProtocolEnum;
   import flash.geom.Point;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.events.Event;
   import com.ankamagames.dofus.kernel.sound.utils.SoundUtil;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.tubul.factory.SoundFactory;
   import com.ankamagames.tubul.enum.EnumSoundType;
   import com.ankamagames.tubul.events.AudioBusEvent;
   import com.ankamagames.tubul.events.SoundCompleteEvent;
   
   public class RegSoundManager extends EventDispatcher implements com.ankamagames.dofus.kernel.sound.manager.ISoundManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(RegSoundManager));
      
      private static var _self:com.ankamagames.dofus.kernel.sound.manager.ISoundManager;
       
      private var _previousSubareaId:int;
      
      private var _criterionSubarea:int;
      
      private var _entitySounds:Array;
      
      private var _reverseEntitySounds:Dictionary;
      
      private var _entityDictionary:Dictionary;
      
      private var _adminSounds:Dictionary;
      
      private var _ambientManager:com.ankamagames.dofus.kernel.sound.manager.AmbientSoundsManager;
      
      private var _localizedSoundsManager:com.ankamagames.dofus.kernel.sound.manager.LocalizedSoundsManager;
      
      private var _fightMusicManager:com.ankamagames.dofus.kernel.sound.manager.FightMusicManager;
      
      private var _forceSounds:Boolean = true;
      
      private var _soundDirectoryExist:Boolean = false;
      
      private var _indoor:int = 0.0;
      
      private var _inFight:Boolean;
      
      private var _adminPlaylist:PlayList;
      
      public function RegSoundManager()
      {
         super();
         this.init();
      }
      
      public function set soundDirectoryExist(pExists:Boolean) : void
      {
         this._soundDirectoryExist = pExists;
      }
      
      public function get soundDirectoryExist() : Boolean
      {
         return this._soundDirectoryExist;
      }
      
      public function get soundIsActivate() : Boolean
      {
         return this.checkIfAvailable();
      }
      
      public function get entitySounds() : Array
      {
         return this._entitySounds;
      }
      
      public function get reverseEntitySounds() : Dictionary
      {
         return this._reverseEntitySounds;
      }
      
      public function set forceSoundsDebugMode(pForce:Boolean) : void
      {
         this._forceSounds = pForce;
      }
      
      public function activateSound() : void
      {
         this._forceSounds = true;
         if(this._localizedSoundsManager != null && Boolean(this._localizedSoundsManager.isInitialized))
         {
            this._localizedSoundsManager.playLocalizedSounds();
         }
         if(this._ambientManager != null)
         {
            this._ambientManager.playMusicAndAmbient();
         }
         if(this._fightMusicManager != null && Boolean(this._inFight))
         {
            this._fightMusicManager.playFightMusic();
         }
         SoundManager.getInstance().setSoundOptions();
      }
      
      public function deactivateSound() : void
      {
         if(this._localizedSoundsManager != null && Boolean(this._localizedSoundsManager.isInitialized))
         {
            this._localizedSoundsManager.stopLocalizedSounds();
         }
         if(this._ambientManager != null)
         {
            this._ambientManager.stopMusicAndAmbient();
         }
         if(this._fightMusicManager != null && Boolean(this._inFight))
         {
            this._fightMusicManager.stopFightMusic();
         }
      }
      
      public function setSubArea(pMap:Map = null) : void
      {
         var mp:MapPosition = MapPosition.getMapPositionById(pMap.id);
         this.removeLocalizedSounds();
         this._localizedSoundsManager.setMap(pMap);
         if(Boolean(this.soundIsActivate) && Boolean(RegConnectionManager.getInstance().isMain))
         {
            this._localizedSoundsManager.playLocalizedSounds();
         }
         this._previousSubareaId = pMap.subareaId;
         this._criterionSubarea = 1;
         var subArea:SubArea = SubArea.getSubAreaById(pMap.subareaId);
         if(subArea == null)
         {
            return;
         }
         this._ambientManager.setAmbientSounds(subArea.ambientSounds,mp.sounds);
         this._ambientManager.selectValidSounds();
         this._ambientManager.playMusicAndAmbient();
      }
      
      public function playUISound(pSoundId:String, pLoop:Boolean = false) : void
      {
         if(!this.checkIfAvailable())
         {
            return;
         }
         var newSound:SoundDofus = new SoundDofus(pSoundId);
         newSound.play(pLoop);
      }
      
      public function playSound(pSound:ISound, pLoop:Boolean = false, pLoops:int = -1) : ISound
      {
         var prop:* = null;
         if(!this.checkIfAvailable())
         {
            return null;
         }
         var soundID:String = pSound.uri.fileName.split(".mp3")[0];
         var newSound:SoundDofus = new SoundDofus(soundID,true);
         for(prop in pSound)
         {
            if(newSound.hasOwnProperty(prop))
            {
               newSound[prop] = pSound;
            }
         }
         newSound.play(pLoop,pLoops);
         return newSound;
      }
      
      public function playFightMusic() : void
      {
         this._inFight = true;
         this._fightMusicManager.playFightMusic();
      }
      
      public function stopFightMusic() : void
      {
         this._inFight = false;
         this._fightMusicManager.stopFightMusic();
      }
      
      public function handleFLAEvent(pParams:String, pSprite:Object = null) : void
      {
         if(!(Boolean(this.soundIsActivate) && Boolean(RegConnectionManager.getInstance().isMain)))
         {
            return;
         }
         if(!pSprite.hasOwnProperty("absoluteBounds"))
         {
            return;
         }
         var posX:Number = pSprite.absoluteBounds.x;
         var posY:Number = pSprite.absoluteBounds.y;
         var entityId:int = pSprite.id;
         pParams = pParams + "*";
         RegConnectionManager.getInstance().send(ProtocolEnum.FLA_EVENT,pParams,entityId,posX,posY);
      }
      
      public function applyDynamicMix(pFadeIn:Number, pFadeInTime:uint, pWaitingTime:uint, pFadeOutTime:uint) : void
      {
         RegConnectionManager.getInstance().send(ProtocolEnum.DYNAMIC_MIX,RegConnectionManager.getInstance().socketClientID,pFadeIn,pFadeInTime,pWaitingTime,pFadeOutTime);
      }
      
      public function retriveRollOffPresets() : void
      {
      }
      
      public function setSoundSourcePosition(pEntityId:int, pPosition:Point) : void
      {
         if(!this.checkIfAvailable())
         {
            return;
         }
         if(pEntityId == PlayedCharacterManager.getInstance().id)
         {
            RegConnectionManager.getInstance().send(ProtocolEnum.SET_PLAYER_POSITION,RegConnectionManager.getInstance().socketClientID,pPosition.x,pPosition.y);
         }
         else
         {
            RegConnectionManager.getInstance().send(ProtocolEnum.SET_SOUND_SOURCE_POSITION,RegConnectionManager.getInstance().socketClientID,pEntityId,pPosition.x,pPosition.y);
         }
      }
      
      public function addSoundEntity(pISound:ISound, pEntityId:int) : void
      {
         if(!this.checkIfAvailable())
         {
            return;
         }
         if(this._entitySounds[pEntityId] == null)
         {
            this._entitySounds[pEntityId] = new Vector.<ISound>();
         }
         this._entityDictionary[DofusEntities.getEntity(pEntityId)] = this._entitySounds[pEntityId];
         this._entitySounds[pEntityId].push(pISound);
         this._reverseEntitySounds[pISound] = pEntityId;
      }
      
      public function removeSoundEntity(pISound:ISound) : void
      {
         var isound:ISound = null;
         var entityId:int = this._reverseEntitySounds[pISound];
         if(!this._entitySounds[entityId])
         {
            return;
         }
         for each(isound in this._entitySounds[entityId])
         {
            if(isound == pISound)
            {
               isound.stop();
               this._entitySounds[entityId].splice(this._entitySounds[entityId].indexOf(isound),1);
               delete this._reverseEntitySounds[pISound];
               if(this._entitySounds[entityId].length == 0)
               {
                  this._entitySounds[entityId] = null;
               }
               return;
            }
         }
      }
      
      public function removeEntitySound(pEntityId:IEntity) : void
      {
         var isound:ISound = null;
         if(this._entityDictionary[pEntityId] == null)
         {
            return;
         }
         for each(isound in this._entityDictionary[pEntityId])
         {
            isound.stop(0,0.1);
         }
         delete this._entityDictionary[pEntityId];
      }
      
      public function retriveXMLSounds() : void
      {
      }
      
      private function playIntro() : void
      {
      }
      
      public function playIntroMusic(pFirstHarmonic:Boolean = true) : void
      {
         if(!(Boolean(this.soundIsActivate) || Boolean(RegConnectionManager.getInstance().isMain)))
         {
            return;
         }
         RegConnectionManager.getInstance().send(ProtocolEnum.PLAY_INTRO,RegConnectionManager.getInstance().socketClientID);
      }
      
      public function switchIntroMusic(pFirstHarmonic:Boolean) : void
      {
         if(!(Boolean(this.soundIsActivate) || Boolean(RegConnectionManager.getInstance().isMain)))
         {
            return;
         }
         RegConnectionManager.getInstance().send(ProtocolEnum.SWITCH_INTRO,RegConnectionManager.getInstance().socketClientID,pFirstHarmonic);
      }
      
      public function stopIntroMusic() : void
      {
         if(!this.checkIfAvailable())
         {
            return;
         }
         RegConnectionManager.getInstance().send(ProtocolEnum.STOP_INTRO,RegConnectionManager.getInstance().socketClientID);
      }
      
      public function removeAllSounds(pFade:Number = 0, pFadeTime:Number = 0) : void
      {
         RegConnectionManager.getInstance().send(ProtocolEnum.REMOVE_ALL_SOUNDS,RegConnectionManager.getInstance().socketClientID);
      }
      
      public function fadeBusVolume(pBusID:int, pFade:Number, pFadeTime:Number) : void
      {
         RegConnectionManager.getInstance().send(ProtocolEnum.FADE_BUS,pBusID,pFade,pFadeTime);
      }
      
      public function setBusVolume(pBusID:int, pNewVolume:Number) : void
      {
         RegConnectionManager.getInstance().send(ProtocolEnum.SET_BUS_VOLUME,pBusID,pNewVolume);
      }
      
      public function reset() : void
      {
         this.removeAllSounds();
      }
      
      private function init() : void
      {
         this._previousSubareaId = -1;
         this._localizedSoundsManager = new com.ankamagames.dofus.kernel.sound.manager.LocalizedSoundsManager();
         this._ambientManager = new com.ankamagames.dofus.kernel.sound.manager.AmbientSoundsManager();
         this._fightMusicManager = new com.ankamagames.dofus.kernel.sound.manager.FightMusicManager();
         this._entitySounds = new Array();
         this._reverseEntitySounds = new Dictionary();
         this._adminSounds = new Dictionary();
         this._entityDictionary = new Dictionary();
         StageShareManager.stage.nativeWindow.addEventListener(Event.CLOSE,this.onClose);
         RegConnectionManager.getInstance().send(ProtocolEnum.SAY_HELLO,RegConnectionManager.getInstance().socketClientID);
      }
      
      private function removeLocalizedSounds() : void
      {
         this._entitySounds = new Array();
         this._reverseEntitySounds = new Dictionary();
         RegConnectionManager.getInstance().send(ProtocolEnum.REMOVE_LOCALIZED_SOUNDS,RegConnectionManager.getInstance().socketClientID);
      }
      
      private function checkIfAvailable() : Boolean
      {
         return Boolean(this._forceSounds) && Boolean(this._soundDirectoryExist);
      }
      
      public function playAdminSound(pSoundId:String, pVolume:Number, pLoop:Boolean, pType:uint) : void
      {
         var busId:uint = SoundUtil.getBusIdBySoundId(pSoundId);
         var soundPath:String = SoundUtil.getConfigEntryByBusId(busId);
         var soundUri:Uri = new Uri(soundPath + pSoundId + ".mp3");
         var isound:ISound = SoundFactory.getSound(EnumSoundType.UNLOCALIZED_SOUND,soundUri);
         this._adminSounds[pType] = isound;
         isound.volume = pVolume;
         isound.play(pLoop);
      }
      
      public function stopAdminSound(pType:uint) : void
      {
         var isound:ISound = this._adminSounds[pType] as ISound;
         isound.stop();
      }
      
      public function addSoundInPlaylist(pSoundId:String, pVolume:Number, pSilenceMin:uint, pSilenceMax:uint) : Boolean
      {
         if(this._adminPlaylist == null)
         {
            this._adminPlaylist = new PlayList(false,true);
         }
         var busId:uint = SoundUtil.getBusIdBySoundId(pSoundId);
         var soundPath:String = SoundUtil.getConfigEntryByBusId(busId);
         var soundUri:Uri = new Uri(soundPath + pSoundId + ".mp3");
         var isound:ISound = SoundFactory.getSound(EnumSoundType.UNLOCALIZED_SOUND,soundUri);
         if(this._adminPlaylist.addSound(isound) > 0)
         {
            return true;
         }
         return false;
      }
      
      public function removeSoundInPLaylist(pSoundId:String) : Boolean
      {
         if(this._adminPlaylist == null)
         {
            return false;
         }
         this._adminPlaylist.removeSoundBySoundId(pSoundId,true);
         return true;
      }
      
      public function playPlaylist() : void
      {
         if(this.checkIfAvailable())
         {
            return;
         }
         if(this._adminPlaylist == null)
         {
            return;
         }
         this._adminPlaylist.play();
      }
      
      public function stopPlaylist() : void
      {
         if(this.checkIfAvailable())
         {
            return;
         }
         if(this._adminPlaylist == null)
         {
            return;
         }
         this._adminPlaylist.stop();
      }
      
      public function resetPlaylist() : void
      {
         if(this._adminPlaylist)
         {
            this._adminPlaylist.reset();
         }
      }
      
      private function onRemoveSoundInTubul(pEvent:AudioBusEvent) : void
      {
         this.removeSoundEntity(pEvent.sound);
      }
      
      private function onSoundAdminComplete(pEvent:SoundCompleteEvent) : void
      {
         pEvent.sound.eventDispatcher.removeEventListener(SoundCompleteEvent.SOUND_COMPLETE,this.onSoundAdminComplete);
         var soundId:String = pEvent.sound.uri.fileName.split(".mp3")[0];
         this._adminSounds[soundId] = null;
         delete this._adminSounds[soundId];
      }
      
      public function onClose(pEvent:Event) : void
      {
         RegConnectionManager.getInstance().send(ProtocolEnum.SAY_GOODBYE,RegConnectionManager.getInstance().socketClientID);
      }
   }
}

import flash.geom.Point;

class WaitingMapLocalizedSound
{
    
   public var soundId:String;
   
   public var position:Point;
   
   public var range:int;
   
   public var saturationRange:int;
   
   public var silenceMin:int;
   
   public var silenceMax:int;
   
   public var volumeMax:Number;
   
   function WaitingMapLocalizedSound()
   {
      super();
   }
}
