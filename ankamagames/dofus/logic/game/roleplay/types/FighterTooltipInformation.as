package com.ankamagames.dofus.logic.game.roleplay.types
{
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   
   public class FighterTooltipInformation
   {
       
      public var info:GameFightFighterInformations;
      
      public function FighterTooltipInformation(pInfo:GameFightFighterInformations)
      {
         super();
         this.info = pInfo;
      }
   }
}
