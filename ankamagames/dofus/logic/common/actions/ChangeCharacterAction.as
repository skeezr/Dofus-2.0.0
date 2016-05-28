package com.ankamagames.dofus.logic.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ChangeCharacterAction implements Action
   {
       
      private var _serverId:uint;
      
      public function ChangeCharacterAction()
      {
         super();
      }
      
      public static function create(serverId:uint) : ChangeCharacterAction
      {
         var a:ChangeCharacterAction = new ChangeCharacterAction();
         a._serverId = serverId;
         return a;
      }
      
      public function get serverId() : uint
      {
         return this._serverId;
      }
   }
}
