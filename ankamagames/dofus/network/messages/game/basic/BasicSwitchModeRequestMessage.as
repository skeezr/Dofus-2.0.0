package com.ankamagames.dofus.network.messages.game.basic
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class BasicSwitchModeRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6101;
       
      private var _isInitialized:Boolean = false;
      
      public var mode:int = 0;
      
      public function BasicSwitchModeRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6101;
      }
      
      public function initBasicSwitchModeRequestMessage(mode:int = 0) : BasicSwitchModeRequestMessage
      {
         this.mode = mode;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.mode = 0;
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
         this.serializeAs_BasicSwitchModeRequestMessage(output);
      }
      
      public function serializeAs_BasicSwitchModeRequestMessage(output:IDataOutput) : void
      {
         output.writeByte(this.mode);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_BasicSwitchModeRequestMessage(input);
      }
      
      public function deserializeAs_BasicSwitchModeRequestMessage(input:IDataInput) : void
      {
         this.mode = input.readByte();
      }
   }
}
