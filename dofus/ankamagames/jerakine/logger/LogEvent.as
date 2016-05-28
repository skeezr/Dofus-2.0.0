package com.ankamagames.jerakine.logger
{
   import flash.events.Event;
   
   public class LogEvent extends Event
   {
      
      public static const LOG_EVENT:String = "logEvent";
       
      private var _category:String;
      
      private var _message:String;
      
      private var _level:uint;
      
      public function LogEvent(category:String, message:String, logLevel:uint)
      {
         super(LOG_EVENT,false,false);
         this._category = category;
         this._message = message;
         this._level = logLevel;
      }
      
      public function get message() : String
      {
         return this._message;
      }
      
      public function get level() : uint
      {
         return this._level;
      }
      
      public function get category() : String
      {
         return this._category;
      }
      
      override public function clone() : Event
      {
         return new LogEvent(this.category,this.message,this.level);
      }
   }
}
