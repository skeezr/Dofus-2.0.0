package com.ankamagames.dofus.logic.game.common.actions.chat
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class FightOutputAction implements Action
   {
       
      private var _content:String;
      
      private var _channel:uint;
      
      public function FightOutputAction()
      {
         super();
      }
      
      public static function create(msg:String, channel:uint = 0) : FightOutputAction
      {
         var a:FightOutputAction = new FightOutputAction();
         a._content = msg;
         a._channel = channel;
         return a;
      }
      
      public function get content() : String
      {
         return this._content;
      }
      
      public function get channel() : uint
      {
         return this._channel;
      }
   }
}
