package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class SpellSetPositionAction implements Action
   {
       
      private var _spellID:uint;
      
      private var _position:uint;
      
      public function SpellSetPositionAction()
      {
         super();
      }
      
      public static function create(spellID:uint, position:uint) : SpellSetPositionAction
      {
         var a:SpellSetPositionAction = new SpellSetPositionAction();
         a._spellID = spellID;
         a._position = position;
         return a;
      }
      
      public function get spellID() : uint
      {
         return this._spellID;
      }
      
      public function get position() : uint
      {
         return this._position;
      }
   }
}
