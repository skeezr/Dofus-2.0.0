package com.ankamagames.dofus.logic.game.approach.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class CharacterReplayWithRecolorRequestAction implements Action
   {
       
      private var _characterId:uint;
      
      private var _characterColors:Array;
      
      public function CharacterReplayWithRecolorRequestAction()
      {
         super();
      }
      
      public static function create(characterId:uint, characterColors:Array) : CharacterReplayWithRecolorRequestAction
      {
         var a:CharacterReplayWithRecolorRequestAction = new CharacterReplayWithRecolorRequestAction();
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
