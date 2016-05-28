package com.ankamagames.dofus.network.messages.game.context.roleplay.npc
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class NpcGenericActionRequestMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5898;
       
      private var _isInitialized:Boolean = false;
      
      public var npcId:int = 0;
      
      public var npcActionId:uint = 0;
      
      public function NpcGenericActionRequestMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5898;
      }
      
      public function initNpcGenericActionRequestMessage(npcId:int = 0, npcActionId:uint = 0) : NpcGenericActionRequestMessage
      {
         this.npcId = npcId;
         this.npcActionId = npcActionId;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.npcId = 0;
         this.npcActionId = 0;
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
         this.serializeAs_NpcGenericActionRequestMessage(output);
      }
      
      public function serializeAs_NpcGenericActionRequestMessage(output:IDataOutput) : void
      {
         output.writeInt(this.npcId);
         if(this.npcActionId < 0)
         {
            throw new Error("Forbidden value (" + this.npcActionId + ") on element npcActionId.");
         }
         output.writeByte(this.npcActionId);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_NpcGenericActionRequestMessage(input);
      }
      
      public function deserializeAs_NpcGenericActionRequestMessage(input:IDataInput) : void
      {
         this.npcId = input.readInt();
         this.npcActionId = input.readByte();
         if(this.npcActionId < 0)
         {
            throw new Error("Forbidden value (" + this.npcActionId + ") on element of NpcGenericActionRequestMessage.npcActionId.");
         }
      }
   }
}
