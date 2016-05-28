package com.ankamagames.tubul.types.bus
{
   import com.ankamagames.tubul.interfaces.IAudioBus;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.tubul.interfaces.ISound;
   import com.ankamagames.jerakine.newCache.ICache;
   import flash.events.EventDispatcher;
   import com.ankamagames.tubul.types.PlayList;
   import flash.utils.Timer;
   import com.ankamagames.tubul.interfaces.IEffect;
   import com.ankamagames.jerakine.resources.CacheableResource;
   import com.TubulConstants;
   import com.ankamagames.tubul.events.SoundCompleteEvent;
   import com.ankamagames.tubul.events.LoadingSound.LoadingSoundEvent;
   import caurina.transitions.Tweener;
   import com.ankamagames.jerakine.newCache.impl.Cache;
   import com.ankamagames.jerakine.newCache.garbage.LruGarbageCollector;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.tubul.events.SilenceEvent;
   import flash.events.TimerEvent;
   import com.ankamagames.tubul.events.AudioBusVolumeEvent;
   import com.ankamagames.tubul.interfaces.ILocalizedSoundListener;
   import com.ankamagames.tubul.Tubul;
   import com.ankamagames.tubul.events.FadeEvent;
   import com.ankamagames.tubul.events.AudioBusEvent;
   import com.ankamagames.jerakine.logger.Log;
   
   public class AudioBus implements IAudioBus
   {
      
      protected static var _playingSound:Number = 0;
      
      protected static var id_sound:uint = 0;
       
      private const _log:Logger = Log.getLogger(getQualifiedClassName(AudioBus));
      
      protected var _id:uint;
      
      protected var _name:String;
      
      protected var _soundVector:Vector.<ISound>;
      
      protected var _volume:Number;
      
      protected var _volumeMax:Number;
      
      protected var _fadeVolume:Number;
      
      protected var _cache:ICache;
      
      protected var _eventDispatcher:EventDispatcher;
      
      protected var _numberSoundsLimitation:int = -1;
      
      protected var _playlist:PlayList;
      
      protected var _playlistEnable:Boolean;
      
      protected var _timerSilence:Timer;
      
      protected var _playlistAlreadyUsed:Boolean;
      
      protected var _effects:Vector.<IEffect>;
      
      public function AudioBus(id:int, name:String)
      {
         super();
         this.init(id,name);
      }
      
      public function set volumeMax(pVolMax:Number) : void
      {
         if(pVolMax > 1)
         {
            pVolMax = 1;
         }
         if(pVolMax < 0)
         {
            pVolMax = 0;
         }
         this._volumeMax = pVolMax;
      }
      
      public function get volumeMax() : Number
      {
         return this._volumeMax;
      }
      
      public function get numberSoundsLimitation() : int
      {
         return this._numberSoundsLimitation;
      }
      
      public function set numberSoundsLimitation(pLimit:int) : void
      {
         this._numberSoundsLimitation = pLimit;
      }
      
      public function get sounds() : Vector.<ISound>
      {
         return this._soundVector;
      }
      
      public function get effects() : Vector.<IEffect>
      {
         return this._effects;
      }
      
      public function get eventDispatcher() : EventDispatcher
      {
         return this._eventDispatcher;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function set volume(pVolume:Number) : void
      {
         if(pVolume > 1)
         {
            pVolume = 1;
         }
         if(pVolume < 0)
         {
            pVolume = 0;
         }
         this._volume = pVolume;
         this._log.warn("Bus " + "(" + this.id + ") vol. réel : " + this.effectiveVolume + " (vol. max : " + this._volumeMax + " / % vol : " + this._volume + ") [" + this.name + "]");
         this.informSoundsNewVolume();
      }
      
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function get fadeVolume() : Number
      {
         return this._fadeVolume;
      }
      
      public function set fadeVolume(pFadeVolume:Number) : void
      {
         if(pFadeVolume > 1)
         {
            pFadeVolume = 1;
         }
         if(pFadeVolume < 0)
         {
            pFadeVolume = 0;
         }
         this._fadeVolume = pFadeVolume;
         this.informSoundsNewVolume();
      }
      
      public function get effectiveVolume() : Number
      {
         return Math.round(this._volume * this._volumeMax * this._fadeVolume * 1000) / 1000;
      }
      
      public function clearBUS(fade:Number = -1, fadetime:Number = 0) : void
      {
         var isound:ISound = null;
         for each(isound in this._soundVector)
         {
            this.removeSound(isound,fade,fadetime);
         }
         if(this._timerSilence)
         {
            this._timerSilence.stop();
         }
         this._timerSilence = null;
         this._playlist = null;
         this._playlistAlreadyUsed = false;
      }
      
      public function playISound(newSound:ISound, pLoop:Boolean = false, pLoops:int = -1) : void
      {
         var isound:ISound = null;
         var existingSound:Boolean = false;
         if(newSound.silenceMin == 0 && newSound.silenceMax == 0)
         {
            pLoop = true;
         }
         for each(isound in this._soundVector)
         {
            if(isound === newSound)
            {
               existingSound = true;
               break;
            }
         }
         if(!existingSound)
         {
            this.addISound(newSound);
         }
         if(!newSound.isPlaying)
         {
            newSound.play(pLoop,pLoops);
         }
      }
      
      public function addISound(pISound:ISound) : void
      {
         var effect:IEffect = null;
         var cr:CacheableResource = null;
         var resource:* = undefined;
         if(_playingSound >= TubulConstants.MAXIMUM_SOUNDS_PLAYING_SAME_TIME)
         {
            this._log.warn("We have reached the maximum number of sounds playing simultaneously");
            return;
         }
         if(this._numberSoundsLimitation >= 0 && _playingSound >= this._numberSoundsLimitation)
         {
            this._log.warn("We have reached the maximum number of sounds for this bus (" + this._id + " / " + this._name + ")");
            return;
         }
         if(this.soundAllreadyExists(pISound))
         {
            return;
         }
         pISound.bus = this.id;
         _playingSound++;
         if(!pISound.volume == -1)
         {
            pISound.volume = 1;
         }
         for each(effect in this._effects)
         {
            pISound.addEffect(effect);
         }
         this._soundVector.push(pISound);
         pISound.eventDispatcher.addEventListener(SoundCompleteEvent.SOUND_COMPLETE,this.onSoundComplete,false,0,true);
         if(this._cache.contains(TubulConstants.PREFIXE_LOADER + pISound.uri.toSum()))
         {
            cr = this._cache.peek(TubulConstants.PREFIXE_LOADER + pISound.uri.toSum());
            resource = cr.resource;
            pISound.sound = resource;
         }
         else
         {
            pISound.loadSound(this._cache);
            pISound.eventDispatcher.addEventListener(LoadingSoundEvent.LOADING_FAILED,this.onLoadFail);
         }
      }
      
      public function setPlaylist(playlist:Vector.<ISound>) : void
      {
         var sound:ISound = null;
         this._playlist = new PlayList();
         for each(sound in playlist)
         {
            this._playlist.addSound(sound);
         }
      }
      
      public function addISoundInPlaylist(sound:ISound) : void
      {
         if(!this._playlist)
         {
            this._playlist = new PlayList();
         }
         this._playlist.addSound(sound);
      }
      
      public function addEffect(pEffect:IEffect) : void
      {
         var effect:IEffect = null;
         var isound:ISound = null;
         for each(effect in this._effects)
         {
            if(effect.name == pEffect.name)
            {
               return;
            }
         }
         this._effects.push(pEffect);
         for each(isound in this._soundVector)
         {
            isound.addEffect(pEffect);
         }
      }
      
      public function removeEffect(pEffect:IEffect) : void
      {
         var effect:IEffect = null;
         var isound:ISound = null;
         var compt:uint = 0;
         for each(effect in this._effects)
         {
            if(effect == pEffect)
            {
               this._effects.splice(compt,1);
            }
            else
            {
               compt++;
            }
         }
         for each(isound in this._soundVector)
         {
            isound.removeEffect(pEffect);
         }
      }
      
      public function fadeSound(pFade:Number, pFadeTime:Number) : void
      {
         Tweener.removeTweens(this);
         Tweener.addTween(this,{
            "fadeVolume":pFade,
            "time":pFadeTime,
            "transition":"linear"
         });
      }
      
      public function play() : void
      {
         var isound:ISound = null;
         for each(isound in this._soundVector)
         {
            isound.play();
         }
      }
      
      public function stop() : void
      {
         var isound:ISound = null;
         for each(isound in this._soundVector)
         {
            isound.stop();
         }
         this._timerSilence.stop();
      }
      
      public function startPlaylist(pWithFade:Boolean = false, pFadetime:Number = 0) : void
      {
         this._playlist.play();
      }
      
      public function stopPlaylist() : void
      {
         this._playlist.stop();
      }
      
      public function applyDynamicMix(pFadeIn:Number, pFadeInTime:uint, pWaitingTime:uint, pFadeOutTime:uint) : void
      {
      }
      
      private function init(id:int, name:String) : void
      {
         this._eventDispatcher = new EventDispatcher();
         this._cache = Cache.create(TubulConstants.MAXIMUM_BOUNDS_CACHE,new LruGarbageCollector(),getQualifiedClassName(this));
         this._soundVector = new Vector.<ISound>();
         this._playlistAlreadyUsed = false;
         this._name = name;
         this._id = id;
         this._effects = new Vector.<IEffect>();
         this.volume = 1;
         this.fadeVolume = 1;
      }
      
      private function soundAllreadyExists(pISound:ISound) : Boolean
      {
         var isound:ISound = null;
         for each(isound in this._soundVector)
         {
            if(isound.id == pISound.id)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function removeSound(pISound:ISound, pFade:Number = -1, pFadeTime:Number = 0) : uint
      {
         var indexOfSound:uint = this._soundVector.indexOf(pISound);
         if(indexOfSound == -1)
         {
            return this._soundVector.length;
         }
         if(pFade > 1)
         {
            pFade = 1;
         }
         if(pFade < 0)
         {
            pFade = 0;
         }
         pISound.eventDispatcher.removeEventListener(SoundCompleteEvent.SOUND_COMPLETE,this.onSoundComplete);
         pISound.eventDispatcher.removeEventListener(SilenceEvent.SOUND_SILENCE_COMPLETE,this.onSilenceEnd);
         pISound.eventDispatcher.removeEventListener(LoadingSoundEvent.LOADING_FAILED,this.onLoadFail);
         if(this._timerSilence)
         {
            this._timerSilence.removeEventListener(TimerEvent.TIMER,this.onSilenceEnd);
         }
         if(pISound.isPlayingSilence)
         {
            pISound.stopSilence();
         }
         if(pISound.isPlaying)
         {
            pISound.stop(pFade,pFadeTime);
         }
         pISound = null;
         this._soundVector.splice(indexOfSound,1);
         _playingSound--;
         return this._soundVector.length;
      }
      
      protected function nextISoundInPlaylist() : void
      {
         this._playlist.nextSound();
      }
      
      protected function shufflePlaylist() : void
      {
         this._playlist.shuffle = true;
      }
      
      protected function getOlderSound() : ISound
      {
         var olderSound:ISound = null;
         var isound:ISound = null;
         for each(isound in this._soundVector)
         {
            if(olderSound == null)
            {
               olderSound = isound;
            }
            else if(isound.id < olderSound.id)
            {
               olderSound = isound;
            }
         }
         return olderSound;
      }
      
      protected function informSoundsNewVolume() : void
      {
         var abve:AudioBusVolumeEvent = new AudioBusVolumeEvent(AudioBusVolumeEvent.VOLUME_CHANGED);
         abve.newVolume = this.effectiveVolume;
         this._eventDispatcher.dispatchEvent(abve);
      }
      
      private function onLoadFail(event:LoadingSoundEvent) : void
      {
         this._log.warn("A sound failed to load : " + event.data.uri);
         this.removeSound(event.data);
      }
      
      protected function onSoundComplete(e:SoundCompleteEvent) : void
      {
         var listener:ILocalizedSoundListener = null;
         this._eventDispatcher.dispatchEvent(e);
         for each(listener in Tubul.getInstance().localizedSoundListeners)
         {
            listener.removeSoundEntity(e.sound);
         }
         this.removeSound(e.sound);
         e = null;
      }
      
      protected function onSilenceEnd(e:TimerEvent) : void
      {
         this.nextISoundInPlaylist();
      }
      
      protected function onFadeBeforeDeleteComplete(e:FadeEvent) : void
      {
         this.removeSound(e.sound);
      }
      
      private function onRemoveSound(sound:ISound) : void
      {
         var event:AudioBusEvent = new AudioBusEvent(AudioBusEvent.REMOVE_SOUND_IN_BUS);
         event.sound = sound;
         this._eventDispatcher.dispatchEvent(event);
      }
      
      private function onAddSound(sound:ISound) : void
      {
         var event:AudioBusEvent = new AudioBusEvent(AudioBusEvent.ADD_SOUND_IN_BUS);
         event.sound = sound;
         this._eventDispatcher.dispatchEvent(event);
      }
   }
}
