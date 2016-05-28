package com.ankamagames.dofus.network.messages.game.context.roleplay.emote
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class EmotePlayMassiveMessage extends EmotePlayAbstractMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5691;
       
      private var _isInitialized:Boolean = false;
      
      public var actorIds:Vector.<int>;
      
      public function EmotePlayMassiveMessage()
      {
         this.actorIds = new Vector.<int>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return Boolean(super.isInitialized) && Boolean(this._isInitialized);
      }
      
      override public function getMessageId() : uint
      {
         return 5691;
      }
      
      public function initEmotePlayMassiveMessage(emoteId:uint = 0, duration:uint = 0, actorIds:Vector.<int> = null) : EmotePlayMassiveMessage
      {
         super.initEmotePlayAbstractMessage(emoteId,duration);
         this.actorIds = actorIds;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.actorIds = new Vector.<int>();
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
         this.serializeAs_EmotePlayMassiveMessage(output);
      }
      
      public function serializeAs_EmotePlayMassiveMessage(output:IDataOutput) : void
      {
         super.serializeAs_EmotePlayAbstractMessage(output);
         output.writeShort(this.actorIds.length);
         for(var _i1:uint = 0; _i1 < this.actorIds.length; _i1++)
         {
            output.writeInt(this.actorIds[_i1]);
         }
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_EmotePlayMassiveMessage(input);
      }
      
      public function deserializeAs_EmotePlayMassiveMessage(input:IDataInput) : void
      {
         var _val1:int = 0;
         super.deserialize(input);
         var _actorIdsLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _actorIdsLen; _i1++)
         {
            _val1 = input.readInt();
            this.actorIds.push(_val1);
         }
      }
   }
}
