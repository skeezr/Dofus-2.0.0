package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class RemoveFriendAction implements Action
   {
       
      private var _name:String;
      
      public function RemoveFriendAction()
      {
         super();
      }
      
      public static function create(name:String) : RemoveFriendAction
      {
         var a:RemoveFriendAction = new RemoveFriendAction();
         a._name = name;
         return a;
      }
      
      public function get name() : String
      {
         return this._name;
      }
   }
}
