package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildCharacsUpgradeRequestAction implements Action
   {
       
      private var _charaTypeTarget:uint;
      
      public function GuildCharacsUpgradeRequestAction()
      {
         super();
      }
      
      public static function create(pCharaTypeTarget:uint) : GuildCharacsUpgradeRequestAction
      {
         var action:GuildCharacsUpgradeRequestAction = new GuildCharacsUpgradeRequestAction();
         action._charaTypeTarget = pCharaTypeTarget;
         return action;
      }
      
      public function get charaTypeTarget() : uint
      {
         return this._charaTypeTarget;
      }
   }
}
