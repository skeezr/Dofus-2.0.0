package com.ankamagames.dofus.internalDatacenter.conquest
{
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalPlusLookAndGradeInformations;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   
   public class PrismFightersWrapper
   {
       
      public var playerCharactersInformations:CharacterMinimalPlusLookAndGradeInformations;
      
      public var entityLook:TiphonEntityLook;
      
      public function PrismFightersWrapper()
      {
         super();
      }
      
      public static function create(pFightersInformations:CharacterMinimalPlusLookAndGradeInformations) : PrismFightersWrapper
      {
         var item:PrismFightersWrapper = new PrismFightersWrapper();
         item.playerCharactersInformations = pFightersInformations;
         if(pFightersInformations.entityLook != null)
         {
            item.entityLook = EntityLookAdapter.fromNetwork(pFightersInformations.entityLook);
         }
         return item;
      }
   }
}
