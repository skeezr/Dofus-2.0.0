package com.ankamagames.jerakine.data
{
   import com.ankamagames.jerakine.types.DataStoreType;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.JerakineConstants;
   import com.ankamagames.jerakine.types.enums.DataStoreEnum;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.utils.files.FileUtils;
   import com.ankamagames.jerakine.types.events.LangFileEvent;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class I18nUpdater extends DataUpdateManager
   {
      
      private static var _self:com.ankamagames.jerakine.data.I18nUpdater;
       
      private var _storeFile:Array;
      
      public function I18nUpdater()
      {
         super();
         if(_self)
         {
            throw new SingletonError();
         }
      }
      
      public static function getInstance() : com.ankamagames.jerakine.data.I18nUpdater
      {
         if(!_self)
         {
            _self = new com.ankamagames.jerakine.data.I18nUpdater();
         }
         return _self;
      }
      
      override public function clear() : void
      {
         var file:String = null;
         var dst:DataStoreType = null;
         this._storeFile = StoreDataManager.getInstance().getSetData(JerakineConstants.DATASTORE_FILES_INFO,_storeKey + "I18nUpdater_fileList",[]);
         for each(file in this._storeFile)
         {
            dst = new DataStoreType(file,true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_COMPUTER);
            StoreDataManager.getInstance().clear(dst);
         }
         this._storeFile = [];
         StoreDataManager.getInstance().setData(JerakineConstants.DATASTORE_FILES_INFO,_storeKey + "I18nUpdater_fileList",[]);
      }
      
      override protected function processFileData(container:Object, uri:Uri) : void
      {
         var storeKey:DataStoreType = null;
         var n:int = 0;
         var i:int = 0;
         var s:String = null;
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
         StoreDataManager.getInstance().setData(storeKey,"data",aContent);
         StoreDataManager.getInstance().close(storeKey);
         this._storeFile = StoreDataManager.getInstance().getSetData(JerakineConstants.DATASTORE_FILES_INFO,_storeKey + "I18nUpdater_fileList",[]);
         this._storeFile.push(FileUtils.getFileStartName(uri.fileName));
         StoreDataManager.getInstance().setData(JerakineConstants.DATASTORE_FILES_INFO,_storeKey + "I18nUpdater_fileList",this._storeFile);
         _versions[uri.tag.file] = uri.tag.version;
         StoreDataManager.getInstance().setData(JerakineConstants.DATASTORE_FILES_INFO,_storeKey,_versions);
         dispatchEvent(new LangFileEvent(LangFileEvent.COMPLETE,false,false,uri.tag.file));
         if(SQL_MODE)
         {
            SQLiteHandler.getInstance().initI18n();
            n = aContent.length;
            for(i = 0; i < n; i++)
            {
               s = aContent[i];
               if(s)
               {
                  SQLiteHandler.getInstance().executeSyncQuery("INSERT INTO i18n VALUES (?, ?)",-1,new Array(i,s));
               }
            }
         }
      }
   }
}
