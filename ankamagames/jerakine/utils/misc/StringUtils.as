package com.ankamagames.jerakine.utils.misc
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class StringUtils
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(StringUtils));
       
      public function StringUtils()
      {
         super();
      }
      
      public static function cleanString(s:String) : String
      {
         s = s.split("<").join("&lt;");
         s = s.split(">").join("&gt;");
         return s;
      }
      
      public static function fill(str:String, len:uint, char:String, before:Boolean = true) : String
      {
         if(!char || !char.length)
         {
            return str;
         }
         while(str.length != len)
         {
            if(before)
            {
               str = char + str;
            }
            else
            {
               str = str + char;
            }
         }
         return str;
      }
      
      public static function replace(src:String, pFrom:* = null, pTo:* = null) : String
      {
         var i:uint = 0;
         if(!pFrom)
         {
            return src;
         }
         if(!pTo)
         {
            if(pFrom is Array)
            {
               pTo = new Array(pFrom.length);
            }
            else
            {
               return src.split(pFrom).join("");
            }
         }
         if(!(pFrom is Array))
         {
            return src.split(pFrom).join(pTo);
         }
         var lLength:Number = pFrom.length;
         var lString:String = src;
         if(pTo is Array)
         {
            for(i = 0; i < lLength; i++)
            {
               lString = lString.split(pFrom[i]).join(pTo[i]);
            }
         }
         else
         {
            for(i = 0; i < lLength; i++)
            {
               lString = lString.split(pFrom[i]).join(pTo);
            }
         }
         return lString;
      }
   }
}
