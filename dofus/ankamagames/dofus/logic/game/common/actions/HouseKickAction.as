package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HouseKickAction implements Action
   {
       
      private var _id:uint;
      
      public function HouseKickAction()
      {
         super();
      }
      
      public static function create(id:uint) : HouseKickAction
      {
         var action:HouseKickAction = new HouseKickAction();
         action._id = id;
         return action;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
   }
}
