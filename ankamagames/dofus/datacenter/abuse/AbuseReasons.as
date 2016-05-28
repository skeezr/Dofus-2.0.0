package com.ankamagames.dofus.datacenter.abuse
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class AbuseReasons
   {
      
      private static const MODULE:String = "AbuseReasons";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AbuseReasons));
       
      public var _abuseReasonId:uint;
      
      public var _mask:uint;
      
      public var _reasonTextId:int;
      
      public function AbuseReasons()
      {
         super();
      }
      
      public static function getReasonNameById(id:uint) : AbuseReasons
      {
         return GameData.getObject(MODULE,id) as AbuseReasons;
      }
      
      public static function getReasonNames() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(abuseReasonId:uint, mask:uint, reasonTextId:int) : AbuseReasons
      {
         var o:AbuseReasons = new AbuseReasons();
         o._abuseReasonId = abuseReasonId;
         o._mask = mask;
         o._reasonTextId = reasonTextId;
         return o;
      }
      
      public function get name() : String
      {
         return I18n.getText(this._reasonTextId);
      }
   }
}
