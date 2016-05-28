package com.ankamagames.dofus.network.messages.game.interactive.zaap
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class TeleportDestinationsListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5960;
       
      private var _isInitialized:Boolean = false;
      
      public var teleporterType:uint = 0;
      
      public var mapIds:Vector.<uint>;
      
      public var subareaIds:Vector.<uint>;
      
      public var costs:Vector.<uint>;
      
      public function TeleportDestinationsListMessage()
      {
         this.mapIds = new Vector.<uint>();
         this.subareaIds = new Vector.<uint>();
         this.costs = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5960;
      }
      
      public function initTeleportDestinationsListMessage(teleporterType:uint = 0, mapIds:Vector.<uint> = null, subareaIds:Vector.<uint> = null, costs:Vector.<uint> = null) : TeleportDestinationsListMessage
      {
         this.teleporterType = teleporterType;
         this.mapIds = mapIds;
         this.subareaIds = subareaIds;
         this.costs = costs;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.teleporterType = 0;
         this.mapIds = new Vector.<uint>();
         this.subareaIds = new Vector.<uint>();
         this.costs = new Vector.<uint>();
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
         this.serializeAs_TeleportDestinationsListMessage(output);
      }
      
      public function serializeAs_TeleportDestinationsListMessage(output:IDataOutput) : void
      {
         output.writeByte(this.teleporterType);
         output.writeShort(this.mapIds.length);
         for(var _i2:uint = 0; _i2 < this.mapIds.length; _i2++)
         {
            if(this.mapIds[_i2] < 0)
            {
               throw new Error("Forbidden value (" + this.mapIds[_i2] + ") on element 2 (starting at 1) of mapIds.");
            }
            output.writeInt(this.mapIds[_i2]);
         }
         output.writeShort(this.subareaIds.length);
         for(var _i3:uint = 0; _i3 < this.subareaIds.length; _i3++)
         {
            if(this.subareaIds[_i3] < 0)
            {
               throw new Error("Forbidden value (" + this.subareaIds[_i3] + ") on element 3 (starting at 1) of subareaIds.");
            }
            output.writeShort(this.subareaIds[_i3]);
         }
         output.writeShort(this.costs.length);
         for(var _i4:uint = 0; _i4 < this.costs.length; _i4++)
         {
            if(this.costs[_i4] < 0)
            {
               throw new Error("Forbidden value (" + this.costs[_i4] + ") on element 4 (starting at 1) of costs.");
            }
            output.writeShort(this.costs[_i4]);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_TeleportDestinationsListMessage(input);
      }
      
      public function deserializeAs_TeleportDestinationsListMessage(input:IDataInput) : void
      {
         var _val2:uint = 0;
         var _val3:uint = 0;
         var _val4:uint = 0;
         this.teleporterType = input.readByte();
         if(this.teleporterType < 0)
         {
            throw new Error("Forbidden value (" + this.teleporterType + ") on element of TeleportDestinationsListMessage.teleporterType.");
         }
         var _mapIdsLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _mapIdsLen; _i2++)
         {
            _val2 = input.readInt();
            if(_val2 < 0)
            {
               throw new Error("Forbidden value (" + _val2 + ") on elements of mapIds.");
            }
            this.mapIds.push(_val2);
         }
         var _subareaIdsLen:uint = input.readUnsignedShort();
         for(var _i3:uint = 0; _i3 < _subareaIdsLen; _i3++)
         {
            _val3 = input.readShort();
            if(_val3 < 0)
            {
               throw new Error("Forbidden value (" + _val3 + ") on elements of subareaIds.");
            }
            this.subareaIds.push(_val3);
         }
         var _costsLen:uint = input.readUnsignedShort();
         for(var _i4:uint = 0; _i4 < _costsLen; _i4++)
         {
            _val4 = input.readShort();
            if(_val4 < 0)
            {
               throw new Error("Forbidden value (" + _val4 + ") on elements of costs.");
            }
            this.costs.push(_val4);
         }
      }
   }
}
