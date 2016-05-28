package com.ankamagames.dofus.network.messages.game.context.roleplay.spell
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class SpellMoveMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5567;
       
      private var _isInitialized:Boolean = false;
      
      public var spellId:uint = 0;
      
      public var position:uint = 0;
      
      public function SpellMoveMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5567;
      }
      
      public function initSpellMoveMessage(spellId:uint = 0, position:uint = 0) : SpellMoveMessage
      {
         this.spellId = spellId;
         this.position = position;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.spellId = 0;
         this.position = 0;
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
         this.serializeAs_SpellMoveMessage(output);
      }
      
      public function serializeAs_SpellMoveMessage(output:IDataOutput) : void
      {
         if(this.spellId < 0)
         {
            throw new Error("Forbidden value (" + this.spellId + ") on element spellId.");
         }
         output.writeShort(this.spellId);
         if(this.position < 63 || this.position > 255)
         {
            throw new Error("Forbidden value (" + this.position + ") on element position.");
         }
         output.writeByte(this.position);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_SpellMoveMessage(input);
      }
      
      public function deserializeAs_SpellMoveMessage(input:IDataInput) : void
      {
         this.spellId = input.readShort();
         if(this.spellId < 0)
         {
            throw new Error("Forbidden value (" + this.spellId + ") on element of SpellMoveMessage.spellId.");
         }
         this.position = input.readUnsignedByte();
         if(this.position < 63 || this.position > 255)
         {
            throw new Error("Forbidden value (" + this.position + ") on element of SpellMoveMessage.position.");
         }
      }
   }
}
