package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class MonsterInGroupInformations implements INetworkType
   {
      
      public static const protocolId:uint = 144;
       
      public var creatureGenericId:int = 0;
      
      public var level:uint = 0;
      
      public var look:EntityLook;
      
      public function MonsterInGroupInformations()
      {
         this.look = new EntityLook();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 144;
      }
      
      public function initMonsterInGroupInformations(creatureGenericId:int = 0, level:uint = 0, look:EntityLook = null) : MonsterInGroupInformations
      {
         this.creatureGenericId = creatureGenericId;
         this.level = level;
         this.look = look;
         return this;
      }
      
      public function reset() : void
      {
         this.creatureGenericId = 0;
         this.level = 0;
         this.look = new EntityLook();
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_MonsterInGroupInformations(output);
      }
      
      public function serializeAs_MonsterInGroupInformations(output:IDataOutput) : void
      {
         output.writeInt(this.creatureGenericId);
         if(this.level < 0)
         {
            throw new Error("Forbidden value (" + this.level + ") on element level.");
         }
         output.writeShort(this.level);
         this.look.serializeAs_EntityLook(output);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_MonsterInGroupInformations(input);
      }
      
      public function deserializeAs_MonsterInGroupInformations(input:IDataInput) : void
      {
         this.creatureGenericId = input.readInt();
         this.level = input.readShort();
         if(this.level < 0)
         {
            throw new Error("Forbidden value (" + this.level + ") on element of MonsterInGroupInformations.level.");
         }
         this.look = new EntityLook();
         this.look.deserialize(input);
      }
   }
}
