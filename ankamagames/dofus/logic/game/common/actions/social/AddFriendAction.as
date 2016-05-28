package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class AddFriendAction implements Action
   {
       
      private var _name:String;
      
      public function AddFriendAction()
      {
         super();
      }
      
      public static function create(name:String) : AddFriendAction
      {
         var a:AddFriendAction = new AddFriendAction();
         a._name = name;
         return a;
      }
      
      public function get name() : String
      {
         return this._name;
      }
   }
}
