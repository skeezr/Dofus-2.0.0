package com.ankamagames.dofus.network.messages.game.context.fight
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.context.fight.FightResultListEntry;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   
   public class GameFightEndMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 720;
       
      private var _isInitialized:Boolean = false;
      
      public var duration:uint = 0;
      
      public var ageBonus:int = 0;
      
      public var results:Vector.<FightResultListEntry>;
      
      public function GameFightEndMessage()
      {
         this.results = new Vector.<FightResultListEntry>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 720;
      }
      
      public function initGameFightEndMessage(duration:uint = 0, ageBonus:int = 0, results:Vector.<FightResultListEntry> = null) : GameFightEndMessage
      {
         this.duration = duration;
         this.ageBonus = ageBonus;
         this.results = results;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.duration = 0;
         this.ageBonus = 0;
         this.results = new Vector.<FightResultListEntry>();
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
         this.serializeAs_GameFightEndMessage(output);
      }
      
      public function serializeAs_GameFightEndMessage(output:IDataOutput) : void
      {
         if(this.duration < 0)
         {
            throw new Error("Forbidden value (" + this.duration + ") on element duration.");
         }
         output.writeInt(this.duration);
         output.writeShort(this.ageBonus);
         output.writeShort(this.results.length);
         for(var _i3:uint = 0; _i3 < this.results.length; _i3++)
         {
            output.writeShort((this.results[_i3] as FightResultListEntry).getTypeId());
            (this.results[_i3] as FightResultListEntry).serialize(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameFightEndMessage(input);
      }
      
      public function deserializeAs_GameFightEndMessage(input:IDataInput) : void
      {
         var _id3:uint = 0;
         var _item3:FightResultListEntry = null;
         this.duration = input.readInt();
         if(this.duration < 0)
         {
            throw new Error("Forbidden value (" + this.duration + ") on element of GameFightEndMessage.duration.");
         }
         this.ageBonus = input.readShort();
         var _resultsLen:uint = input.readUnsignedShort();
         for(var _i3:uint = 0; _i3 < _resultsLen; _i3++)
         {
            _id3 = input.readUnsignedShort();
            _item3 = ProtocolTypeManager.getInstance(FightResultListEntry,_id3);
            _item3.deserialize(input);
            this.results.push(_item3);
         }
      }
   }
}
