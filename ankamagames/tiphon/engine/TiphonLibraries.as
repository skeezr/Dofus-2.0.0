package com.ankamagames.tiphon.engine
{
   public class TiphonLibraries
   {
      
      public static const skullLibrary:com.ankamagames.tiphon.engine.LibrariesManager = new com.ankamagames.tiphon.engine.LibrariesManager("skullLibrary",com.ankamagames.tiphon.engine.LibrariesManager.TYPE_BONE);
      
      public static const skinLibrary:com.ankamagames.tiphon.engine.LibrariesManager = new com.ankamagames.tiphon.engine.LibrariesManager("skinLibrary",com.ankamagames.tiphon.engine.LibrariesManager.TYPE_SKIN);
       
      public function TiphonLibraries()
      {
         super();
      }
   }
}
