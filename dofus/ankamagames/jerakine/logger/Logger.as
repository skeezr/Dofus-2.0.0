package com.ankamagames.jerakine.logger
{
   public interface Logger
   {
       
      function trace(param1:String) : void;
      
      function debug(param1:String) : void;
      
      function info(param1:String) : void;
      
      function warn(param1:String) : void;
      
      function error(param1:String) : void;
      
      function fatal(param1:String) : void;
      
      function log(param1:uint, param2:String) : void;
      
      function logDirectly(param1:LogEvent) : void;
      
      function get category() : String;
      
      function clear() : void;
      
      function get enabled() : Boolean;
      
      function set enabled(param1:Boolean) : void;
   }
}
