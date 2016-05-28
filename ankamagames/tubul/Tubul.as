package com.ankamagames.tubul
{
   import flash.events.EventDispatcher;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.tubul.interfaces.IAudioBus;
   import flash.utils.Dictionary;
   import flash.geom.Point;
   import flash.utils.Timer;
   import com.ankamagames.tubul.types.TubulOptions;
   import com.ankamagames.tubul.types.bus.LocalizedBus;
   import com.ankamagames.tubul.events.TubulEvent;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.tubul.utils.error.TubulError;
   import com.ankamagames.tubul.events.AudioBusEvent;
   import com.ankamagames.tubul.types.LoadedSoundInformations;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.tubul.interfaces.ILocalizedSoundListener;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.tubul.types.RollOffPreset;
   import com.ankamagames.jerakine.resources.adapters.AdapterFactory;
   import com.ankamagames.tubul.resources.adapters.MP3Adapter;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import flash.events.TimerEvent;
   
   public class Tubul extends EventDispatcher
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.tubul.Tubul));
      
      private static var _self:com.ankamagames.tubul.Tubul;
       
      private var _resourceLoader:IResourceLoader;
      
      private var _audioBus:Vector.<IAudioBus>;
      
      private var _busDictionary:Dictionary;
      
      private var _XMLSoundFilesDictionary:Dictionary;
      
      private var _rollOffPresets:Array;
      
      private var _earPosition:Point;
      
      private var _localizedSoundListeners:Array;
      
      private var _tempTimer:Timer;
      
      private var _loadedSoundsInformations:Dictionary;
      
      public var playedCharacterId:int;
      
      private var _tuOptions:TubulOptions;
      
      public function Tubul()
      {
         super();
         if(_self)
         {
            throw new TubulError("Warning : Tubul is a singleton class and shoulnd\'t be instancied directly!");
         }
         this.init();
      }
      
      public static function getInstance() : com.ankamagames.tubul.Tubul
      {
         if(!_self)
         {
            _self = new com.ankamagames.tubul.Tubul();
         }
         return _self;
      }
      
      public function get options() : TubulOptions
      {
         return this._tuOptions;
      }
      
      public function get localizedSoundListeners() : Array
      {
         return this._localizedSoundListeners;
      }
      
      public function get earPosition() : Point
      {
         return this._earPosition;
      }
      
      public function set earPosition(pPosition:Point) : void
      {
         var bus:IAudioBus = null;
         this._earPosition = pPosition;
         for each(bus in this._audioBus)
         {
            if(bus is LocalizedBus)
            {
               (bus as LocalizedBus).updateObserverPosition(pPosition);
            }
         }
      }
      
      public function get audioBus() : Vector.<IAudioBus>
      {
         return this._audioBus;
      }
      
      public function get isActive() : Boolean
      {
         return true;
      }
      
      public function activate(bValue:Boolean = true) : void
      {
         if(this.isActive)
         {
            _log.info("Tubul is now ACTIVATED");
         }
         else
         {
            _log.info("Tubul is now DESACTIVATED");
            this.resetTubul();
         }
         var tea:TubulEvent = new TubulEvent(TubulEvent.ACTIVATION);
         tea.activated = this.isActive;
         dispatchEvent(tea);
      }
      
      public function setDisplayOptions(topt:TubulOptions) : void
      {
         this._tuOptions = topt;
         this._tuOptions.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
      }
      
      public function addBus(pBus:IAudioBus) : void
      {
         var busID:int = pBus.id;
         if(this._busDictionary[busID] != null)
         {
            return;
         }
         if(this._audioBus.length > BusConstants.MAXIMUM_NUMBER_OF_BUS)
         {
            throw new TubulError("The maximum number of audio Bus have been reached !");
         }
         this._audioBus.push(pBus);
         this._busDictionary[busID] = pBus;
         pBus.eventDispatcher.addEventListener(AudioBusEvent.REMOVE_SOUND_IN_BUS,this.onRemoveSoundInBus);
      }
      
      public function getBus(pBusID:uint) : IAudioBus
      {
         if(this.contains(pBusID))
         {
            return this._busDictionary[pBusID];
         }
         _log.warn("The audio BUS " + pBusID + " doesn\'t exists");
         return null;
      }
      
      public function removeBus(pBusID:uint) : void
      {
         var bus:IAudioBus = null;
         var size:int = 0;
         var i:int = 0;
         if(!this.isActive)
         {
            return;
         }
         if(this.contains(pBusID))
         {
            bus = this._busDictionary[pBusID];
            bus.eventDispatcher.addEventListener(AudioBusEvent.REMOVE_SOUND_IN_BUS,this.onRemoveSoundInBus);
            delete this._busDictionary[pBusID];
            size = this._audioBus.length;
            for(i = 0; i < size; i++)
            {
               if(this._audioBus[i] == bus)
               {
                  this._audioBus[i] = null;
                  this._audioBus.splice(i,1);
                  break;
               }
            }
            return;
         }
         throw new TubulError("The audio BUS " + pBusID + " doesn\'t exist !");
      }
      
      public function clearBuses() : void
      {
         var key:IAudioBus = null;
         if(!this.isActive)
         {
            return;
         }
         for each(key in this._busDictionary)
         {
            this.removeBus(key.id);
         }
      }
      
      public function contains(pBusID:uint) : Boolean
      {
         if(this._busDictionary[pBusID] != null)
         {
            return true;
         }
         return false;
      }
      
      public function getLoadedSoundInformations(pSoundUri:Uri) : LoadedSoundInformations
      {
         if(this._loadedSoundsInformations[pSoundUri])
         {
            trace("Existe déjà");
         }
         return null;
      }
      
      public function setLoadedSoundInformations(pSoundUri:Uri, pInfo:LoadedSoundInformations) : void
      {
         if(this._loadedSoundsInformations[pSoundUri])
         {
            trace("Existe déjà");
         }
         else
         {
            this._loadedSoundsInformations[pSoundUri] = pInfo;
         }
      }
      
      public function addListener(pListener:ILocalizedSoundListener) : void
      {
         if(!this.isActive)
         {
            return;
         }
         if(this._localizedSoundListeners == null)
         {
            this._localizedSoundListeners = new Array();
         }
         if(!this._localizedSoundListeners.indexOf(pListener))
         {
            return;
         }
         this._localizedSoundListeners.push(pListener);
      }
      
      public function removeListener(pListener:ILocalizedSoundListener) : void
      {
         if(this._localizedSoundListeners == null)
         {
            this._localizedSoundListeners = new Array();
         }
         var index:int = this._localizedSoundListeners.indexOf(pListener);
         if(index < 0)
         {
            return;
         }
         this._localizedSoundListeners[index] = null;
         this._localizedSoundListeners.splice(index,1);
      }
      
      private function resetTubul() : void
      {
         var bus:IAudioBus = null;
         for each(bus in this._audioBus)
         {
            bus.clearBUS();
         }
         this._resourceLoader.removeEventListener(ResourceLoadedEvent.LOADED,this.onXMLSoundsLoaded);
         this._resourceLoader.removeEventListener(ResourceErrorEvent.ERROR,this.onXMLSoundsFailed);
      }
      
      private function retriveRollOffPresets(pXMLPreset:XML) : void
      {
         var preset:XML = null;
         var rollOffPreset:RollOffPreset = null;
         var presets:XMLList = pXMLPreset.elements();
         if(this._rollOffPresets == null)
         {
            this._rollOffPresets = new Array();
         }
         for each(preset in presets)
         {
            rollOffPreset = new RollOffPreset(uint(preset.GainMax),uint(preset.DistMax),uint(preset.DistMaxSat));
            this._rollOffPresets[preset.@id] = rollOffPreset;
         }
      }
      
      public function init() : void
      {
         this._audioBus = new Vector.<IAudioBus>();
         this._busDictionary = new Dictionary(true);
         this._XMLSoundFilesDictionary = new Dictionary();
         this._earPosition = new Point();
         this._loadedSoundsInformations = new Dictionary();
         AdapterFactory.addAdapter("mp3",MP3Adapter);
         this._resourceLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SERIAL_LOADER);
         this._resourceLoader.addEventListener(ResourceLoadedEvent.LOADED,this.onXMLSoundsLoaded);
         this._resourceLoader.addEventListener(ResourceErrorEvent.ERROR,this.onXMLSoundsFailed);
      }
      
      private function setVolumeToBus(pBusId:int, pVolume:uint) : void
      {
         var audioBus:IAudioBus = com.ankamagames.tubul.Tubul.getInstance().getBus(pBusId);
         if(audioBus != null)
         {
            audioBus.volume = pVolume / 100;
         }
      }
      
      private function onTimerEnd(pEvent:TimerEvent) : void
      {
         this._resourceLoader.load([XMLSounds.BREED_BONES_BARKS,XMLSounds.ROLLOFF_PRESET]);
      }
      
      private function onXMLSoundsLoaded(pEvent:ResourceLoadedEvent) : void
      {
         var fileName:String = pEvent.uri.fileName.split(".")[0];
         if(fileName == XMLSounds.ROLLOFF_FILENAME)
         {
            this.retriveRollOffPresets(pEvent.resource);
         }
         else if(!this._XMLSoundFilesDictionary[fileName])
         {
            this._XMLSoundFilesDictionary[fileName] = pEvent.resource;
         }
      }
      
      private function onXMLSoundsFailed(pEvent:ResourceErrorEvent) : void
      {
         this.activate(false);
         _log.error("An XML sound file failed to load : " + pEvent.uri + " / [" + pEvent.errorCode + "] " + pEvent.errorMsg);
      }
      
      private function onRemoveSoundInBus(pEvent:AudioBusEvent) : void
      {
         dispatchEvent(pEvent);
      }
      
      private function onPropertyChanged(e:PropertyChangeEvent) : void
      {
         switch(e.propertyName)
         {
            case "muteMusic":
               this.setVolumeToBus(0,!!e.propertyValue?uint(0):uint(this._tuOptions.volumeMusic));
               break;
            case "muteSound":
               this.setVolumeToBus(4,!!e.propertyValue?uint(0):uint(this._tuOptions.volumeSound));
               break;
            case "muteAmbientSound":
               this.setVolumeToBus(1,!!e.propertyValue?uint(0):uint(this._tuOptions.volumeAmbientSound));
               this.setVolumeToBus(2,!!e.propertyValue?uint(0):uint(this._tuOptions.volumeAmbientSound));
               this.setVolumeToBus(3,!!e.propertyValue?uint(0):uint(this._tuOptions.volumeAmbientSound));
               this.setVolumeToBus(5,!!e.propertyValue?uint(0):uint(this._tuOptions.volumeAmbientSound));
               this.setVolumeToBus(6,!!e.propertyValue?uint(0):uint(this._tuOptions.volumeAmbientSound));
               this.setVolumeToBus(7,!!e.propertyValue?uint(0):uint(this._tuOptions.volumeAmbientSound));
               break;
            case "volumeMusic":
               if(this._tuOptions.muteMusic == false)
               {
                  this.setVolumeToBus(0,e.propertyValue);
               }
               break;
            case "volumeSound":
               if(this._tuOptions.muteSound == false)
               {
                  this.setVolumeToBus(4,e.propertyValue);
               }
               break;
            case "volumeAmbientSound":
               if(this._tuOptions.muteAmbientSound == false)
               {
                  this.setVolumeToBus(1,e.propertyValue);
                  this.setVolumeToBus(2,e.propertyValue);
                  this.setVolumeToBus(3,e.propertyValue);
                  this.setVolumeToBus(5,e.propertyValue);
                  this.setVolumeToBus(6,e.propertyValue);
                  this.setVolumeToBus(7,e.propertyValue);
               }
         }
      }
   }
}
