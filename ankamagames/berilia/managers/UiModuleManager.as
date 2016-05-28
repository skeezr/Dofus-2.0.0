package com.ankamagames.berilia.managers
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.types.Uri;
   import flash.filesystem.File;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.types.messages.ModuleRessourceLoadFailedMessage;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.berilia.types.shortcut.Shortcut;
   import com.ankamagames.berilia.utils.berilia_internal_namespace;
   import com.ankamagames.berilia.api.ApiBinder;
   import com.ankamagames.jerakine.logger.ExceptionLogEvent;
   import com.ankamagames.berilia.types.messages.ModuleExecErrorMessage;
   import com.ankamagames.berilia.utils.errors.ApiError;
   import com.ankamagames.berilia.types.messages.AllModulesLoadedMessage;
   import com.ankamagames.jerakine.resources.adapters.impl.TxtAdapter;
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.jerakine.utils.files.FileUtils;
   import com.ankamagames.berilia.utils.UriCacheFactory;
   import com.ankamagames.jerakine.newCache.impl.Cache;
   import com.ankamagames.jerakine.newCache.garbage.LruGarbageCollector;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.berilia.types.data.UiData;
   import flash.system.LoaderContext;
   import flash.system.ApplicationDomain;
   import com.ankamagames.jerakine.resources.adapters.SimpleLoaderAdapter;
   import flash.display.Loader;
   import com.ankamagames.berilia.types.messages.ModuleLoadedMessage;
   import com.ankamagames.berilia.types.shortcut.ShortcutCategory;
   import com.ankamagames.jerakine.resources.events.ResourceLoaderProgressEvent;
   import com.ankamagames.berilia.uiRender.XmlParsor;
   import flash.events.Event;
   import com.ankamagames.berilia.types.messages.AllUiXmlParsedMessage;
   import com.ankamagames.berilia.types.event.ParsorEvent;
   import com.ankamagames.berilia.types.messages.UiXmlParsedMessage;
   import com.ankamagames.jerakine.utils.crypto.MD5;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   
   public class UiModuleManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.berilia.managers.UiModuleManager));
      
      private static var _self:com.ankamagames.berilia.managers.UiModuleManager;
       
      private var _loader:IResourceLoader;
      
      private var _uiLoader:IResourceLoader;
      
      private var _scriptNum:uint;
      
      private var _modules:Array;
      
      private var _preprocessorIndex:Dictionary;
      
      private var _uiFiles:Array;
      
      private var _regImport:RegExp;
      
      private var _versions:Array;
      
      private var _clearUi:Array;
      
      private var _uiFileToLoad:uint;
      
      private var _moduleCount:uint = 0;
      
      private var _cacheLoader:IResourceLoader;
      
      private var _unparsedXml:Array;
      
      private var _unparsedXmlCount:uint;
      
      private var _unparsedXmlTotalCount:uint;
      
      private var _parserAvaibleCount:uint = 2;
      
      public function UiModuleManager()
      {
         this._regImport = /<Import *url *= *"([^"]*)/g;
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onLoadError,false,0,true);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onLoad,false,0,true);
         this._uiLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._uiLoader.addEventListener(ResourceErrorEvent.ERROR,this.onUiLoadError,false,0,true);
         this._uiLoader.addEventListener(ResourceLoadedEvent.LOADED,this.onUiLoaded,false,0,true);
         this._cacheLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
      }
      
      public static function getInstance() : com.ankamagames.berilia.managers.UiModuleManager
      {
         if(!_self)
         {
            _self = new com.ankamagames.berilia.managers.UiModuleManager();
         }
         return _self;
      }
      
      public function get moduleCount() : uint
      {
         return this._moduleCount;
      }
      
      public function get unparsedXmlCount() : uint
      {
         return this._unparsedXmlCount;
      }
      
      public function get unparsedXmlTotalCount() : uint
      {
         return this._unparsedXmlTotalCount;
      }
      
      public function init(filter:Array, filterInclude:Boolean) : void
      {
         var uri:Uri = null;
         var file:File = null;
         var dmFile:File = null;
         var len:int = 0;
         var substr:String = null;
         this._modules = new Array();
         this._preprocessorIndex = new Dictionary(true);
         this._scriptNum = 0;
         this._moduleCount = 0;
         this._versions = new Array();
         this._clearUi = new Array();
         this._uiFiles = new Array();
         var uiDir:File = File.applicationDirectory.resolvePath(LangManager.getInstance().getEntry("config.mod.path"));
         if(uiDir.exists)
         {
            for each(file in uiDir.getDirectoryListing())
            {
               if(file.name.charAt(0) != ".")
               {
                  if(filter.indexOf(file.name) != -1 == filterInclude)
                  {
                     dmFile = this.searchDmFile(file);
                     if(dmFile)
                     {
                        this._moduleCount++;
                        this._scriptNum++;
                        len = "app:/".length;
                        substr = dmFile.url.substring(len,dmFile.url.length);
                        uri = new Uri(substr);
                        uri.tag = dmFile;
                        this._loader.load(uri);
                     }
                     else
                     {
                        _log.error("Cannot found .dm file in " + file.url);
                        Berilia.getInstance().handler.process(new ModuleRessourceLoadFailedMessage(file.name,uri,false));
                     }
                  }
               }
            }
         }
         else
         {
            _log.fatal("No ui module folder, looking for " + LangManager.getInstance().getEntry("config.mod.path"));
         }
      }
      
      public function getModules() : Array
      {
         return this._modules;
      }
      
      public function getModule(name:String) : UiModule
      {
         return this._modules[name];
      }
      
      public function reset() : void
      {
         var module:UiModule = null;
         Shortcut.reset();
         Berilia.getInstance().reset();
         for each(module in this._modules)
         {
            if(module.berilia_internal_namespace::loader)
            {
               module.berilia_internal_namespace::loader.unloadAndStop();
            }
            else
            {
               _log.error("Impossible de décharger completement le Module " + module.name);
            }
         }
         KernelEventsManager.getInstance().initialize();
         this._modules = [];
      }
      
      private function launchModule() : void
      {
         var module:UiModule = null;
         var missingName:String = null;
         var missingModule:UiModule = null;
         var notLoaded:Array = null;
         var m:UiModule = null;
         var st:String = null;
         var modules:Array = new Array();
         for each(module in this._modules)
         {
            if(module.trusted)
            {
               modules.unshift(module);
            }
            else
            {
               modules.push(module);
            }
         }
         while(modules.length > 0)
         {
            notLoaded = new Array();
            for each(m in modules)
            {
               ApiBinder.addApiData("currentUi",null);
               missingName = ApiBinder.initApi(m.mainClass,m);
               if(missingName)
               {
                  missingModule = m;
                  notLoaded.push(m);
               }
               else if(Berilia.getInstance().verboseException)
               {
                  m.mainClass.main();
               }
               else
               {
                  try
                  {
                     m.mainClass.main();
                  }
                  catch(e:Error)
                  {
                     if(e.getStackTrace())
                     {
                        st = e.getStackTrace();
                     }
                     else
                     {
                        st = "no stack trace available";
                     }
                     _log.logDirectly(new ExceptionLogEvent(st));
                     Berilia.getInstance().handler.process(new ModuleExecErrorMessage(m.id,st));
                     throw e;
                  }
               }
            }
            if(notLoaded.length == modules.length)
            {
               throw new ApiError("Module " + missingName + " does not exist (in " + missingModule.id + ")");
            }
            modules = notLoaded;
         }
         Berilia.getInstance().handler.process(new AllModulesLoadedMessage());
      }
      
      private function launchUiCheck() : void
      {
         this._uiFileToLoad = this._uiFiles.length;
         this._uiLoader.load(this._uiFiles,null,TxtAdapter);
      }
      
      private function processCachedFiles(files:Array) : void
      {
         var uri:Uri = null;
         var file:Uri = null;
         var c:ICache = null;
         for each(file in files)
         {
            switch(file.fileType.toLowerCase())
            {
               case "css":
                  CssManager.getInstance().load(file.uri);
                  continue;
               case "jpg":
               case "png":
                  uri = new Uri(FileUtils.getFilePath(file.normalizedUri));
                  c = UriCacheFactory.getCacheFromUri(uri);
                  if(!c)
                  {
                     c = UriCacheFactory.init(uri.uri,new Cache(files.length,new LruGarbageCollector()));
                  }
                  this._cacheLoader.load(file,c);
                  continue;
               default:
                  _log.warn("Cannot put " + file.uri + " into cache, type not supported");
                  continue;
            }
         }
      }
      
      private function onLoadError(e:ResourceErrorEvent) : void
      {
         _log.error("Cannot load " + e.uri + "(" + e.errorMsg + ")");
         Berilia.getInstance().handler.process(new ModuleRessourceLoadFailedMessage(e.uri.tag,e.uri));
         switch(e.uri.fileType.toLowerCase())
         {
            case "swf":
               if(!--this._scriptNum)
               {
                  this.launchUiCheck();
               }
         }
      }
      
      private function onUiLoadError(e:ResourceErrorEvent) : void
      {
         _log.error("Cannot load UI " + e.uri + "(" + e.errorMsg + ")");
         Berilia.getInstance().handler.process(new ModuleRessourceLoadFailedMessage(e.uri.tag,e.uri));
         this._uiFileToLoad--;
      }
      
      private function onLoad(e:ResourceLoadedEvent) : void
      {
         switch(e.uri.fileType.toLowerCase())
         {
            case "swf":
               this.onScriptLoad(e);
               if(!--this._scriptNum)
               {
                  this.launchUiCheck();
               }
               break;
            case "dm":
               this.onDMLoad(e);
               break;
            case "xml":
               this.onShortcutLoad(e);
         }
      }
      
      private function onDMLoad(e:ResourceLoadedEvent) : void
      {
         var uiUri:Uri = null;
         var ui:UiData = null;
         var root:File = null;
         var currentFile:File = null;
         var path:String = null;
         var shortcutsUri:Uri = null;
         var scriptUri:Uri = null;
         var dirFiles:Array = null;
         var dirFile:File = null;
         var um:UiModule = UiModule.createFromXml(e.resource as XML,FileUtils.getFilePath(e.uri.path),File(e.uri.tag).name.split(".")[0]);
         this._modules[um.id] = um;
         if(um.shortcuts)
         {
            shortcutsUri = new Uri(um.shortcuts);
            shortcutsUri.tag = um;
            this._loader.load(shortcutsUri);
         }
         if(um.script)
         {
            scriptUri = new Uri(um.script);
            scriptUri.loaderContext = new LoaderContext(false,new ApplicationDomain());
            scriptUri.tag = um;
            this._loader.load(scriptUri,null,SimpleLoaderAdapter);
         }
         var files:Array = new Array();
         for each(ui in um.uis)
         {
            if(ui.file)
            {
               uiUri = new Uri(ui.file);
               uiUri.tag = {
                  "mod":um,
                  "base":ui.file
               };
               this._uiFiles.push(uiUri);
            }
         }
         this._uiLoader.load(files,null,TxtAdapter);
         root = File.applicationDirectory.resolvePath("ui/" + um.id);
         files = new Array();
         for each(path in um.cachedFiles)
         {
            currentFile = root.resolvePath(path);
            if(currentFile.exists)
            {
               if(!currentFile.isDirectory)
               {
                  files.push(new Uri("mod://" + um.id + "/" + path));
               }
               else
               {
                  dirFiles = currentFile.getDirectoryListing();
                  for each(dirFile in dirFiles)
                  {
                     if(dirFile.isDirectory)
                     {
                     }
                     files.push(new Uri("mod://" + um.id + "/" + path + "/" + FileUtils.getFileName(dirFile.url)));
                  }
               }
            }
         }
         this.processCachedFiles(files);
      }
      
      private function onScriptLoad(e:ResourceLoadedEvent) : void
      {
         var uiModule:UiModule = e.uri.tag;
         var l:Loader = e.resource as Loader;
         uiModule.berilia_internal_namespace::loader = l;
         uiModule.applicationDomain = l.contentLoaderInfo.applicationDomain;
         uiModule.mainClass = l.content;
         Berilia.getInstance().handler.process(new ModuleLoadedMessage(uiModule.id));
      }
      
      private function onShortcutLoad(e:ResourceLoadedEvent) : void
      {
         var category:XML = null;
         var cat:ShortcutCategory = null;
         var permanent:Boolean = false;
         var shortcut:XML = null;
         var shortcutsXml:XML = e.resource;
         for each(category in shortcutsXml..category)
         {
            cat = ShortcutCategory.create(category.@name,LangManager.getInstance().replaceKey(category.@description));
            permanent = false;
            for each(shortcut in category..shortcut)
            {
               if(!shortcut.@name || !shortcut.@name.toString().length)
               {
                  throw new ApiError("Shortcuts file misformated, missing name value in " + e.uri);
               }
               if(Boolean(shortcut.@permanent) && shortcut.@permanent == true)
               {
                  permanent = true;
               }
               new Shortcut(shortcut.@name,shortcut.@textfieldEnabled == true,LangManager.getInstance().replaceKey(shortcut.toString()),cat,!permanent);
            }
         }
      }
      
      private function onAllUiChecked(e:ResourceLoaderProgressEvent) : void
      {
         var module:UiModule = null;
         var url:* = null;
         var ui:UiData = null;
         var uiDataList:Array = new Array();
         for each(module in this._modules)
         {
            for each(ui in module.uis)
            {
               uiDataList[UiData(ui).file] = ui;
            }
         }
         this._unparsedXml = [];
         for(url in this._clearUi)
         {
            UiRenderManager.getInstance().clearCacheFromId(url);
            UiRenderManager.getInstance().setUiVersion(url,this._clearUi[url]);
            if(uiDataList[url])
            {
               this._unparsedXml.push(uiDataList[url]);
            }
         }
         this._unparsedXmlCount = this._unparsedXmlTotalCount = this._unparsedXml.length;
         this.parseNextXml();
      }
      
      private function parseNextXml() : void
      {
         var uiData:UiData = null;
         var xmlParsor:XmlParsor = null;
         this._unparsedXmlCount = this._unparsedXml.length;
         if(this._unparsedXml.length)
         {
            if(this._parserAvaibleCount)
            {
               this._parserAvaibleCount--;
               uiData = this._unparsedXml.shift() as UiData;
               xmlParsor = new XmlParsor();
               xmlParsor.rootPath = uiData.module.rootPath;
               xmlParsor.addEventListener(Event.COMPLETE,this.onXmlParsed,false,0,true);
               xmlParsor.processFile(uiData.file);
            }
         }
         else
         {
            Berilia.getInstance().handler.process(new AllUiXmlParsedMessage());
            this.launchModule();
         }
      }
      
      private function onXmlParsed(e:ParsorEvent) : void
      {
         if(e.uiDefinition)
         {
            e.uiDefinition.name = XmlParsor(e.target).url;
            UiRenderManager.getInstance().setUiDefinition(e.uiDefinition);
            _log.info("Preparsing " + XmlParsor(e.target).url + " ok");
            Berilia.getInstance().handler.process(new UiXmlParsedMessage(e.uiDefinition.name));
         }
         this._parserAvaibleCount++;
         this.parseNextXml();
      }
      
      private function onUiLoaded(e:ResourceLoadedEvent) : void
      {
         var res:Array = null;
         var filePath:String = null;
         var templateUri:Uri = null;
         var mod:UiModule = e.uri.tag.mod;
         var base:String = e.uri.tag.base;
         var md5:String = this._versions[e.uri.uri] != null?this._versions[e.uri.uri]:MD5.hash(e.resource as String);
         var versionOk:* = md5 == UiRenderManager.getInstance().getUiVersion(e.uri.uri);
         if(!versionOk)
         {
            this._clearUi[e.uri.uri] = md5;
            if(e.uri.tag.template)
            {
               this._clearUi[e.uri.tag.base] = this._versions[e.uri.tag.base];
            }
         }
         this._versions[e.uri.uri] = md5;
         var xml:String = e.resource as String;
         while(res = this._regImport.exec(xml))
         {
            filePath = LangManager.getInstance().replaceKey(res[1]);
            if(filePath.indexOf("mod://") != -1)
            {
               filePath = LangManager.getInstance().getEntry("config.mod.path") + filePath.substr(6);
            }
            else if(filePath.indexOf(":") == -1 && filePath.indexOf("./ui/Ankama_Common") == -1)
            {
               filePath = mod.rootPath + filePath;
            }
            if(this._clearUi[filePath])
            {
               this._clearUi[e.uri.uri] = md5;
               this._clearUi[base] = this._versions[base];
            }
            else
            {
               this._uiFileToLoad++;
               templateUri = new Uri(filePath);
               templateUri.tag = {
                  "mod":mod,
                  "base":base,
                  "template":true
               };
               this._uiLoader.load(templateUri,null,TxtAdapter);
            }
         }
         if(!--this._uiFileToLoad)
         {
            this.onAllUiChecked(null);
         }
      }
      
      private function searchDmFile(rootPath:File) : File
      {
         var file:File = null;
         var dm:File = null;
         if(rootPath.nativePath.indexOf(".svn") != -1)
         {
            return null;
         }
         var files:Array = rootPath.getDirectoryListing();
         for each(file in files)
         {
            if(!file.isDirectory && file.extension.toLowerCase() == "dm")
            {
               return file;
            }
         }
         for each(file in files)
         {
            if(file.isDirectory)
            {
               dm = this.searchDmFile(file);
               if(dm)
               {
                  break;
               }
            }
         }
         return dm;
      }
   }
}
