package com.ankamagames.dofus.datacenter.servers
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class ServerCommunity
   {
      
      private static const MODULE:String = "ServerCommunities";
      
      private static var _log:Logger = Log.getLogger(getQualifiedClassName(ServerCommunity));
       
      public var id:int;
      
      public var nameId:uint;
      
      public var defaultCountries:Vector.<String>;
      
      public function ServerCommunity()
      {
         super();
      }
      
      public static function getServerCommunityById(id:int) : ServerCommunity
      {
         return GameData.getObject(MODULE,id) as ServerCommunity;
      }
      
      public static function create(id:int, nameId:uint, defaultCountries:Vector.<String>) : ServerCommunity
      {
         var o:ServerCommunity = new ServerCommunity();
         o.id = id;
         o.nameId = nameId;
         o.defaultCountries = defaultCountries;
         return o;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
