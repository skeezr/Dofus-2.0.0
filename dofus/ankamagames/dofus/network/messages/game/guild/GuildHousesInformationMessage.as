package com.ankamagames.dofus.network.messages.game.guild
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.house.HouseInformationsForGuild;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GuildHousesInformationMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5919;
       
      private var _isInitialized:Boolean = false;
      
      public var HousesInformations:Vector.<HouseInformationsForGuild>;
      
      public function GuildHousesInformationMessage()
      {
         this.HousesInformations = new Vector.<HouseInformationsForGuild>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5919;
      }
      
      public function initGuildHousesInformationMessage(HousesInformations:Vector.<HouseInformationsForGuild> = null) : GuildHousesInformationMessage
      {
         this.HousesInformations = HousesInformations;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.HousesInformations = new Vector.<HouseInformationsForGuild>();
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
         this.serializeAs_GuildHousesInformationMessage(output);
      }
      
      public function serializeAs_GuildHousesInformationMessage(output:IDataOutput) : void
      {
         output.writeShort(this.HousesInformations.length);
         for(var _i1:uint = 0; _i1 < this.HousesInformations.length; _i1++)
         {
            (this.HousesInformations[_i1] as HouseInformationsForGuild).serializeAs_HouseInformationsForGuild(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GuildHousesInformationMessage(input);
      }
      
      public function deserializeAs_GuildHousesInformationMessage(input:IDataInput) : void
      {
         var _item1:HouseInformationsForGuild = null;
         var _HousesInformationsLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _HousesInformationsLen; _i1++)
         {
            _item1 = new HouseInformationsForGuild();
            _item1.deserialize(input);
            this.HousesInformations.push(_item1);
         }
      }
   }
}
