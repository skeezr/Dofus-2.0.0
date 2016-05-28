package com.ankamagames.dofus.network.messages.game.basic
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class TextInformationMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 780;
       
      private var _isInitialized:Boolean = false;
      
      public var msgType:uint = 0;
      
      public var msgId:uint = 0;
      
      public var parameters:Vector.<String>;
      
      public function TextInformationMessage()
      {
         this.parameters = new Vector.<String>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 780;
      }
      
      public function initTextInformationMessage(msgType:uint = 0, msgId:uint = 0, parameters:Vector.<String> = null) : TextInformationMessage
      {
         this.msgType = msgType;
         this.msgId = msgId;
         this.parameters = parameters;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.msgType = 0;
         this.msgId = 0;
         this.parameters = new Vector.<String>();
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
         this.serializeAs_TextInformationMessage(output);
      }
      
      public function serializeAs_TextInformationMessage(output:IDataOutput) : void
      {
         output.writeByte(this.msgType);
         if(this.msgId < 0)
         {
            throw new Error("Forbidden value (" + this.msgId + ") on element msgId.");
         }
         output.writeShort(this.msgId);
         output.writeShort(this.parameters.length);
         for(var _i3:uint = 0; _i3 < this.parameters.length; _i3++)
         {
            output.writeUTF(this.parameters[_i3]);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_TextInformationMessage(input);
      }
      
      public function deserializeAs_TextInformationMessage(input:IDataInput) : void
      {
         var _val3:String = null;
         this.msgType = input.readByte();
         if(this.msgType < 0)
         {
            throw new Error("Forbidden value (" + this.msgType + ") on element of TextInformationMessage.msgType.");
         }
         this.msgId = input.readShort();
         if(this.msgId < 0)
         {
            throw new Error("Forbidden value (" + this.msgId + ") on element of TextInformationMessage.msgId.");
         }
         var _parametersLen:uint = input.readUnsignedShort();
         for(var _i3:uint = 0; _i3 < _parametersLen; _i3++)
         {
            _val3 = input.readUTF();
            this.parameters.push(_val3);
         }
      }
   }
}
