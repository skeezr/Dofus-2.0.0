package com.ankamagames.dofus.datacenter.alignments
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class AlignmentRankJntGift
   {
      
      private static const MODULE:String = "AlignmentRankJntGift";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AlignmentRankJntGift));
       
      public var id:int;
      
      public var gifts:Vector.<int>;
      
      public var parameters:Vector.<int>;
      
      public var levels:Vector.<int>;
      
      public function AlignmentRankJntGift()
      {
         super();
      }
      
      public static function getAlignmentRankJntGiftById(id:int) : AlignmentRankJntGift
      {
         return GameData.getObject(MODULE,id) as AlignmentRankJntGift;
      }
      
      public static function getAlignmentRankJntGifts() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(id:uint, gifts:Vector.<int>, parameters:Vector.<int>, levels:Vector.<int>) : AlignmentRankJntGift
      {
         var o:AlignmentRankJntGift = new AlignmentRankJntGift();
         o.id = id;
         o.gifts = gifts;
         o.parameters = parameters;
         o.levels = levels;
         return o;
      }
   }
}
