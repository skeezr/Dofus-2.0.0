package com.ankamagames.jerakine.utils.display.spellZone
{
   public interface ICellZoneProvider
   {
       
      function get minimalRange() : uint;
      
      function set minimalRange(param1:uint) : void;
      
      function get maximalRange() : uint;
      
      function set maximalRange(param1:uint) : void;
      
      function get castZoneInLine() : Boolean;
      
      function set castZoneInLine(param1:Boolean) : void;
      
      function get spellZoneEffects() : Vector.<IZoneShape>;
   }
}
