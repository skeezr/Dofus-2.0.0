package com.ankamagames.dofus.network.messages.game.interactive.zaap
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class ZaapListMessage extends TeleportDestinationsListMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 1604;
       
      private var _isInitialized:Boolean = false;
      
      public var spawnMapId:uint = 0;
      
      public function ZaapListMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return Boolean(super.isInitialized) && Boolean(this._isInitialized);
      }
      
      override public function getMessageId() : uint
      {
         return 1604;
      }
      
      public function initZaapListMessage(teleporterType:uint = 0, mapIds:Vector.<uint> = null, subareaIds:Vector.<uint> = null, costs:Vector.<uint> = null, spawnMapId:uint = 0) : ZaapListMessage
      {
         super.initTeleportDestinationsListMessage(teleporterType,mapIds,subareaIds,costs);
         this.spawnMapId = spawnMapId;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.spawnMapId = 0;
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
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_ZaapListMessage(output);
      }
      
      public function serializeAs_ZaapListMessage(output:IDataOutput) : void
      {
         super.serializeAs_TeleportDestinationsListMessage(output);
         if(this.spawnMapId < 0)
         {
            throw new Error("Forbidden value (" + this.spawnMapId + ") on element spawnMapId.");
         }
         output.writeInt(this.spawnMapId);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ZaapListMessage(input);
      }
      
      public function deserializeAs_ZaapListMessage(input:IDataInput) : void
      {
         super.deserialize(input);
         this.spawnMapId = input.readInt();
         if(this.spawnMapId < 0)
         {
            throw new Error("Forbidden value (" + this.spawnMapId + ") on element of ZaapListMessage.spawnMapId.");
         }
      }
   }
}
