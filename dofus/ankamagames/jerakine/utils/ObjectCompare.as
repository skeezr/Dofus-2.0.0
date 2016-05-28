package com.ankamagames.jerakine.utils
{
   import flash.utils.describeType;
   
   public class ObjectCompare
   {
       
      public function ObjectCompare()
      {
         super();
      }
      
      public static function compareObjects(obj1:Object, obj2:Object) : Boolean
      {
         var variable:XML = null;
         var varName:String = null;
         var varType:String = null;
         var xml2:XML = null;
         var isComplexe:* = false;
         if(obj1 == null && obj2 != null || obj2 == null && obj1 != null)
         {
            return false;
         }
         var xml:XML = describeType(obj1);
         var result:* = true;
         for each(variable in xml.variable)
         {
            varName = variable.@name;
            varType = variable.@type;
            if(obj2.hasOwnProperty(varName))
            {
               xml2 = describeType(obj1[varName]);
               isComplexe = (xml2.variable as XMLList).length() > 0;
               if(isComplexe)
               {
                  result = Boolean(compareObjects(obj1[varName],obj2[varName]));
               }
               else
               {
                  result = obj1[varName] == obj2[varName];
               }
               if(!result)
               {
                  return false;
               }
               continue;
            }
            return false;
         }
         return true;
      }
   }
}
