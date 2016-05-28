package com.ankamagames.dofus.logic.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ChangeWorldInteractionAction implements Action
   {
       
      private var _enabled:Boolean;
      
      public function ChangeWorldInteractionAction()
      {
         super();
      }
      
      public static function create(enabled:Boolean) : ChangeWorldInteractionAction
      {
         var a:ChangeWorldInteractionAction = new ChangeWorldInteractionAction();
         a._enabled = enabled;
         return a;
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
   }
}
