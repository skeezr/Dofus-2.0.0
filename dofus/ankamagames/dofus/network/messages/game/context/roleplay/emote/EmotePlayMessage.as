package com.ankamagames.dofus.network.messages.game.context.roleplay.emote
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class EmotePlayMessage extends EmotePlayAbstractMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5683;
       
      private var _isInitialized:Boolean = false;
      
      public var actorId:int = 0;
      
      public function EmotePlayMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return Boolean(super.isInitialized) && Boolean(this._isInitialized);
      }
      
      override public function getMessageId() : uint
      {
         return 5683;
      }
      
      public function initEmotePlayMessage(emoteId:uint = 0, duration:uint = 0, actorId:int = 0) : EmotePlayMessage
      {
         super.initEmotePlayAbstractMessage(emoteId,duration);
         this.actorId = actorId;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.actorId = 0;
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
         this.serializeAs_EmotePlayMessage(output);
      }
      
      public function serializeAs_EmotePlayMessage(output:IDataOutput) : void
      {
         super.serializeAs_EmotePlayAbstractMessage(output);
         output.writeInt(this.actorId);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_EmotePlayMessage(input);
      }
      
      public function deserializeAs_EmotePlayMessage(input:IDataInput) : void
      {
         super.deserialize(input);
         this.actorId = input.readInt();
      }
   }
}
