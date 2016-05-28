package com.ankamagames.dofus.datacenter.houses
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class House
   {
      
      private static const MODULE:String = "Houses";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(House));
       
      public var typeId:int;
      
      public var defaultPrice:uint;
      
      public var nameId:int;
      
      public var descriptionId:int;
      
      public var gfxId:int;
      
      public function House()
      {
         super();
      }
      
      public static function getGuildHouseById(id:int) : House
      {
         return GameData.getObject(MODULE,id) as House;
      }
      
      public static function create(pId:int, pDefaultPrice:uint, pName:int, pDescription:int, pGfxId:int) : House
      {
         var o:House = new House();
         o.typeId = pId;
         o.defaultPrice = pDefaultPrice;
         o.nameId = pName;
         o.descriptionId = pDescription;
         o.gfxId = pGfxId;
         return o;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
      
      public function get description() : String
      {
         return I18n.getText(this.descriptionId);
      }
   }
}
