package com.ankamagames.jerakine.utils.files
{
   public class FileUtils
   {
       
      public function FileUtils()
      {
         super();
      }
      
      public static function getExtension(sUrl:String) : String
      {
         var aTmp:Array = sUrl.split(".");
         if(aTmp.length > 1)
         {
            return aTmp[aTmp.length - 1];
         }
         return null;
      }
      
      public static function getFileName(sUrl:String) : String
      {
         var aTmp:Array = sUrl.split("/");
         return aTmp[aTmp.length - 1];
      }
      
      public static function getFilePath(sUrl:String) : String
      {
         var aTmp:Array = sUrl.split("/");
         aTmp.pop();
         return aTmp.join("/");
      }
      
      public static function getFilePathStartName(sUrl:String) : String
      {
         var aTmp:Array = sUrl.split(".");
         aTmp.pop();
         return aTmp.join(".");
      }
      
      public static function getFileStartName(sUrl:String) : String
      {
         var aTmp:Array = sUrl.split("/");
         aTmp = aTmp[aTmp.length - 1].split(".");
         aTmp.pop();
         return aTmp.join(".");
      }
   }
}
