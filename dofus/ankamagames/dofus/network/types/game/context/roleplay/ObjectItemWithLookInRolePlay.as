package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class ObjectItemWithLookInRolePlay extends ObjectItemInRolePlay implements INetworkType
   {
      
      public static const protocolId:uint = 197;
       
      public var entityLook:EntityLook;
      
      public function ObjectItemWithLookInRolePlay()
      {
         this.entityLook = new EntityLook();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 197;
      }
      
      public function initObjectItemWithLookInRolePlay(cellId:uint = 0, objectGID:uint = 0, entityLook:EntityLook = null) : ObjectItemWithLookInRolePlay
      {
         super.initObjectItemInRolePlay(cellId,objectGID);
         this.entityLook = entityLook;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.entityLook = new EntityLook();
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_ObjectItemWithLookInRolePlay(output);
      }
      
      public function serializeAs_ObjectItemWithLookInRolePlay(output:IDataOutput) : void
      {
         super.serializeAs_ObjectItemInRolePlay(output);
         this.entityLook.serializeAs_EntityLook(output);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ObjectItemWithLookInRolePlay(input);
      }
      
      public function deserializeAs_ObjectItemWithLookInRolePlay(input:IDataInput) : void
      {
         super.deserialize(input);
         this.entityLook = new EntityLook();
         this.entityLook.deserialize(input);
      }
   }
}
