package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class OpenCurrentFightAction implements Action
   {
       
      private var _name:String;
      
      public function OpenCurrentFightAction()
      {
         super();
      }
      
      public static function create() : OpenCurrentFightAction
      {
         return new OpenCurrentFightAction();
      }
      
      public function get value() : String
      {
         return this._name;
      }
   }
}
