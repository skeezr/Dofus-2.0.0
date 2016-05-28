package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.network.types.game.character.restriction.ActorRestrictionsInformations;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class HumanWithGuildInformations extends HumanInformations implements INetworkType
   {
      
      public static const protocolId:uint = 153;
       
      public var guildInformations:com.ankamagames.dofus.network.types.game.context.roleplay.GuildInformations;
      
      public function HumanWithGuildInformations()
      {
         this.guildInformations = new com.ankamagames.dofus.network.types.game.context.roleplay.GuildInformations();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 153;
      }
      
      public function initHumanWithGuildInformations(followingCharactersLook:Vector.<EntityLook> = null, emoteId:int = 0, emoteEndTime:uint = 0, restrictions:ActorRestrictionsInformations = null, titleId:uint = 0, guildInformations:com.ankamagames.dofus.network.types.game.context.roleplay.GuildInformations = null) : HumanWithGuildInformations
      {
         super.initHumanInformations(followingCharactersLook,emoteId,emoteEndTime,restrictions,titleId);
         this.guildInformations = guildInformations;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.guildInformations = new com.ankamagames.dofus.network.types.game.context.roleplay.GuildInformations();
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_HumanWithGuildInformations(output);
      }
      
      public function serializeAs_HumanWithGuildInformations(output:IDataOutput) : void
      {
         super.serializeAs_HumanInformations(output);
         this.guildInformations.serializeAs_GuildInformations(output);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_HumanWithGuildInformations(input);
      }
      
      public function deserializeAs_HumanWithGuildInformations(input:IDataInput) : void
      {
         super.deserialize(input);
         this.guildInformations = new com.ankamagames.dofus.network.types.game.context.roleplay.GuildInformations();
         this.guildInformations.deserialize(input);
      }
   }
}
