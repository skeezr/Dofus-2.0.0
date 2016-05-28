package com.ankamagames.dofus.logic.game.approach.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class CharacterRecolorSelectionAction implements Action
   {
       
      private var _characterId:int;
      
      private var _characterColors:Array;
      
      public function CharacterRecolorSelectionAction()
      {
         super();
      }
      
      public static function create(characterId:int, characterColors:Array) : CharacterRecolorSelectionAction
      {
         var a:CharacterRecolorSelectionAction = new CharacterRecolorSelectionAction();
         a._characterId = characterId;
         a._characterColors = characterColors;
         return a;
      }
      
      public function get characterId() : int
      {
         return this._characterId;
      }
      
      public function get characterColors() : Array
      {
         return this._characterColors;
      }
   }
}
