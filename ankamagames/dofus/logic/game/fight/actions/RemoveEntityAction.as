package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class RemoveEntityAction implements Action
   {
       
      private var _actorId:int;
      
      public function RemoveEntityAction()
      {
         super();
      }
      
      public static function create(actorId:int) : RemoveEntityAction
      {
         var o:RemoveEntityAction = new RemoveEntityAction();
         o._actorId = actorId;
         return o;
      }
      
      public function get actorId() : int
      {
         return this._actorId;
      }
   }
}
