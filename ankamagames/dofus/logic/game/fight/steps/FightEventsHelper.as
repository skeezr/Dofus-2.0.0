package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   
   public class FightEventsHelper
   {
       
      public function FightEventsHelper()
      {
         super();
      }
      
      public static function sendFightEvent(fightEventName:String, fightEventParams:Array) : void
      {
         KernelEventsManager.getInstance().processCallback(HookList.FightEvent,fightEventName,fightEventParams);
      }
   }
}
