package com.ankamagames.tiphon.types
{
   import flash.utils.getQualifiedClassName;
   import flash.display.Sprite;
   
   public class EquipmentSprite extends DynamicSprite
   {
      
      private static var n:uint = 0;
       
      public function EquipmentSprite()
      {
         super();
      }
      
      override public function init(handler:IAnimationSpriteHandler) : void
      {
         if(getQualifiedClassName(parent) == getQualifiedClassName(this))
         {
            return;
         }
         var c:Sprite = handler.getSkinSprite(this);
         if(Boolean(c) && c != this)
         {
            addChild(c);
         }
      }
   }
}
