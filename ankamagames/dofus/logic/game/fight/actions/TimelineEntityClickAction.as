package com.ankamagames.dofus.logic.game.fight.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class TimelineEntityClickAction implements Action
   {
       
      private var _cellId:int;
      
      public function TimelineEntityClickAction()
      {
         super();
      }
      
      public static function create(cell:int) : TimelineEntityClickAction
      {
         var a:TimelineEntityClickAction = new TimelineEntityClickAction();
         a._cellId = cell;
         return a;
      }
      
      public function get cellId() : int
      {
         return this._cellId;
      }
   }
}
