package com.ankamagames.dofus.logic.game.approach.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class CharacterDeletionAction implements Action
   {
       
      private var _id:int;
      
      private var _answer:String;
      
      public function CharacterDeletionAction()
      {
         super();
      }
      
      public static function create(id:int, answer:String) : CharacterDeletionAction
      {
         var a:CharacterDeletionAction = new CharacterDeletionAction();
         a._id = id;
         a._answer = answer;
         return a;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get answer() : String
      {
         return this._answer;
      }
   }
}
