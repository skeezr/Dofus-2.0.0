package com.ankamagames.dofus.datacenter.world
{
   import flash.geom.Rectangle;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   
   public class Area
   {
      
      private static const MODULE:String = "Areas";
       
      public var id:int;
      
      public var nameId:uint;
      
      public var superAreaId:int;
      
      public var bounds:Rectangle;
      
      public function Area()
      {
         super();
      }
      
      public static function create(id:int, nameId:uint, superAreaId:int, bounds:Rectangle) : Area
      {
         var o:Area = new Area();
         o.id = id;
         o.nameId = nameId;
         o.superAreaId = superAreaId;
         o.bounds = bounds;
         return o;
      }
      
      public static function getAreaById(id:int) : Area
      {
         return GameData.getObject(MODULE,id) as Area;
      }
      
      public static function getAllArea() : Array
      {
         return GameData.getObjects(MODULE) as Array;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
      
      public function get superArea() : SuperArea
      {
         return SuperArea.getSuperAreaById(this.superAreaId);
      }
   }
}
