package com.ankamagames.tubul.interfaces
{
   public interface ISoundController
   {
       
      function get effects() : Vector.<IEffect>;
      
      function get volume() : Number;
      
      function set volume(param1:Number) : void;
      
      function get fadeVolume() : Number;
      
      function set fadeVolume(param1:Number) : void;
      
      function get effectiveVolume() : Number;
      
      function addEffect(param1:IEffect) : void;
      
      function removeEffect(param1:IEffect) : void;
      
      function fadeSound(param1:Number, param2:Number) : void;
      
      function applyDynamicMix(param1:Number, param2:uint, param3:uint, param4:uint) : void;
   }
}
