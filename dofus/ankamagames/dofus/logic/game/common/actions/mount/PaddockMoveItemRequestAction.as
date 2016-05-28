package com.ankamagames.dofus.logic.game.common.actions.mount
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PaddockMoveItemRequestAction implements Action
   {
       
      private var _object:Object;
      
      public function PaddockMoveItemRequestAction()
      {
         super();
      }
      
      public static function create(object:Object) : PaddockMoveItemRequestAction
      {
         var o:PaddockMoveItemRequestAction = new PaddockMoveItemRequestAction();
         o._object = object;
         return o;
      }
      
      public function get object() : Object
      {
         return this._object;
      }
   }
}
