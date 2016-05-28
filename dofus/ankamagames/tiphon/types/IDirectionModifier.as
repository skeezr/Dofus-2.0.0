package com.ankamagames.tiphon.types
{
   import com.ankamagames.tiphon.display.TiphonSprite;
   
   public interface IDirectionModifier
   {
       
      function getModifiedDirection(param1:uint, param2:TiphonSprite) : uint;
   }
}
