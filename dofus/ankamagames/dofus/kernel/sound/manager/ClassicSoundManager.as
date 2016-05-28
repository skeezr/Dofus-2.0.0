package com.ankamagames.dofus.kernel.sound.manager
{
   import flash.events.EventDispatcher;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.tubul.interfaces.ISound;
   import com.ankamagames.tubul.types.effects.LowPassFilter;
   import com.ankamagames.tubul.types.PlayList;
   import com.ankamagames.tubul.types.TubulOptions;
   import com.ankamagames.tubul.Tubul;
   import com.ankamagames.atouin.data.map.Map;
   import com.ankamagames.tubul.interfaces.IAudioBus;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.atouin.enums.MapTypesEnum;
   import com.ankamagames.dofus.kernel.sound.TubulSoundConfiguration;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.kernel.sound.utils.SoundUtil;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.tubul.factory.SoundFactory;
   import com.ankamagames.tubul.enum.EnumSoundType;
   import com.ankamagames.dofus.kernel.sound.type.RollOffPreset;
   import com.ankamagames.jerakine.utils.parser.FLAEventLabelParser;
   import com.ankamagames.jerakine.types.SoundEventParamWrapper;
   import com.ankamagames.dofus.kernel.sound.parser.XMLSoundParser;
   import com.ankamagames.tubul.types.sounds.LocalizedSound;
   import com.ankamagames.atouin.AtouinConstants;
   import flash.geom.Point;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import flash.filesystem.File;
   import com.ankamagames.tubul.events.LoadingSound.LoadingSoundEvent;
   import com.ankamagames.tubul.events.AudioBusEvent;
   import com.ankamagames.tubul.factory.AudioBusFactory;
   import com.ankamagames.tubul.enum.EnumTypeBus;
   import com.ankamagames.dofus.kernel.sound.SoundManager;
   import com.ankamagames.tubul.events.TubulEvent;
   import com.ankamagames.tubul.events.SoundCompleteEvent;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.tiphon.engine.TiphonEventsManager;
   
   public class ClassicSoundManager extends EventDispatcher implements com.ankamagames.dofus.kernel.sound.manager.ISoundManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ClassicSoundManager));
      
      private static var _self:com.ankamagames.dofus.kernel.sound.manager.ISoundManager;
       
      private var _previousSubareaId:int;
      
      private var _criterionSubarea:int;
      
      private var _entitySounds:Array;
      
      private var _reverseEntitySounds:Dictionary;
      
      private var _entityDictionary:Dictionary;
      
      private var _rollOffPresets:Array;
      
      private var _XMLSoundFilesDictionary:Dictionary;
      
      private var _XMLSoundFilesToLoad:Array;
      
      private var _presetResourceLoader:IResourceLoader;
      
      private var _XMLSoundFilesResourceLoader:IResourceLoader;
      
      private var _introHarmonicOne:ISound;
      
      private var _introHarmonicTwo:ISound;
      
      private var _introHarmonicOneLoaded:Boolean = false;
      
      private var _introHarmonicTwoLoaded:Boolean = false;
      
      private var _introFirstHarmonic:Boolean;
      
      private var _ambientManager:com.ankamagames.dofus.kernel.sound.manager.AmbientSoundsManager;
      
      private var _localizedSoundsManager:com.ankamagames.dofus.kernel.sound.manager.LocalizedSoundsManager;
      
      private var _fightMusicManager:com.ankamagames.dofus.kernel.sound.manager.FightMusicManager;
      
      private var _forceSounds:Boolean = false;
      
      private var _soundDirectoryExist:Boolean = false;
      
      private var _inFight:Boolean;
      
      private var _indoor:int = 0.0;
      
      private var _lowPassFilter:LowPassFilter;
      
      private var _adminSounds:Dictionary;
      
      private var _adminPlaylist:PlayList;
      
      public function ClassicSoundManager()
      {
         super();
         if(_self)
         {
            throw new Error("Warning : ClassicSoundManager is a singleton class and shoulnd\'t be instancied directly!");
         }
         this.init();
      }
      
      public static function getInstance() : com.ankamagames.dofus.kernel.sound.manager.ISoundManager
      {
         if(!_self)
         {
            _self = new ClassicSoundManager();
         }
         return _self;
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
         if(this._forceSounds)
         {
            this.initTubul();
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
         }
         else
         {
            this.desactivateTubul();
         }
      }
      
      public function setDisplayOptions(pOptions:TubulOptions) : void
      {
         if(this.soundIsActivate)
         {
            Tubul.getInstance().setDisplayOptions(pOptions);
         }
      }
      
      public function setSubArea(pMap:Map = null) : void
      {
         var busMusic1:IAudioBus = null;
         var busAmbiance1:IAudioBus = null;
         var busMusic2:IAudioBus = null;
         var busAmbiance2:IAudioBus = null;
         var mp:MapPosition = MapPosition.getMapPositionById(pMap.id);
         if(Boolean(this.soundIsActivate) && false)
         {
            if(this._indoor == MapTypesEnum.INDOOR && pMap.mapType == MapTypesEnum.OUTDOOR)
            {
               this._indoor = MapTypesEnum.OUTDOOR;
               busMusic1 = Tubul.getInstance().getBus(TubulSoundConfiguration.BUS_MUSIC_ID);
               busAmbiance1 = Tubul.getInstance().getBus(TubulSoundConfiguration.BUS_AMBIENT_2D_ID);
               busMusic1.removeEffect(this._lowPassFilter);
               busAmbiance1.removeEffect(this._lowPassFilter);
            }
            else if(this._indoor == MapTypesEnum.OUTDOOR && pMap.mapType == MapTypesEnum.INDOOR)
            {
               this._indoor = MapTypesEnum.INDOOR;
               busMusic2 = Tubul.getInstance().getBus(TubulSoundConfiguration.BUS_MUSIC_ID);
               busAmbiance2 = Tubul.getInstance().getBus(TubulSoundConfiguration.BUS_AMBIENT_2D_ID);
               busMusic2.addEffect(this._lowPassFilter);
               busAmbiance2.addEffect(this._lowPassFilter);
            }
         }
         this._localizedSoundsManager.setMap(pMap);
         if(this.soundIsActivate)
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
         var busId:uint = SoundUtil.getBusIdBySoundId(pSoundId);
         var soundPath:String = SoundUtil.getConfigEntryByBusId(busId);
         var soundUri:Uri = new Uri(soundPath + pSoundId + ".mp3");
         var isound:ISound = SoundFactory.getSound(EnumSoundType.UNLOCALIZED_SOUND,soundUri);
         isound.volume = 1;
         var bus:IAudioBus = Tubul.getInstance().getBus(busId);
         if(bus != null)
         {
            bus.playISound(isound,pLoop);
         }
      }
      
      public function playSound(pSound:ISound, pLoop:Boolean = false, pLoops:int = -1) : ISound
      {
         if(!this.checkIfAvailable())
         {
            return null;
         }
         var soundID:String = pSound.uri.fileName.split(".mp3")[0];
         var busId:uint = SoundUtil.getBusIdBySoundId(soundID);
         var bus:IAudioBus = Tubul.getInstance().getBus(busId);
         if(bus != null)
         {
            bus.playISound(pSound,pLoop,pLoops);
         }
         return pSound;
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
         var soundType:uint = 0;
         var busId:uint = 0;
         var rollOff:RollOffPreset = null;
         var soundPath:String = null;
         if(!this.checkIfAvailable())
         {
            return;
         }
         var posX:Number = pSprite.absoluteBounds.x;
         var posY:Number = pSprite.absoluteBounds.y;
         var entityId:int = pSprite.id;
         var sepw:Array = FLAEventLabelParser.parseSoundLabel(pParams);
         var selectedIndex:uint = Math.round(Math.random() * (sepw.length - 1));
         var selectedSEPW:SoundEventParamWrapper = sepw[selectedIndex];
         var soundId:String = selectedSEPW.id;
         if(this._XMLSoundFilesDictionary[soundId])
         {
            selectedSEPW = XMLSoundParser.parseXMLSoundFile(this._XMLSoundFilesDictionary[soundId],pSprite.look.skins);
            soundId = selectedSEPW.id;
         }
         if(XMLSoundParser.isLocalized(soundId))
         {
            soundType = EnumSoundType.LOCALIZED_SOUND;
         }
         else
         {
            soundType = EnumSoundType.UNLOCALIZED_SOUND;
         }
         busId = SoundUtil.getBusIdBySoundId(soundId);
         soundPath = SoundUtil.getConfigEntryByBusId(busId);
         var soundUri:Uri = new Uri(soundPath + soundId + ".mp3");
         var isound:ISound = SoundFactory.getSound(soundType,soundUri);
         isound.volume = selectedSEPW.volume / 100;
         if(isound is LocalizedSound && Boolean(selectedSEPW.rollOff))
         {
            rollOff = this._rollOffPresets[selectedSEPW.rollOff];
            if(Boolean(rollOff) && isound is LocalizedSound)
            {
               (isound as LocalizedSound).range = rollOff.maxRange * AtouinConstants.CELL_WIDTH;
               (isound as LocalizedSound).saturationRange = rollOff.maxSaturationRange * AtouinConstants.CELL_WIDTH;
               (isound as LocalizedSound).volumeMax = selectedSEPW.volume / 100;
               (isound as LocalizedSound).position = new Point(posX,posY);
            }
         }
         this.addSoundEntity(isound,entityId);
         var bus:IAudioBus = Tubul.getInstance().getBus(busId);
         if(bus != null)
         {
            bus.playISound(isound);
            if(int(selectedSEPW.berceauVol) < 100)
            {
               bus.applyDynamicMix(selectedSEPW.berceauVol,selectedSEPW.berceauFadeIn,selectedSEPW.berceauDuree,selectedSEPW.berceauFadeOut);
            }
         }
      }
      
      public function applyDynamicMix(pFadeIn:Number, pFadeInTime:uint, pWaitingTime:uint, pFadeOutTime:uint) : void
      {
         var musicBus:IAudioBus = Tubul.getInstance().getBus(TubulSoundConfiguration.BUS_MUSIC_ID);
         var ambientBus:IAudioBus = Tubul.getInstance().getBus(TubulSoundConfiguration.BUS_AMBIENT_2D_ID);
         if(musicBus)
         {
            musicBus.applyDynamicMix(pFadeIn,pFadeInTime,pWaitingTime,pFadeOutTime);
         }
         if(ambientBus)
         {
            ambientBus.applyDynamicMix(pFadeIn,pFadeInTime,pWaitingTime,pFadeOutTime);
         }
      }
      
      public function retriveRollOffPresets() : void
      {
         this._presetResourceLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SINGLE_LOADER);
         this._presetResourceLoader.addEventListener(ResourceLoadedEvent.LOADED,this.onXMLPresetsRollOffLoaded);
         this._presetResourceLoader.addEventListener(ResourceErrorEvent.ERROR,this.onXMLPresetsRollOffFailed);
         this._presetResourceLoader.load(TubulSoundConfiguration.ROLLOFF_PRESET);
      }
      
      public function setSoundSourcePosition(pEntityId:int, pPosition:Point) : void
      {
         var sounds:Vector.<ISound> = null;
         var isound:ISound = null;
         if(!this.checkIfAvailable())
         {
            return;
         }
         if(pEntityId == PlayedCharacterManager.getInstance().id)
         {
            Tubul.getInstance().earPosition = pPosition;
         }
         else
         {
            sounds = this.entitySounds[pEntityId];
            for each(isound in sounds)
            {
               if(isound is LocalizedSound)
               {
                  (isound as LocalizedSound).position = pPosition;
               }
            }
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
         var compt:uint = 0;
         for each(isound in this._entitySounds[entityId])
         {
            if(isound == pISound)
            {
               this._entitySounds[entityId].splice(compt,1);
               delete this._reverseEntitySounds[pISound];
               if(this._entitySounds[entityId].length == 0)
               {
                  this._entitySounds[entityId] = null;
               }
               return;
            }
            compt++;
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
      }
      
      public function retriveXMLSounds() : void
      {
         this._XMLSoundFilesDictionary = new Dictionary();
         this._XMLSoundFilesToLoad = new Array();
         var AudioDirectory:File = new File(File.applicationDirectory.nativePath + "/content/audio");
         this.findXmlSoundsInDirectory(AudioDirectory);
         this._XMLSoundFilesResourceLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._XMLSoundFilesResourceLoader.addEventListener(ResourceLoadedEvent.LOADED,this.onXMLSoundFileLoaded);
         this._XMLSoundFilesResourceLoader.addEventListener(ResourceErrorEvent.ERROR,this.onXMLSoundFileFailed);
         this._XMLSoundFilesResourceLoader.load(this._XMLSoundFilesToLoad);
      }
      
      private function playIntro() : void
      {
         if(!this.checkIfAvailable())
         {
            return;
         }
         this._introHarmonicOne.fadeVolume = 0;
         this._introHarmonicTwo.fadeVolume = 0;
         Tubul.getInstance().getBus(TubulSoundConfiguration.BUS_MUSIC_ID).playISound(this._introHarmonicOne,true);
         Tubul.getInstance().getBus(TubulSoundConfiguration.BUS_MUSIC_ID).playISound(this._introHarmonicTwo,true);
         if(this._introFirstHarmonic)
         {
            this._introHarmonicOne.fadeSound(1,3);
         }
         else
         {
            this._introHarmonicTwo.fadeSound(1,3);
         }
      }
      
      public function playIntroMusic(pFirstHarmonic:Boolean = true) : void
      {
         var soundId:String = null;
         var busId:uint = 0;
         var soundPath:String = null;
         var soundUri:Uri = null;
         if(!this.checkIfAvailable())
         {
            return;
         }
         this._introFirstHarmonic = pFirstHarmonic;
         var musicBus:IAudioBus = Tubul.getInstance().getBus(TubulSoundConfiguration.BUS_MUSIC_ID);
         if(musicBus)
         {
            soundId = "20000";
            busId = SoundUtil.getBusIdBySoundId(soundId);
            soundPath = SoundUtil.getConfigEntryByBusId(busId);
            soundUri = new Uri(soundPath + soundId + ".mp3");
            this._introHarmonicOne = SoundFactory.getSound(EnumSoundType.UNLOCALIZED_SOUND,soundUri);
            this._introHarmonicOne.volume = 1;
            soundId = "20001";
            busId = SoundUtil.getBusIdBySoundId(soundId);
            soundPath = SoundUtil.getConfigEntryByBusId(busId);
            soundUri = new Uri(soundPath + soundId + ".mp3");
            this._introHarmonicTwo = SoundFactory.getSound(EnumSoundType.UNLOCALIZED_SOUND,soundUri);
            this._introHarmonicOne.eventDispatcher.addEventListener(LoadingSoundEvent.LOADED,this.onIntroMusicHarmonicOneLoaded);
            this._introHarmonicTwo.eventDispatcher.addEventListener(LoadingSoundEvent.LOADED,this.onIntroMusicHarmonicTwoLoaded);
            musicBus.addISound(this._introHarmonicOne);
            musicBus.addISound(this._introHarmonicTwo);
         }
      }
      
      public function switchIntroMusic(pFirstHarmonic:Boolean) : void
      {
         if(!this.checkIfAvailable())
         {
            return;
         }
         if(Boolean(this._introHarmonicOneLoaded) && Boolean(this._introHarmonicTwoLoaded))
         {
            if(pFirstHarmonic)
            {
               this._introHarmonicOne.fadeSound(0,1.5);
               this._introHarmonicTwo.fadeSound(1,1.5);
            }
            else
            {
               this._introHarmonicOne.fadeSound(1,1.5);
               this._introHarmonicTwo.fadeSound(0,1.5);
            }
         }
         else
         {
            this.playIntroMusic(false);
         }
      }
      
      public function stopIntroMusic() : void
      {
         if(!this.checkIfAvailable())
         {
            return;
         }
         if(this._introHarmonicOne)
         {
            this._introHarmonicOne.stop(0,1.5);
            this._introHarmonicOne.eventDispatcher.removeEventListener(LoadingSoundEvent.LOADED,this.onIntroMusicHarmonicOneLoaded);
         }
         if(this._introHarmonicTwo)
         {
            this._introHarmonicTwo.stop(0,1.5);
            this._introHarmonicTwo.eventDispatcher.removeEventListener(LoadingSoundEvent.LOADED,this.onIntroMusicHarmonicTwoLoaded);
         }
         this._introHarmonicOneLoaded = false;
         this._introHarmonicTwoLoaded = false;
      }
      
      public function removeAllSounds(pFade:Number = 0, pFadeTime:Number = 0) : void
      {
         var iBus:IAudioBus = null;
         if(this._introHarmonicOne)
         {
            this._introHarmonicOne.eventDispatcher.removeEventListener(LoadingSoundEvent.LOADED,this.onIntroMusicHarmonicOneLoaded);
         }
         if(this._introHarmonicTwo)
         {
            this._introHarmonicTwo.eventDispatcher.removeEventListener(LoadingSoundEvent.LOADED,this.onIntroMusicHarmonicTwoLoaded);
         }
         for each(iBus in Tubul.getInstance().audioBus)
         {
            iBus.clearBUS();
         }
      }
      
      public function setBusVolume(pBusID:int, pNewVolume:Number) : void
      {
         var bus:IAudioBus = Tubul.getInstance().getBus(pBusID);
         if(bus != null)
         {
            bus.volume = pNewVolume;
         }
      }
      
      public function reset() : void
      {
         this.removeAllSounds();
      }
      
      private function findXmlSoundsInDirectory(pDirectory:File) : void
      {
         var filesAndDirectories:Array = null;
         var file:File = null;
         if(pDirectory.exists)
         {
            filesAndDirectories = pDirectory.getDirectoryListing();
            for each(file in filesAndDirectories)
            {
               if(Boolean(file.isDirectory) && file.name != ".svn" && file.name != "presets")
               {
                  this.findXmlSoundsInDirectory(file);
               }
               else if(Boolean(file.extension) && file.extension.toUpperCase() == "XML")
               {
                  this._XMLSoundFilesToLoad.push(new Uri(file.nativePath));
               }
            }
         }
         else
         {
            _log.fatal("The sound directory doesn\'t exists !");
            this._soundDirectoryExist = false;
         }
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
         this._rollOffPresets = new Array();
         this.initTubul();
         this._lowPassFilter = new LowPassFilter();
      }
      
      private function initTubul() : void
      {
         if(!this.soundIsActivate)
         {
            return;
         }
         Tubul.getInstance().addEventListener(AudioBusEvent.REMOVE_SOUND_IN_BUS,this.onRemoveSoundInTubul);
         Tubul.getInstance().addBus(AudioBusFactory.getAudioBus(EnumTypeBus.UNLOCALIZED_BUS,TubulSoundConfiguration.BUS_MUSIC_ID,TubulSoundConfiguration.CHANNEL_MUSIC));
         Tubul.getInstance().addBus(AudioBusFactory.getAudioBus(EnumTypeBus.UNLOCALIZED_BUS,TubulSoundConfiguration.BUS_AMBIENT_2D_ID,TubulSoundConfiguration.CHANNEL_AMBIENT_2D));
         Tubul.getInstance().addBus(AudioBusFactory.getAudioBus(EnumTypeBus.LOCALIZED_BUS,TubulSoundConfiguration.BUS_AMBIENT_3D_ID,TubulSoundConfiguration.CHANNEL_AMBIENT_3D));
         Tubul.getInstance().addBus(AudioBusFactory.getAudioBus(EnumTypeBus.LOCALIZED_BUS,TubulSoundConfiguration.BUS_SFX_ID,TubulSoundConfiguration.CHANNEL_SFX));
         Tubul.getInstance().addBus(AudioBusFactory.getAudioBus(EnumTypeBus.LOCALIZED_BUS,TubulSoundConfiguration.BUS_UI_ID,TubulSoundConfiguration.CHANNEL_UI));
         Tubul.getInstance().addBus(AudioBusFactory.getAudioBus(EnumTypeBus.LOCALIZED_BUS,TubulSoundConfiguration.BUS_NPC_FOLEYS_ID,TubulSoundConfiguration.CHANNEL_NPC_FOLEYS));
         Tubul.getInstance().addBus(AudioBusFactory.getAudioBus(EnumTypeBus.LOCALIZED_BUS,TubulSoundConfiguration.BUS_FIGHT_ID,TubulSoundConfiguration.CHANNEL_FIGHT));
         Tubul.getInstance().addBus(AudioBusFactory.getAudioBus(EnumTypeBus.LOCALIZED_BUS,TubulSoundConfiguration.BUS_BARKS_ID,TubulSoundConfiguration.CHANNEL_BARKS));
         Tubul.getInstance().addBus(AudioBusFactory.getAudioBus(EnumTypeBus.LOCALIZED_BUS,TubulSoundConfiguration.BUS_GFX_ID,TubulSoundConfiguration.CHANNEL_GFX));
         Tubul.getInstance().addBus(AudioBusFactory.getAudioBus(EnumTypeBus.UNLOCALIZED_BUS,TubulSoundConfiguration.BUS_FIGHT_MUSIC_ID,TubulSoundConfiguration.CHANNEL_FIGHT_MUSIC));
         Tubul.getInstance().getBus(TubulSoundConfiguration.BUS_MUSIC_ID).volumeMax = TubulSoundConfiguration.BUS_MUSIC_VOLUME;
         Tubul.getInstance().getBus(TubulSoundConfiguration.BUS_AMBIENT_2D_ID).volumeMax = TubulSoundConfiguration.BUS_AMBIENT_2D_VOLUME;
         Tubul.getInstance().getBus(TubulSoundConfiguration.BUS_AMBIENT_3D_ID).volumeMax = TubulSoundConfiguration.BUS_AMBIENT_3D_VOLUME;
         Tubul.getInstance().getBus(TubulSoundConfiguration.BUS_SFX_ID).volumeMax = TubulSoundConfiguration.BUS_SFX_VOLUME;
         Tubul.getInstance().getBus(TubulSoundConfiguration.BUS_UI_ID).volumeMax = TubulSoundConfiguration.BUS_UI_VOLUME;
         Tubul.getInstance().getBus(TubulSoundConfiguration.BUS_NPC_FOLEYS_ID).volumeMax = TubulSoundConfiguration.BUS_NPC_FOLEYS_VOLUME;
         Tubul.getInstance().getBus(TubulSoundConfiguration.BUS_FIGHT_ID).volumeMax = TubulSoundConfiguration.BUS_FIGHT_VOLUME;
         Tubul.getInstance().getBus(TubulSoundConfiguration.BUS_BARKS_ID).volumeMax = TubulSoundConfiguration.BUS_BARKS_VOLUME;
         Tubul.getInstance().getBus(TubulSoundConfiguration.BUS_GFX_ID).volumeMax = TubulSoundConfiguration.BUS_GFX_VOLUME;
         Tubul.getInstance().getBus(TubulSoundConfiguration.BUS_FIGHT_MUSIC_ID).volumeMax = TubulSoundConfiguration.BUS_FIGHT_MUSIC_VOLUME;
         SoundManager.getInstance().setSoundOptions();
         this.retriveRollOffPresets();
         this.retriveXMLSounds();
         Tubul.getInstance().addEventListener(TubulEvent.ACTIVATION,this.onTubulActivation);
         var e:TubulEvent = new TubulEvent(TubulEvent.ACTIVATION);
         e.activated = true;
         this.onTubulActivation(e);
      }
      
      private function desactivateTubul() : void
      {
         if(this.soundIsActivate)
         {
            return;
         }
         if(this._ambientManager != null)
         {
            this._ambientManager.stopMusicAndAmbient();
         }
         if(this._localizedSoundsManager != null)
         {
            this._localizedSoundsManager.stopLocalizedSounds();
         }
         Tubul.getInstance().clearBuses();
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
         isound.bus = busId;
         isound.volume = pVolume / 100;
         this._adminSounds[pType] = isound;
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
         if(!Tubul.getInstance().isActive)
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
         if(!Tubul.getInstance().isActive)
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
      
      public function fadeBusVolume(pBusID:int, pFade:Number, pFadeTime:Number) : void
      {
         var bus:IAudioBus = Tubul.getInstance().getBus(pBusID);
         if(bus != null)
         {
            bus.fadeSound(pFade,pFadeTime);
         }
      }
      
      private function onXMLPresetsRollOffLoaded(pEvent:ResourceLoadedEvent) : void
      {
         var preset:XML = null;
         var rollOffPreset:RollOffPreset = null;
         var presets:XMLList = (pEvent.resource as XML).elements();
         for each(preset in presets)
         {
            rollOffPreset = new RollOffPreset(uint(preset.GainMax),uint(preset.DistMax),uint(preset.DistMaxSat));
            this._rollOffPresets[preset.@id] = rollOffPreset;
         }
      }
      
      private function onXMLPresetsRollOffFailed(pEvent:ResourceErrorEvent) : void
      {
         Tubul.getInstance().activate(false);
         _log.error("An XML sound file failed to load : " + pEvent.uri + " / [" + pEvent.errorCode + "] " + pEvent.errorMsg);
      }
      
      private function onXMLSoundFileLoaded(pEvent:ResourceLoadedEvent) : void
      {
         var filename:String = pEvent.uri.fileName.split("." + pEvent.uri.fileType)[0];
         var splitedFilename:Array = filename.split("\\");
         filename = splitedFilename.pop();
         this._XMLSoundFilesDictionary[filename] = pEvent.resource;
         var index:int = this._XMLSoundFilesToLoad.indexOf(pEvent.uri);
         if(index >= 0)
         {
            this._XMLSoundFilesToLoad.splice(index,1);
         }
         if(this._XMLSoundFilesToLoad.length == 0)
         {
            this._XMLSoundFilesToLoad = null;
            this._XMLSoundFilesResourceLoader.removeEventListener(ResourceLoadedEvent.LOADED,this.onXMLSoundFileLoaded);
            this._XMLSoundFilesResourceLoader.removeEventListener(ResourceErrorEvent.ERROR,this.onXMLSoundFileFailed);
         }
      }
      
      private function onXMLSoundFileFailed(pEvent:ResourceErrorEvent) : void
      {
         _log.warn("The xml sound file " + pEvent.uri + " failed to load !!");
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
      
      private function onIntroMusicHarmonicOneLoaded(pEvent:LoadingSoundEvent) : void
      {
         this._introHarmonicOneLoaded = true;
         if(this._introHarmonicTwoLoaded)
         {
            this.playIntro();
         }
      }
      
      private function onIntroMusicHarmonicTwoLoaded(pEvent:LoadingSoundEvent) : void
      {
         this._introHarmonicTwoLoaded = true;
         if(this._introHarmonicOneLoaded)
         {
            this.playIntro();
         }
      }
      
      private function onTubulActivation(pEvent:TubulEvent) : void
      {
         switch(pEvent.activated)
         {
            case true:
               Berilia.getInstance().addUIListener(this);
               TiphonEventsManager.addListener(this,"Sound");
               Tubul.getInstance().addListener(this);
               break;
            case false:
               Berilia.getInstance().removeUIListener(this);
               TiphonEventsManager.removeListener(this);
               Tubul.getInstance().removeListener(this);
         }
      }
   }
}
