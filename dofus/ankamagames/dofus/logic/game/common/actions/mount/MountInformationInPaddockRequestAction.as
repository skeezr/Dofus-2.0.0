package com.ankamagames.dofus.logic.game.common.actions.mount
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class MountInformationInPaddockRequestAction implements Action
   {
       
      private var _mountId:uint;
      
      public function MountInformationInPaddockRequestAction()
      {
         super();
      }
      
      public static function create(mountId:uint) : MountInformationInPaddockRequestAction
      {
         var act:MountInformationInPaddockRequestAction = new MountInformationInPaddockRequestAction();
         act._mountId = mountId;
         return act;
      }
      
      public function get mountId() : uint
      {
         return this._mountId;
      }
   }
}
