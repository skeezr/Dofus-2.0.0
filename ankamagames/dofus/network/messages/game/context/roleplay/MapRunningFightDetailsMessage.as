package com.ankamagames.dofus.network.messages.game.context.roleplay
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class MapRunningFightDetailsMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5751;
       
      private var _isInitialized:Boolean = false;
      
      public var fightId:uint = 0;
      
      public var names:Vector.<String>;
      
      public var levels:Vector.<uint>;
      
      public var teamSwap:uint = 0;
      
      public var alives:Vector.<Boolean>;
      
      public function MapRunningFightDetailsMessage()
      {
         this.names = new Vector.<String>();
         this.levels = new Vector.<uint>();
         this.alives = new Vector.<Boolean>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5751;
      }
      
      public function initMapRunningFightDetailsMessage(fightId:uint = 0, names:Vector.<String> = null, levels:Vector.<uint> = null, teamSwap:uint = 0, alives:Vector.<Boolean> = null) : MapRunningFightDetailsMessage
      {
         this.fightId = fightId;
         this.names = names;
         this.levels = levels;
         this.teamSwap = teamSwap;
         this.alives = alives;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.fightId = 0;
         this.names = new Vector.<String>();
         this.levels = new Vector.<uint>();
         this.teamSwap = 0;
         this.alives = new Vector.<Boolean>();
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
         this.serializeAs_MapRunningFightDetailsMessage(output);
      }
      
      public function serializeAs_MapRunningFightDetailsMessage(output:IDataOutput) : void
      {
         if(this.fightId < 0)
         {
            throw new Error("Forbidden value (" + this.fightId + ") on element fightId.");
         }
         output.writeInt(this.fightId);
         output.writeShort(this.names.length);
         for(var _i2:uint = 0; _i2 < this.names.length; _i2++)
         {
            output.writeUTF(this.names[_i2]);
         }
         output.writeShort(this.levels.length);
         for(var _i3:uint = 0; _i3 < this.levels.length; _i3++)
         {
            if(this.levels[_i3] < 0)
            {
               throw new Error("Forbidden value (" + this.levels[_i3] + ") on element 3 (starting at 1) of levels.");
            }
            output.writeShort(this.levels[_i3]);
         }
         if(this.teamSwap < 0)
         {
            throw new Error("Forbidden value (" + this.teamSwap + ") on element teamSwap.");
         }
         output.writeByte(this.teamSwap);
         output.writeShort(this.alives.length);
         for(var _i5:uint = 0; _i5 < this.alives.length; _i5++)
         {
            output.writeBoolean(this.alives[_i5]);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_MapRunningFightDetailsMessage(input);
      }
      
      public function deserializeAs_MapRunningFightDetailsMessage(input:IDataInput) : void
      {
         var _val2:String = null;
         var _val3:uint = 0;
         var _val5:Boolean = false;
         this.fightId = input.readInt();
         if(this.fightId < 0)
         {
            throw new Error("Forbidden value (" + this.fightId + ") on element of MapRunningFightDetailsMessage.fightId.");
         }
         var _namesLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _namesLen; _i2++)
         {
            _val2 = input.readUTF();
            this.names.push(_val2);
         }
         var _levelsLen:uint = input.readUnsignedShort();
         for(var _i3:uint = 0; _i3 < _levelsLen; _i3++)
         {
            _val3 = input.readShort();
            if(_val3 < 0)
            {
               throw new Error("Forbidden value (" + _val3 + ") on elements of levels.");
            }
            this.levels.push(_val3);
         }
         this.teamSwap = input.readByte();
         if(this.teamSwap < 0)
         {
            throw new Error("Forbidden value (" + this.teamSwap + ") on element of MapRunningFightDetailsMessage.teamSwap.");
         }
         var _alivesLen:uint = input.readUnsignedShort();
         for(var _i5:uint = 0; _i5 < _alivesLen; _i5++)
         {
            _val5 = input.readBoolean();
            this.alives.push(_val5);
         }
      }
   }
}
