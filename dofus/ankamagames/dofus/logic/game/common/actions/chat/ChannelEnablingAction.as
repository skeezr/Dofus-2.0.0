package com.ankamagames.dofus.logic.game.common.actions.chat
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class ChannelEnablingAction implements Action
   {
       
      private var _channel:uint;
      
      private var _enable:Boolean;
      
      public function ChannelEnablingAction()
      {
         super();
      }
      
      public static function create(channel:uint, enable:Boolean = true) : ChannelEnablingAction
      {
         var a:ChannelEnablingAction = new ChannelEnablingAction();
         a._channel = channel;
         a._enable = enable;
         return a;
      }
      
      public function get channel() : uint
      {
         return this._channel;
      }
      
      public function get enable() : Boolean
      {
         return this._enable;
      }
   }
}
