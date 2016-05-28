package com.ankamagames.dofus.logic.game.fight.miscs
{
   import com.ankamagames.tiphon.types.IAnimationModifier;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   
   public class CarrierAnimationModifier implements IAnimationModifier
   {
      
      private static var _self:com.ankamagames.dofus.logic.game.fight.miscs.CarrierAnimationModifier;
       
      public function CarrierAnimationModifier()
      {
         super();
      }
      
      public static function getInstance() : com.ankamagames.dofus.logic.game.fight.miscs.CarrierAnimationModifier
      {
         if(!_self)
         {
            _self = new com.ankamagames.dofus.logic.game.fight.miscs.CarrierAnimationModifier();
         }
         return _self;
      }
      
      public function getModifiedAnimation(animation:String, look:TiphonEntityLook) : String
      {
         switch(animation)
         {
            case AnimationEnum.ANIM_STATIQUE:
               return AnimationEnum.ANIM_STATIQUE_CARRYING;
            case AnimationEnum.ANIM_MARCHE:
               return AnimationEnum.ANIM_MARCHE_CARRYING;
            case AnimationEnum.ANIM_COURSE:
               return AnimationEnum.ANIM_COURSE_CARRYING;
            default:
               return animation;
         }
      }
   }
}
