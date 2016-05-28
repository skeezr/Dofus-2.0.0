package com.ankamagames.dofus.network.messages.game.context.roleplay.npc
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class TaxCollectorDialogQuestionBasicMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5619;
       
      private var _isInitialized:Boolean = false;
      
      public var guildName:String = "";
      
      public function TaxCollectorDialogQuestionBasicMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5619;
      }
      
      public function initTaxCollectorDialogQuestionBasicMessage(guildName:String = "") : TaxCollectorDialogQuestionBasicMessage
      {
         this.guildName = guildName;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.guildName = "";
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
         this.serializeAs_TaxCollectorDialogQuestionBasicMessage(output);
      }
      
      public function serializeAs_TaxCollectorDialogQuestionBasicMessage(output:IDataOutput) : void
      {
         output.writeUTF(this.guildName);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_TaxCollectorDialogQuestionBasicMessage(input);
      }
      
      public function deserializeAs_TaxCollectorDialogQuestionBasicMessage(input:IDataInput) : void
      {
         this.guildName = input.readUTF();
      }
   }
}
