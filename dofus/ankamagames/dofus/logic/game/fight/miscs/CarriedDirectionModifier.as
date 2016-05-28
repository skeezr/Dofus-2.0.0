package com.ankamagames.dofus.logic.game.fight.miscs
{
   import com.ankamagames.tiphon.types.IDirectionModifier;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.types.TiphonUtility;
   
   public class CarriedDirectionModifier implements IDirectionModifier
   {
      
      private static var _self:com.ankamagames.dofus.logic.game.fight.miscs.CarriedDirectionModifier;
       
      public function CarriedDirectionModifier()
      {
         super();
      }
      
      public static function getInstance() : com.ankamagames.dofus.logic.game.fight.miscs.CarriedDirectionModifier
      {
         if(!_self)
         {
            _self = new com.ankamagames.dofus.logic.game.fight.miscs.CarriedDirectionModifier();
         }
         return _self;
      }
      
      public function getModifiedDirection(direction:uint, target:TiphonSprite) : uint
      {
         if(Boolean(target.parentSprite) && Boolean(target.parentSprite.fliped))
         {
            return TiphonUtility.getFlipDirection(direction);
         }
         return direction;
      }
   }
}
