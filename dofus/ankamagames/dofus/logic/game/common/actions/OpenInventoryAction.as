package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class OpenInventoryAction implements Action
   {
       
      public function OpenInventoryAction()
      {
         super();
      }
      
      public static function create() : OpenInventoryAction
      {
         var a:OpenInventoryAction = new OpenInventoryAction();
         return a;
      }
   }
}
