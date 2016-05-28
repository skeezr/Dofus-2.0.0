package com.ankamagames.jerakine.utils.misc
{
   public class CopyObject
   {
       
      public function CopyObject()
      {
         super();
      }
      
      public static function copyObject(o:Object, exclude:Array = null) : Object
      {
         var p:String = null;
         var obj:Object = new Object();
         var properties:Array = DescribeTypeCache.getVariables(o);
         for each(p in properties)
         {
            if(!(Boolean(exclude) && exclude.indexOf(p) != -1))
            {
               obj[p] = o[p];
            }
         }
         return obj;
      }
   }
}
