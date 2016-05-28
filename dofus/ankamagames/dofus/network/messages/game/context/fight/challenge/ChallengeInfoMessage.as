package com.ankamagames.dofus.network.messages.game.context.fight.challenge
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class ChallengeInfoMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6022;
       
      private var _isInitialized:Boolean = false;
      
      public var challengeId:uint = 0;
      
      public var targetId:int = 0;
      
      public var baseXpBonus:uint = 0;
      
      public var extraXpBonus:uint = 0;
      
      public var baseDropBonus:uint = 0;
      
      public var extraDropBonus:uint = 0;
      
      public function ChallengeInfoMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6022;
      }
      
      public function initChallengeInfoMessage(challengeId:uint = 0, targetId:int = 0, baseXpBonus:uint = 0, extraXpBonus:uint = 0, baseDropBonus:uint = 0, extraDropBonus:uint = 0) : ChallengeInfoMessage
      {
         this.challengeId = challengeId;
         this.targetId = targetId;
         this.baseXpBonus = baseXpBonus;
         this.extraXpBonus = extraXpBonus;
         this.baseDropBonus = baseDropBonus;
         this.extraDropBonus = extraDropBonus;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.challengeId = 0;
         this.targetId = 0;
         this.baseXpBonus = 0;
         this.extraXpBonus = 0;
         this.baseDropBonus = 0;
         this.extraDropBonus = 0;
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
         this.serializeAs_ChallengeInfoMessage(output);
      }
      
      public function serializeAs_ChallengeInfoMessage(output:IDataOutput) : void
      {
         if(this.challengeId < 0)
         {
            throw new Error("Forbidden value (" + this.challengeId + ") on element challengeId.");
         }
         output.writeByte(this.challengeId);
         output.writeInt(this.targetId);
         if(this.baseXpBonus < 0)
         {
            throw new Error("Forbidden value (" + this.baseXpBonus + ") on element baseXpBonus.");
         }
         output.writeInt(this.baseXpBonus);
         if(this.extraXpBonus < 0)
         {
            throw new Error("Forbidden value (" + this.extraXpBonus + ") on element extraXpBonus.");
         }
         output.writeInt(this.extraXpBonus);
         if(this.baseDropBonus < 0)
         {
            throw new Error("Forbidden value (" + this.baseDropBonus + ") on element baseDropBonus.");
         }
         output.writeInt(this.baseDropBonus);
         if(this.extraDropBonus < 0)
         {
            throw new Error("Forbidden value (" + this.extraDropBonus + ") on element extraDropBonus.");
         }
         output.writeInt(this.extraDropBonus);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ChallengeInfoMessage(input);
      }
      
      public function deserializeAs_ChallengeInfoMessage(input:IDataInput) : void
      {
         this.challengeId = input.readByte();
         if(this.challengeId < 0)
         {
            throw new Error("Forbidden value (" + this.challengeId + ") on element of ChallengeInfoMessage.challengeId.");
         }
         this.targetId = input.readInt();
         this.baseXpBonus = input.readInt();
         if(this.baseXpBonus < 0)
         {
            throw new Error("Forbidden value (" + this.baseXpBonus + ") on element of ChallengeInfoMessage.baseXpBonus.");
         }
         this.extraXpBonus = input.readInt();
         if(this.extraXpBonus < 0)
         {
            throw new Error("Forbidden value (" + this.extraXpBonus + ") on element of ChallengeInfoMessage.extraXpBonus.");
         }
         this.baseDropBonus = input.readInt();
         if(this.baseDropBonus < 0)
         {
            throw new Error("Forbidden value (" + this.baseDropBonus + ") on element of ChallengeInfoMessage.baseDropBonus.");
         }
         this.extraDropBonus = input.readInt();
         if(this.extraDropBonus < 0)
         {
            throw new Error("Forbidden value (" + this.extraDropBonus + ") on element of ChallengeInfoMessage.extraDropBonus.");
         }
      }
   }
}
