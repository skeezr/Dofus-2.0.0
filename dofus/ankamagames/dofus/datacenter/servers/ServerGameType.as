package com.ankamagames.dofus.datacenter.servers
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class ServerGameType
   {
      
      private static const MODULE:String = "ServerGameTypes";
      
      private static var _log:Logger = Log.getLogger(getQualifiedClassName(ServerGameType));
       
      public var id:int;
      
      public var nameId:uint;
      
      public function ServerGameType()
      {
         super();
      }
      
      public static function getServerGameTypeById(id:int) : ServerGameType
      {
         return GameData.getObject(MODULE,id) as ServerGameType;
      }
      
      public static function create(id:int, nameId:uint) : ServerGameType
      {
         var o:ServerGameType = new ServerGameType();
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
