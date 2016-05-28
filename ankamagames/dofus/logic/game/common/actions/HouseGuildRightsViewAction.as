package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HouseGuildRightsViewAction implements Action
   {
       
      public function HouseGuildRightsViewAction()
      {
         super();
      }
      
      public static function create() : HouseGuildRightsViewAction
      {
         var action:HouseGuildRightsViewAction = new HouseGuildRightsViewAction();
         return action;
      }
   }
}
