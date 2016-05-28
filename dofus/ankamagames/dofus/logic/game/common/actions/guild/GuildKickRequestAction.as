package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildKickRequestAction implements Action
   {
       
      private var _targetId:uint;
      
      public function GuildKickRequestAction()
      {
         super();
      }
      
      public static function create(pTargetId:uint) : GuildKickRequestAction
      {
         var action:GuildKickRequestAction = new GuildKickRequestAction();
         action._targetId = pTargetId;
         return action;
      }
      
      public function get targetId() : uint
      {
         return this._targetId;
      }
   }
}
