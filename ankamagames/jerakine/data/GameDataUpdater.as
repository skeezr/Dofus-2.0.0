package com.ankamagames.jerakine.data
{
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.types.DataStoreType;
   import com.ankamagames.jerakine.utils.files.FileUtils;
   import com.ankamagames.jerakine.types.enums.DataStoreEnum;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.JerakineConstants;
   import com.ankamagames.jerakine.types.events.LangFileEvent;
   import flash.utils.describeType;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class GameDataUpdater extends DataUpdateManager
   {
      
      private static var _self:com.ankamagames.jerakine.data.GameDataUpdater;
       
      public function GameDataUpdater()
      {
         super();
         if(_self)
         {
            throw new SingletonError();
         }
      }
      
      public static function getInstance() : com.ankamagames.jerakine.data.GameDataUpdater
      {
         if(!_self)
         {
            _self = new com.ankamagames.jerakine.data.GameDataUpdater();
         }
         return _self;
      }
      
      override protected function processFileData(container:Object, uri:Uri) : void
      {
         var storeKey:DataStoreType = null;
         var SQLiteHandlerInstance:SQLiteHandler = null;
         var createTable:Boolean = false;
         var n:int = 0;
         var i:int = 0;
         var object:Object = null;
         try
         {
            container.create();
         }
         catch(e:Error)
         {
            _log.fatal("Error while filling a data container :");
            if(e.getStackTrace())
            {
               _log.fatal(e.getStackTrace());
            }
            else
            {
               _log.fatal("no stack trace available");
            }
            return;
         }
         var aContent:Array = container.container;
         storeKey = new DataStoreType(FileUtils.getFileStartName(uri.fileName),true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_COMPUTER);
         StoreDataManager.getInstance().setData(storeKey,"data",aContent,true);
         StoreDataManager.getInstance().close(storeKey);
         _versions[uri.tag.file] = uri.tag.version;
         StoreDataManager.getInstance().setData(JerakineConstants.DATASTORE_FILES_INFO,_storeKey,_versions,true);
         dispatchEvent(new LangFileEvent(LangFileEvent.COMPLETE,false,false,uri.tag.file));
         if(SQL_MODE)
         {
            SQLiteHandlerInstance = SQLiteHandler.getInstance();
            createTable = true;
            n = aContent.length;
            for(i = 0; i < n; i++)
            {
               object = aContent[i];
               if(object)
               {
                  if(createTable)
                  {
                     createTable = false;
                     SQLiteHandlerInstance.createGameDataTable(container.moduleName,describeType(object));
                  }
                  SQLiteHandlerInstance.addGameDataObject(container.moduleName,object);
               }
            }
         }
      }
   }
}
