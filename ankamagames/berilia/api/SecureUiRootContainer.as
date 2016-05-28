package com.ankamagames.berilia.api
{
   import flash.utils.Proxy;
   import com.ankamagames.jerakine.interfaces.Secure;
   import flash.utils.Dictionary;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import flash.utils.flash_proxy;
   import com.ankamagames.jerakine.utils.misc.BoxingUnBoxing;
   import flash.display.DisplayObject;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   
   public dynamic class SecureUiRootContainer extends Proxy implements Secure
   {
      
      private static var _secureUis:Dictionary = new Dictionary(true);
      
      protected static var _properties:Array;
       
      private var _ui:UiRootContainer;
      
      private var _trusted:Boolean;
      
      public function SecureUiRootContainer(ui:UiRootContainer, trusted:Boolean)
      {
         super();
         if(_secureUis[ui])
         {
            throw BeriliaError(ui + " have already been securised, please use getSecureUi() method to get it");
         }
         this._ui = ui;
         this._trusted = trusted;
         _secureUis[ui] = this;
      }
      
      public static function getSecureUi(ui:UiRootContainer, trusted:Boolean = false) : SecureUiRootContainer
      {
         if(!_secureUis[ui])
         {
            _secureUis[ui] = new SecureUiRootContainer(ui,trusted);
         }
         return _secureUis[ui];
      }
      
      override flash_proxy function callProperty(name:*, ... rest) : *
      {
         var param:Array = BoxingUnBoxing.unboxParam(rest);
         var result:* = this._ui[name].apply(this._ui[name],param);
         switch(true)
         {
            case result is DisplayObject:
               result = SecureComponent.getSecureComponent(result,this._trusted);
         }
         return result;
      }
      
      override flash_proxy function getProperty(name:*) : *
      {
         if(!this._ui)
         {
            return null;
         }
         var result:* = this._ui[name];
         switch(true)
         {
            case result is DisplayObject:
               result = SecureComponent.getSecureComponent(result,this._trusted);
         }
         return result;
      }
      
      override flash_proxy function setProperty(name:*, value:*) : void
      {
         this._ui[name] = value;
      }
      
      override flash_proxy function nextNameIndex(index:int) : int
      {
         if(index == 0 && !_properties)
         {
            _properties = DescribeTypeCache.getVariables(this._ui);
         }
         if(index < _properties.length)
         {
            return index + 1;
         }
         return 0;
      }
      
      override flash_proxy function nextName(index:int) : String
      {
         return _properties[index - 1];
      }
      
      restricted_namespace function get object() : UiRootContainer
      {
         return this._ui;
      }
      
      restricted_namespace function destroy() : void
      {
         delete _secureUis[this._ui];
         this._ui = null;
      }
   }
}
