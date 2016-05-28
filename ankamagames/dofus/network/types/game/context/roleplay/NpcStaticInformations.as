package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class NpcStaticInformations implements INetworkType
   {
      
      public static const protocolId:uint = 155;
       
      public var npcId:uint = 0;
      
      public var sex:Boolean = false;
      
      public var specialArtworkId:uint = 0;
      
      public function NpcStaticInformations()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 155;
      }
      
      public function initNpcStaticInformations(npcId:uint = 0, sex:Boolean = false, specialArtworkId:uint = 0) : NpcStaticInformations
      {
         this.npcId = npcId;
         this.sex = sex;
         this.specialArtworkId = specialArtworkId;
         return this;
      }
      
      public function reset() : void
      {
         this.npcId = 0;
         this.sex = false;
         this.specialArtworkId = 0;
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_NpcStaticInformations(output);
      }
      
      public function serializeAs_NpcStaticInformations(output:IDataOutput) : void
      {
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
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_NpcStaticInformations(input);
      }
      
      public function deserializeAs_NpcStaticInformations(input:IDataInput) : void
      {
         this.npcId = input.readShort();
         if(this.npcId < 0)
         {
            throw new Error("Forbidden value (" + this.npcId + ") on element of NpcStaticInformations.npcId.");
         }
         this.sex = input.readBoolean();
         this.specialArtworkId = input.readShort();
         if(this.specialArtworkId < 0)
         {
            throw new Error("Forbidden value (" + this.specialArtworkId + ") on element of NpcStaticInformations.specialArtworkId.");
         }
      }
   }
}
