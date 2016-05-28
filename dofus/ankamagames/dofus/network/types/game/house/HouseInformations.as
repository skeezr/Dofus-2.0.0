package com.ankamagames.dofus.network.types.game.house
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class HouseInformations implements INetworkType
   {
      
      public static const protocolId:uint = 111;
       
      public var houseId:uint = 0;
      
      public var doorsOnMap:Vector.<uint>;
      
      public var ownerName:String = "";
      
      public var isOnSale:Boolean = false;
      
      public var modelId:uint = 0;
      
      public function HouseInformations()
      {
         this.doorsOnMap = new Vector.<uint>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 111;
      }
      
      public function initHouseInformations(houseId:uint = 0, doorsOnMap:Vector.<uint> = null, ownerName:String = "", isOnSale:Boolean = false, modelId:uint = 0) : HouseInformations
      {
         this.houseId = houseId;
         this.doorsOnMap = doorsOnMap;
         this.ownerName = ownerName;
         this.isOnSale = isOnSale;
         this.modelId = modelId;
         return this;
      }
      
      public function reset() : void
      {
         this.houseId = 0;
         this.doorsOnMap = new Vector.<uint>();
         this.ownerName = "";
         this.isOnSale = false;
         this.modelId = 0;
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_HouseInformations(output);
      }
      
      public function serializeAs_HouseInformations(output:IDataOutput) : void
      {
         if(this.houseId < 0)
         {
            throw new Error("Forbidden value (" + this.houseId + ") on element houseId.");
         }
         output.writeInt(this.houseId);
         output.writeShort(this.doorsOnMap.length);
         for(var _i2:uint = 0; _i2 < this.doorsOnMap.length; _i2++)
         {
            if(this.doorsOnMap[_i2] < 0)
            {
               throw new Error("Forbidden value (" + this.doorsOnMap[_i2] + ") on element 2 (starting at 1) of doorsOnMap.");
            }
            output.writeInt(this.doorsOnMap[_i2]);
         }
         output.writeUTF(this.ownerName);
         output.writeBoolean(this.isOnSale);
         if(this.modelId < 0)
         {
            throw new Error("Forbidden value (" + this.modelId + ") on element modelId.");
         }
         output.writeShort(this.modelId);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_HouseInformations(input);
      }
      
      public function deserializeAs_HouseInformations(input:IDataInput) : void
      {
         var _val2:uint = 0;
         this.houseId = input.readInt();
         if(this.houseId < 0)
         {
            throw new Error("Forbidden value (" + this.houseId + ") on element of HouseInformations.houseId.");
         }
         var _doorsOnMapLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _doorsOnMapLen; _i2++)
         {
            _val2 = input.readInt();
            if(_val2 < 0)
            {
               throw new Error("Forbidden value (" + _val2 + ") on elements of doorsOnMap.");
            }
            this.doorsOnMap.push(_val2);
         }
         this.ownerName = input.readUTF();
         this.isOnSale = input.readBoolean();
         this.modelId = input.readShort();
         if(this.modelId < 0)
         {
            throw new Error("Forbidden value (" + this.modelId + ") on element of HouseInformations.modelId.");
         }
      }
   }
}
