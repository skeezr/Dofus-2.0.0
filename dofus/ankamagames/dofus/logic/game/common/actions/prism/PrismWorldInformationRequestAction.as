package com.ankamagames.dofus.logic.game.common.actions.prism
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class PrismWorldInformationRequestAction implements Action
   {
       
      private var _join:Boolean;
      
      public function PrismWorldInformationRequestAction()
      {
         super();
      }
      
      public static function create(join:Boolean) : PrismWorldInformationRequestAction
      {
         var action:PrismWorldInformationRequestAction = new PrismWorldInformationRequestAction();
         action._join = join;
         return action;
      }
      
      public function get join() : Boolean
      {
         return this._join;
      }
   }
}
