package com.ankamagames.dofus.types.events
{
   import com.ankamagames.jerakine.logger.LogEvent;
   import flash.events.Event;
   
   public class SendActionLogEvent extends LogEvent
   {
       
      private var _actionName:String;
      
      private var _params:Array;
      
      public function SendActionLogEvent(actionName:String, params:Array)
      {
         super(null,null,0);
         this._actionName = actionName;
         this._params = params;
      }
      
      public function get name() : String
      {
         return this._actionName;
      }
      
      public function get params() : Array
      {
         return this._params;
      }
      
      override public function clone() : Event
      {
         return new SendActionLogEvent(this._actionName,this._params);
      }
   }
}
