package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ToggleLockFightAction implements Action
   {
       
      public function ToggleLockFightAction()
      {
         super();
      }
      
      public static function create() : ToggleLockFightAction
      {
         var a:ToggleLockFightAction = new ToggleLockFightAction();
         return a;
      }
   }
}
