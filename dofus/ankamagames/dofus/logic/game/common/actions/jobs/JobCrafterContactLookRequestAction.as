package com.ankamagames.dofus.logic.game.common.actions.jobs
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class JobCrafterContactLookRequestAction implements Action
   {
       
      private var _crafterId:uint;
      
      public function JobCrafterContactLookRequestAction()
      {
         super();
      }
      
      public static function create(crafterId:uint) : JobCrafterContactLookRequestAction
      {
         var act:JobCrafterContactLookRequestAction = new JobCrafterContactLookRequestAction();
         act._crafterId = crafterId;
         return act;
      }
      
      public function get crafterId() : uint
      {
         return this._crafterId;
      }
   }
}
