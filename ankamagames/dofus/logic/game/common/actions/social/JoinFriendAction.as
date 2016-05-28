package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class JoinFriendAction implements Action
   {
       
      private var _name:String;
      
      public function JoinFriendAction()
      {
         super();
      }
      
      public static function create(name:String) : JoinFriendAction
      {
         var a:JoinFriendAction = new JoinFriendAction();
         a._name = name;
         return a;
      }
      
      public function get name() : String
      {
         return this._name;
      }
   }
}
