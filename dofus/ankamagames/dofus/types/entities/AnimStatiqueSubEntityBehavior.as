package com.ankamagames.dofus.types.entities
{
   import com.ankamagames.tiphon.types.ISubEntityBehavior;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.types.BehaviorData;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.types.TiphonUtility;
   
   public class AnimStatiqueSubEntityBehavior implements ISubEntityBehavior
   {
       
      private var _subentity:TiphonSprite;
      
      private var _parentData:BehaviorData;
      
      private var _animation:String;
      
      public function AnimStatiqueSubEntityBehavior()
      {
         super();
      }
      
      public function updateFromParentEntity(target:TiphonSprite, parentData:BehaviorData) : void
      {
         this._subentity = target;
         this._parentData = parentData;
         this._animation = parentData.animation;
         switch(true)
         {
            case this._parentData.animation.indexOf("AnimStatique") != -1:
               this._animation = "AnimStatique";
         }
         parentData.parent.addEventListener(TiphonEvent.RENDER_FATHER_SUCCEED,this.onFatherRendered);
      }
      
      private function onFatherRendered(e:TiphonEvent) : void
      {
         var p:TiphonSprite = e.target as TiphonSprite;
         this._parentData.parent.removeEventListener(TiphonEvent.RENDER_FATHER_SUCCEED,this.onFatherRendered);
         this._subentity.setAnimationAndDirection(this._animation,!p.fliped?uint(this._parentData.direction):uint(TiphonUtility.getFlipDirection(this._parentData.direction)));
      }
   }
}
