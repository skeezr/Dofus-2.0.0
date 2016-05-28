package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildInvitationAnswerAction implements Action
   {
       
      private var _accept:Boolean;
      
      public function GuildInvitationAnswerAction()
      {
         super();
      }
      
      public static function create(pAccept:Boolean) : GuildInvitationAnswerAction
      {
         var action:GuildInvitationAnswerAction = new GuildInvitationAnswerAction();
         action._accept = pAccept;
         return action;
      }
      
      public function get accept() : Boolean
      {
         return this._accept;
      }
   }
}
