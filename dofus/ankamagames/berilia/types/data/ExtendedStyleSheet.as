package com.ankamagames.berilia.types.data
{
   import flash.text.StyleSheet;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.berilia.managers.CssManager;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.berilia.types.event.CssEvent;
   
   public class ExtendedStyleSheet extends StyleSheet
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ExtendedStyleSheet));
      
      private static const CSS_INHERITANCE_KEYWORD:String = "extends";
      
      private static const CSS_FILES_KEYWORD:String = "files";
       
      private var _inherit:Array;
      
      private var _inherited:uint;
      
      private var _url:String;
      
      public function ExtendedStyleSheet(url:String)
      {
         this._inherit = new Array();
         this._inherited = 0;
         this._url = url;
         super();
      }
      
      public function get inherit() : Array
      {
         return this._inherit;
      }
      
      public function get ready() : Boolean
      {
         return this._inherited == this._inherit.length;
      }
      
      public function get url() : String
      {
         return this._url;
      }
      
      override public function parseCSS(content:String) : void
      {
         var inheritance:Object = null;
         var regFile:RegExp = null;
         var match:Array = null;
         var file:String = null;
         var i:uint = 0;
         super.parseCSS(content);
         var find:int = styleNames.indexOf(CSS_INHERITANCE_KEYWORD);
         if(find != -1)
         {
            inheritance = getStyle(styleNames[find]);
            if(inheritance[CSS_FILES_KEYWORD])
            {
               regFile = /url\('?([^']*)'\)?/g;
               match = String(inheritance[CSS_FILES_KEYWORD]).match(regFile);
               for(i = 0; i < match.length; i++)
               {
                  file = String(match[i]).replace(regFile,"$1");
                  if(-1 == this._inherit.indexOf(file))
                  {
                     file = LangManager.getInstance().replaceKey(file);
                     CssManager.getInstance().askCss(file,new Callback(this.makeMerge,file));
                     this._inherit.push(file);
                  }
               }
            }
            else
            {
               _log.warn("property \'" + CSS_FILES_KEYWORD + "\' wasn\'t found (flash css doesn\'t support space between property name and colon, propertyName:value)");
               dispatchEvent(new CssEvent(CssEvent.CSS_PARSED,false,false,this));
            }
         }
         else
         {
            dispatchEvent(new CssEvent(CssEvent.CSS_PARSED,false,false,this));
         }
      }
      
      public function merge(stylesheet:ExtendedStyleSheet, replace:Boolean = false) : void
      {
         var localDef:Object = null;
         var newDef:Object = null;
         var property:* = null;
         for(var i:uint = 0; i < stylesheet.styleNames.length; i++)
         {
            if(stylesheet.styleNames[i] != CSS_INHERITANCE_KEYWORD)
            {
               localDef = getStyle(stylesheet.styleNames[i]);
               newDef = stylesheet.getStyle(stylesheet.styleNames[i]);
               if(localDef)
               {
                  for(property in newDef)
                  {
                     if(localDef[property] == null || Boolean(replace))
                     {
                        localDef[property] = newDef[property];
                     }
                  }
                  newDef = localDef;
               }
               setStyle(stylesheet.styleNames[i],newDef);
            }
         }
      }
      
      override public function toString() : String
      {
         var localDef:Object = null;
         var property:* = null;
         var result:String = "";
         result = result + ("File " + this.url + " :\n");
         for(var i:uint = 0; i < styleNames.length; i++)
         {
            localDef = getStyle(styleNames[i]);
            result = result + (" [" + styleNames[i] + "]\n");
            for(property in localDef)
            {
               result = result + ("  " + property + " : " + localDef[property] + "\n");
            }
         }
         return result;
      }
      
      private function makeMerge(sUrl:String) : void
      {
         this.merge(CssManager.getInstance().getCss(sUrl));
         this._inherited++;
         if(this.ready)
         {
            dispatchEvent(new CssEvent(CssEvent.CSS_PARSED,false,false,this));
         }
      }
   }
}
