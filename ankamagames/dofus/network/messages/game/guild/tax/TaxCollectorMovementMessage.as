package com.ankamagames.dofus.network.messages.game.guild.tax
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.guild.tax.TaxCollectorBasicInformations;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class TaxCollectorMovementMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5633;
       
      private var _isInitialized:Boolean = false;
      
      public var hireOrFire:Boolean = false;
      
      public var basicInfos:TaxCollectorBasicInformations;
      
      public var playerName:String = "";
      
      public function TaxCollectorMovementMessage()
      {
         this.basicInfos = new TaxCollectorBasicInformations();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5633;
      }
      
      public function initTaxCollectorMovementMessage(hireOrFire:Boolean = false, basicInfos:TaxCollectorBasicInformations = null, playerName:String = "") : TaxCollectorMovementMessage
      {
         this.hireOrFire = hireOrFire;
         this.basicInfos = basicInfos;
         this.playerName = playerName;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.hireOrFire = false;
         this.basicInfos = new TaxCollectorBasicInformations();
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
         this.serializeAs_TaxCollectorMovementMessage(output);
      }
      
      public function serializeAs_TaxCollectorMovementMessage(output:IDataOutput) : void
      {
         output.writeBoolean(this.hireOrFire);
         this.basicInfos.serializeAs_TaxCollectorBasicInformations(output);
         output.writeUTF(this.playerName);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_TaxCollectorMovementMessage(input);
      }
      
      public function deserializeAs_TaxCollectorMovementMessage(input:IDataInput) : void
      {
         this.hireOrFire = input.readBoolean();
         this.basicInfos = new TaxCollectorBasicInformations();
         this.basicInfos.deserialize(input);
         this.playerName = input.readUTF();
      }
   }
}
