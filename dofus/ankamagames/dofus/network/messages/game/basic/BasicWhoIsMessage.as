package com.ankamagames.dofus.network.messages.game.basic
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class BasicWhoIsMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 180;
       
      private var _isInitialized:Boolean = false;
      
      public var self:Boolean = false;
      
      public var position:int = 0;
      
      public var accountNickname:String = "";
      
      public var characterName:String = "";
      
      public var areaId:int = 0;
      
      public function BasicWhoIsMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 180;
      }
      
      public function initBasicWhoIsMessage(self:Boolean = false, position:int = 0, accountNickname:String = "", characterName:String = "", areaId:int = 0) : BasicWhoIsMessage
      {
         this.self = self;
         this.position = position;
         this.accountNickname = accountNickname;
         this.characterName = characterName;
         this.areaId = areaId;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.self = false;
         this.position = 0;
         this.accountNickname = "";
         this.characterName = "";
         this.areaId = 0;
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
         this.serializeAs_BasicWhoIsMessage(output);
      }
      
      public function serializeAs_BasicWhoIsMessage(output:IDataOutput) : void
      {
         output.writeBoolean(this.self);
         output.writeByte(this.position);
         output.writeUTF(this.accountNickname);
         output.writeUTF(this.characterName);
         output.writeShort(this.areaId);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_BasicWhoIsMessage(input);
      }
      
      public function deserializeAs_BasicWhoIsMessage(input:IDataInput) : void
      {
         this.self = input.readBoolean();
         this.position = input.readByte();
         this.accountNickname = input.readUTF();
         this.characterName = input.readUTF();
         this.areaId = input.readShort();
      }
   }
}
