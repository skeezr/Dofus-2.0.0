package com.ankamagames.dofus.datacenter.npcs
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class TaxCollectorName
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(TaxCollectorName));
      
      private static const MODULE:String = "TaxCollectorNames";
       
      public var id:int;
      
      public var nameId:uint;
      
      public function TaxCollectorName()
      {
         super();
      }
      
      public static function create(id:int, nameId:uint) : TaxCollectorName
      {
         var o:TaxCollectorName = new TaxCollectorName();
         o.id = id;
         o.nameId = nameId;
         return o;
      }
      
      public static function getTaxCollectorNameById(id:int) : TaxCollectorName
      {
         return GameData.getObject(MODULE,id) as TaxCollectorName;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
