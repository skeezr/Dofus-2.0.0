package com.ankamagames.dofus.logic.game.roleplay.types
{
   import com.ankamagames.dofus.network.types.game.context.roleplay.GuildInformations;
   
   public class TaxCollectorTooltipInformation
   {
       
      public var lastName:String;
      
      public var firstName:String;
      
      public var guildIdentity:GuildInformations;
      
      public function TaxCollectorTooltipInformation(pFirstName:String, pLastName:String, pGuildIdentity:GuildInformations)
      {
         super();
         this.lastName = pLastName;
         this.firstName = pFirstName;
         this.guildIdentity = pGuildIdentity;
      }
   }
}
