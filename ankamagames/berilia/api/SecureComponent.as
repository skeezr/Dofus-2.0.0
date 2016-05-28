package com.ankamagames.berilia.api
{
   import flash.utils.Proxy;
   import com.ankamagames.jerakine.interfaces.Secure;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import flash.utils.flash_proxy;
   import com.ankamagames.jerakine.utils.misc.BoxingUnBoxing;
   import com.ankamagames.berilia.interfaces.IGridRenderer;
   import flash.geom.Transform;
   import flash.text.TextField;
   import com.ankamagames.jerakine.utils.misc.DescribeTypeCache;
   import flash.display.DisplayObject;
   import com.ankamagames.berilia.utils.errors.ApiError;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   
   public class SecureComponent extends Proxy implements Secure
   {
      
      private static var _secureComponents:Dictionary = new Dictionary(true);
       
      private var _component:Object;
      
      private var _trusted:Boolean;
      
      protected var _properties:Array;
      
      public function SecureComponent(component:Object, trusted:Boolean)
      {
         super();
         if(_secureComponents[component])
         {
            throw BeriliaError(component + " have already been securised, please use getSecureComponent() method to get it");
         }
         this._component = component;
         this._trusted = trusted;
         _secureComponents[component] = this;
      }
      
      public static function getSecureComponent(component:Object, trusted:Boolean = false) : SecureComponent
      {
         if(!_secureComponents[component])
         {
            _secureComponents[component] = new SecureComponent(component,trusted);
         }
         return _secureComponents[component];
      }
      
      restricted_namespace static function destroy(component:Object) : void
      {
         if(_secureComponents[component])
         {
            _secureComponents[component]._component = null;
            delete _secureComponents[component];
         }
      }
      
      public function get isNull() : Boolean
      {
         if(this._component)
         {
            if(this._component.hasOwnProperty("isNull"))
            {
               return this._component[this.isNull];
            }
            return false;
         }
         return true;
      }
      
      override flash_proxy function callProperty(name:*, ... rest) : *
      {
         var unboxedParam:Array = BoxingUnBoxing.unboxParam(rest);
         var result:* = this._component[name].apply(this._component[name],unboxedParam);
         return BoxingUnBoxing.box(result);
      }
      
      override flash_proxy function hasProperty(name:*) : Boolean
      {
         return this._component.hasOwnProperty(name);
      }
      
      override flash_proxy function getProperty(name:*) : *
      {
         var prop:* = this._component[name];
         switch(true)
         {
            case prop is IGridRenderer:
            case prop is Transform:
            case prop is TextField:
               return prop;
            default:
               return BoxingUnBoxing.box(prop);
         }
      }
      
      override flash_proxy function setProperty(name:*, value:*) : void
      {
         var realValue:* = BoxingUnBoxing.unbox(value);
         this._component[name] = realValue;
      }
      
      override flash_proxy function nextNameIndex(index:int) : int
      {
         if(index == 0 && !this._properties)
         {
            this._properties = DescribeTypeCache.getVariables(this._component);
         }
         if(index < this._properties.length)
         {
            return index + 1;
         }
         return 0;
      }
      
      override flash_proxy function nextName(index:int) : String
      {
         return this._properties[index - 1];
      }
      
      public function getRealInstance() : DisplayObject
      {
         if(!this._trusted)
         {
            throw new ApiError("You are not allowed to access this item");
         }
         return this._component as DisplayObject;
      }
      
      restricted_namespace function get object() : Object
      {
         return this._component;
      }
   }
}
