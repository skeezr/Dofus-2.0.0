package com.ankamagames.dofus.network.messages.game.pvp
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PVPActivationCostMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 1801;
       
      private var _isInitialized:Boolean = false;
      
      public var cost:uint = 0;
      
      public function PVPActivationCostMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 1801;
      }
      
      public function initPVPActivationCostMessage(cost:uint = 0) : PVPActivationCostMessage
      {
         this.cost = cost;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.cost = 0;
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
         this.serializeAs_PVPActivationCostMessage(output);
      }
      
      public function serializeAs_PVPActivationCostMessage(output:IDataOutput) : void
      {
         if(this.cost < 0)
         {
            throw new Error("Forbidden value (" + this.cost + ") on element cost.");
         }
         output.writeShort(this.cost);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PVPActivationCostMessage(input);
      }
      
      public function deserializeAs_PVPActivationCostMessage(input:IDataInput) : void
      {
         this.cost = input.readShort();
         if(this.cost < 0)
         {
            throw new Error("Forbidden value (" + this.cost + ") on element of PVPActivationCostMessage.cost.");
         }
      }
   }
}
