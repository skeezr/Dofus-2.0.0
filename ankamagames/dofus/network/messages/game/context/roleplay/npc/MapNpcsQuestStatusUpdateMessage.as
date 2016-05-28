package com.ankamagames.dofus.network.messages.game.context.roleplay.npc
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class MapNpcsQuestStatusUpdateMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5642;
       
      private var _isInitialized:Boolean = false;
      
      public var mapId:int = 0;
      
      public var npcsIdsCanGiveQuest:Vector.<int>;
      
      public var npcsIdsCannotGiveQuest:Vector.<int>;
      
      public function MapNpcsQuestStatusUpdateMessage()
      {
         this.npcsIdsCanGiveQuest = new Vector.<int>();
         this.npcsIdsCannotGiveQuest = new Vector.<int>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5642;
      }
      
      public function initMapNpcsQuestStatusUpdateMessage(mapId:int = 0, npcsIdsCanGiveQuest:Vector.<int> = null, npcsIdsCannotGiveQuest:Vector.<int> = null) : MapNpcsQuestStatusUpdateMessage
      {
         this.mapId = mapId;
         this.npcsIdsCanGiveQuest = npcsIdsCanGiveQuest;
         this.npcsIdsCannotGiveQuest = npcsIdsCannotGiveQuest;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.mapId = 0;
         this.npcsIdsCanGiveQuest = new Vector.<int>();
         this.npcsIdsCannotGiveQuest = new Vector.<int>();
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
         this.serializeAs_MapNpcsQuestStatusUpdateMessage(output);
      }
      
      public function serializeAs_MapNpcsQuestStatusUpdateMessage(output:IDataOutput) : void
      {
         output.writeInt(this.mapId);
         output.writeShort(this.npcsIdsCanGiveQuest.length);
         for(var _i2:uint = 0; _i2 < this.npcsIdsCanGiveQuest.length; _i2++)
         {
            output.writeInt(this.npcsIdsCanGiveQuest[_i2]);
         }
         output.writeShort(this.npcsIdsCannotGiveQuest.length);
         for(var _i3:uint = 0; _i3 < this.npcsIdsCannotGiveQuest.length; _i3++)
         {
            output.writeInt(this.npcsIdsCannotGiveQuest[_i3]);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_MapNpcsQuestStatusUpdateMessage(input);
      }
      
      public function deserializeAs_MapNpcsQuestStatusUpdateMessage(input:IDataInput) : void
      {
         var _val2:int = 0;
         var _val3:int = 0;
         this.mapId = input.readInt();
         var _npcsIdsCanGiveQuestLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _npcsIdsCanGiveQuestLen; _i2++)
         {
            _val2 = input.readInt();
            this.npcsIdsCanGiveQuest.push(_val2);
         }
         var _npcsIdsCannotGiveQuestLen:uint = input.readUnsignedShort();
         for(var _i3:uint = 0; _i3 < _npcsIdsCannotGiveQuestLen; _i3++)
         {
            _val3 = input.readInt();
            this.npcsIdsCannotGiveQuest.push(_val3);
         }
      }
   }
}
