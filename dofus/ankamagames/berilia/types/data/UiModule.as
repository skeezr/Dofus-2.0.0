package com.ankamagames.berilia.types.data
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.berilia.managers.UiGroupManager;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.display.Loader;
   import com.ankamagames.berilia.utils.api_namespace;
   import flash.system.ApplicationDomain;
   import com.ankamagames.berilia.utils.berilia_internal_namespace;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   
   public class UiModule
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(UiModule));
       
      private var _id:String;
      
      private var _name:String;
      
      private var _version:String;
      
      private var _gameVersion:String;
      
      private var _author:String;
      
      private var _shortDescription:String;
      
      private var _description:String;
      
      private var _script:String;
      
      private var _shortcuts:String;
      
      private var _uis:Array;
      
      private var _trusted:Boolean = true;
      
      private var _rootPath:String;
      
      private var _mainClass:Object;
      
      private var _cachedFiles:Array;
      
      var _loader:Loader;
      
      api_namespace var moduleAppDomain:ApplicationDomain;
      
      berilia_internal_namespace var loader:Loader;
      
      public function UiModule(id:String = null, name:String = null, version:String = null, gameVersion:String = null, author:String = null, shortDescription:String = null, description:String = null, script:String = null, shortcuts:String = null, uis:Array = null, cachedFiles:Array = null)
      {
         var ui:UiData = null;
         super();
         this._name = name;
         this._version = version;
         this._gameVersion = gameVersion;
         this._author = author;
         this._shortDescription = shortDescription;
         this._description = description;
         this._script = script;
         this._shortcuts = shortcuts;
         this._id = id;
         this._uis = new Array();
         this._cachedFiles = !!cachedFiles?cachedFiles:new Array();
         for each(ui in uis)
         {
            this._uis[ui.name] = ui;
         }
      }
      
      public static function createFromXml(xml:XML, nativePath:String, id:String) : UiModule
      {
         var uiGroup:UiGroup = null;
         var group:XML = null;
         var uiData:UiData = null;
         var uis:XML = null;
         var path:XML = null;
         var uiNames:Array = null;
         var groupName:String = null;
         var uisXML:XMLList = null;
         var uiName:XML = null;
         var uisGroup:String = null;
         var ui:XML = null;
         var um:UiModule = new UiModule();
         um.setProperty("name",xml..header..name);
         um.setProperty("version",xml..header..version);
         um.setProperty("gameVersion",xml..header..gameVersion);
         um.setProperty("author",xml..header..author);
         um.setProperty("description",xml..header..description);
         um.setProperty("shortDescription",xml..header..shortDescription);
         um.setProperty("script",xml..script);
         um.setProperty("shortcuts",xml..shortcuts);
         var nativePath:String = nativePath.split("app:/").join("");
         if(nativePath.indexOf("file://") == -1)
         {
            nativePath = "file://" + nativePath;
         }
         um._id = id;
         if(um.script)
         {
            um._script = nativePath + "/" + um.script;
         }
         if(um.shortcuts)
         {
            um._shortcuts = nativePath + "/" + um.shortcuts;
         }
         um._rootPath = nativePath + "/";
         for(; §§hasnext(xml.uiGroup,_loc5_); uiGroup = new UiGroup(group.@name,group.@exclusive.toString() == "true",group.@permanent.toString() == "true",uiNames),UiGroupManager.getInstance().registerGroup(uiGroup))
         {
            group = §§nextvalue(_loc5_,_loc6_);
            uiNames = new Array();
            groupName = group..@name;
            try
            {
               uisXML = xml.uis.(@group == groupName);
               for each(uiName in uisXML..@name)
               {
                  uiNames.push(uiName.toString());
               }
            }
            catch(e:Error)
            {
               continue;
            }
         }
         for each(uis in xml.uis)
         {
            uisGroup = uis.@group.toString();
            for each(ui in uis..ui)
            {
               if(ui.@group.toString().length)
               {
                  uisGroup = ui.@group.toString();
               }
               uiData = new UiData(um,ui.@name,!!ui.@file.toString().length?nativePath + "/" + ui.@file:null,ui["class"],uisGroup);
               um._uis[uiData.name] = uiData;
            }
         }
         for each(path in xml.cachedFiles..path)
         {
            um.cachedFiles.push(path.children().toString());
         }
         return um;
      }
      
      public function get id() : String
      {
         return this._id;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get version() : String
      {
         return this._version;
      }
      
      public function get gameVersion() : String
      {
         return this._gameVersion;
      }
      
      public function get author() : String
      {
         return this._author;
      }
      
      public function get shortDescription() : String
      {
         return this._shortDescription;
      }
      
      public function get description() : String
      {
         return this._description;
      }
      
      public function get script() : String
      {
         return this._script;
      }
      
      public function get shortcuts() : String
      {
         return this._shortcuts;
      }
      
      public function get uis() : Array
      {
         return this._uis;
      }
      
      public function get trusted() : Boolean
      {
         return this._trusted;
      }
      
      public function get rootPath() : String
      {
         return this._rootPath;
      }
      
      public function get cachedFiles() : Array
      {
         return this._cachedFiles;
      }
      
      public function set applicationDomain(appDomain:ApplicationDomain) : void
      {
         var ui:UiData = null;
         if(api_namespace::moduleAppDomain)
         {
            throw new BeriliaError("ApplicationDomain cannot be set twice.");
         }
         for each(ui in this.uis)
         {
            if(Boolean(appDomain) && Boolean(appDomain.hasDefinition(ui.uiClassName)))
            {
               ui.uiClass = appDomain.getDefinition(ui.uiClassName) as Class;
            }
            else
            {
               _log.error(ui.uiClassName + " cannot be found");
            }
         }
         api_namespace::moduleAppDomain = appDomain;
      }
      
      public function get mainClass() : Object
      {
         return this._mainClass;
      }
      
      public function set mainClass(instance:Object) : void
      {
         if(this._mainClass)
         {
            throw new BeriliaError("mainClass cannot be set twice.");
         }
         this._mainClass = instance;
      }
      
      public function getUi(name:String) : UiData
      {
         return this._uis[name];
      }
      
      private function setProperty(key:String, value:String) : void
      {
         if(Boolean(value) && Boolean(value.length))
         {
            this["_" + key] = value;
         }
         else
         {
            this["_" + key] = null;
         }
      }
   }
}
