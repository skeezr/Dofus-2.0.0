package com.ankamagames.jerakine.data
{
   public class GameData extends AbstractDataManager
   {
      
      private static var _self:com.ankamagames.jerakine.data.GameData;
       
      public function GameData()
      {
         super();
      }
      
      public static function init() : void
      {
         if(_self)
         {
            return;
         }
         _self = new com.ankamagames.jerakine.data.GameData();
         _self.init(10,1000);
         if(DataUpdateManager.SQL_MODE)
         {
            SQLiteHandler.getInstance().createGameData();
         }
      }
      
      public static function getObject(moduleId:String, keyId:uint) : Object
      {
         if(!_self)
         {
            return null;
         }
         if(DataUpdateManager.SQL_MODE)
         {
            return SQLiteHandler.getInstance().getObject(moduleId,keyId);
         }
         _self._soPrefix = moduleId;
         return _self.getObject(keyId);
      }
      
      public static function getObjects(moduleId:String) : Array
      {
         if(!_self)
         {
            return null;
         }
         if(DataUpdateManager.SQL_MODE)
         {
            return SQLiteHandler.getInstance().getObjects(moduleId);
         }
         _self._soPrefix = moduleId;
         return _self.getObjects();
      }
   }
}
