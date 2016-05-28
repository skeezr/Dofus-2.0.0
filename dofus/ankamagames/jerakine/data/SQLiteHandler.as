package com.ankamagames.jerakine.data
{
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.data.SQLConnection;
   import flash.data.SQLStatement;
   import flash.data.SQLResult;
   import flash.errors.SQLError;
   import flash.events.SQLErrorEvent;
   import flash.net.Responder;
   import flash.events.SQLEvent;
   import flash.filesystem.File;
   
   public class SQLiteHandler
   {
      
      private static var _self:com.ankamagames.jerakine.data.SQLiteHandler;
      
      private static var _asyncOpened:Boolean = false;
      
      private static var _syncOpened:Boolean = false;
      
      private static var _callBackFunctions:Array = new Array();
       
      private const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.jerakine.data.SQLiteHandler));
      
      private var _gameDataTemp:Object;
      
      private var _resetI18n:Boolean = true;
      
      public var _SQLiteConnectionAsync:SQLConnection;
      
      public var _SQLiteConnectionSync:SQLConnection;
      
      public function SQLiteHandler()
      {
         this._gameDataTemp = new Object();
         super();
         this.openConnection();
      }
      
      public static function getInstance() : com.ankamagames.jerakine.data.SQLiteHandler
      {
         if(_self)
         {
            return _self;
         }
         Log.getLogger(getQualifiedClassName(com.ankamagames.jerakine.data.SQLiteHandler)).error("Ce client n\'utilise pas de base de donnée locale.");
         return null;
      }
      
      public static function init(callBack:Function = null) : com.ankamagames.jerakine.data.SQLiteHandler
      {
         if(_self)
         {
            if(Boolean(_asyncOpened) && Boolean(_syncOpened))
            {
               callBack();
            }
            else
            {
               _callBackFunctions.push(callBack);
            }
         }
         else
         {
            if(callBack != null)
            {
               _callBackFunctions.push(callBack);
            }
            _self = new com.ankamagames.jerakine.data.SQLiteHandler();
         }
         return _self;
      }
      
      public function initI18n() : void
      {
         if(this._resetI18n)
         {
            this._resetI18n = false;
            this.executeSyncQuery("DROP TABLE IF EXISTS i18n");
         }
         this.executeSyncQuery("CREATE TABLE IF NOT EXISTS i18n (id INTEGER PRIMARY KEY, _i18n TEXT)");
      }
      
      public function beginAsyncTransaction() : void
      {
         if(this._SQLiteConnectionAsync.inTransaction)
         {
            this._log.error("Une transaction Asynchrone est déjà en cours");
         }
         else
         {
            this._log.debug("Démarrage d\'une transaction Asynchrone...");
            this._SQLiteConnectionAsync.begin();
         }
      }
      
      public function commitAsyncTransaction() : void
      {
         if(this._SQLiteConnectionAsync.inTransaction)
         {
            this._SQLiteConnectionAsync.commit();
            this._log.debug("Transaction Asynchrone commité !");
         }
         else
         {
            this._log.error("Pas de transaction Asynchrone en cours :/");
         }
      }
      
      public function beginSyncTransaction() : void
      {
         if(this._SQLiteConnectionSync.inTransaction)
         {
            this._log.error("Une transaction Synchrone est déjà en cours");
         }
         else
         {
            this._log.debug("Démarrage d\'une transaction Synchrone...");
            this._SQLiteConnectionSync.begin();
         }
      }
      
      public function commitSyncTransaction() : void
      {
         if(this._SQLiteConnectionSync.inTransaction)
         {
            this._SQLiteConnectionSync.commit();
            this._log.debug("Transaction Synchrone commité !");
         }
         else
         {
            this._log.error("Pas de transaction Synchrone en cours :/");
         }
      }
      
      public function getObject(moduleName:String, id:uint) : Object
      {
         var query:SQLStatement = null;
         var resultQuery:SQLResult = null;
         var results:Array = null;
         query = new SQLStatement();
         query.sqlConnection = this._SQLiteConnectionSync;
         var objectName:String = "_" + moduleName;
         query.text = "SELECT " + objectName + " FROM " + moduleName + " WHERE id=" + id;
         try
         {
            query.execute(1);
            resultQuery = query.getResult();
            if(resultQuery)
            {
               results = resultQuery.data;
               if(results)
               {
                  return results[0][objectName];
               }
            }
         }
         catch(error:Error)
         {
            _log.error(query.text);
            throw error;
         }
         return null;
      }
      
      public function getObjects(moduleName:String) : Array
      {
         var lsResults:Array = null;
         var nResults:int = 0;
         var lsObject:Array = null;
         var i:int = 0;
         this._log.debug(moduleName);
         var query:SQLStatement = new SQLStatement();
         query.sqlConnection = this._SQLiteConnectionSync;
         var objectName:String = "_" + moduleName;
         query.text = "SELECT " + objectName + " FROM " + moduleName;
         try
         {
            query.execute();
            lsResults = query.getResult().data;
            nResults = lsResults.length;
            lsObject = new Array(nResults);
            for(i = 0; i < nResults; i++)
            {
               lsObject[i] = lsResults[i][objectName];
            }
            return lsObject;
         }
         catch(error:SQLError)
         {
            _log.error(error.toString());
         }
         return null;
      }
      
      public function executeSyncQuery(sQuery:String, prefetch:int = -1, params:Array = null) : Array
      {
         var nP:int = 0;
         var i:int = 0;
         var query:SQLStatement = new SQLStatement();
         query.sqlConnection = this._SQLiteConnectionSync;
         query.text = sQuery;
         if(params != null)
         {
            nP = params.length;
            for(i = 0; i < nP; i++)
            {
               query.parameters[i] = params[i];
            }
         }
         try
         {
            query.execute(prefetch);
            return query.getResult().data;
         }
         catch(error:SQLError)
         {
            _log.error(error.toString());
         }
         return null;
      }
      
      public function executeAsyncQuery(sQuery:String, callBack:Function = null, prefetch:int = -1, params:Array = null) : void
      {
         var nP:int = 0;
         var i:int = 0;
         var query:SQLStatement = new SQLStatement();
         query.addEventListener(SQLErrorEvent.ERROR,this.errorHandler);
         query.sqlConnection = this._SQLiteConnectionAsync;
         query.text = sQuery;
         if(params != null)
         {
            nP = params.length;
            for(i = 0; i < nP; i++)
            {
               query.parameters[i] = params[i];
            }
         }
         if(callBack == null)
         {
            query.execute();
         }
         else
         {
            query.execute(prefetch,new Responder(callBack));
         }
      }
      
      public function createGameData() : void
      {
         var moduleInfo:Object = null;
         var decriptionList:Array = null;
         var nDescription:int = 0;
         var namesList:Array = null;
         var variablesList:Array = null;
         var d:int = 0;
         var createTable:String = null;
         var n:int = 0;
         var parameters:Array = null;
         var i:int = 0;
         var lsObject:Array = null;
         var nObject:int = 0;
         var x:int = 0;
         var description:XML = null;
         var lsV:XMLList = null;
         var nV:int = 0;
         var k:int = 0;
         var variable:XML = null;
         var variableType:String = null;
         var variableName:String = null;
         var currentObject:Object = null;
         var query:SQLStatement = null;
         var p:int = 0;
         for each(moduleInfo in this._gameDataTemp)
         {
            decriptionList = moduleInfo.descriptionList;
            nDescription = decriptionList.length;
            namesList = new Array("_" + moduleInfo.moduleName);
            variablesList = new Array("_" + moduleInfo.moduleName + " OBJECT");
            for(d = 0; d < nDescription; d++)
            {
               description = decriptionList[d];
               lsV = description.child("variable");
               nV = lsV.length();
               for(k = 0; k < nV; k++)
               {
                  variable = lsV[k];
                  variableType = this.as3Type_To_SQLiteType(variable.attribute("type"));
                  if(variableType)
                  {
                     variableName = variable.attribute("name");
                     if(namesList.indexOf(variableName) == -1)
                     {
                        if(variableName == "id")
                        {
                           variablesList.push(variableName + " " + variableType + " PRIMARY KEY");
                        }
                        else
                        {
                           variablesList.push(variableName + " " + variableType);
                        }
                        namesList.push(variableName);
                     }
                  }
               }
            }
            if(namesList.indexOf("id") == -1)
            {
               variablesList.push("id INTEGER PRIMARY KEY AUTOINCREMENT");
               namesList.push("id");
            }
            this.executeSyncQuery("DROP TABLE IF EXISTS " + moduleInfo.moduleName);
            createTable = "CREATE TABLE " + moduleInfo.moduleName + " (" + variablesList.join(",") + ")";
            this._log.debug("Création d\'une table : " + createTable);
            this.executeSyncQuery(createTable);
            n = namesList.length;
            parameters = new Array(n);
            for(i = 0; i < n; i++)
            {
               parameters[i] = "?";
            }
            lsObject = moduleInfo.objectList;
            nObject = lsObject.length;
            for(x = 0; x < nObject; x++)
            {
               currentObject = lsObject[x];
               query = new SQLStatement();
               query.sqlConnection = this._SQLiteConnectionSync;
               query.addEventListener(SQLErrorEvent.ERROR,this.errorHandler);
               query.text = "INSERT INTO " + moduleInfo.moduleName + " VALUES (" + parameters.join(",") + ")";
               for(p = 0; p < n; p++)
               {
                  if(p == 0)
                  {
                     query.parameters[0] = currentObject;
                  }
                  else
                  {
                     try
                     {
                        query.parameters[p] = currentObject[namesList[p]];
                     }
                     catch(error:Error)
                     {
                        query.parameters[p] = null;
                     }
                  }
               }
               query.execute();
            }
         }
         this.commitSyncTransaction();
         this._gameDataTemp = null;
      }
      
      public function createGameDataTable(moduleName:String, description:XML) : void
      {
         var gameDataObject:Object = this._gameDataTemp[moduleName];
         if(gameDataObject)
         {
            gameDataObject.descriptionList.push(description);
         }
         else
         {
            gameDataObject = new Object();
            gameDataObject.moduleName = moduleName;
            gameDataObject.objectList = new Array();
            gameDataObject.descriptionList = new Array(description);
            this._gameDataTemp[moduleName] = gameDataObject;
         }
      }
      
      public function addGameDataObject(moduleName:String, object:Object) : void
      {
         this._gameDataTemp[moduleName].objectList.push(object);
      }
      
      public function traceCount() : void
      {
         var n:int = 0;
         var i:int = 0;
         var o:Object = null;
         var p:* = null;
         var L:Array = this.executeSyncQuery("SELECT * FROM I18nProxy");
         if(L)
         {
            n = L.length;
            for(i = 0; i < n; i++)
            {
               o = L[i];
               for(p in o)
               {
                  this._log.debug(p + " : " + o[p]);
               }
            }
         }
      }
      
      private function traceEvent(result:SQLResult) : void
      {
         var o:Object = null;
         var p:* = null;
         trace("______________________________________________");
         var n:int = result.data.length;
         for(var i:int = 0; i < n; i++)
         {
            o = result.data[i];
            for(p in o)
            {
               trace(p + " : " + o[p]);
            }
         }
         trace("______________________________________________");
      }
      
      private function openConnection() : void
      {
         this._SQLiteConnectionSync = new SQLConnection();
         this._SQLiteConnectionSync.addEventListener(SQLEvent.OPEN,this.openSyncHandler);
         this._SQLiteConnectionSync.addEventListener(SQLErrorEvent.ERROR,this.errorHandler);
         this._SQLiteConnectionSync.open(File.applicationStorageDirectory.resolvePath("test.db"));
      }
      
      private function as3Type_To_SQLiteType(as3Type:String) : String
      {
         if(as3Type == "uint" || as3Type == "int")
         {
            return "INTEGER";
         }
         if(as3Type == "Number")
         {
            return "REAL";
         }
         if(as3Type == "Boolean")
         {
            return "BOOLEAN";
         }
         if(as3Type == "String")
         {
            return "TEXT";
         }
         return "";
      }
      
      private function openAsyncHandler(event:SQLEvent) : void
      {
         var callBack:Function = null;
         this._log.info("Connexion SQLite asynchrone effectuée");
         _asyncOpened = true;
         for each(callBack in _callBackFunctions)
         {
            callBack();
         }
      }
      
      private function openSyncHandler(event:SQLEvent) : void
      {
         this._log.info("Connexion SQLite synchrone effectuée");
         this.beginSyncTransaction();
         this._SQLiteConnectionAsync = new SQLConnection();
         this._SQLiteConnectionAsync.addEventListener(SQLEvent.OPEN,this.openAsyncHandler);
         this._SQLiteConnectionAsync.addEventListener(SQLErrorEvent.ERROR,this.errorHandler);
         this._SQLiteConnectionAsync.openAsync(File.applicationStorageDirectory.resolvePath("test.db"),"read");
         _syncOpened = true;
      }
      
      private function errorHandler(event:SQLErrorEvent) : void
      {
         throw new Error(event.text);
      }
   }
}
