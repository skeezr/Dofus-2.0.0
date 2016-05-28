package com.ankamagames.dofus.network.types.game.data.items
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   
   public class ObjectItemToSell extends Item implements INetworkType
   {
      
      public static const protocolId:uint = 120;
       
      public var objectGID:uint = 0;
      
      public var effects:Vector.<ObjectEffect>;
      
      public var objectUID:uint = 0;
      
      public var quantity:uint = 0;
      
      public var objectPrice:uint = 0;
      
      public function ObjectItemToSell()
      {
         this.effects = new Vector.<ObjectEffect>();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 120;
      }
      
      public function initObjectItemToSell(objectGID:uint = 0, effects:Vector.<ObjectEffect> = null, objectUID:uint = 0, quantity:uint = 0, objectPrice:uint = 0) : ObjectItemToSell
      {
         this.objectGID = objectGID;
         this.effects = effects;
         this.objectUID = objectUID;
         this.quantity = quantity;
         this.objectPrice = objectPrice;
         return this;
      }
      
      override public function reset() : void
      {
         this.objectGID = 0;
         this.effects = new Vector.<ObjectEffect>();
         this.objectUID = 0;
         this.quantity = 0;
         this.objectPrice = 0;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_ObjectItemToSell(output);
      }
      
      public function serializeAs_ObjectItemToSell(output:IDataOutput) : void
      {
         super.serializeAs_Item(output);
         if(this.objectGID < 0)
         {
            throw new Error("Forbidden value (" + this.objectGID + ") on element objectGID.");
         }
         output.writeShort(this.objectGID);
         output.writeShort(this.effects.length);
         for(var _i2:uint = 0; _i2 < this.effects.length; _i2++)
         {
            output.writeShort((this.effects[_i2] as ObjectEffect).getTypeId());
            (this.effects[_i2] as ObjectEffect).serialize(output);
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
         if(this.objectPrice < 0)
         {
            throw new Error("Forbidden value (" + this.objectPrice + ") on element objectPrice.");
         }
         output.writeInt(this.objectPrice);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ObjectItemToSell(input);
      }
      
      public function deserializeAs_ObjectItemToSell(input:IDataInput) : void
      {
         var _id2:uint = 0;
         var _item2:ObjectEffect = null;
         super.deserialize(input);
         this.objectGID = input.readShort();
         if(this.objectGID < 0)
         {
            throw new Error("Forbidden value (" + this.objectGID + ") on element of ObjectItemToSell.objectGID.");
         }
         var _effectsLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _effectsLen; _i2++)
         {
            _id2 = input.readUnsignedShort();
            _item2 = ProtocolTypeManager.getInstance(ObjectEffect,_id2);
            _item2.deserialize(input);
            this.effects.push(_item2);
         }
         this.objectUID = input.readInt();
         if(this.objectUID < 0)
         {
            throw new Error("Forbidden value (" + this.objectUID + ") on element of ObjectItemToSell.objectUID.");
         }
         this.quantity = input.readInt();
         if(this.quantity < 0)
         {
            throw new Error("Forbidden value (" + this.quantity + ") on element of ObjectItemToSell.quantity.");
         }
         this.objectPrice = input.readInt();
         if(this.objectPrice < 0)
         {
            throw new Error("Forbidden value (" + this.objectPrice + ") on element of ObjectItemToSell.objectPrice.");
         }
      }
   }
}
