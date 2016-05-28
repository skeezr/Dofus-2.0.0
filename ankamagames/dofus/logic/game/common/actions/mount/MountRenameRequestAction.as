package com.ankamagames.dofus.logic.game.common.actions.mount
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class MountRenameRequestAction implements Action
   {
       
      private var _newName:String;
      
      private var _mountId:Number;
      
      public function MountRenameRequestAction()
      {
         super();
      }
      
      public static function create(newName:String, mountId:Number) : MountRenameRequestAction
      {
         var o:MountRenameRequestAction = new MountRenameRequestAction();
         o._newName = newName;
         o._mountId = mountId;
         return o;
      }
      
      public function get newName() : String
      {
         return this._newName;
      }
      
      public function get mountId() : Number
      {
         return this._mountId;
      }
   }
}
