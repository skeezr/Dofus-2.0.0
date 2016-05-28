package com.ankamagames.jerakine.types.enums
{
   public final class BuildTypeEnum
   {
      
      public static const DEBUG:uint = 5;
      
      public static const INTERNAL:uint = 4;
      
      public static const TESTING:uint = 3;
      
      public static const ALPHA:uint = 2;
      
      public static const BETA:uint = 1;
      
      public static const RELEASE:uint = 0;
       
      public function BuildTypeEnum()
      {
         super();
      }
      
      public static function getTypeName(type:uint) : String
      {
         switch(type)
         {
            case RELEASE:
               return "RELEASE";
            case BETA:
               return "BETA";
            case ALPHA:
               return "ALPHA";
            case TESTING:
               return "TESTING";
            case INTERNAL:
               return "INTERNAL";
            case DEBUG:
               return "DEBUG";
            default:
               return "UNKNOWN";
         }
      }
   }
}
