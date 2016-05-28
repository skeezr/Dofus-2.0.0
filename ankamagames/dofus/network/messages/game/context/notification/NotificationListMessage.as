package com.ankamagames.dofus.network.messages.game.context.notification
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class NotificationListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6087;
       
      private var _isInitialized:Boolean = false;
      
      public var flags:Vector.<int>;
      
      public function NotificationListMessage()
      {
         this.flags = new Vector.<int>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6087;
      }
      
      public function initNotificationListMessage(flags:Vector.<int> = null) : NotificationListMessage
      {
         this.flags = flags;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.flags = new Vector.<int>();
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
         this.serializeAs_NotificationListMessage(output);
      }
      
      public function serializeAs_NotificationListMessage(output:IDataOutput) : void
      {
         output.writeShort(this.flags.length);
         for(var _i1:uint = 0; _i1 < this.flags.length; _i1++)
         {
            output.writeInt(this.flags[_i1]);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_NotificationListMessage(input);
      }
      
      public function deserializeAs_NotificationListMessage(input:IDataInput) : void
      {
         var _val1:int = 0;
         var _flagsLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _flagsLen; _i1++)
         {
            _val1 = input.readInt();
            this.flags.push(_val1);
         }
      }
   }
}
