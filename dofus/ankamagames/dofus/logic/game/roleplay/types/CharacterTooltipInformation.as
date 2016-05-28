package com.ankamagames.dofus.logic.game.roleplay.types
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayActorInformations;
   
   public class CharacterTooltipInformation
   {
       
      public var infos:GameRolePlayActorInformations;
      
      public var wingsEffect:int;
      
      public function CharacterTooltipInformation(pInfos:GameRolePlayActorInformations, pWingsEffect:int)
      {
         super();
         this.infos = pInfos;
         this.wingsEffect = pWingsEffect;
      }
   }
}
