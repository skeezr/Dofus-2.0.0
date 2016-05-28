package com.ankamagames.dofus.logic.game.common.actions.social
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class CharacterReportAction implements Action
   {
       
      private var _reportedId:uint;
      
      private var _reason:uint;
      
      public function CharacterReportAction()
      {
         super();
      }
      
      public static function create(reportedId:uint, reason:uint) : CharacterReportAction
      {
         var a:CharacterReportAction = new CharacterReportAction();
         a._reportedId = reportedId;
         a._reason = reason;
         return a;
      }
      
      public function get reportedId() : uint
      {
         return this._reportedId;
      }
      
      public function get reason() : uint
      {
         return this._reason;
      }
   }
}
