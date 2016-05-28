package com.ankamagames.dofus.network.messages.connection
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import com.ankamagames.jerakine.network.utils.BooleanByteWrapper;
   
   public class IdentificationSuccessMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 22;
       
      private var _isInitialized:Boolean = false;
      
      public var nickname:String = "";
      
      public var communityId:uint = 0;
      
      public var hasRights:Boolean = false;
      
      public var secretQuestion:String = "";
      
      public var remainingSubscriptionTime:Number = 0;
      
      public var wasAlreadyConnected:Boolean = false;
      
      public function IdentificationSuccessMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 22;
      }
      
      public function initIdentificationSuccessMessage(nickname:String = "", communityId:uint = 0, hasRights:Boolean = false, secretQuestion:String = "", remainingSubscriptionTime:Number = 0, wasAlreadyConnected:Boolean = false) : IdentificationSuccessMessage
      {
         this.nickname = nickname;
         this.communityId = communityId;
         this.hasRights = hasRights;
         this.secretQuestion = secretQuestion;
         this.remainingSubscriptionTime = remainingSubscriptionTime;
         this.wasAlreadyConnected = wasAlreadyConnected;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.nickname = "";
         this.communityId = 0;
         this.hasRights = false;
         this.secretQuestion = "";
         this.remainingSubscriptionTime = 0;
         this.wasAlreadyConnected = false;
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
         this.serializeAs_IdentificationSuccessMessage(output);
      }
      
      public function serializeAs_IdentificationSuccessMessage(output:IDataOutput) : void
      {
         var _box0:uint = 0;
         BooleanByteWrapper.setFlag(_box0,0,this.hasRights);
         BooleanByteWrapper.setFlag(_box0,1,this.wasAlreadyConnected);
         output.writeByte(_box0);
         output.writeUTF(this.nickname);
         if(this.communityId < 0)
         {
            throw new Error("Forbidden value (" + this.communityId + ") on element communityId.");
         }
         output.writeByte(this.communityId);
         output.writeUTF(this.secretQuestion);
         if(this.remainingSubscriptionTime < 0)
         {
            throw new Error("Forbidden value (" + this.remainingSubscriptionTime + ") on element remainingSubscriptionTime.");
         }
         output.writeDouble(this.remainingSubscriptionTime);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_IdentificationSuccessMessage(input);
      }
      
      public function deserializeAs_IdentificationSuccessMessage(input:IDataInput) : void
      {
         var _box0:uint = input.readByte();
         this.hasRights = BooleanByteWrapper.getFlag(_box0,0);
         this.wasAlreadyConnected = BooleanByteWrapper.getFlag(_box0,1);
         this.nickname = input.readUTF();
         this.communityId = input.readByte();
         if(this.communityId < 0)
         {
            throw new Error("Forbidden value (" + this.communityId + ") on element of IdentificationSuccessMessage.communityId.");
         }
         this.secretQuestion = input.readUTF();
         this.remainingSubscriptionTime = input.readDouble();
         if(this.remainingSubscriptionTime < 0)
         {
            throw new Error("Forbidden value (" + this.remainingSubscriptionTime + ") on element of IdentificationSuccessMessage.remainingSubscriptionTime.");
         }
      }
   }
}
