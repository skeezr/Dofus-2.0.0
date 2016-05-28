package com.ankamagames.dofus.network.messages.game.friend
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.friend.FriendSpouseInformations;
   import com.ankamagames.dofus.network.types.game.friend.FriendInformations;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   
   public class FriendsListWithSpouseMessage extends FriendsListMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5931;
       
      private var _isInitialized:Boolean = false;
      
      public var spouse:FriendSpouseInformations;
      
      public function FriendsListWithSpouseMessage()
      {
         this.spouse = new FriendSpouseInformations();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return Boolean(super.isInitialized) && Boolean(this._isInitialized);
      }
      
      override public function getMessageId() : uint
      {
         return 5931;
      }
      
      public function initFriendsListWithSpouseMessage(friendsList:Vector.<FriendInformations> = null, spouse:FriendSpouseInformations = null) : FriendsListWithSpouseMessage
      {
         super.initFriendsListMessage(friendsList);
         this.spouse = spouse;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.spouse = new FriendSpouseInformations();
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
         this.serializeAs_FriendsListWithSpouseMessage(output);
      }
      
      public function serializeAs_FriendsListWithSpouseMessage(output:IDataOutput) : void
      {
         super.serializeAs_FriendsListMessage(output);
         output.writeShort(this.spouse.getTypeId());
         this.spouse.serialize(output);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_FriendsListWithSpouseMessage(input);
      }
      
      public function deserializeAs_FriendsListWithSpouseMessage(input:IDataInput) : void
      {
         super.deserialize(input);
         var _id1:uint = input.readUnsignedShort();
         this.spouse = ProtocolTypeManager.getInstance(FriendSpouseInformations,_id1);
         this.spouse.deserialize(input);
      }
   }
}
