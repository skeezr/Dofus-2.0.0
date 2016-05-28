package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ObjectDropAction implements Action
   {
       
      private var _objectUID:uint;
      
      private var _objectGID:uint;
      
      private var _quantity:uint;
      
      public function ObjectDropAction()
      {
         super();
      }
      
      public static function create(pObjectUID:uint, pObjectGID:uint, pQuantity:uint) : ObjectDropAction
      {
         var a:ObjectDropAction = new ObjectDropAction();
         a._objectUID = pObjectUID;
         a._objectGID = pObjectGID;
         a._quantity = pQuantity;
         return a;
      }
      
      public function get objectUID() : uint
      {
         return this._objectUID;
      }
      
      public function get objectGID() : uint
      {
         return this._objectGID;
      }
      
      public function get quantity() : uint
      {
         return this._quantity;
      }
   }
}
