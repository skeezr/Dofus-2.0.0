package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class HouseBuyAction implements Action
   {
       
      private var _proposedPrice:uint;
      
      public function HouseBuyAction()
      {
         super();
      }
      
      public static function create(proposedPrice:uint) : HouseBuyAction
      {
         var action:HouseBuyAction = new HouseBuyAction();
         action._proposedPrice = proposedPrice;
         return action;
      }
      
      public function get proposedPrice() : uint
      {
         return this._proposedPrice;
      }
   }
}
