package com.ankamagames.tiphon.types
{
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   
   public interface IAnimationModifier
   {
       
      function getModifiedAnimation(param1:String, param2:TiphonEntityLook) : String;
   }
}
