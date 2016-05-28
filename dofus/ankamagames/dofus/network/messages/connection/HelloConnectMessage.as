package com.ankamagames.dofus.network.messages.connection
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class HelloConnectMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 3;
       
      private var _isInitialized:Boolean = false;
      
      public var key:String = "";
      
      public function HelloConnectMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 3;
      }
      
      public function initHelloConnectMessage(key:String = "") : HelloConnectMessage
      {
         this.key = key;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.key = "";
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
         this.serializeAs_HelloConnectMessage(output);
      }
      
      public function serializeAs_HelloConnectMessage(output:IDataOutput) : void
      {
         output.writeUTF(this.key);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_HelloConnectMessage(input);
      }
      
      public function deserializeAs_HelloConnectMessage(input:IDataInput) : void
      {
         this.key = input.readUTF();
      }
   }
}
