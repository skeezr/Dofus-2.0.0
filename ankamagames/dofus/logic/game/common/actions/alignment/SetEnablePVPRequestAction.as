package com.ankamagames.dofus.logic.game.common.actions.alignment
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class SetEnablePVPRequestAction implements Action
   {
       
      private var _enable:Boolean;
      
      public function SetEnablePVPRequestAction()
      {
         super();
      }
      
      public static function create(enable:Boolean) : SetEnablePVPRequestAction
      {
         var action:SetEnablePVPRequestAction = new SetEnablePVPRequestAction();
         action._enable = enable;
         return action;
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
   }
}
