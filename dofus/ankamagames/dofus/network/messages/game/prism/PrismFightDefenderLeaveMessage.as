package com.ankamagames.dofus.network.messages.game.prism
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PrismFightDefenderLeaveMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5892;
       
      private var _isInitialized:Boolean = false;
      
      public var fightId:Number = 0;
      
      public var fighterToRemoveId:uint = 0;
      
      public var successor:uint = 0;
      
      public function PrismFightDefenderLeaveMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5892;
      }
      
      public function initPrismFightDefenderLeaveMessage(fightId:Number = 0, fighterToRemoveId:uint = 0, successor:uint = 0) : PrismFightDefenderLeaveMessage
      {
         this.fightId = fightId;
         this.fighterToRemoveId = fighterToRemoveId;
         this.successor = successor;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.fightId = 0;
         this.fighterToRemoveId = 0;
         this.successor = 0;
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
         this.serializeAs_PrismFightDefenderLeaveMessage(output);
      }
      
      public function serializeAs_PrismFightDefenderLeaveMessage(output:IDataOutput) : void
      {
         output.writeDouble(this.fightId);
         if(this.fighterToRemoveId < 0)
         {
            throw new Error("Forbidden value (" + this.fighterToRemoveId + ") on element fighterToRemoveId.");
         }
         output.writeInt(this.fighterToRemoveId);
         if(this.successor < 0)
         {
            throw new Error("Forbidden value (" + this.successor + ") on element successor.");
         }
         output.writeInt(this.successor);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PrismFightDefenderLeaveMessage(input);
      }
      
      public function deserializeAs_PrismFightDefenderLeaveMessage(input:IDataInput) : void
      {
         this.fightId = input.readDouble();
         this.fighterToRemoveId = input.readInt();
         if(this.fighterToRemoveId < 0)
         {
            throw new Error("Forbidden value (" + this.fighterToRemoveId + ") on element of PrismFightDefenderLeaveMessage.fighterToRemoveId.");
         }
         this.successor = input.readInt();
         if(this.successor < 0)
         {
            throw new Error("Forbidden value (" + this.successor + ") on element of PrismFightDefenderLeaveMessage.successor.");
         }
      }
   }
}
