package com.ankamagames.dofus.network.messages.game.pvp
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class AlignmentSubAreasListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6059;
       
      private var _isInitialized:Boolean = false;
      
      public var angelsSubAreas:Vector.<int>;
      
      public var evilsSubAreas:Vector.<int>;
      
      public function AlignmentSubAreasListMessage()
      {
         this.angelsSubAreas = new Vector.<int>();
         this.evilsSubAreas = new Vector.<int>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6059;
      }
      
      public function initAlignmentSubAreasListMessage(angelsSubAreas:Vector.<int> = null, evilsSubAreas:Vector.<int> = null) : AlignmentSubAreasListMessage
      {
         this.angelsSubAreas = angelsSubAreas;
         this.evilsSubAreas = evilsSubAreas;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.angelsSubAreas = new Vector.<int>();
         this.evilsSubAreas = new Vector.<int>();
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
         this.serializeAs_AlignmentSubAreasListMessage(output);
      }
      
      public function serializeAs_AlignmentSubAreasListMessage(output:IDataOutput) : void
      {
         output.writeShort(this.angelsSubAreas.length);
         for(var _i1:uint = 0; _i1 < this.angelsSubAreas.length; _i1++)
         {
            output.writeShort(this.angelsSubAreas[_i1]);
         }
         output.writeShort(this.evilsSubAreas.length);
         for(var _i2:uint = 0; _i2 < this.evilsSubAreas.length; _i2++)
         {
            output.writeShort(this.evilsSubAreas[_i2]);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_AlignmentSubAreasListMessage(input);
      }
      
      public function deserializeAs_AlignmentSubAreasListMessage(input:IDataInput) : void
      {
         var _val1:int = 0;
         var _val2:int = 0;
         var _angelsSubAreasLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _angelsSubAreasLen; _i1++)
         {
            _val1 = input.readShort();
            this.angelsSubAreas.push(_val1);
         }
         var _evilsSubAreasLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _evilsSubAreasLen; _i2++)
         {
            _val2 = input.readShort();
            this.evilsSubAreas.push(_val2);
         }
      }
   }
}
