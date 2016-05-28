package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class OpenSmileysAction implements Action
   {
       
      public function OpenSmileysAction()
      {
         super();
      }
      
      public static function create() : OpenSmileysAction
      {
         var a:OpenSmileysAction = new OpenSmileysAction();
         return a;
      }
   }
}
