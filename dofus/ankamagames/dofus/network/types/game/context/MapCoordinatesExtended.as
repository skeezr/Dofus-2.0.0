package com.ankamagames.dofus.network.types.game.context
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class MapCoordinatesExtended extends MapCoordinates implements INetworkType
   {
      
      public static const protocolId:uint = 176;
       
      public var mapId:uint = 0;
      
      public function MapCoordinatesExtended()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 176;
      }
      
      public function initMapCoordinatesExtended(worldX:int = 0, worldY:int = 0, mapId:uint = 0) : MapCoordinatesExtended
      {
         super.initMapCoordinates(worldX,worldY);
         this.mapId = mapId;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.mapId = 0;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_MapCoordinatesExtended(output);
      }
      
      public function serializeAs_MapCoordinatesExtended(output:IDataOutput) : void
      {
         super.serializeAs_MapCoordinates(output);
         if(this.mapId < 0)
         {
            throw new Error("Forbidden value (" + this.mapId + ") on element mapId.");
         }
         output.writeInt(this.mapId);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_MapCoordinatesExtended(input);
      }
      
      public function deserializeAs_MapCoordinatesExtended(input:IDataInput) : void
      {
         super.deserialize(input);
         this.mapId = input.readInt();
         if(this.mapId < 0)
         {
            throw new Error("Forbidden value (" + this.mapId + ") on element of MapCoordinatesExtended.mapId.");
         }
      }
   }
}
