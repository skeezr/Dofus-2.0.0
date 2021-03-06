package com.ankamagames.dofus.network.messages.game.friend
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.friend.IgnoredInformations;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   
   public class IgnoredListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5674;
       
      private var _isInitialized:Boolean = false;
      
      public var ignoredList:Vector.<IgnoredInformations>;
      
      public function IgnoredListMessage()
      {
         this.ignoredList = new Vector.<IgnoredInformations>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5674;
      }
      
      public function initIgnoredListMessage(ignoredList:Vector.<IgnoredInformations> = null) : IgnoredListMessage
      {
         this.ignoredList = ignoredList;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.ignoredList = new Vector.<IgnoredInformations>();
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
         this.serializeAs_IgnoredListMessage(output);
      }
      
      public function serializeAs_IgnoredListMessage(output:IDataOutput) : void
      {
         output.writeShort(this.ignoredList.length);
         for(var _i1:uint = 0; _i1 < this.ignoredList.length; _i1++)
         {
            output.writeShort((this.ignoredList[_i1] as IgnoredInformations).getTypeId());
            (this.ignoredList[_i1] as IgnoredInformations).serialize(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_IgnoredListMessage(input);
      }
      
      public function deserializeAs_IgnoredListMessage(input:IDataInput) : void
      {
         var _id1:uint = 0;
         var _item1:IgnoredInformations = null;
         var _ignoredListLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _ignoredListLen; _i1++)
         {
            _id1 = input.readUnsignedShort();
            _item1 = ProtocolTypeManager.getInstance(IgnoredInformations,_id1);
            _item1.deserialize(input);
            this.ignoredList.push(_item1);
         }
      }
   }
}
