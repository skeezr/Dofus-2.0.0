package com.ankamagames.dofus.internalDatacenter.people
{
   public class IgnoredWrapper
   {
       
      public var name:String = "";
      
      public var state:int = 1;
      
      public var lastConnection:uint = 0;
      
      public var online:Boolean = true;
      
      public var type:String = "Ignored";
      
      public var playerName:String = "";
      
      public var breed:uint = 0;
      
      public var sex:uint = 2;
      
      public var level:int = 0;
      
      public var alignmentSide:int = -1;
      
      public var guildName:String = "";
      
      public function IgnoredWrapper(name:String)
      {
         super();
         this.name = name;
      }
   }
}
