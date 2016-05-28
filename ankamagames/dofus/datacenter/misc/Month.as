package com.ankamagames.dofus.datacenter.misc
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class Month
   {
      
      private static const MODULE:String = "Months";
      
      private static var _log:Logger = Log.getLogger(getQualifiedClassName(Month));
       
      public var id:int;
      
      public var nameId:uint;
      
      public function Month()
      {
         super();
      }
      
      public static function getMonthById(id:int) : Month
      {
         return GameData.getObject(MODULE,id) as Month;
      }
      
      public static function create(id:int, nameId:uint) : Month
      {
         var o:Month = new Month();
         o.id = id;
         o.nameId = nameId;
         return o;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
