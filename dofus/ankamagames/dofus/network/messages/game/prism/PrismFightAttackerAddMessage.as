package com.ankamagames.dofus.network.messages.game.prism
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalPlusLookAndGradeInformations;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PrismFightAttackerAddMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5893;
       
      private var _isInitialized:Boolean = false;
      
      public var fightId:Number = 0;
      
      public var charactersDescription:Vector.<CharacterMinimalPlusLookAndGradeInformations>;
      
      public function PrismFightAttackerAddMessage()
      {
         this.charactersDescription = new Vector.<CharacterMinimalPlusLookAndGradeInformations>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5893;
      }
      
      public function initPrismFightAttackerAddMessage(fightId:Number = 0, charactersDescription:Vector.<CharacterMinimalPlusLookAndGradeInformations> = null) : PrismFightAttackerAddMessage
      {
         this.fightId = fightId;
         this.charactersDescription = charactersDescription;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.fightId = 0;
         this.charactersDescription = new Vector.<CharacterMinimalPlusLookAndGradeInformations>();
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
         this.serializeAs_PrismFightAttackerAddMessage(output);
      }
      
      public function serializeAs_PrismFightAttackerAddMessage(output:IDataOutput) : void
      {
         output.writeDouble(this.fightId);
         output.writeShort(this.charactersDescription.length);
         for(var _i2:uint = 0; _i2 < this.charactersDescription.length; _i2++)
         {
            (this.charactersDescription[_i2] as CharacterMinimalPlusLookAndGradeInformations).serializeAs_CharacterMinimalPlusLookAndGradeInformations(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PrismFightAttackerAddMessage(input);
      }
      
      public function deserializeAs_PrismFightAttackerAddMessage(input:IDataInput) : void
      {
         var _item2:CharacterMinimalPlusLookAndGradeInformations = null;
         this.fightId = input.readDouble();
         var _charactersDescriptionLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _charactersDescriptionLen; _i2++)
         {
            _item2 = new CharacterMinimalPlusLookAndGradeInformations();
            _item2.deserialize(input);
            this.charactersDescription.push(_item2);
         }
      }
   }
}
