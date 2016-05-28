package com.ankamagames.dofus.internalDatacenter.guild
{
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalPlusLookInformations;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   
   public class TaxCollectorFightersWrapper
   {
       
      public var ally:uint;
      
      public var playerCharactersInformations:CharacterMinimalPlusLookInformations;
      
      public var entityLook:TiphonEntityLook;
      
      public function TaxCollectorFightersWrapper()
      {
         super();
      }
      
      public static function create(pAlly:uint, pFightersInformations:CharacterMinimalPlusLookInformations) : TaxCollectorFightersWrapper
      {
         var item:TaxCollectorFightersWrapper = new TaxCollectorFightersWrapper();
         item.ally = pAlly;
         item.playerCharactersInformations = pFightersInformations;
         if(pFightersInformations.entityLook != null)
         {
            item.entityLook = EntityLookAdapter.fromNetwork(pFightersInformations.entityLook);
         }
         else
         {
            trace("Le entityLook est null :(");
         }
         return item;
      }
   }
}
