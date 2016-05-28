package com.ankamagames.dofus.misc
{
   import com.ankamagames.jerakine.data.DataUpdateManager;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.jerakine.data.GameData;
   
   public class I18nProxyConfig
   {
       
      public function I18nProxyConfig()
      {
         super();
      }
      
      public static function init() : void
      {
         if(DataUpdateManager.SQL_MODE)
         {
            I18nProxy.init(GameData.getObject("I18nProxy",1));
         }
         else
         {
            I18nProxy.init(GameData.getObject("I18nProxy",0));
         }
      }
   }
}
