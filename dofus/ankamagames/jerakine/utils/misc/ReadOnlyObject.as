package com.ankamagames.jerakine.utils.misc
{
   import flash.utils.Proxy;
   import com.ankamagames.jerakine.interfaces.Secure;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.flash_proxy;
   import com.ankamagames.jerakine.interfaces.ISecurizable;
   
   public class ReadOnlyObject extends Proxy implements Secure
   {
      
      private static const _createdObjectProperties:Dictionary = new Dictionary(true);
      
      private static const _createdObject:Dictionary = new Dictionary(true);
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(ReadOnlyObject));
       
      private var _object:Object;
      
      private var _getQualifiedClassName:String;
      
      private var _properties:Array;
      
      private var _simplyfiedQualifiedClassName:String;
      
      public function ReadOnlyObject(o:Object)
      {
         super();
         this._object = o;
         this._getQualifiedClassName = getQualifiedClassName(o);
         if(!(this._properties && (o is Array || o is Vector.<*>)))
         {
            if(_createdObjectProperties[this._getQualifiedClassName])
            {
               return;
            }
            _createdObjectProperties[this._getQualifiedClassName] = DescribeTypeCache.getVariables(this._object);
            this._properties = _createdObjectProperties[this._getQualifiedClassName];
         }
      }
      
      public static function create(o:Object) : ReadOnlyObject
      {
         if(_createdObject[o])
         {
            return _createdObject[o];
         }
         _createdObject[o] = new ReadOnlyObject(o);
         return _createdObject[o];
      }
      
      restricted_namespace static function unSecure(o:Object) : *
      {
         return o is ReadOnlyObject?ReadOnlyObject(o).restricted_namespace::object:o;
      }
      
      public function get simplyfiedQualifiedClassName() : String
      {
         var splitedClassName:Array = null;
         if(this._simplyfiedQualifiedClassName == null)
         {
            splitedClassName = this._getQualifiedClassName.split("::");
            this._simplyfiedQualifiedClassName = splitedClassName[splitedClassName.length - 1];
         }
         return this._simplyfiedQualifiedClassName;
      }
      
      restricted_namespace function get object() : *
      {
         return this._object;
      }
      
      override flash_proxy function callProperty(name:*, ... rest) : *
      {
         switch(QName(name).localName)
         {
            case "toString":
               if(this._object.hasOwnProperty("toString"))
               {
                  return CallWithParameters.callR(this._object.toString,rest);
               }
               return this._object + "";
            case "hasOwnProperty":
               return CallWithParameters.callR(this._object.hasOwnProperty,rest);
            case "propertyIsEnumerable":
               return CallWithParameters.callR(this._object.propertyIsEnumerable,rest);
            case "indexOf":
               if(this._object is Array || this._object is Dictionary)
               {
                  return CallWithParameters.callR(this._object.indexOf,rest);
               }
               _log.error("Try to use \'indexOf\' method on a simple ReadOnlyObject.");
               return null;
            default:
               try
               {
                  throw new Error();
               }
               catch(e:Error)
               {
                  if(e.getStackTrace())
                  {
                     _log.error("Cannot call method on ReadOnlyObject : " + name + ", " + e.getStackTrace().split("at ")[2]);
                  }
                  else
                  {
                     _log.error("Cannot call method on ReadOnlyObject : " + name + ", no stack trace available");
                  }
               }
               return null;
         }
      }
      
      override flash_proxy function getProperty(name:*) : *
      {
         if(this._object[name] === null)
         {
            return null;
         }
         var o:* = this._object[name];
         switch(true)
         {
            case o == null:
            case o is uint:
            case o is int:
            case o is Number:
            case o is String:
            case o is Boolean:
            case o == undefined:
            case o is Secure:
               return o;
            case o is ISecurizable:
               return (o as ISecurizable).getSecureObject();
            default:
               return create(o);
         }
      }
      
      override flash_proxy function nextNameIndex(index:int) : int
      {
         var x:* = undefined;
         if(index == 0 && (this._object is Array || this._object is Vector.<*> || this._object is Vector.<uint> || this._object is Vector.<int> || this._object is Vector.<Number> || this._object is Vector.<Boolean>))
         {
            this._properties = new Array();
            for(x in this._object)
            {
               this._properties.push(x);
            }
         }
         if(index < this._properties.length)
         {
            return index + 1;
         }
         return 0;
      }
      
      override flash_proxy function nextValue(index:int) : *
      {
         var prop:* = this._properties[index - 1];
         var o:* = this._object[prop];
         switch(true)
         {
            case o == null:
            case o is uint:
            case o is int:
            case o is Number:
            case o is String:
            case o is Boolean:
            case o == undefined:
            case o is Secure:
               return o;
            case o is ISecurizable:
               return (o as ISecurizable).getSecureObject();
            default:
               return create(o);
         }
      }
      
      override flash_proxy function nextName(index:int) : String
      {
         return this._properties[index - 1];
      }
      
      override flash_proxy function setProperty(name:*, value:*) : void
      {
         try
         {
            _log.debug("Ou pas");
            throw new Error();
         }
         catch(e:Error)
         {
            if(e.getStackTrace())
            {
               _log.error("Cannot set property on ReadOnlyObject : " + name + ", " + e.getStackTrace().split("at ")[2]);
            }
            else
            {
               _log.error("Cannot set property on ReadOnlyObject : " + name + ", no stack trace available");
            }
         }
      }
      
      override flash_proxy function hasProperty(name:*) : Boolean
      {
         return this._object.hasOwnProperty(name);
      }
   }
}
