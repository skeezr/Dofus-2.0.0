package com.ankamagames.jerakine.logger
{
   public class LogLogger implements Logger
   {
      
      private static var _enabled:Boolean = true;
       
      private var _category:String;
      
      public function LogLogger(category:String)
      {
         super();
         this._category = category;
      }
      
      public function get category() : String
      {
         return this._category;
      }
      
      public function get enabled() : Boolean
      {
         return _enabled;
      }
      
      public function set enabled(v:Boolean) : void
      {
         _enabled = v;
      }
      
      public function trace(message:String) : void
      {
         this.log(LogLevel.TRACE,message);
      }
      
      public function debug(message:String) : void
      {
         this.log(LogLevel.DEBUG,message);
      }
      
      public function info(message:String) : void
      {
         this.log(LogLevel.INFO,message);
      }
      
      public function warn(message:String) : void
      {
         this.log(LogLevel.WARN,message);
      }
      
      public function error(message:String) : void
      {
         this.log(LogLevel.ERROR,message);
      }
      
      public function fatal(message:String) : void
      {
         this.log(LogLevel.FATAL,message);
      }
      
      public function logDirectly(logEvent:LogEvent) : void
      {
         if(_enabled)
         {
            Log.broadcastToTargets(logEvent);
         }
      }
      
      public function log(level:uint, message:String) : void
      {
         if(_enabled)
         {
            Log.broadcastToTargets(new TextLogEvent(this._category,level != LogLevel.COMMANDS?this.getFormatedMessage(message):message,level));
         }
      }
      
      private function getFormatedMessage(message:String) : String
      {
         if(!message)
         {
            message = "";
         }
         var catSplit:Array = this._category.split(".");
         var head:* = "[" + catSplit[catSplit.length - 1] + "] ";
         var indent:* = "";
         for(var i:uint = 0; i < head.length; i++)
         {
            indent = indent + " ";
         }
         message = message.replace("\n","\n" + indent);
         return head + message;
      }
      
      public function clear() : void
      {
         this.log(LogLevel.COMMANDS,"clear");
      }
   }
}
