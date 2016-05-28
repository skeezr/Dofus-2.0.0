package com.ankamagames.dofus.network.messages.game.chat.channel
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class EnabledChannelsMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 892;
       
      private var _isInitialized:Boolean = false;
      
      public var channels:Vector.<uint>;
      
      public var disallowed:Vector.<uint>;
      
      public function EnabledChannelsMessage()
      {
         this.channels = new Vector.<uint>();
         this.disallowed = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 892;
      }
      
      public function initEnabledChannelsMessage(channels:Vector.<uint> = null, disallowed:Vector.<uint> = null) : EnabledChannelsMessage
      {
         this.channels = channels;
         this.disallowed = disallowed;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.channels = new Vector.<uint>();
         this.disallowed = new Vector.<uint>();
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
         this.serializeAs_EnabledChannelsMessage(output);
      }
      
      public function serializeAs_EnabledChannelsMessage(output:IDataOutput) : void
      {
         output.writeShort(this.channels.length);
         for(var _i1:uint = 0; _i1 < this.channels.length; _i1++)
         {
            output.writeByte(this.channels[_i1]);
         }
         output.writeShort(this.disallowed.length);
         for(var _i2:uint = 0; _i2 < this.disallowed.length; _i2++)
         {
            output.writeByte(this.disallowed[_i2]);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_EnabledChannelsMessage(input);
      }
      
      public function deserializeAs_EnabledChannelsMessage(input:IDataInput) : void
      {
         var _val1:uint = 0;
         var _val2:uint = 0;
         var _channelsLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _channelsLen; _i1++)
         {
            _val1 = input.readByte();
            if(_val1 < 0)
            {
               throw new Error("Forbidden value (" + _val1 + ") on elements of channels.");
            }
            this.channels.push(_val1);
         }
         var _disallowedLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _disallowedLen; _i2++)
         {
            _val2 = input.readByte();
            if(_val2 < 0)
            {
               throw new Error("Forbidden value (" + _val2 + ") on elements of disallowed.");
            }
            this.disallowed.push(_val2);
         }
      }
   }
}
