package com.ankamagames.dofus.network.messages.game.context.roleplay
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.context.fight.FightExternalInformations;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class MapRunningFightListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5743;
       
      private var _isInitialized:Boolean = false;
      
      public var fights:Vector.<FightExternalInformations>;
      
      public function MapRunningFightListMessage()
      {
         this.fights = new Vector.<FightExternalInformations>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5743;
      }
      
      public function initMapRunningFightListMessage(fights:Vector.<FightExternalInformations> = null) : MapRunningFightListMessage
      {
         this.fights = fights;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.fights = new Vector.<FightExternalInformations>();
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
         this.serializeAs_MapRunningFightListMessage(output);
      }
      
      public function serializeAs_MapRunningFightListMessage(output:IDataOutput) : void
      {
         output.writeShort(this.fights.length);
         for(var _i1:uint = 0; _i1 < this.fights.length; _i1++)
         {
            (this.fights[_i1] as FightExternalInformations).serializeAs_FightExternalInformations(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_MapRunningFightListMessage(input);
      }
      
      public function deserializeAs_MapRunningFightListMessage(input:IDataInput) : void
      {
         var _item1:FightExternalInformations = null;
         var _fightsLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _fightsLen; _i1++)
         {
            _item1 = new FightExternalInformations();
            _item1.deserialize(input);
            this.fights.push(_item1);
         }
      }
   }
}
