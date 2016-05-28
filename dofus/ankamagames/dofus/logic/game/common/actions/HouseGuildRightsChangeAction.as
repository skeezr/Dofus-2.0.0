package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HouseGuildRightsChangeAction implements Action
   {
       
      private var _rights:int;
      
      public function HouseGuildRightsChangeAction()
      {
         super();
      }
      
      public static function create(rights:int) : HouseGuildRightsChangeAction
      {
         var action:HouseGuildRightsChangeAction = new HouseGuildRightsChangeAction();
         action._rights = rights;
         return action;
      }
      
      public function get rights() : int
      {
         return this._rights;
      }
   }
}
