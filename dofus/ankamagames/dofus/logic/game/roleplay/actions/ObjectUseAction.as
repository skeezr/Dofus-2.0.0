package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ObjectUseAction implements Action
   {
       
      private var _objectUID:uint;
      
      private var _useOnCell:Boolean;
      
      public function ObjectUseAction()
      {
         super();
      }
      
      public static function create(objectUID:uint, useOnCell:Boolean = false) : ObjectUseAction
      {
         var a:ObjectUseAction = new ObjectUseAction();
         a._objectUID = objectUID;
         a._useOnCell = useOnCell;
         return a;
      }
      
      public function get objectUID() : uint
      {
         return this._objectUID;
      }
      
      public function get useOnCell() : Boolean
      {
         return this._useOnCell;
      }
   }
}
