package com.ankamagames.tubul.interfaces
{
   import flash.events.EventDispatcher;
   
   public interface IAudioBus extends ISoundController
   {
       
      function get eventDispatcher() : EventDispatcher;
      
      function get id() : uint;
      
      function get name() : String;
      
      function set volumeMax(param1:Number) : void;
      
      function get volumeMax() : Number;
      
      function get numberSoundsLimitation() : int;
      
      function set numberSoundsLimitation(param1:int) : void;
      
      function addISound(param1:ISound) : void;
      
      function playISound(param1:ISound, param2:Boolean = false, param3:int = -1) : void;
      
      function clearBUS(param1:Number = -1, param2:Number = 1) : void;
      
      function setPlaylist(param1:Vector.<ISound>) : void;
      
      function addISoundInPlaylist(param1:ISound) : void;
      
      function startPlaylist(param1:Boolean = false, param2:Number = 1) : void;
      
      function stopPlaylist() : void;
   }
}
