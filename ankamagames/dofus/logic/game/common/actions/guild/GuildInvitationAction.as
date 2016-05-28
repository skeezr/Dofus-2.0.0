package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildInvitationAction implements Action
   {
       
      private var _targetId:uint;
      
      public function GuildInvitationAction()
      {
         super();
      }
      
      public static function create(pTargetId:uint) : GuildInvitationAction
      {
         var action:GuildInvitationAction = new GuildInvitationAction();
         action._targetId = pTargetId;
         return action;
      }
      
      public function get targetId() : uint
      {
         return this._targetId;
      }
   }
}
