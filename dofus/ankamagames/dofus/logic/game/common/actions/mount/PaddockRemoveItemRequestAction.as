package com.ankamagames.dofus.logic.game.common.actions.mount
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PaddockRemoveItemRequestAction implements Action
   {
       
      private var _cellId:uint;
      
      public function PaddockRemoveItemRequestAction()
      {
         super();
      }
      
      public static function create(cellId:uint) : PaddockRemoveItemRequestAction
      {
         var o:PaddockRemoveItemRequestAction = new PaddockRemoveItemRequestAction();
         o._cellId = cellId;
         return o;
      }
      
      public function get cellId() : uint
      {
         return this._cellId;
      }
   }
}
