package com.ankamagames.dofus.network.messages.game.context.roleplay.quest
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class QuestStepInfoMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5625;
       
      private var _isInitialized:Boolean = false;
      
      public var questId:uint = 0;
      
      public var stepId:uint = 0;
      
      public var objectivesIds:Vector.<uint>;
      
      public var objectivesStatus:Vector.<Boolean>;
      
      public function QuestStepInfoMessage()
      {
         this.objectivesIds = new Vector.<uint>();
         this.objectivesStatus = new Vector.<Boolean>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5625;
      }
      
      public function initQuestStepInfoMessage(questId:uint = 0, stepId:uint = 0, objectivesIds:Vector.<uint> = null, objectivesStatus:Vector.<Boolean> = null) : QuestStepInfoMessage
      {
         this.questId = questId;
         this.stepId = stepId;
         this.objectivesIds = objectivesIds;
         this.objectivesStatus = objectivesStatus;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.questId = 0;
         this.stepId = 0;
         this.objectivesIds = new Vector.<uint>();
         this.objectivesStatus = new Vector.<Boolean>();
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
         this.serializeAs_QuestStepInfoMessage(output);
      }
      
      public function serializeAs_QuestStepInfoMessage(output:IDataOutput) : void
      {
         if(this.questId < 0)
         {
            throw new Error("Forbidden value (" + this.questId + ") on element questId.");
         }
         output.writeShort(this.questId);
         if(this.stepId < 0)
         {
            throw new Error("Forbidden value (" + this.stepId + ") on element stepId.");
         }
         output.writeShort(this.stepId);
         output.writeShort(this.objectivesIds.length);
         for(var _i3:uint = 0; _i3 < this.objectivesIds.length; _i3++)
         {
            if(this.objectivesIds[_i3] < 0)
            {
               throw new Error("Forbidden value (" + this.objectivesIds[_i3] + ") on element 3 (starting at 1) of objectivesIds.");
            }
            output.writeShort(this.objectivesIds[_i3]);
         }
         output.writeShort(this.objectivesStatus.length);
         for(var _i4:uint = 0; _i4 < this.objectivesStatus.length; _i4++)
         {
            output.writeBoolean(this.objectivesStatus[_i4]);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_QuestStepInfoMessage(input);
      }
      
      public function deserializeAs_QuestStepInfoMessage(input:IDataInput) : void
      {
         var _val3:uint = 0;
         var _val4:Boolean = false;
         this.questId = input.readShort();
         if(this.questId < 0)
         {
            throw new Error("Forbidden value (" + this.questId + ") on element of QuestStepInfoMessage.questId.");
         }
         this.stepId = input.readShort();
         if(this.stepId < 0)
         {
            throw new Error("Forbidden value (" + this.stepId + ") on element of QuestStepInfoMessage.stepId.");
         }
         var _objectivesIdsLen:uint = input.readUnsignedShort();
         for(var _i3:uint = 0; _i3 < _objectivesIdsLen; _i3++)
         {
            _val3 = input.readShort();
            if(_val3 < 0)
            {
               throw new Error("Forbidden value (" + _val3 + ") on elements of objectivesIds.");
            }
            this.objectivesIds.push(_val3);
         }
         var _objectivesStatusLen:uint = input.readUnsignedShort();
         for(var _i4:uint = 0; _i4 < _objectivesStatusLen; _i4++)
         {
            _val4 = input.readBoolean();
            this.objectivesStatus.push(_val4);
         }
      }
   }
}
