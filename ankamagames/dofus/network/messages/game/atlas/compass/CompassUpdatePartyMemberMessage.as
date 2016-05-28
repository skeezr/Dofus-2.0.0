package com.ankamagames.dofus.network.messages.game.atlas.compass
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class CompassUpdatePartyMemberMessage extends CompassUpdateMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5589;
       
      private var _isInitialized:Boolean = false;
      
      public var memberId:uint = 0;
      
      public function CompassUpdatePartyMemberMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return Boolean(super.isInitialized) && Boolean(this._isInitialized);
      }
      
      override public function getMessageId() : uint
      {
         return 5589;
      }
      
      public function initCompassUpdatePartyMemberMessage(type:uint = 0, worldX:int = 0, worldY:int = 0, memberId:uint = 0) : CompassUpdatePartyMemberMessage
      {
         super.initCompassUpdateMessage(type,worldX,worldY);
         this.memberId = memberId;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.memberId = 0;
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
         this.serializeAs_CompassUpdatePartyMemberMessage(output);
      }
      
      public function serializeAs_CompassUpdatePartyMemberMessage(output:IDataOutput) : void
      {
         super.serializeAs_CompassUpdateMessage(output);
         if(this.memberId < 0)
         {
            throw new Error("Forbidden value (" + this.memberId + ") on element memberId.");
         }
         output.writeInt(this.memberId);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_CompassUpdatePartyMemberMessage(input);
      }
      
      public function deserializeAs_CompassUpdatePartyMemberMessage(input:IDataInput) : void
      {
         super.deserialize(input);
         this.memberId = input.readInt();
         if(this.memberId < 0)
         {
            throw new Error("Forbidden value (" + this.memberId + ") on element of CompassUpdatePartyMemberMessage.memberId.");
         }
      }
   }
}
