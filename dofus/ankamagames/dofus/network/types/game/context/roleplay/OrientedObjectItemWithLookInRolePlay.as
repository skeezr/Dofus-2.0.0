package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class OrientedObjectItemWithLookInRolePlay extends ObjectItemWithLookInRolePlay implements INetworkType
   {
      
      public static const protocolId:uint = 199;
       
      public var direction:uint = 1;
      
      public function OrientedObjectItemWithLookInRolePlay()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 199;
      }
      
      public function initOrientedObjectItemWithLookInRolePlay(cellId:uint = 0, objectGID:uint = 0, entityLook:EntityLook = null, direction:uint = 1) : OrientedObjectItemWithLookInRolePlay
      {
         super.initObjectItemWithLookInRolePlay(cellId,objectGID,entityLook);
         this.direction = direction;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.direction = 1;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_OrientedObjectItemWithLookInRolePlay(output);
      }
      
      public function serializeAs_OrientedObjectItemWithLookInRolePlay(output:IDataOutput) : void
      {
         super.serializeAs_ObjectItemWithLookInRolePlay(output);
         output.writeByte(this.direction);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_OrientedObjectItemWithLookInRolePlay(input);
      }
      
      public function deserializeAs_OrientedObjectItemWithLookInRolePlay(input:IDataInput) : void
      {
         super.deserialize(input);
         this.direction = input.readByte();
         if(this.direction < 0)
         {
            throw new Error("Forbidden value (" + this.direction + ") on element of OrientedObjectItemWithLookInRolePlay.direction.");
         }
      }
   }
}
