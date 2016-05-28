package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GameFightSpellCastAction implements Action
   {
       
      private var _spellId:uint;
      
      public function GameFightSpellCastAction()
      {
         super();
      }
      
      public static function create(spellId:uint) : GameFightSpellCastAction
      {
         var a:GameFightSpellCastAction = new GameFightSpellCastAction();
         a._spellId = spellId;
         return a;
      }
      
      public function get spellId() : uint
      {
         return this._spellId;
      }
   }
}
