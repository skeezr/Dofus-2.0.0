package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class OpenFriendsAction implements Action
   {
       
      private var _name:String;
      
      public function OpenFriendsAction()
      {
         super();
      }
      
      public static function create() : OpenFriendsAction
      {
         return new OpenFriendsAction();
      }
      
      public function get value() : String
      {
         return this._name;
      }
   }
}
