package com.ankamagames.tubul.interfaces
{
   import com.ankamagames.jerakine.types.Uri;
   import flash.events.EventDispatcher;
   import flash.media.Sound;
   import com.ankamagames.jerakine.newCache.ICache;
   
   public interface ISound extends ISoundController
   {
       
      function get uri() : Uri;
      
      function get eventDispatcher() : EventDispatcher;
      
      function get sound() : Sound;
      
      function set sound(param1:*) : void;
      
      function get bus() : int;
      
      function set bus(param1:int) : void;
      
      function get id() : int;
      
      function get silenceMin() : int;
      
      function set silenceMin(param1:int) : void;
      
      function get silenceMax() : int;
      
      function set silenceMax(param1:int) : void;
      
      function get noCutSilence() : Boolean;
      
      function set noCutSilence(param1:Boolean) : void;
      
      function get isPlaying() : Boolean;
      
      function get isPlayingSilence() : Boolean;
      
      function play(param1:Boolean = false, param2:int = -1, param3:Boolean = false) : void;
      
      function stop(param1:Number = -1, param2:Number = 1) : void;
      
      function loadSound(param1:ICache) : void;
      
      function setSilence(param1:int, param2:int) : void;
      
      function playSilence() : void;
      
      function stopSilence() : void;
   }
}
