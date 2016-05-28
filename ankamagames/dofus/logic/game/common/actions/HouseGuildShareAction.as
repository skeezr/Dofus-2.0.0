package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HouseGuildShareAction implements Action
   {
       
      private var _enabled:Boolean;
      
      public function HouseGuildShareAction()
      {
         super();
      }
      
      public static function create(enabled:Boolean) : HouseGuildShareAction
      {
         var action:HouseGuildShareAction = new HouseGuildShareAction();
         action._enabled = enabled;
         return action;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
   }
}
