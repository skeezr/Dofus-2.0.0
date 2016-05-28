package com.ankamagames.jerakine.managers
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.messages.MessageHandler;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.utils.files.FileUtils;
   import com.ankamagames.jerakine.utils.errors.FileTypeError;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.messages.LangFileLoadedMessage;
   import com.ankamagames.jerakine.messages.LangAllFilesLoadedMessage;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   
   public class FontManager
   {
      
      private static var _self:com.ankamagames.jerakine.managers.FontManager;
      
      public static var initialized:Boolean = false;
       
      private var _log:Logger;
      
      private var _handler:MessageHandler;
      
      private var _loader:IResourceLoader;
      
      private var _data:XML;
      
      private var _lang:String;
      
      private var _fonts:Dictionary;
      
      public function FontManager()
      {
         this._log = Log.getLogger(getQualifiedClassName(com.ankamagames.jerakine.managers.FontManager));
         super();
         if(_self != null)
         {
            throw new SingletonError("FontManager is a singleton and should not be instanciated directly.");
         }
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SERIAL_LOADER);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onFileLoaded);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onLoadError);
      }
      
      public static function getInstance() : com.ankamagames.jerakine.managers.FontManager
      {
         if(_self == null)
         {
            _self = new com.ankamagames.jerakine.managers.FontManager();
         }
         return _self;
      }
      
      public function set handler(value:MessageHandler) : void
      {
         this._handler = value;
      }
      
      public function loadFile(sUrl:String) : void
      {
         var sExtension:String = FileUtils.getExtension(sUrl);
         this._lang = LangManager.getInstance().getEntry("config.lang.current");
         if(sExtension == null)
         {
            throw new FileTypeError(sUrl + " have no type (no extension found).");
         }
         var uri:Uri = new Uri(sUrl);
         uri.tag = sUrl;
         this._loader.load(uri);
      }
      
      public function getRealFontName(font:String) : String
      {
         if(this._fonts[font])
         {
            return this._fonts[font].realname;
         }
         return "";
      }
      
      public function getFontsList() : Array
      {
         var o:Object = null;
         var fontList:Array = new Array();
         for each(o in this._fonts)
         {
            fontList.push(o.url);
         }
         return fontList;
      }
      
      public function getSizeMultipicator(fontName:String) : Number
      {
         if(this._fonts[fontName])
         {
            return Number(this._fonts[fontName].sizemultiplicator);
         }
         return 1;
      }
      
      public function getFontClassName(cssName:String) : String
      {
         return this._fonts[cssName].classname;
      }
      
      private function onFileLoaded(e:ResourceLoadedEvent) : void
      {
         var length:int = 0;
         var i:int = 0;
         var xml:XMLList = null;
         var name:String = null;
         var o:Object = null;
         this._data = new XML(e.resource);
         this._fonts = new Dictionary();
         if(this._lang == "ja")
         {
            xml = this._data.Fonts.(@lang == "ja");
         }
         else
         {
            xml = this._data.Fonts.(@lang != "ja");
         }
         length = xml.font.length();
         for(i = 0; i < length; i++)
         {
            name = xml.font[i].@name;
            o = {
               "realname":xml.font[i].@realName,
               "classname":xml.font[i].@classname,
               "sizemultiplicator":xml.font[i].@sizemultiplicator,
               "url":LangManager.getInstance().replaceKey(xml.font[i])
            };
            this._fonts[name] = o;
         }
         this._handler.process(new LangFileLoadedMessage(e.uri.uri,true,e.uri.uri));
         this._handler.process(new LangAllFilesLoadedMessage(e.uri.uri,true));
         initialized = true;
      }
      
      private function onLoadError(e:ResourceErrorEvent) : void
      {
         this._handler.process(new LangFileLoadedMessage(e.uri.uri,false,e.uri.uri));
         this._log.warn("can\'t load " + e.uri.uri);
      }
   }
}
