package com.ankamagames.dofus.network.messages.game.context.roleplay.npc
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class TaxCollectorDialogQuestionExtendedMessage extends TaxCollectorDialogQuestionBasicMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5615;
       
      private var _isInitialized:Boolean = false;
      
      public var pods:uint = 0;
      
      public var prospecting:uint = 0;
      
      public var wisdom:uint = 0;
      
      public var taxCollectorsCount:uint = 0;
      
      public function TaxCollectorDialogQuestionExtendedMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return Boolean(super.isInitialized) && Boolean(this._isInitialized);
      }
      
      override public function getMessageId() : uint
      {
         return 5615;
      }
      
      public function initTaxCollectorDialogQuestionExtendedMessage(guildName:String = "", pods:uint = 0, prospecting:uint = 0, wisdom:uint = 0, taxCollectorsCount:uint = 0) : TaxCollectorDialogQuestionExtendedMessage
      {
         super.initTaxCollectorDialogQuestionBasicMessage(guildName);
         this.pods = pods;
         this.prospecting = prospecting;
         this.wisdom = wisdom;
         this.taxCollectorsCount = taxCollectorsCount;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.pods = 0;
         this.prospecting = 0;
         this.wisdom = 0;
         this.taxCollectorsCount = 0;
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
         this.serializeAs_TaxCollectorDialogQuestionExtendedMessage(output);
      }
      
      public function serializeAs_TaxCollectorDialogQuestionExtendedMessage(output:IDataOutput) : void
      {
         super.serializeAs_TaxCollectorDialogQuestionBasicMessage(output);
         if(this.pods < 0)
         {
            throw new Error("Forbidden value (" + this.pods + ") on element pods.");
         }
         output.writeShort(this.pods);
         if(this.prospecting < 0)
         {
            throw new Error("Forbidden value (" + this.prospecting + ") on element prospecting.");
         }
         output.writeShort(this.prospecting);
         if(this.wisdom < 0)
         {
            throw new Error("Forbidden value (" + this.wisdom + ") on element wisdom.");
         }
         output.writeShort(this.wisdom);
         if(this.taxCollectorsCount < 0)
         {
            throw new Error("Forbidden value (" + this.taxCollectorsCount + ") on element taxCollectorsCount.");
         }
         output.writeByte(this.taxCollectorsCount);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_TaxCollectorDialogQuestionExtendedMessage(input);
      }
      
      public function deserializeAs_TaxCollectorDialogQuestionExtendedMessage(input:IDataInput) : void
      {
         super.deserialize(input);
         this.pods = input.readShort();
         if(this.pods < 0)
         {
            throw new Error("Forbidden value (" + this.pods + ") on element of TaxCollectorDialogQuestionExtendedMessage.pods.");
         }
         this.prospecting = input.readShort();
         if(this.prospecting < 0)
         {
            throw new Error("Forbidden value (" + this.prospecting + ") on element of TaxCollectorDialogQuestionExtendedMessage.prospecting.");
         }
         this.wisdom = input.readShort();
         if(this.wisdom < 0)
         {
            throw new Error("Forbidden value (" + this.wisdom + ") on element of TaxCollectorDialogQuestionExtendedMessage.wisdom.");
         }
         this.taxCollectorsCount = input.readByte();
         if(this.taxCollectorsCount < 0)
         {
            throw new Error("Forbidden value (" + this.taxCollectorsCount + ") on element of TaxCollectorDialogQuestionExtendedMessage.taxCollectorsCount.");
         }
      }
   }
}
