package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.context.MapCoordinatesExtended;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class AtlasPointsInformations implements INetworkType
   {
      
      public static const protocolId:uint = 175;
       
      public var type:uint = 0;
      
      public var coords:Vector.<MapCoordinatesExtended>;
      
      public function AtlasPointsInformations()
      {
         this.coords = new Vector.<MapCoordinatesExtended>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 175;
      }
      
      public function initAtlasPointsInformations(type:uint = 0, coords:Vector.<MapCoordinatesExtended> = null) : AtlasPointsInformations
      {
         this.type = type;
         this.coords = coords;
         return this;
      }
      
      public function reset() : void
      {
         this.type = 0;
         this.coords = new Vector.<MapCoordinatesExtended>();
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_AtlasPointsInformations(output);
      }
      
      public function serializeAs_AtlasPointsInformations(output:IDataOutput) : void
      {
         output.writeByte(this.type);
         output.writeShort(this.coords.length);
         for(var _i2:uint = 0; _i2 < this.coords.length; _i2++)
         {
            (this.coords[_i2] as MapCoordinatesExtended).serializeAs_MapCoordinatesExtended(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_AtlasPointsInformations(input);
      }
      
      public function deserializeAs_AtlasPointsInformations(input:IDataInput) : void
      {
         var _item2:MapCoordinatesExtended = null;
         this.type = input.readByte();
         if(this.type < 0)
         {
            throw new Error("Forbidden value (" + this.type + ") on element of AtlasPointsInformations.type.");
         }
         var _coordsLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _coordsLen; _i2++)
         {
            _item2 = new MapCoordinatesExtended();
            _item2.deserialize(input);
            this.coords.push(_item2);
         }
      }
   }
}
