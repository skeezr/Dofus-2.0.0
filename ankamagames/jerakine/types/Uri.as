package com.ankamagames.jerakine.types
{
   import flash.system.LoaderContext;
   import com.ankamagames.jerakine.resources.protocols.impl.ModProtocol;
   import com.ankamagames.jerakine.utils.crypto.CRC32;
   import flash.utils.ByteArray;
   
   public class Uri
   {
      
      private static const URI_SYNTAX:RegExp = /^(?:(?P<protocol>[a-z]+)\:\\/\\/)?(?P<path>[^\|]*)(?|\|)?(?|\\/)?(?P<subpath>.*)?$/i;
       
      private var _protocol:String;
      
      private var _path:String;
      
      private var _subpath:String;
      
      private var _tag;
      
      private var _sum:String;
      
      private var _loaderContext:LoaderContext;
      
      public function Uri(uri:String = null)
      {
         super();
         if(Boolean(uri) && uri.length > 0)
         {
            this.parseUri(uri);
         }
      }
      
      public function get protocol() : String
      {
         return this._protocol;
      }
      
      public function set protocol(value:String) : void
      {
         this._protocol = value;
         this._sum = "";
      }
      
      public function get path() : String
      {
         return this._path;
      }
      
      public function set path(value:String) : void
      {
         this._path = value;
         this._sum = "";
      }
      
      public function get subPath() : String
      {
         return this._subpath;
      }
      
      public function set subPath(value:String) : void
      {
         this._subpath = value;
         this._sum = "";
      }
      
      public function get uri() : String
      {
         return this.toString();
      }
      
      public function set uri(value:String) : void
      {
         this.parseUri(value);
      }
      
      public function get tag() : *
      {
         return this._tag;
      }
      
      public function set tag(value:*) : void
      {
         this._tag = value;
      }
      
      public function get loaderContext() : LoaderContext
      {
         return this._loaderContext;
      }
      
      public function set loaderContext(value:LoaderContext) : void
      {
         this._loaderContext = value;
      }
      
      public function get fileType() : String
      {
         if(!this._subpath || this._subpath.length == 0)
         {
            return this._path.substr(this._path.lastIndexOf(".") + 1);
         }
         return this._subpath.substr(this._subpath.lastIndexOf(".") + 1);
      }
      
      public function get fileName() : String
      {
         if(!this._subpath || this._subpath.length == 0)
         {
            return this._path.substr(this._path.lastIndexOf("/") + 1);
         }
         return this._subpath.substr(this._subpath.lastIndexOf("/") + 1);
      }
      
      public function get normalizedUri() : String
      {
         switch(this._protocol)
         {
            case "http":
            case "file":
            case "zip":
            case "upd":
               return this.replaceChar(this.uri,"\\","/");
            case "mod":
               return this.replaceChar(ModProtocol.MODULE_ROOT_PATH + this._path,"\\","/");
            default:
               return null;
         }
      }
      
      public function toString(withSubPath:Boolean = true) : String
      {
         return this._protocol + "://" + this._path + (Boolean(withSubPath) && Boolean(this._subpath) && this._subpath.length > 0?"|" + this._subpath:"");
      }
      
      public function toSum() : String
      {
         if(this._sum.length > 0)
         {
            return this._sum;
         }
         var crc:CRC32 = new CRC32();
         var buf:ByteArray = new ByteArray();
         buf.writeUTF(this.normalizedUri);
         crc.update(buf);
         return this._sum = crc.getValue().toString(16);
      }
      
      private function parseUri(uri:String) : void
      {
         var m:Array = uri.match(URI_SYNTAX);
         if(!m)
         {
            throw new ArgumentError("\'" + uri + "\' is a misformated URI.");
         }
         this._protocol = m["protocol"];
         if(this._protocol.length == 0)
         {
            this._protocol = "file";
         }
         this._path = m["path"];
         this._subpath = m["subpath"];
         this._sum = "";
      }
      
      private function replaceChar(str:String, search:String, replace:String) : String
      {
         return str.split(search).join(replace);
      }
   }
}
