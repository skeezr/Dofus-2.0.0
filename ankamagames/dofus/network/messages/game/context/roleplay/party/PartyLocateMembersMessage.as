package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class PartyLocateMembersMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5595;
       
      private var _isInitialized:Boolean = false;
      
      public var geopositions:Vector.<uint>;
      
      public function PartyLocateMembersMessage()
      {
         this.geopositions = new Vector.<uint>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5595;
      }
      
      public function initPartyLocateMembersMessage(geopositions:Vector.<uint> = null) : PartyLocateMembersMessage
      {
         this.geopositions = geopositions;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.geopositions = new Vector.<uint>();
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
         this.serializeAs_PartyLocateMembersMessage(output);
      }
      
      public function serializeAs_PartyLocateMembersMessage(output:IDataOutput) : void
      {
         output.writeShort(this.geopositions.length);
         for(var _i1:uint = 0; _i1 < this.geopositions.length; _i1++)
         {
            if(this.geopositions[_i1] < 0)
            {
               throw new Error("Forbidden value (" + this.geopositions[_i1] + ") on element 1 (starting at 1) of geopositions.");
            }
            output.writeInt(this.geopositions[_i1]);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_PartyLocateMembersMessage(input);
      }
      
      public function deserializeAs_PartyLocateMembersMessage(input:IDataInput) : void
      {
         var _val1:uint = 0;
         var _geopositionsLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _geopositionsLen; _i1++)
         {
            _val1 = input.readInt();
            if(_val1 < 0)
            {
               throw new Error("Forbidden value (" + _val1 + ") on elements of geopositions.");
            }
            this.geopositions.push(_val1);
         }
      }
   }
}
