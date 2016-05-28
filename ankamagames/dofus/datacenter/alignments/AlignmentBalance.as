package com.ankamagames.dofus.datacenter.alignments
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class AlignmentBalance
   {
      
      private static const MODULE:String = "AlignmentBalance";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AlignmentBalance));
       
      public var id:int;
      
      public var startValue:int;
      
      public var endValue:int;
      
      public var nameId:uint;
      
      public var descriptionId:uint;
      
      public function AlignmentBalance()
      {
         super();
      }
      
      public static function getAlignmentBalanceById(id:int) : AlignmentBalance
      {
         return GameData.getObject(MODULE,id) as AlignmentBalance;
      }
      
      public static function getAlignmentBalances() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(id:uint, startValue:int, endValue:int, nameId:uint, descriptionId:uint) : AlignmentBalance
      {
         var o:AlignmentBalance = new AlignmentBalance();
         o.id = id;
         o.startValue = startValue;
         o.endValue = endValue;
         o.nameId = nameId;
         o.descriptionId = descriptionId;
         return o;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
      
      public function get description() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
