package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class OpenBookAction implements Action
   {
       
      private var _name:String;
      
      public function OpenBookAction()
      {
         super();
      }
      
      public static function create() : OpenBookAction
      {
         return new OpenBookAction();
      }
      
      public function get value() : String
      {
         return this._name;
      }
   }
}
