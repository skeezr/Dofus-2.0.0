package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class TimelineEntityOutAction implements Action
   {
       
      private var _targetId:int;
      
      public function TimelineEntityOutAction()
      {
         super();
      }
      
      public static function create(target:int) : TimelineEntityOutAction
      {
         var a:TimelineEntityOutAction = new TimelineEntityOutAction();
         a._targetId = target;
         return a;
      }
      
      public function get targetId() : int
      {
         return this._targetId;
      }
   }
}
