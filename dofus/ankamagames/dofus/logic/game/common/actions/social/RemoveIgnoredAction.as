package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class RemoveIgnoredAction implements Action
   {
       
      private var _name:String;
      
      public function RemoveIgnoredAction()
      {
         super();
      }
      
      public static function create(name:String) : RemoveIgnoredAction
      {
         var a:RemoveIgnoredAction = new RemoveIgnoredAction();
         a._name = name;
         return a;
      }
      
      public function get name() : String
      {
         return this._name;
      }
   }
}
