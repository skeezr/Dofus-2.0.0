package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class TimelineEntityOverAction implements Action
   {
       
      private var _targetId:int;
      
      public function TimelineEntityOverAction()
      {
         super();
      }
      
      public static function create(target:int) : TimelineEntityOverAction
      {
         var a:TimelineEntityOverAction = new TimelineEntityOverAction();
         a._targetId = target;
         return a;
      }
      
      public function get targetId() : int
      {
         return this._targetId;
      }
   }
}
