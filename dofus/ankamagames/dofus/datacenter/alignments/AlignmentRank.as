package com.ankamagames.dofus.datacenter.alignments
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class AlignmentRank
   {
      
      private static const MODULE:String = "AlignmentRank";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AlignmentRank));
       
      public var id:int;
      
      public var orderId:uint;
      
      public var nameId:uint;
      
      public var descriptionId:uint;
      
      public var minimumAlignment:int;
      
      public var objectsStolen:int;
      
      public var gifts:Array;
      
      public function AlignmentRank()
      {
         super();
      }
      
      public static function getAlignmentRankById(id:int) : AlignmentRank
      {
         return GameData.getObject(MODULE,id) as AlignmentRank;
      }
      
      public static function getAlignmentRanks() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(id:uint, orderId:uint, nameId:uint, descriptionId:uint, minimumAlignment:int, objectsStolen:int, gifts:Array) : AlignmentRank
      {
         var o:AlignmentRank = new AlignmentRank();
         o.id = id;
         o.orderId = orderId;
         o.nameId = nameId;
         o.descriptionId = descriptionId;
         o.minimumAlignment = minimumAlignment;
         o.objectsStolen = objectsStolen;
         o.gifts = gifts;
         return o;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
      
      public function get description() : String
      {
         return I18n.getText(this.descriptionId);
      }
   }
}
