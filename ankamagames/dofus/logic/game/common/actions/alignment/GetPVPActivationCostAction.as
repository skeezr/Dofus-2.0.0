package com.ankamagames.dofus.logic.game.common.actions.alignment
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GetPVPActivationCostAction implements Action
   {
       
      public function GetPVPActivationCostAction()
      {
         super();
      }
      
      public static function create() : GetPVPActivationCostAction
      {
         var action:GetPVPActivationCostAction = new GetPVPActivationCostAction();
         return action;
      }
   }
}
