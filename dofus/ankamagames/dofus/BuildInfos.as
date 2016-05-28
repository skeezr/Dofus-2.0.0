package com.ankamagames.dofus
{
   import com.ankamagames.jerakine.types.Version;
   import com.ankamagames.jerakine.types.enums.BuildTypeEnum;
   
   public final class BuildInfos
   {
      
      public static const BUILD_VERSION:Version = new Version(2,0,0);
      
      public static var BUILD_TYPE:uint = BuildTypeEnum.TESTING;
      
      public static const BUILD_REVISION:int = 22554;
      
      public static const BUILD_DATE:String = "Nov 12, 2009 - 15:24:56 CET";
       
      public function BuildInfos()
      {
         super();
      }
   }
}
