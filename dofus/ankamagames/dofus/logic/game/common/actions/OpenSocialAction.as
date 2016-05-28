package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class OpenSocialAction implements Action
   {
       
      public function OpenSocialAction()
      {
         super();
      }
      
      public static function create() : OpenSocialAction
      {
         var a:OpenSocialAction = new OpenSocialAction();
         return a;
      }
   }
}
