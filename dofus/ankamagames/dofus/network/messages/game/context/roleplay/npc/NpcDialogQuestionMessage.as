package com.ankamagames.dofus.network.messages.game.context.roleplay.npc
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class NpcDialogQuestionMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5617;
       
      private var _isInitialized:Boolean = false;
      
      public var messageId:uint = 0;
      
      public var dialogParams:Vector.<String>;
      
      public var visibleReplies:Vector.<uint>;
      
      public function NpcDialogQuestionMessage()
      {
         this.dialogParams = new Vector.<String>();
         this.visibleReplies = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5617;
      }
      
      public function initNpcDialogQuestionMessage(messageId:uint = 0, dialogParams:Vector.<String> = null, visibleReplies:Vector.<uint> = null) : NpcDialogQuestionMessage
      {
         this.messageId = messageId;
         this.dialogParams = dialogParams;
         this.visibleReplies = visibleReplies;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.messageId = 0;
         this.dialogParams = new Vector.<String>();
         this.visibleReplies = new Vector.<uint>();
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
         this.serializeAs_NpcDialogQuestionMessage(output);
      }
      
      public function serializeAs_NpcDialogQuestionMessage(output:IDataOutput) : void
      {
         if(this.messageId < 0)
         {
            throw new Error("Forbidden value (" + this.messageId + ") on element messageId.");
         }
         output.writeShort(this.messageId);
         output.writeShort(this.dialogParams.length);
         for(var _i2:uint = 0; _i2 < this.dialogParams.length; _i2++)
         {
            output.writeUTF(this.dialogParams[_i2]);
         }
         output.writeShort(this.visibleReplies.length);
         for(var _i3:uint = 0; _i3 < this.visibleReplies.length; _i3++)
         {
            if(this.visibleReplies[_i3] < 0)
            {
               throw new Error("Forbidden value (" + this.visibleReplies[_i3] + ") on element 3 (starting at 1) of visibleReplies.");
            }
            output.writeShort(this.visibleReplies[_i3]);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_NpcDialogQuestionMessage(input);
      }
      
      public function deserializeAs_NpcDialogQuestionMessage(input:IDataInput) : void
      {
         var _val2:String = null;
         var _val3:uint = 0;
         this.messageId = input.readShort();
         if(this.messageId < 0)
         {
            throw new Error("Forbidden value (" + this.messageId + ") on element of NpcDialogQuestionMessage.messageId.");
         }
         var _dialogParamsLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _dialogParamsLen; _i2++)
         {
            _val2 = input.readUTF();
            this.dialogParams.push(_val2);
         }
         var _visibleRepliesLen:uint = input.readUnsignedShort();
         for(var _i3:uint = 0; _i3 < _visibleRepliesLen; _i3++)
         {
            _val3 = input.readShort();
            if(_val3 < 0)
            {
               throw new Error("Forbidden value (" + _val3 + ") on elements of visibleReplies.");
            }
            this.visibleReplies.push(_val3);
         }
      }
   }
}
