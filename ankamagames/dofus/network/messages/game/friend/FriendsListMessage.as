package com.ankamagames.dofus.network.messages.game.friend
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.friend.FriendInformations;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   
   public class FriendsListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 4002;
       
      private var _isInitialized:Boolean = false;
      
      public var friendsList:Vector.<FriendInformations>;
      
      public function FriendsListMessage()
      {
         this.friendsList = new Vector.<FriendInformations>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 4002;
      }
      
      public function initFriendsListMessage(friendsList:Vector.<FriendInformations> = null) : FriendsListMessage
      {
         this.friendsList = friendsList;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.friendsList = new Vector.<FriendInformations>();
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
         this.serializeAs_FriendsListMessage(output);
      }
      
      public function serializeAs_FriendsListMessage(output:IDataOutput) : void
      {
         output.writeShort(this.friendsList.length);
         for(var _i1:uint = 0; _i1 < this.friendsList.length; _i1++)
         {
            output.writeShort((this.friendsList[_i1] as FriendInformations).getTypeId());
            (this.friendsList[_i1] as FriendInformations).serialize(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_FriendsListMessage(input);
      }
      
      public function deserializeAs_FriendsListMessage(input:IDataInput) : void
      {
         var _id1:uint = 0;
         var _item1:FriendInformations = null;
         var _friendsListLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _friendsListLen; _i1++)
         {
            _id1 = input.readUnsignedShort();
            _item1 = ProtocolTypeManager.getInstance(FriendInformations,_id1);
            _item1.deserialize(input);
            this.friendsList.push(_item1);
         }
      }
   }
}
