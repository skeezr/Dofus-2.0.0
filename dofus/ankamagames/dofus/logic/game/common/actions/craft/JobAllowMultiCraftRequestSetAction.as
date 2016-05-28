package com.ankamagames.dofus.logic.game.common.actions.craft
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class JobAllowMultiCraftRequestSetAction implements Action
   {
       
      private var _isPublic:Boolean;
      
      public function JobAllowMultiCraftRequestSetAction()
      {
         super();
      }
      
      public static function create(pIsPublic:Boolean) : JobAllowMultiCraftRequestSetAction
      {
         var action:JobAllowMultiCraftRequestSetAction = new JobAllowMultiCraftRequestSetAction();
         action._isPublic = pIsPublic;
         return action;
      }
      
      public function get isPublic() : Boolean
      {
         return this._isPublic;
      }
   }
}
