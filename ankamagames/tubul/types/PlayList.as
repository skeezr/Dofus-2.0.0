package com.ankamagames.tubul.types
{
   import flash.events.EventDispatcher;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.tubul.interfaces.ISound;
   import com.ankamagames.jerakine.BalanceManager.BalanceManager;
   import com.ankamagames.tubul.interfaces.IAudioBus;
   import com.ankamagames.tubul.events.SoundCompleteEvent;
   import com.ankamagames.tubul.Tubul;
   import com.ankamagames.tubul.events.PlaylistEvent;
   
   public class PlayList extends EventDispatcher
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(PlayList));
       
      private var _sounds:Vector.<ISound>;
      
      private var _playingSound:ISound;
      
      public var shuffle:Boolean;
      
      public var loop:Boolean;
      
      private var _isPlaying:Boolean = false;
      
      private var _balanceManager:BalanceManager;
      
      public function PlayList(pShuffle:Boolean = false, pLoop:Boolean = false)
      {
         super();
         this.shuffle = pShuffle;
         this.loop = pLoop;
         this.init();
      }
      
      public function get tracklist() : Vector.<ISound>
      {
         return this._sounds;
      }
      
      public function get playingSound() : ISound
      {
         if(this._isPlaying)
         {
            return this._playingSound;
         }
         return null;
      }
      
      public function get playingSoundIndex() : int
      {
         var index:uint = 0;
         if(this._isPlaying)
         {
            index = this._sounds.indexOf(this._playingSound);
            return index;
         }
         return -1;
      }
      
      public function addSound(pSound:ISound) : uint
      {
         this._sounds.push(pSound);
         this._balanceManager.addItem(pSound);
         return this._sounds.length;
      }
      
      public function removeSound(pSound:ISound) : uint
      {
         var index:int = this._sounds.indexOf(pSound);
         if(index != -1)
         {
            if(pSound.isPlaying)
            {
               pSound.stop();
            }
            this._balanceManager.removeItem(pSound);
            this._sounds.splice(index,1);
         }
         return this._sounds.length;
      }
      
      public function removeSoundBySoundId(pSoundId:String, pRemoveAll:Boolean = true) : uint
      {
         var sound:ISound = null;
         var index:int = 0;
         for each(sound in this._sounds)
         {
            if(sound.uri.fileName.split(".")[0] == pSoundId)
            {
               index = this._sounds.indexOf(sound);
               if(index != -1)
               {
                  if(sound.isPlaying)
                  {
                     sound.stop();
                  }
                  this._balanceManager.removeItem(sound);
                  this._sounds.splice(index,1);
               }
            }
         }
         return this._sounds.length;
      }
      
      public function play() : void
      {
         var bus:IAudioBus = null;
         if(this._isPlaying)
         {
            return;
         }
         if(Boolean(this._sounds) && this._sounds.length > 0)
         {
            this._isPlaying = true;
            switch(this.shuffle)
            {
               case true:
                  this._playingSound = this._balanceManager.callItem() as ISound;
                  break;
               case false:
                  this._playingSound = this._sounds[0] as ISound;
            }
            this._playingSound.eventDispatcher.addEventListener(SoundCompleteEvent.SOUND_COMPLETE,this.onSoundComplete);
            bus = Tubul.getInstance().getBus(0);
            if(bus != null)
            {
               bus.playISound(this._playingSound);
            }
         }
      }
      
      public function nextSound() : void
      {
         var index:int = 0;
         var bus:IAudioBus = null;
         switch(this.shuffle)
         {
            case true:
               this._playingSound = this._balanceManager.callItem() as ISound;
               break;
            case false:
               index = this._sounds.indexOf(this._playingSound);
               if(index == this._sounds.length - 1)
               {
                  _log.warn("We reached the end of the playlist.");
                  if(this.loop)
                  {
                     _log.warn("Playlist is in loop mode. Looping.");
                     this._playingSound = this._sounds[0];
                  }
                  else
                  {
                     _log.warn("Playlist stop.");
                     this._playingSound = null;
                  }
                  dispatchEvent(new PlaylistEvent(PlaylistEvent.PLAYLIST_COMPLETE));
               }
               else
               {
                  this._playingSound = this._sounds[index + 1];
               }
         }
         if(this._playingSound)
         {
            this._playingSound.eventDispatcher.addEventListener(SoundCompleteEvent.SOUND_COMPLETE,this.onSoundComplete);
            bus = Tubul.getInstance().getBus(0);
            if(bus != null)
            {
               bus.playISound(this._playingSound);
            }
         }
      }
      
      public function previousSound() : void
      {
         switch(this.shuffle)
         {
            case true:
               break;
            case false:
         }
      }
      
      public function stop() : void
      {
         if(this._playingSound == null)
         {
            return;
         }
         this._playingSound.eventDispatcher.removeEventListener(SoundCompleteEvent.SOUND_COMPLETE,this.onSoundComplete);
         this._playingSound.stop();
      }
      
      public function reset() : void
      {
         this.stop();
         this.init();
      }
      
      private function init() : void
      {
         this._sounds = new Vector.<ISound>();
         this._balanceManager = new BalanceManager();
      }
      
      private function onSoundComplete(pEvent:SoundCompleteEvent) : void
      {
         this._playingSound.eventDispatcher.removeEventListener(SoundCompleteEvent.SOUND_COMPLETE,this.onSoundComplete);
         this.nextSound();
      }
   }
}
