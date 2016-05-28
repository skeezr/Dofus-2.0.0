package com.ankamagames.dofus.logic.connection.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ServerSelectionAction implements Action
   {
       
      private var _serverId:int;
      
      public function ServerSelectionAction()
      {
         super();
      }
      
      public static function create(serverId:int) : ServerSelectionAction
      {
         var a:ServerSelectionAction = new ServerSelectionAction();
         a._serverId = serverId;
         return a;
      }
      
      public function get serverId() : int
      {
         return this._serverId;
      }
   }
}
