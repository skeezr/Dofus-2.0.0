package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PlayerFightFriendlyAnswerAction implements Action
   {
       
      private var _accept:Boolean;
      
      public function PlayerFightFriendlyAnswerAction()
      {
         super();
      }
      
      public static function create(accept:Boolean = true) : PlayerFightFriendlyAnswerAction
      {
         var o:PlayerFightFriendlyAnswerAction = new PlayerFightFriendlyAnswerAction();
         o._accept = accept;
         return o;
      }
      
      public function get accept() : Boolean
      {
         return this._accept;
      }
   }
}
