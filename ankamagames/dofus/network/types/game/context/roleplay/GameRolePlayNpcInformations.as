package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class GameRolePlayNpcInformations extends GameRolePlayActorInformations implements INetworkType
   {
      
      public static const protocolId:uint = 156;
       
      public var npcId:uint = 0;
      
      public var sex:Boolean = false;
      
      public var specialArtworkId:uint = 0;
      
      public var canGiveQuest:Boolean = false;
      
      public function GameRolePlayNpcInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 156;
      }
      
      public function initGameRolePlayNpcInformations(contextualId:int = 0, look:EntityLook = null, disposition:EntityDispositionInformations = null, npcId:uint = 0, sex:Boolean = false, specialArtworkId:uint = 0, canGiveQuest:Boolean = false) : GameRolePlayNpcInformations
      {
         super.initGameRolePlayActorInformations(contextualId,look,disposition);
         this.npcId = npcId;
         this.sex = sex;
         this.specialArtworkId = specialArtworkId;
         this.canGiveQuest = canGiveQuest;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.npcId = 0;
         this.sex = false;
         this.specialArtworkId = 0;
         this.canGiveQuest = false;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_GameRolePlayNpcInformations(output);
      }
      
      public function serializeAs_GameRolePlayNpcInformations(output:IDataOutput) : void
      {
         super.serializeAs_GameRolePlayActorInformations(output);
         if(this.npcId < 0)
         {
            throw new Error("Forbidden value (" + this.npcId + ") on element npcId.");
         }
         output.writeShort(this.npcId);
         output.writeBoolean(this.sex);
         if(this.specialArtworkId < 0)
         {
            throw new Error("Forbidden value (" + this.specialArtworkId + ") on element specialArtworkId.");
         }
         output.writeShort(this.specialArtworkId);
         output.writeBoolean(this.canGiveQuest);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameRolePlayNpcInformations(input);
      }
      
      public function deserializeAs_GameRolePlayNpcInformations(input:IDataInput) : void
      {
         super.deserialize(input);
         this.npcId = input.readShort();
         if(this.npcId < 0)
         {
            throw new Error("Forbidden value (" + this.npcId + ") on element of GameRolePlayNpcInformations.npcId.");
         }
         this.sex = input.readBoolean();
         this.specialArtworkId = input.readShort();
         if(this.specialArtworkId < 0)
         {
            throw new Error("Forbidden value (" + this.specialArtworkId + ") on element of GameRolePlayNpcInformations.specialArtworkId.");
         }
         this.canGiveQuest = input.readBoolean();
      }
   }
}
