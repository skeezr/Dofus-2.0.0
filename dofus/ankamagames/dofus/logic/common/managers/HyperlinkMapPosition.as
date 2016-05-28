package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   
   public class HyperlinkMapPosition
   {
       
      public function HyperlinkMapPosition()
      {
         super();
      }
      
      public static function showPosition(posX:int, posY:int) : void
      {
         KernelEventsManager.getInstance().processCallback(HookList.ArtworkMode,1);
         KernelEventsManager.getInstance().processCallback(HookList.AddMapFlag,"ChatFlag",null,posX,posY,true);
      }
      
      public static function getText(posX:int, posY:int) : String
      {
         return "[" + posX + "," + posY + "]";
      }
   }
}
