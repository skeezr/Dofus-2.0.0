package com.ankamagames.tiphon.types
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.display.DisplayObject;
   import com.ankamagames.tiphon.display.TiphonSprite;
   
   public class DynamicSprite extends MovieClip
   {
       
      protected var _root:com.ankamagames.tiphon.types.ScriptedAnimation;
      
      public function DynamicSprite()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
      }
      
      protected function getRoot() : com.ankamagames.tiphon.types.ScriptedAnimation
      {
         if(!this._root)
         {
            this._root = this._getRoot();
         }
         return this._root;
      }
      
      public function init(handler:IAnimationSpriteHandler) : void
      {
      }
      
      private function onAdded(e:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAdded);
         var currentDo:DisplayObject = e.target as DisplayObject;
         while(!(currentDo is TiphonSprite) && Boolean(currentDo.parent))
         {
            currentDo = currentDo.parent;
         }
         if(currentDo is TiphonSprite)
         {
            this.init(currentDo as TiphonSprite);
         }
      }
      
      private function _getRoot() : com.ankamagames.tiphon.types.ScriptedAnimation
      {
         var current:DisplayObject = this;
         while(current)
         {
            if(current is com.ankamagames.tiphon.types.ScriptedAnimation)
            {
               return current as com.ankamagames.tiphon.types.ScriptedAnimation;
            }
            current = current.parent;
         }
         return null;
      }
   }
}
