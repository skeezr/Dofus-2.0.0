package com.ankamagames.dofus.network.messages.connection
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.version.Version;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class IdentificationMessageWithServerIdMessage extends IdentificationMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6104;
       
      private var _isInitialized:Boolean = false;
      
      public var serverId:int = 0;
      
      public function IdentificationMessageWithServerIdMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return Boolean(super.isInitialized) && Boolean(this._isInitialized);
      }
      
      override public function getMessageId() : uint
      {
         return 6104;
      }
      
      public function initIdentificationMessageWithServerIdMessage(version:Version = null, login:String = "", password:String = "", autoconnect:Boolean = false, serverId:int = 0) : IdentificationMessageWithServerIdMessage
      {
         super.initIdentificationMessage(version,login,password,autoconnect);
         this.serverId = serverId;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.serverId = 0;
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
         this.serializeAs_IdentificationMessageWithServerIdMessage(output);
      }
      
      public function serializeAs_IdentificationMessageWithServerIdMessage(output:IDataOutput) : void
      {
         super.serializeAs_IdentificationMessage(output);
         output.writeShort(this.serverId);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_IdentificationMessageWithServerIdMessage(input);
      }
      
      public function deserializeAs_IdentificationMessageWithServerIdMessage(input:IDataInput) : void
      {
         super.deserialize(input);
         this.serverId = input.readShort();
      }
   }
}
