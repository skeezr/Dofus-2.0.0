package com.ankamagames.dofus.logic.game.approach.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class CharacterSelectionAction implements Action
   {
       
      private var _characterId:int;
      
      private var _btutoriel:Boolean;
      
      public function CharacterSelectionAction()
      {
         super();
      }
      
      public static function create(characterId:int, btutoriel:Boolean) : CharacterSelectionAction
      {
         var a:CharacterSelectionAction = new CharacterSelectionAction();
         a._characterId = characterId;
         a._btutoriel = btutoriel;
         return a;
      }
      
      public function get characterId() : int
      {
         return this._characterId;
      }
      
      public function get btutoriel() : Boolean
      {
         return this._btutoriel;
      }
   }
}
