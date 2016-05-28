package com.ankamagames.dofus.logic.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ResetGameAction implements Action
   {
       
      public function ResetGameAction()
      {
         super();
      }
      
      public static function create() : ResetGameAction
      {
         return new ResetGameAction();
      }
   }
}
