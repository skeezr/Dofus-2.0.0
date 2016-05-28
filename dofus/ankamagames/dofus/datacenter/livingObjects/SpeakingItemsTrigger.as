package com.ankamagames.dofus.datacenter.livingObjects
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class SpeakingItemsTrigger
   {
      
      private static const MODULE:String = "SpeakingItemsTriggers";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpeakingItemsTrigger));
       
      public var triggersId:int;
      
      public var textIds:Vector.<int>;
      
      public var states:Vector.<int>;
      
      public function SpeakingItemsTrigger()
      {
         super();
      }
      
      public static function getSpeakingItemsTriggerById(id:int) : SpeakingItemsTrigger
      {
         return GameData.getObject(MODULE,id) as SpeakingItemsTrigger;
      }
      
      public static function getSpeakingItemsTriggers() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(triggersId:int, textIds:Vector.<int>, states:Vector.<int>) : SpeakingItemsTrigger
      {
         var o:SpeakingItemsTrigger = new SpeakingItemsTrigger();
         o.triggersId = triggersId;
         o.textIds = textIds;
         o.states = states;
         return o;
      }
   }
}
