package com.ankamagames.dofus.network.messages.game.context
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.context.IdentifiedEntityDispositionInformations;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GameEntitiesDispositionMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5696;
       
      private var _isInitialized:Boolean = false;
      
      public var dispositions:Vector.<IdentifiedEntityDispositionInformations>;
      
      public function GameEntitiesDispositionMessage()
      {
         this.dispositions = new Vector.<IdentifiedEntityDispositionInformations>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5696;
      }
      
      public function initGameEntitiesDispositionMessage(dispositions:Vector.<IdentifiedEntityDispositionInformations> = null) : GameEntitiesDispositionMessage
      {
         this.dispositions = dispositions;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.dispositions = new Vector.<IdentifiedEntityDispositionInformations>();
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
         this.serializeAs_GameEntitiesDispositionMessage(output);
      }
      
      public function serializeAs_GameEntitiesDispositionMessage(output:IDataOutput) : void
      {
         output.writeShort(this.dispositions.length);
         for(var _i1:uint = 0; _i1 < this.dispositions.length; _i1++)
         {
            (this.dispositions[_i1] as IdentifiedEntityDispositionInformations).serializeAs_IdentifiedEntityDispositionInformations(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameEntitiesDispositionMessage(input);
      }
      
      public function deserializeAs_GameEntitiesDispositionMessage(input:IDataInput) : void
      {
         var _item1:IdentifiedEntityDispositionInformations = null;
         var _dispositionsLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _dispositionsLen; _i1++)
         {
            _item1 = new IdentifiedEntityDispositionInformations();
            _item1.deserialize(input);
            this.dispositions.push(_item1);
         }
      }
   }
}
