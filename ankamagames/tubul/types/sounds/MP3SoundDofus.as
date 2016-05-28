package com.ankamagames.tubul.types.sounds
{
   import com.ankamagames.tubul.interfaces.ISound;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.newCache.impl.Cache;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.TubulConstants;
   import com.ankamagames.jerakine.newCache.garbage.LruGarbageCollector;
   import com.ankamagames.jerakine.types.Uri;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.events.EventDispatcher;
   import flash.media.SoundTransform;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import flash.utils.Timer;
   import com.ankamagames.tubul.interfaces.IEffect;
   import flash.utils.ByteArray;
   import com.ankamagames.tubul.Tubul;
   import com.ankamagames.tubul.events.AudioBusVolumeEvent;
   import caurina.transitions.Tweener;
   import flash.events.TimerEvent;
   import flash.events.SampleDataEvent;
   import flash.events.Event;
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.tubul.events.SoundCompleteEvent;
   import com.ankamagames.tubul.events.SilenceEvent;
   import com.ankamagames.tubul.events.LoadingSound.LoadingSoundEvent;
   import com.ankamagames.tubul.events.FadeEvent;
   import com.ankamagames.tubul.events.LoopEvent;
   
   public class MP3SoundDofus implements ISound
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(MP3SoundDofus));
      
      protected static var cacheByteArray:Cache = new Cache(TubulConstants.BOUNDS_BYTEARRAY_CACHE,new LruGarbageCollector());
       
      protected var _uri:Uri;
      
      protected var _id:int;
      
      protected var _sound:Sound;
      
      protected var _bufferSound:Sound;
      
      protected var _soundChannel:SoundChannel;
      
      protected var _eventDispatcher:EventDispatcher;
      
      protected var _soundTransform:SoundTransform;
      
      protected var _onLoadingComplete:Array;
      
      protected var _soundLoaded:Boolean;
      
      protected var _loader:IResourceLoader;
      
      protected var _silenceMin:int;
      
      protected var _silenceMax:int;
      
      protected var _busId:int;
      
      protected var _loop:Boolean = false;
      
      protected var _playing:Boolean = false;
      
      protected var _stopAfterEnd:Boolean = false;
      
      protected var _noCutSilence:Boolean;
      
      protected var _volume:Number;
      
      protected var _fadeVolume:Number;
      
      protected var _previousVolume:Number;
      
      protected var _previousFadeVolume:Number;
      
      protected var _actualLoop:uint;
      
      protected var _totalLoop:int;
      
      protected var _playSilenceAfterLoop:Boolean;
      
      protected var _timer:Timer;
      
      protected var _effects:Vector.<IEffect>;
      
      protected var _byteArray:ByteArray;
      
      protected var _begin:int;
      
      protected var _loopTime:uint;
      
      protected var _actualLoopTime:uint;
      
      protected var _extractOnSampleEvent:Boolean = false;
      
      protected var _extractPosition:Number;
      
      private var _position:Number;
      
      public function MP3SoundDofus(id:uint, uri:Uri, isInPlaylist:Boolean = false)
      {
         super();
         this.initSound();
         this._uri = uri;
         this._id = id;
         this._effects = new Vector.<IEffect>();
      }
      
      public function get effects() : Vector.<IEffect>
      {
         return this._effects;
      }
      
      public function get uri() : Uri
      {
         return this._uri;
      }
      
      public function get eventDispatcher() : EventDispatcher
      {
         return this._eventDispatcher;
      }
      
      public function get volume() : Number
      {
         return this._volume;
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
         if(Boolean(this._soundLoaded) && this._previousVolume != this._volume)
         {
            this.applyParam();
            _log.info("Sound " + this.id + " (" + this.uri.fileName + ") volume réel : " + this.effectiveVolume + " (volume : " + this._volume + " / vol. fade : " + this._fadeVolume + " / vol. bus : " + this.busVolume + ")");
         }
         this._previousVolume = this._volume;
      }
      
      public function get bus() : int
      {
         return this._busId;
      }
      
      public function set bus(pBus:int) : void
      {
         this._busId = pBus;
         Tubul.getInstance().getBus(pBus).eventDispatcher.addEventListener(AudioBusVolumeEvent.VOLUME_CHANGED,this.onAudioBusVolumeChanged);
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
         if(Boolean(this._soundLoaded) && this._previousFadeVolume != this._fadeVolume)
         {
            this.applyParam();
         }
         this._previousFadeVolume = this._fadeVolume;
      }
      
      public function get effectiveVolume() : Number
      {
         return this.busVolume * this.volume * this.fadeVolume;
      }
      
      public function get soundChannel() : SoundChannel
      {
         return this._soundChannel;
      }
      
      public function get sound() : Sound
      {
         return this._sound;
      }
      
      public function set sound(sound:*) : void
      {
         this._sound = sound;
         this._soundLoaded = true;
         this.finishLoading();
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set silenceMin(pSilenceMin:int) : void
      {
         this._silenceMin = pSilenceMin;
      }
      
      public function get silenceMin() : int
      {
         return this._silenceMin;
      }
      
      public function set silenceMax(pSilenceMax:int) : void
      {
         this._silenceMax = pSilenceMax;
      }
      
      public function get silenceMax() : int
      {
         return this._silenceMax;
      }
      
      public function get busVolume() : Number
      {
         if(this._busId != -1)
         {
            return Tubul.getInstance().getBus(this._busId).effectiveVolume;
         }
         return -1;
      }
      
      public function get noCutSilence() : Boolean
      {
         return this._noCutSilence;
      }
      
      public function set noCutSilence(pNoCutSilence:Boolean) : void
      {
         this._noCutSilence = pNoCutSilence;
         if(this._noCutSilence)
         {
            this._begin = 0;
         }
      }
      
      public function get isPlaying() : Boolean
      {
         return this._playing;
      }
      
      public function get isPlayingSilence() : Boolean
      {
         if(Boolean(this._timer) && Boolean(this._timer.running))
         {
            return true;
         }
         return false;
      }
      
      public function addEffect(pEffect:IEffect) : void
      {
         this._effects.push(pEffect);
      }
      
      public function removeEffect(pEffect:IEffect) : void
      {
         var effect:IEffect = null;
         var compt:uint = 0;
         for each(effect in this._effects)
         {
            if(effect == pEffect)
            {
               this._effects.splice(compt,1);
               return;
            }
         }
      }
      
      public function fadeSound(pFade:Number, pFadeTime:Number) : void
      {
         if(pFade > 1)
         {
            pFade = 1;
         }
         if(pFade < 0)
         {
            pFade = 0;
         }
         Tweener.removeTweens(this);
         Tweener.addTween(this,{
            "fadeVolume":pFade,
            "time":pFadeTime,
            "transition":"linear",
            "onComplete":this.onFadeComplete
         });
      }
      
      public function playSilence() : void
      {
         var silenceTime:uint = this.silenceMin + Math.random() * (this.silenceMax - this.silenceMin);
         silenceTime = 10;
         trace("On a définit le silence sur " + silenceTime + " seconde(s)");
         this._timer = new Timer(silenceTime * 1000,1);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimerEnd);
         this._timer.start();
         this._byteArray.position = this._begin;
      }
      
      public function stopSilence() : void
      {
         if(this._timer == null)
         {
            return;
         }
         this._timer.removeEventListener(TimerEvent.TIMER,this.onTimerEnd);
         this._timer.stop();
         this._timer = null;
      }
      
      public function play(pLoop:Boolean = false, pLoops:int = -1, pPlaySilenceAfterLoopThenReloop:Boolean = false) : void
      {
         if(this._busId == -1)
         {
            _log.error("The sound (" + this._id + " / " + this._uri.uri + ") is not attribuated to an audio bus, can\'t play");
            return;
         }
         Tubul.getInstance().getBus(this._busId).addISound(this);
         if(this._playing)
         {
            return;
         }
         this._loop = pLoop;
         this._totalLoop = pLoops;
         this._playSilenceAfterLoop = pPlaySilenceAfterLoopThenReloop;
         if(this._noCutSilence)
         {
            this._begin = 0;
         }
         if(!this._actualLoopTime)
         {
            this._actualLoopTime = 1;
         }
         else
         {
            this._actualLoopTime++;
         }
         if(!this._soundLoaded)
         {
            if(this._loop)
            {
               this._onLoadingComplete.push(this.playLoop);
            }
            else
            {
               this._onLoadingComplete.push(this.play);
            }
            return;
         }
         this._playing = true;
         this._bufferSound = new Sound();
         this._bufferSound.addEventListener(SampleDataEvent.SAMPLE_DATA,this.onSampleData);
         this._soundChannel = this._bufferSound.play();
         this._soundChannel.addEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         this.applyParam();
         _log.debug("Play / file : " + this._uri.fileName + " / id : " + this._id + " / vol. réel : " + this.effectiveVolume + " / vol. : " + this._volume + " / vol. fade : " + this._fadeVolume + " / bus : " + Tubul.getInstance().getBus(this.bus).name + " (" + this.bus + ")");
      }
      
      public function loadSound(cache:ICache) : void
      {
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SINGLE_LOADER);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onLoaded);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onFailed);
         this._loader.load(this._uri,cache);
      }
      
      public function playLoop(numberPlay:int = -1, timePause:Number = 0) : void
      {
         this._loop = true;
         this.play(this._loop,this._totalLoop,this._playSilenceAfterLoop);
      }
      
      public function stop(pFade:Number = -1, pFadeTime:Number = 1) : void
      {
         var sce:SoundCompleteEvent = null;
         if(this._loader)
         {
            this._loader.removeEventListener(ResourceLoadedEvent.LOADED,this.onLoaded);
            this._loader.removeEventListener(ResourceErrorEvent.ERROR,this.onFailed);
            this._loader = null;
         }
         this.stopSilence();
         if(this._soundChannel != null)
         {
            if(pFade != -1 && pFade >= 0 && pFadeTime != 0)
            {
               this._stopAfterEnd = true;
               this.fadeSound(pFade,pFadeTime);
            }
            else
            {
               Tweener.removeTweens(this);
               if(this._bufferSound)
               {
                  this._bufferSound.removeEventListener(SampleDataEvent.SAMPLE_DATA,this.onSampleData);
               }
               this._playing = false;
               Tubul.getInstance().getBus(this.bus).eventDispatcher.removeEventListener(AudioBusVolumeEvent.VOLUME_CHANGED,this.onAudioBusVolumeChanged);
               sce = new SoundCompleteEvent(SoundCompleteEvent.SOUND_COMPLETE);
               sce.sound = this;
               this.onSoundComplete(sce);
            }
         }
      }
      
      public function setSilence(silenceMin:int, silenceMax:int) : void
      {
         this._silenceMin = silenceMin;
         this._silenceMax = silenceMax;
      }
      
      public function applyDynamicMix(pFadeIn:Number, pFadeInTime:uint, pWaitingTime:uint, pFadeOutTime:uint) : void
      {
      }
      
      protected function applyParam() : void
      {
         this._soundTransform = this._soundChannel.soundTransform;
         this._soundTransform.volume = this.effectiveVolume;
         this._soundChannel.soundTransform = this._soundTransform;
      }
      
      protected function initSound() : void
      {
         this._silenceMin = -1;
         this._silenceMax = -1;
         this._soundLoaded = false;
         this._onLoadingComplete = new Array();
         this._soundChannel = new SoundChannel();
         this._eventDispatcher = new EventDispatcher();
         this._busId = -1;
         this.volume = 1;
         this.fadeVolume = 1;
         this._previousVolume = 1;
         this._previousFadeVolume = 1;
         this._byteArray = new ByteArray();
         this._begin = 0;
         this._actualLoop = 0;
         this._totalLoop = -1;
      }
      
      protected function onSoundComplete(e:Event) : void
      {
         Tweener.removeTweens(this);
         this._soundChannel.removeEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         Tubul.getInstance().getBus(this.bus).eventDispatcher.removeEventListener(AudioBusVolumeEvent.VOLUME_CHANGED,this.onAudioBusVolumeChanged);
         this._playing = false;
         var sce:SoundCompleteEvent = new SoundCompleteEvent(SoundCompleteEvent.SOUND_COMPLETE);
         sce.sound = this;
         if(this._eventDispatcher == null)
         {
            this._eventDispatcher = new EventDispatcher();
         }
         this._eventDispatcher.dispatchEvent(sce);
         sce = null;
         this._eventDispatcher = null;
         if(this._byteArray)
         {
            this._byteArray.position = this._begin;
            this._byteArray = null;
         }
      }
      
      protected function onTimerEnd(event:TimerEvent) : void
      {
         this._timer.removeEventListener(TimerEvent.TIMER,this.onTimerEnd);
         var se:SilenceEvent = new SilenceEvent(SilenceEvent.SOUND_SILENCE_COMPLETE);
         se.sound = this;
         this.eventDispatcher.dispatchEvent(se);
         if(this._playSilenceAfterLoop)
         {
            this.play(this._loop,this._loopTime,this._playSilenceAfterLoop);
         }
      }
      
      private function onLoaded(e:ResourceLoadedEvent) : void
      {
         this._soundLoaded = true;
         this._sound = e.resource;
         this._loader.removeEventListener(ResourceLoadedEvent.LOADED,this.onLoaded);
         this._loader.removeEventListener(ResourceErrorEvent.ERROR,this.onFailed);
         this._loader = null;
         this.finishLoading();
      }
      
      private function processFilters(pInput:Number = Infinity) : Number
      {
         var iFilter:IEffect = null;
         if(pInput == Number.POSITIVE_INFINITY)
         {
            if(this._byteArray.bytesAvailable >= 4)
            {
               pInput = this._byteArray.readFloat();
            }
            else
            {
               _log.warn("The sound\'s byteArray is at the end of file !");
               this._bufferSound.removeEventListener(SampleDataEvent.SAMPLE_DATA,this.onSampleData);
               return 0;
            }
         }
         var filteredData:Number = pInput;
         for each(iFilter in Tubul.getInstance().getBus(this._busId).effects)
         {
            filteredData = iFilter.process(filteredData);
         }
         return filteredData;
      }
      
      private function finishLoading() : void
      {
         var minimum:Number = NaN;
         var readFloat:Number = NaN;
         var i:int = 0;
         if(MP3SoundDofus.cacheByteArray.contains(this._uri.path))
         {
            this._byteArray = new ByteArray();
            this._byteArray.writeBytes((MP3SoundDofus.cacheByteArray.peek(this._uri.path) as cacheObjectSound).byteArray);
            this._begin = (MP3SoundDofus.cacheByteArray.peek(this._uri.path) as cacheObjectSound).begin;
         }
         else if(!this._extractOnSampleEvent)
         {
            this._sound.extract(this._byteArray,this._sound.length * 44.1,0);
            this._byteArray.position = 0;
            this._sound = null;
            minimum = 0;
            while(this._byteArray.bytesAvailable >= 4)
            {
               readFloat = this._byteArray.readFloat();
               if(readFloat > minimum)
               {
                  break;
               }
               this._begin++;
            }
            this._begin = this._begin * ((4 * 2 + 4 * 2) * 2);
            MP3SoundDofus.cacheByteArray.store(this._uri.path,new cacheObjectSound(this._byteArray,this._begin));
         }
         this._byteArray.position = 0;
         var lse:LoadingSoundEvent = new LoadingSoundEvent(LoadingSoundEvent.LOADED);
         lse.data = this;
         this._eventDispatcher.dispatchEvent(lse);
         var size:int = this._onLoadingComplete.length;
         if(size > 0)
         {
            this._onLoadingComplete.reverse();
            for(i = size - 1; i >= 0; i--)
            {
               (this._onLoadingComplete[i] as Function)();
            }
         }
         this._onLoadingComplete = new Array();
      }
      
      private function onFailed(e:ResourceErrorEvent) : void
      {
         var lse:LoadingSoundEvent = new LoadingSoundEvent(LoadingSoundEvent.LOADING_FAILED);
         lse.data = this;
         this._eventDispatcher.dispatchEvent(lse);
      }
      
      private function onFadeComplete() : void
      {
         var fe:FadeEvent = new FadeEvent(FadeEvent.COMPLETE);
         fe.sound = this;
         this._eventDispatcher.dispatchEvent(fe);
         _log.info("FIN DE FADE Sound " + this.id + " (" + this.uri.fileName + ") volume réel : " + this.effectiveVolume + " (volume : " + this._volume + " / vol. fade : " + this._fadeVolume + " / vol. bus : " + this.busVolume + ")");
         if(this._stopAfterEnd)
         {
            this.stop();
         }
      }
      
      private function onSampleData(pEvent:SampleDataEvent) : void
      {
         var compt:uint = 0;
         var len:uint = 0;
         var le:LoopEvent = null;
         var buffSize:uint = 0;
         if(this._extractOnSampleEvent)
         {
            compt = 0;
            this._sound.extract(this._byteArray,TubulConstants.BUFFER_SIZE,this._position);
            if(this._byteArray.bytesAvailable >= TubulConstants.BUFFER_SIZE * 4)
            {
               for(compt = 0; compt < TubulConstants.BUFFER_SIZE; compt++)
               {
                  pEvent.data.writeFloat(this.processFilters());
               }
            }
            else
            {
               len = this._byteArray.bytesAvailable / 4;
               for(compt = 0; compt < len; compt++)
               {
                  pEvent.data.writeFloat(this.processFilters());
               }
               if(this._loop)
               {
                  this._actualLoop++;
                  if(this._actualLoop >= this._totalLoop && this._totalLoop > 0)
                  {
                     if(this._playSilenceAfterLoop)
                     {
                        this.playSilence();
                     }
                     le = new LoopEvent(LoopEvent.SOUND_LOOP_ALL_COMPLETE);
                     this._bufferSound.removeEventListener(SampleDataEvent.SAMPLE_DATA,this.onSampleData);
                  }
                  else
                  {
                     le = new LoopEvent(LoopEvent.SOUND_LOOP);
                     this._byteArray.position = this._begin;
                     buffSize = TubulConstants.BUFFER_SIZE - len;
                     for(compt = 0; compt < buffSize; compt++)
                     {
                        pEvent.data.writeFloat(this.processFilters());
                     }
                  }
                  le.loop = this._actualLoop;
                  le.sound = this;
                  this.eventDispatcher.dispatchEvent(le);
                  le = null;
               }
               else
               {
                  this._bufferSound.removeEventListener(SampleDataEvent.SAMPLE_DATA,this.onSampleData);
               }
            }
         }
         else
         {
            if(this._byteArray == null)
            {
               this._bufferSound.removeEventListener(SampleDataEvent.SAMPLE_DATA,this.onSampleData);
               return;
            }
            compt = 0;
            if(this._byteArray.bytesAvailable >= TubulConstants.BUFFER_SIZE * 4)
            {
               for(compt = 0; compt < TubulConstants.BUFFER_SIZE; compt++)
               {
                  pEvent.data.writeFloat(this.processFilters());
               }
            }
            else
            {
               len = this._byteArray.bytesAvailable / 4;
               for(compt = 0; compt < len; compt++)
               {
                  pEvent.data.writeFloat(this.processFilters());
               }
               if(this._loop)
               {
                  this._actualLoop++;
                  if(this._actualLoop >= this._totalLoop && this._totalLoop > 0)
                  {
                     if(this._playSilenceAfterLoop)
                     {
                        this.playSilence();
                     }
                     le = new LoopEvent(LoopEvent.SOUND_LOOP_ALL_COMPLETE);
                     this._bufferSound.removeEventListener(SampleDataEvent.SAMPLE_DATA,this.onSampleData);
                  }
                  else
                  {
                     le = new LoopEvent(LoopEvent.SOUND_LOOP);
                     this._byteArray.position = this._begin;
                     buffSize = TubulConstants.BUFFER_SIZE - len;
                     for(compt = 0; compt < buffSize; compt++)
                     {
                        pEvent.data.writeFloat(this.processFilters());
                     }
                  }
                  le.loop = this._actualLoop;
                  le.sound = this;
                  this.eventDispatcher.dispatchEvent(le);
                  le = null;
               }
               else
               {
                  this._bufferSound.removeEventListener(SampleDataEvent.SAMPLE_DATA,this.onSampleData);
               }
            }
         }
      }
      
      private function onAudioBusVolumeChanged(pEvent:AudioBusVolumeEvent) : void
      {
         this.applyParam();
      }
   }
}

import flash.utils.ByteArray;

class cacheObjectSound
{
    
   public var byteArray:ByteArray;
   
   public var begin:int = 0;
   
   function cacheObjectSound(pByteArray:ByteArray, pBegin:int)
   {
      super();
      this.byteArray = pByteArray;
      this.begin = pBegin;
   }
}
