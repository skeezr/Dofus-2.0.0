package com.ankamagames.jerakine.utils.misc
{
   import flash.utils.getQualifiedClassName;
   import flash.utils.describeType;
   
   public class DescribeTypeCache
   {
      
      private static var _classDesc:Object = new Object();
      
      private static var _variables:Object = new Object();
       
      public function DescribeTypeCache()
      {
         super();
      }
      
      public static function typeDescription(o:Object) : XML
      {
         var c:String = getQualifiedClassName(o);
         if(!_classDesc[c])
         {
            _classDesc[c] = describeType(o);
         }
         return _classDesc[c];
      }
      
      public static function getVariables(o:Object, onlyVar:Boolean = false) : Array
      {
         var variable:XML = null;
         var accessor:XML = null;
         var c:String = getQualifiedClassName(o);
         if(_variables[c])
         {
            return _variables[c];
         }
         var variables:Array = new Array();
         for each(variable in typeDescription(o)..variable)
         {
            variables.push(variable.@name.toString());
         }
         if(!onlyVar)
         {
            for each(accessor in typeDescription(o)..accessor)
            {
               variables.push(accessor.@name.toString());
            }
         }
         _variables[c] = variables;
         return variables;
      }
   }
}
