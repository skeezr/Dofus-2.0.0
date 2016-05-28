package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildGetInformationsAction implements Action
   {
       
      private var _infoType:uint;
      
      public function GuildGetInformationsAction()
      {
         super();
      }
      
      public static function create(pInfoType:uint) : GuildGetInformationsAction
      {
         var action:GuildGetInformationsAction = new GuildGetInformationsAction();
         action._infoType = pInfoType;
         return action;
      }
      
      public function get infoType() : uint
      {
         return this._infoType;
      }
   }
}
