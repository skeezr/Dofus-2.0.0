package com.ankamagames.jerakine.utils.memory
{
   import flash.system.System;
   import flash.net.LocalConnection;
   
   public class Memory
   {
      
      private static const MOD:uint = 1024;
      
      private static const UNITS:Array = ["B","KB","MB","GB","TB","PB"];
       
      public function Memory()
      {
         super();
      }
      
      public static function usage() : uint
      {
         return System.totalMemory;
      }
      
      public static function humanReadableUsage() : String
      {
         var memory:uint = System.totalMemory;
         for(var i:uint = 0; memory > MOD; i++)
         {
            memory = memory / MOD;
         }
         return memory + " " + UNITS[i];
      }
      
      public static function gc() : void
      {
         try
         {
            new LocalConnection().connect("foo");
            new LocalConnection().connect("foo");
         }
         catch(e:*)
         {
         }
      }
   }
}
