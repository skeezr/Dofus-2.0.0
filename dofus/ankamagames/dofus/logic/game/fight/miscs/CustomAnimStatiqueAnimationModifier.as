package com.ankamagames.dofus.logic.game.fight.miscs
{
   import com.ankamagames.tiphon.types.IAnimationModifier;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   
   public class CustomAnimStatiqueAnimationModifier implements IAnimationModifier
   {
       
      public function CustomAnimStatiqueAnimationModifier()
      {
         super();
      }
      
      public function getModifiedAnimation(pAnimation:String, pLook:TiphonEntityLook) : String
      {
         switch(pAnimation)
         {
            case AnimationEnum.ANIM_STATIQUE:
               if(pLook.getBone() == 1)
               {
                  return AnimationEnum.ANIM_STATIQUE + pLook.skins[0].toString();
               }
               return pAnimation;
            default:
               return pAnimation;
         }
      }
   }
}
