package com.ankamagames.dofus.types
{
   import com.ankamagames.jerakine.managers.OptionManager;
   
   public dynamic class DofusOptions extends OptionManager
   {
       
      public function DofusOptions()
      {
         super("dofus");
         add("showEveryMonsters",false);
         add("turnPicture",true);
         add("mapCoordinates",true);
         add("showEntityInfos",true);
         add("showMovementRange",true);
         add("showLineOfSight",true);
         add("remindTurn",true);
         add("confirmItemDrop",true);
         add("confirmBeforeUnknownCraft",true);
         add("switchUiSkin",0);
         add("allowBannerShortcuts",true);
         add("dofusQuality",1);
         add("showNotifications",true);
         add("showUsedPaPm",false);
         add("allowSpellEffects",true);
         add("allowHitAnim",true);
      }
   }
}
