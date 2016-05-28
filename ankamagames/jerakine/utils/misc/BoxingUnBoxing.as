package com.ankamagames.jerakine.utils.misc
{
   import com.ankamagames.jerakine.interfaces.Secure;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.jerakine.interfaces.ISecurizable;
   import com.ankamagames.jerakine.interfaces.INoBoxing;
   
   public class BoxingUnBoxing
   {
       
      public function BoxingUnBoxing()
      {
         super();
      }
      
      public static function getBoxingFunction(f:Function) : Function
      {
         return function(... args):*
         {
            var arg:* = undefined;
            var unboxedParam:* = new Array();
            var nb:* = args.length;
            for(var i:* = 0; i < nb; i++)
            {
               arg = args[i];
               if(arg is Secure)
               {
                  unboxedParam[i] = arg.restricted_namespace::object;
               }
               else
               {
                  unboxedParam[i] = arg;
               }
            }
            var result:* = CallWithParameters.callR(f,unboxedParam);
            switch(true)
            {
               case result == null:
               case result is uint:
               case result is int:
               case result is Number:
               case result is String:
               case result is Boolean:
               case result == undefined:
               case result is Secure:
                  return result;
               case result is ISecurizable:
                  return ISecurizable(result).getSecureObject();
               default:
                  return ReadOnlyObject.create(result);
            }
         };
      }
      
      public static function getUnboxingFunction(f:Function) : Function
      {
         return function(... args):*
         {
            var boxedParam:* = boxParam(args);
            var result:* = CallWithParameters.callR(f,boxedParam);
            return unbox(result);
         };
      }
      
      public static function boxParam(param:Array) : Array
      {
         var p:* = undefined;
         var boxedParam:Array = new Array();
         for(var i:uint = 0; i < param.length; i++)
         {
            p = param[i];
            switch(true)
            {
               case p == null:
               case p is uint:
               case p is int:
               case p is Number:
               case p is String:
               case p is Boolean:
               case p == undefined:
               case p is Secure:
                  boxedParam[i] = p;
                  break;
               case p is ISecurizable:
                  boxedParam[i] = ISecurizable(p).getSecureObject();
                  break;
               default:
                  boxedParam[i] = ReadOnlyObject.create(p);
            }
         }
         return boxedParam;
      }
      
      public static function unboxParam(param:Array) : Array
      {
         var unboxedParam:Array = new Array();
         for(var i:uint = 0; i < param.length; i++)
         {
            unboxedParam[i] = unbox(param[i]);
         }
         return unboxedParam;
      }
      
      public static function box(object:*) : *
      {
         switch(true)
         {
            case object == null:
            case object is uint:
            case object is int:
            case object is Number:
            case object is String:
            case object is Boolean:
            case object == undefined:
            case object is Secure:
               return object;
            case object is ISecurizable:
               return ISecurizable(object).getSecureObject();
            default:
               return ReadOnlyObject.create(object);
         }
      }
      
      public static function unbox(object:*) : *
      {
         if(object is Secure && !(object is INoBoxing))
         {
            return object.restricted_namespace::object;
         }
         return object;
      }
   }
}
