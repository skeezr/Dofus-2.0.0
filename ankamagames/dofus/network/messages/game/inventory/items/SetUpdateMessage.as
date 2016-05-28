package com.ankamagames.dofus.network.messages.game.inventory.items
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.data.items.effects.ObjectEffect;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   
   public class SetUpdateMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5503;
       
      private var _isInitialized:Boolean = false;
      
      public var setId:uint = 0;
      
      public var setObjects:Vector.<uint>;
      
      public var setEffects:Vector.<ObjectEffect>;
      
      public function SetUpdateMessage()
      {
         this.setObjects = new Vector.<uint>();
         this.setEffects = new Vector.<ObjectEffect>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5503;
      }
      
      public function initSetUpdateMessage(setId:uint = 0, setObjects:Vector.<uint> = null, setEffects:Vector.<ObjectEffect> = null) : SetUpdateMessage
      {
         this.setId = setId;
         this.setObjects = setObjects;
         this.setEffects = setEffects;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.setId = 0;
         this.setObjects = new Vector.<uint>();
         this.setEffects = new Vector.<ObjectEffect>();
         this._isInitialized = false;
      }
      
      override public function pack(output:IDataOutput) : void
      {
         var data:ByteArray = new ByteArray();
         this.serialize(data);
         writePacket(output,this.getMessageId(),data);
      }
      
      override public function unpack(input:IDataInput, length:uint) : void
      {
         this.deserialize(input);
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_SetUpdateMessage(output);
      }
      
      public function serializeAs_SetUpdateMessage(output:IDataOutput) : void
      {
         if(this.setId < 0)
         {
            throw new Error("Forbidden value (" + this.setId + ") on element setId.");
         }
         output.writeShort(this.setId);
         output.writeShort(this.setObjects.length);
         for(var _i2:uint = 0; _i2 < this.setObjects.length; _i2++)
         {
            if(this.setObjects[_i2] < 0)
            {
               throw new Error("Forbidden value (" + this.setObjects[_i2] + ") on element 2 (starting at 1) of setObjects.");
            }
            output.writeShort(this.setObjects[_i2]);
         }
         output.writeShort(this.setEffects.length);
         for(var _i3:uint = 0; _i3 < this.setEffects.length; _i3++)
         {
            output.writeShort((this.setEffects[_i3] as ObjectEffect).getTypeId());
            (this.setEffects[_i3] as ObjectEffect).serialize(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_SetUpdateMessage(input);
      }
      
      public function deserializeAs_SetUpdateMessage(input:IDataInput) : void
      {
         var _val2:uint = 0;
         var _id3:uint = 0;
         var _item3:ObjectEffect = null;
         this.setId = input.readShort();
         if(this.setId < 0)
         {
            throw new Error("Forbidden value (" + this.setId + ") on element of SetUpdateMessage.setId.");
         }
         var _setObjectsLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _setObjectsLen; _i2++)
         {
            _val2 = input.readShort();
            if(_val2 < 0)
            {
               throw new Error("Forbidden value (" + _val2 + ") on elements of setObjects.");
            }
            this.setObjects.push(_val2);
         }
         var _setEffectsLen:uint = input.readUnsignedShort();
         for(var _i3:uint = 0; _i3 < _setEffectsLen; _i3++)
         {
            _id3 = input.readUnsignedShort();
            _item3 = ProtocolTypeManager.getInstance(ObjectEffect,_id3);
            _item3.deserialize(input);
            this.setEffects.push(_item3);
         }
      }
   }
}
