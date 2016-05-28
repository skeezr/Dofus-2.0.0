package com.ankamagames.dofus.kernel.sound.type
{
   import com.ankamagames.tubul.interfaces.ISound;
   import com.ankamagames.tubul.interfaces.ILocalizedSound;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.tubul.interfaces.IEffect;
   import flash.geom.Point;
   import com.ankamagames.dofus.kernel.sound.manager.RegConnectionManager;
   import com.ankamagames.jerakine.protocolAudio.ProtocolEnum;
   import flash.events.EventDispatcher;
   import flash.media.Sound;
   import com.ankamagames.jerakine.newCache.ICache;
   
   public class SoundDofus implements ISound, ILocalizedSound
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SoundDofus));
      
      private static var _actualId:int = -1;
      
      private static var _cache:Dictionary = new Dictionary();
       
      protected var _busId:int;
      
      protected var _id:int;
      
      protected var _soundId:String;
      
      protected var _uri:Uri;
      
      protected var _volume:Number;
      
      protected var _fadeVolume:Number;
      
      protected var _busVolume:Number;
      
      protected var _silenceMin:int;
      
      protected var _silenceMax:int;
      
      protected var _isInPlaylist:Boolean;
      
      protected var _loop:Boolean = false;
      
      protected var _noCutSilence:Boolean;
      
      protected var _effects:Vector.<IEffect>;
      
      protected var _waitingOperations:Vector.<Function>;
      
      private var _pan:Number;
      
      private var _position:Point;
      
      private var _range:Number;
      
      private var _saturationRange:Number;
      
      private var _observerPosition:Point;
      
      private var _volumeMax:Number;
      
      public function SoundDofus(pSoundID:String, useCache:Boolean = false)
      {
         super();
         this.init();
         if(Boolean(_cache[pSoundID]) && Boolean(useCache))
         {
            this._id = _cache[pSoundID];
         }
         else
         {
            this._id = _actualId--;
            if(useCache)
            {
               _cache[pSoundID] = this._id;
            }
         }
         this._soundId = pSoundID;
         RegConnectionManager.getInstance().send(ProtocolEnum.ADD_SOUND,this._id,this._soundId,true);
      }
      
      public function get pan() : Number
      {
         return this._pan;
      }
      
      public function set pan(pan:Number) : void
      {
         if(pan < -1)
         {
            this._pan = -1;
            return;
         }
         if(pan > 1)
         {
            this._pan = 1;
            return;
         }
         this._pan = pan;
      }
      
      public function get range() : Number
      {
         return this._range;
      }
      
      public function set range(range:Number) : void
      {
         if(range < this._saturationRange)
         {
            range = this._saturationRange;
         }
         this._range = range;
      }
      
      public function get saturationRange() : Number
      {
         return this._saturationRange;
      }
      
      public function set saturationRange(saturationRange:Number) : void
      {
         if(saturationRange >= this._range)
         {
            saturationRange = this._range;
         }
         this._saturationRange = saturationRange;
      }
      
      public function get position() : Point
      {
         return this._position;
      }
      
      public function set position(position:Point) : void
      {
         this._position = position;
      }
      
      public function get volumeMax() : Number
      {
         return this._volumeMax;
      }
      
      public function set volumeMax(pVolumeMax:Number) : void
      {
         if(pVolumeMax > 1)
         {
            pVolumeMax = 1;
         }
         if(pVolumeMax < 0)
         {
            pVolumeMax = 0;
         }
         this._volumeMax = pVolumeMax;
      }
      
      public function get effects() : Vector.<IEffect>
      {
         return this._effects;
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
         RegConnectionManager.getInstance().send(ProtocolEnum.SET_VOLUME,this._id,pVolume);
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
         RegConnectionManager.getInstance().send(ProtocolEnum.SET_FADE_VOLUME,this._id,pFadeVolume);
      }
      
      public function get effectiveVolume() : Number
      {
         return 0;
      }
      
      public function get uri() : Uri
      {
         return this._uri;
      }
      
      public function get eventDispatcher() : EventDispatcher
      {
         return null;
      }
      
      public function get sound() : Sound
      {
         return null;
      }
      
      public function set sound(sound:*) : void
      {
      }
      
      public function get bus() : int
      {
         return this._busId;
      }
      
      public function set bus(pBus:int) : void
      {
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get isInPlaylist() : Boolean
      {
         return this._isInPlaylist;
      }
      
      public function get silenceMin() : int
      {
         return this._silenceMin;
      }
      
      public function set silenceMin(pSilenceMin:int) : void
      {
         var o:Object = new Object();
         o.silenceMin = pSilenceMin;
         RegConnectionManager.getInstance().send(ProtocolEnum.SET_SOUND_PROPERTIES,this._id,o);
      }
      
      public function get silenceMax() : int
      {
         return this._silenceMax;
      }
      
      public function set silenceMax(pSilenceMax:int) : void
      {
         var o:Object = new Object();
         o.silenceMax = pSilenceMax;
         RegConnectionManager.getInstance().send(ProtocolEnum.SET_SOUND_PROPERTIES,this._id,o);
      }
      
      public function get noCutSilence() : Boolean
      {
         return this._noCutSilence;
      }
      
      public function set noCutSilence(pNoCutSilence:Boolean) : void
      {
         this._noCutSilence = pNoCutSilence;
         var o:Object = new Object();
         o.noCutSilence = pNoCutSilence;
         RegConnectionManager.getInstance().send(ProtocolEnum.SET_SOUND_PROPERTIES,this._id,o);
      }
      
      public function get isPlaying() : Boolean
      {
         return true;
      }
      
      public function get isPlayingSilence() : Boolean
      {
         return false;
      }
      
      public function addEffect(pEffect:IEffect) : void
      {
      }
      
      public function removeEffect(pEffect:IEffect) : void
      {
      }
      
      public function fadeSound(pFade:Number, pFadeTime:Number) : void
      {
         RegConnectionManager.getInstance().send(ProtocolEnum.FADE_SOUND,this._id,pFade,pFadeTime);
      }
      
      public function applyDynamicMix(pFadeIn:Number, pFadeInTime:uint, pWaitingTime:uint, pFadeOutTime:uint) : void
      {
      }
      
      public function play(pLoop:Boolean = false, pLoops:int = -1, pPlaySilenceAfterLoopThenReloop:Boolean = false) : void
      {
         RegConnectionManager.getInstance().send(ProtocolEnum.PLAY_SOUND,this._id,this._soundId,pLoop,pLoops,pPlaySilenceAfterLoopThenReloop);
      }
      
      public function playSilence() : void
      {
      }
      
      public function stopSilence() : void
      {
      }
      
      public function stop(pFade:Number = -1, pFadeTime:Number = 1) : void
      {
         RegConnectionManager.getInstance().send(ProtocolEnum.STOP_SOUND,this._id,pFade,pFadeTime);
      }
      
      public function loadSound(cache:ICache) : void
      {
      }
      
      public function setSilence(pSilenceMin:int, pSilenceMax:int) : void
      {
         RegConnectionManager.getInstance().send(ProtocolEnum.SET_SILENCE,this._id,pSilenceMin,pSilenceMax);
      }
      
      private function init() : void
      {
         this._waitingOperations = new Vector.<Function>();
         this._fadeVolume = 1;
         this._silenceMin = -1;
         this._silenceMax = -1;
         this._busVolume = 1;
         this._volume = 1;
      }
   }
}
