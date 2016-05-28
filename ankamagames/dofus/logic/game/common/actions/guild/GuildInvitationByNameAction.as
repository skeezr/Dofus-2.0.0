package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildInvitationByNameAction implements Action
   {
       
      private var _target:String;
      
      public function GuildInvitationByNameAction()
      {
         super();
      }
      
      public static function create(pTarget:String) : GuildInvitationByNameAction
      {
         var action:GuildInvitationByNameAction = new GuildInvitationByNameAction();
         action._target = pTarget;
         return action;
      }
      
      public function get target() : String
      {
         return this._target;
      }
   }
}
