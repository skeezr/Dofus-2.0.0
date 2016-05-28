package com.ankamagames.dofus.network.messages.game.guild.tax
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class TaxCollectorFireRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5682;
       
      private var _isInitialized:Boolean = false;
      
      public var collectorId:int = 0;
      
      public function TaxCollectorFireRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5682;
      }
      
      public function initTaxCollectorFireRequestMessage(collectorId:int = 0) : TaxCollectorFireRequestMessage
      {
         this.collectorId = collectorId;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.collectorId = 0;
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
         this.serializeAs_TaxCollectorFireRequestMessage(output);
      }
      
      public function serializeAs_TaxCollectorFireRequestMessage(output:IDataOutput) : void
      {
         output.writeInt(this.collectorId);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_TaxCollectorFireRequestMessage(input);
      }
      
      public function deserializeAs_TaxCollectorFireRequestMessage(input:IDataInput) : void
      {
         this.collectorId = input.readInt();
      }
   }
}
