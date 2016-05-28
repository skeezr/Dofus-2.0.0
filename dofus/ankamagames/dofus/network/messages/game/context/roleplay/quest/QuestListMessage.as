package com.ankamagames.dofus.network.messages.game.context.roleplay.quest
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class QuestListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5626;
       
      private var _isInitialized:Boolean = false;
      
      public var finishedQuestsIds:Vector.<uint>;
      
      public var activeQuestsIds:Vector.<uint>;
      
      public function QuestListMessage()
      {
         this.finishedQuestsIds = new Vector.<uint>();
         this.activeQuestsIds = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5626;
      }
      
      public function initQuestListMessage(finishedQuestsIds:Vector.<uint> = null, activeQuestsIds:Vector.<uint> = null) : QuestListMessage
      {
         this.finishedQuestsIds = finishedQuestsIds;
         this.activeQuestsIds = activeQuestsIds;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.finishedQuestsIds = new Vector.<uint>();
         this.activeQuestsIds = new Vector.<uint>();
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
         this.serializeAs_QuestListMessage(output);
      }
      
      public function serializeAs_QuestListMessage(output:IDataOutput) : void
      {
         output.writeShort(this.finishedQuestsIds.length);
         for(var _i1:uint = 0; _i1 < this.finishedQuestsIds.length; _i1++)
         {
            if(this.finishedQuestsIds[_i1] < 0)
            {
               throw new Error("Forbidden value (" + this.finishedQuestsIds[_i1] + ") on element 1 (starting at 1) of finishedQuestsIds.");
            }
            output.writeShort(this.finishedQuestsIds[_i1]);
         }
         output.writeShort(this.activeQuestsIds.length);
         for(var _i2:uint = 0; _i2 < this.activeQuestsIds.length; _i2++)
         {
            if(this.activeQuestsIds[_i2] < 0)
            {
               throw new Error("Forbidden value (" + this.activeQuestsIds[_i2] + ") on element 2 (starting at 1) of activeQuestsIds.");
            }
            output.writeShort(this.activeQuestsIds[_i2]);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_QuestListMessage(input);
      }
      
      public function deserializeAs_QuestListMessage(input:IDataInput) : void
      {
         var _val1:uint = 0;
         var _val2:uint = 0;
         var _finishedQuestsIdsLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _finishedQuestsIdsLen; _i1++)
         {
            _val1 = input.readShort();
            if(_val1 < 0)
            {
               throw new Error("Forbidden value (" + _val1 + ") on elements of finishedQuestsIds.");
            }
            this.finishedQuestsIds.push(_val1);
         }
         var _activeQuestsIdsLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _activeQuestsIdsLen; _i2++)
         {
            _val2 = input.readShort();
            if(_val2 < 0)
            {
               throw new Error("Forbidden value (" + _val2 + ") on elements of activeQuestsIds.");
            }
            this.activeQuestsIds.push(_val2);
         }
      }
   }
}
