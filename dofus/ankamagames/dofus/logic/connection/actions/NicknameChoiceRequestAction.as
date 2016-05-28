package com.ankamagames.dofus.logic.connection.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class NicknameChoiceRequestAction implements Action
   {
       
      private var _nickname:String;
      
      public function NicknameChoiceRequestAction()
      {
         super();
      }
      
      public static function create(nickname:String) : NicknameChoiceRequestAction
      {
         var a:NicknameChoiceRequestAction = new NicknameChoiceRequestAction();
         a._nickname = nickname;
         return a;
      }
      
      public function get nickname() : String
      {
         return this._nickname;
      }
   }
}
