package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class IncreaseSpellLevelAction implements Action
   {
       
      private var _spellId:uint;
      
      public function IncreaseSpellLevelAction()
      {
         super();
      }
      
      public static function create(pSpellId:uint) : IncreaseSpellLevelAction
      {
         var a:IncreaseSpellLevelAction = new IncreaseSpellLevelAction();
         a._spellId = pSpellId;
         return a;
      }
      
      public function get spellId() : uint
      {
         return this._spellId;
      }
   }
}
