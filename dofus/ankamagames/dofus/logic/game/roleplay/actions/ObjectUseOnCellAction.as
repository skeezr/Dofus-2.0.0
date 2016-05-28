package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ObjectUseOnCellAction implements Action
   {
       
      private var _targetedCell:uint;
      
      private var _objectUID:uint;
      
      public function ObjectUseOnCellAction()
      {
         super();
      }
      
      public static function create(objectUID:uint, targetedCell:uint) : ObjectUseOnCellAction
      {
         var o:ObjectUseOnCellAction = new ObjectUseOnCellAction();
         o._targetedCell = targetedCell;
         o._objectUID = objectUID;
         return o;
      }
      
      public function get targetedCell() : uint
      {
         return this._targetedCell;
      }
      
      public function get objectUID() : uint
      {
         return this._objectUID;
      }
   }
}
