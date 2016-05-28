package com.ankamagames.dofus.datacenter.servers
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class ServerPopulation
   {
      
      private static const MODULE:String = "ServerPopulations";
      
      private static var _log:Logger = Log.getLogger(getQualifiedClassName(ServerPopulation));
       
      public var id:int;
      
      public var nameId:uint;
      
      public var weight:int;
      
      public function ServerPopulation()
      {
         super();
      }
      
      public static function getServerPopulationById(id:int) : ServerPopulation
      {
         return GameData.getObject(MODULE,id) as ServerPopulation;
      }
      
      public static function create(id:int, nameId:uint, weight:int) : ServerPopulation
      {
         var o:ServerPopulation = new ServerPopulation();
         o.id = id;
         o.nameId = nameId;
         o.weight = weight;
         return o;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
