package com.ankamagames.dofus.datacenter.guild
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class RankName
   {
      
      private static const MODULE:String = "RankNames";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(RankName));
       
      public var id:int;
      
      public var nameId:uint;
      
      public var order:int;
      
      public function RankName()
      {
         super();
      }
      
      public static function getRankNameById(id:int) : RankName
      {
         return GameData.getObject(MODULE,id) as RankName;
      }
      
      public static function getRankNames() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(id:int, nameId:uint, order:int) : RankName
      {
         var o:RankName = new RankName();
         o.id = id;
         o.nameId = nameId;
         o.order = order;
         return o;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
