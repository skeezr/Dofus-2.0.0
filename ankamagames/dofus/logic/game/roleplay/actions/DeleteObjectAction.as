package com.ankamagames.dofus.logic.game.roleplay.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class DeleteObjectAction implements Action
   {
       
      private var _objectUID:uint;
      
      private var _quantity:uint;
      
      public function DeleteObjectAction()
      {
         super();
      }
      
      public static function create(objectUID:uint, quantity:uint) : DeleteObjectAction
      {
         var a:DeleteObjectAction = new DeleteObjectAction();
         a._objectUID = objectUID;
         a._quantity = quantity;
         return a;
      }
      
      public function get objectUID() : uint
      {
         return this._objectUID;
      }
      
      public function get quantity() : uint
      {
         return this._quantity;
      }
   }
}
