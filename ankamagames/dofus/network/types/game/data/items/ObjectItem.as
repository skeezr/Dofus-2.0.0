package com.ankamagames.dofus.network.types.game.data.items
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   
   public class ObjectItem extends Item implements INetworkType
   {
      
      public static const protocolId:uint = 37;
       
      public var position:uint = 63;
      
      public var objectGID:uint = 0;
      
      public var effects:Vector.<ObjectEffect>;
      
      public var objectUID:uint = 0;
      
      public var quantity:uint = 0;
      
      public function ObjectItem()
      {
         this.effects = new Vector.<ObjectEffect>();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 37;
      }
      
      public function initObjectItem(position:uint = 63, objectGID:uint = 0, effects:Vector.<ObjectEffect> = null, objectUID:uint = 0, quantity:uint = 0) : ObjectItem
      {
         this.position = position;
         this.objectGID = objectGID;
         this.effects = effects;
         this.objectUID = objectUID;
         this.quantity = quantity;
         return this;
      }
      
      override public function reset() : void
      {
         this.position = 63;
         this.objectGID = 0;
         this.effects = new Vector.<ObjectEffect>();
         this.objectUID = 0;
         this.quantity = 0;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_ObjectItem(output);
      }
      
      public function serializeAs_ObjectItem(output:IDataOutput) : void
      {
         super.serializeAs_Item(output);
         output.writeByte(this.position);
         if(this.objectGID < 0)
         {
            throw new Error("Forbidden value (" + this.objectGID + ") on element objectGID.");
         }
         output.writeShort(this.objectGID);
         output.writeShort(this.effects.length);
         for(var _i3:uint = 0; _i3 < this.effects.length; _i3++)
         {
            output.writeShort((this.effects[_i3] as ObjectEffect).getTypeId());
            (this.effects[_i3] as ObjectEffect).serialize(output);
         }
         if(this.objectUID < 0)
         {
            throw new Error("Forbidden value (" + this.objectUID + ") on element objectUID.");
         }
         output.writeInt(this.objectUID);
         if(this.quantity < 0)
         {
            throw new Error("Forbidden value (" + this.quantity + ") on element quantity.");
         }
         output.writeInt(this.quantity);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ObjectItem(input);
      }
      
      public function deserializeAs_ObjectItem(input:IDataInput) : void
      {
         var _id3:uint = 0;
         var _item3:ObjectEffect = null;
         super.deserialize(input);
         this.position = input.readUnsignedByte();
         if(this.position < 0 || this.position > 255)
         {
            throw new Error("Forbidden value (" + this.position + ") on element of ObjectItem.position.");
         }
         this.objectGID = input.readShort();
         if(this.objectGID < 0)
         {
            throw new Error("Forbidden value (" + this.objectGID + ") on element of ObjectItem.objectGID.");
         }
         var _effectsLen:uint = input.readUnsignedShort();
         for(var _i3:uint = 0; _i3 < _effectsLen; _i3++)
         {
            _id3 = input.readUnsignedShort();
            _item3 = ProtocolTypeManager.getInstance(ObjectEffect,_id3);
            _item3.deserialize(input);
            this.effects.push(_item3);
         }
         this.objectUID = input.readInt();
         if(this.objectUID < 0)
         {
            throw new Error("Forbidden value (" + this.objectUID + ") on element of ObjectItem.objectUID.");
         }
         this.quantity = input.readInt();
         if(this.quantity < 0)
         {
            throw new Error("Forbidden value (" + this.quantity + ") on element of ObjectItem.quantity.");
         }
      }
   }
}
