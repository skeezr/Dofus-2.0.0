package com.ankamagames.dofus.internalDatacenter.taxi
{
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.datacenter.world.Area;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   
   public class TeleportDestinationWrapper
   {
       
      public var teleporterType:uint;
      
      public var mapId:uint;
      
      public var subArea:SubArea;
      
      public var cost:uint;
      
      public var spawn:Boolean;
      
      public var name:String;
      
      public var coord:String;
      
      public function TeleportDestinationWrapper(teleporterType:uint, mapId:uint, subareaId:uint, cost:uint, spawn:Boolean = false)
      {
         super();
         this.teleporterType = teleporterType;
         this.mapId = mapId;
         this.subArea = SubArea.getSubAreaById(subareaId);
         this.cost = cost;
         this.spawn = spawn;
         this.name = Area.getAreaById(this.subArea.areaId).name + " ( " + this.subArea.name + " )";
         var p:Object = WorldPoint.fromMapId(mapId);
         this.coord = "" + p.x + ", " + p.y;
      }
   }
}
