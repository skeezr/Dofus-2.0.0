package com.ankamagames.dofus.internalDatacenter.house
{
   import com.ankamagames.dofus.network.types.game.house.HouseInformations;
   import com.ankamagames.dofus.datacenter.houses.House;
   
   public class HouseWrapper
   {
       
      public var houseId:int;
      
      public var name:String;
      
      public var description:String;
      
      public var ownerName:String;
      
      public var isOnSale:Boolean = false;
      
      public var gfxId:int;
      
      public var defaultPrice:uint;
      
      public function HouseWrapper()
      {
         super();
      }
      
      public static function create(houseInformations:HouseInformations) : HouseWrapper
      {
         var house:HouseWrapper = new HouseWrapper();
         var houseInfo:House = House.getGuildHouseById(houseInformations.modelId);
         house.houseId = houseInformations.houseId;
         house.name = houseInfo.name;
         house.description = houseInfo.description;
         house.ownerName = houseInformations.ownerName;
         house.isOnSale = houseInformations.isOnSale;
         house.gfxId = houseInfo.gfxId;
         house.defaultPrice = houseInfo.defaultPrice;
         return house;
      }
      
      public static function manualCreate(typeId:int, houseId:int, ownerName:String, isOnSale:Boolean) : HouseWrapper
      {
         var house:HouseWrapper = new HouseWrapper();
         var houseInfo:House = House.getGuildHouseById(typeId);
         house.houseId = houseId;
         house.name = houseInfo.name;
         house.description = houseInfo.description;
         house.ownerName = ownerName;
         house.isOnSale = isOnSale;
         house.gfxId = houseInfo.gfxId;
         house.defaultPrice = houseInfo.defaultPrice;
         return house;
      }
   }
}
