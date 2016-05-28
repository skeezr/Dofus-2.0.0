package com.ankamagames.dofus.network.messages.game.actions.fight
{
   import com.ankamagames.dofus.network.messages.game.actions.AbstractGameActionMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.actions.fight.GameActionMarkedCell;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GameActionFightMarkCellsMessage extends AbstractGameActionMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5540;
       
      private var _isInitialized:Boolean = false;
      
      public var markId:int = 0;
      
      public var markType:int = 0;
      
      public var cells:Vector.<GameActionMarkedCell>;
      
      public function GameActionFightMarkCellsMessage()
      {
         this.cells = new Vector.<GameActionMarkedCell>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return Boolean(super.isInitialized) && Boolean(this._isInitialized);
      }
      
      override public function getMessageId() : uint
      {
         return 5540;
      }
      
      public function initGameActionFightMarkCellsMessage(actionId:uint = 0, sourceId:int = 0, markId:int = 0, markType:int = 0, cells:Vector.<GameActionMarkedCell> = null) : GameActionFightMarkCellsMessage
      {
         super.initAbstractGameActionMessage(actionId,sourceId);
         this.markId = markId;
         this.markType = markType;
         this.cells = cells;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.markId = 0;
         this.markType = 0;
         this.cells = new Vector.<GameActionMarkedCell>();
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
         this.serializeAs_GameActionFightMarkCellsMessage(output);
      }
      
      public function serializeAs_GameActionFightMarkCellsMessage(output:IDataOutput) : void
      {
         super.serializeAs_AbstractGameActionMessage(output);
         output.writeShort(this.markId);
         output.writeByte(this.markType);
         output.writeShort(this.cells.length);
         for(var _i3:uint = 0; _i3 < this.cells.length; _i3++)
         {
            (this.cells[_i3] as GameActionMarkedCell).serializeAs_GameActionMarkedCell(output);
         }
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameActionFightMarkCellsMessage(input);
      }
      
      public function deserializeAs_GameActionFightMarkCellsMessage(input:IDataInput) : void
      {
         var _item3:GameActionMarkedCell = null;
         super.deserialize(input);
         this.markId = input.readShort();
         this.markType = input.readByte();
         var _cellsLen:uint = input.readUnsignedShort();
         for(var _i3:uint = 0; _i3 < _cellsLen; _i3++)
         {
            _item3 = new GameActionMarkedCell();
            _item3.deserialize(input);
            this.cells.push(_item3);
         }
      }
   }
}
