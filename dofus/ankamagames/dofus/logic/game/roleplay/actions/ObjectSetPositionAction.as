package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ObjectSetPositionAction implements Action
   {
       
      private var _objectUID:uint;
      
      private var _position:uint;
      
      private var _quantity:uint = 1;
      
      public function ObjectSetPositionAction()
      {
         super();
      }
      
      public static function create(objectUID:uint, position:uint, quantity:uint = 1) : ObjectSetPositionAction
      {
         var a:ObjectSetPositionAction = new ObjectSetPositionAction();
         a._objectUID = objectUID;
         a._quantity = quantity;
         a._position = position;
         return a;
      }
      
      public function get objectUID() : uint
      {
         return this._objectUID;
      }
      
      public function get position() : uint
      {
         return this._position;
      }
      
      public function get quantity() : uint
      {
         return this._quantity;
      }
   }
}
