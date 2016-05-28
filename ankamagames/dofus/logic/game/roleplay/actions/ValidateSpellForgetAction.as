package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ValidateSpellForgetAction implements Action
   {
       
      private var _spellId:uint;
      
      public function ValidateSpellForgetAction()
      {
         super();
      }
      
      public static function create(spellId:uint) : ValidateSpellForgetAction
      {
         var a:ValidateSpellForgetAction = new ValidateSpellForgetAction();
         a._spellId = spellId;
         return a;
      }
      
      public function get spellId() : uint
      {
         return this._spellId;
      }
   }
}
