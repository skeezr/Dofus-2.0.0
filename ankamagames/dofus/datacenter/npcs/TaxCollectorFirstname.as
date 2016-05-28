package com.ankamagames.dofus.datacenter.npcs
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class TaxCollectorFirstname
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(TaxCollectorFirstname));
      
      private static const MODULE:String = "TaxCollectorFirstnames";
       
      public var id:int;
      
      public var firstnameId:uint;
      
      public function TaxCollectorFirstname()
      {
         super();
      }
      
      public static function create(id:int, firstnameId:uint) : TaxCollectorFirstname
      {
         var o:TaxCollectorFirstname = new TaxCollectorFirstname();
         o.id = id;
         o.firstnameId = firstnameId;
         return o;
      }
      
      public static function getTaxCollectorFirstnameById(id:int) : TaxCollectorFirstname
      {
         return GameData.getObject(MODULE,id) as TaxCollectorFirstname;
      }
      
      public function get firstname() : String
      {
         return I18n.getText(this.firstnameId);
      }
   }
}
