package com.ankamagames.dofus.logic.game.approach.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class CharacterRenameSelectionAction implements Action
   {
       
      private var _characterId:int;
      
      private var _characterName:String;
      
      public function CharacterRenameSelectionAction()
      {
         super();
      }
      
      public static function create(characterId:int, characterName:String) : CharacterRenameSelectionAction
      {
         var a:CharacterRenameSelectionAction = new CharacterRenameSelectionAction();
         a._characterId = characterId;
         a._characterName = characterName;
         return a;
      }
      
      public function get characterId() : int
      {
         return this._characterId;
      }
      
      public function get characterName() : String
      {
         return this._characterName;
      }
   }
}
