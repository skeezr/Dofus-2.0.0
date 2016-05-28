package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class AddIgnoredAction implements Action
   {
       
      private var _name:String;
      
      public function AddIgnoredAction()
      {
         super();
      }
      
      public static function create(name:String) : AddIgnoredAction
      {
         var a:AddIgnoredAction = new AddIgnoredAction();
         a._name = name;
         return a;
      }
      
      public function get name() : String
      {
         return this._name;
      }
   }
}
