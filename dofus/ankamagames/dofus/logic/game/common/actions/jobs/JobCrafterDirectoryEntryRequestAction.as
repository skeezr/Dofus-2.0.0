package com.ankamagames.dofus.logic.game.common.actions.jobs
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class JobCrafterDirectoryEntryRequestAction implements Action
   {
       
      private var _playerId:uint;
      
      public function JobCrafterDirectoryEntryRequestAction()
      {
         super();
      }
      
      public static function create(playerId:uint) : JobCrafterDirectoryEntryRequestAction
      {
         var act:JobCrafterDirectoryEntryRequestAction = new JobCrafterDirectoryEntryRequestAction();
         act._playerId = playerId;
         return act;
      }
      
      public function get playerId() : uint
      {
         return this._playerId;
      }
   }
}
