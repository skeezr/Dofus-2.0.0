package com.ankamagames.dofus.network.messages.connection
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.version.Version;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class IdentificationMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 4;
       
      private var _isInitialized:Boolean = false;
      
      public var version:Version;
      
      public var login:String = "";
      
      public var password:String = "";
      
      public var autoconnect:Boolean = false;
      
      public function IdentificationMessage()
      {
         this.version = new Version();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 4;
      }
      
      public function initIdentificationMessage(version:Version = null, login:String = "", password:String = "", autoconnect:Boolean = false) : IdentificationMessage
      {
         this.version = version;
         this.login = login;
         this.password = password;
         this.autoconnect = autoconnect;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.version = new Version();
         this.password = "";
         this.autoconnect = false;
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
         this.serializeAs_IdentificationMessage(output);
      }
      
      public function serializeAs_IdentificationMessage(output:IDataOutput) : void
      {
         this.version.serializeAs_Version(output);
         output.writeUTF(this.login);
         output.writeUTF(this.password);
         output.writeBoolean(this.autoconnect);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_IdentificationMessage(input);
      }
      
      public function deserializeAs_IdentificationMessage(input:IDataInput) : void
      {
         this.version = new Version();
         this.version.deserialize(input);
         this.login = input.readUTF();
         this.password = input.readUTF();
         this.autoconnect = input.readBoolean();
      }
   }
}
