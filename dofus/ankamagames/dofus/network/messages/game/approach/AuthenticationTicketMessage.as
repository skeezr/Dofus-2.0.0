package com.ankamagames.dofus.network.messages.game.approach
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class AuthenticationTicketMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 110;
       
      private var _isInitialized:Boolean = false;
      
      public var ticket:String = "";
      
      public var lang:String = "";
      
      public function AuthenticationTicketMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 110;
      }
      
      public function initAuthenticationTicketMessage(ticket:String = "", lang:String = "") : AuthenticationTicketMessage
      {
         this.ticket = ticket;
         this.lang = lang;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.ticket = "";
         this.lang = "";
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
         this.serializeAs_AuthenticationTicketMessage(output);
      }
      
      public function serializeAs_AuthenticationTicketMessage(output:IDataOutput) : void
      {
         output.writeUTF(this.ticket);
         output.writeUTF(this.lang);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_AuthenticationTicketMessage(input);
      }
      
      public function deserializeAs_AuthenticationTicketMessage(input:IDataInput) : void
      {
         this.ticket = input.readUTF();
         this.lang = input.readUTF();
      }
   }
}
