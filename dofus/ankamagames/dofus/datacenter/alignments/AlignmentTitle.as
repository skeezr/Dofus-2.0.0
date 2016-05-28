package com.ankamagames.dofus.datacenter.alignments
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class AlignmentTitle
   {
      
      private static const MODULE:String = "AlignmentTitles";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AlignmentTitle));
       
      public var sideId:int;
      
      public var namesId:Vector.<int>;
      
      public var shortsId:Vector.<int>;
      
      public function AlignmentTitle()
      {
         super();
      }
      
      public static function getAlignmentTitlesById(id:int) : AlignmentTitle
      {
         return GameData.getObject(MODULE,id) as AlignmentTitle;
      }
      
      public static function getAlignmentTitles() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(sideId:int, namesId:Vector.<int>, shortsId:Vector.<int>) : AlignmentTitle
      {
         var o:AlignmentTitle = new AlignmentTitle();
         o.sideId = sideId;
         o.namesId = namesId;
         o.shortsId = shortsId;
         return o;
      }
      
      public function getNameFromGrade(grade:int) : String
      {
         return I18n.getText(this.namesId[grade]);
      }
      
      public function getShortNameFromGrade(grade:int) : String
      {
         return I18n.getText(this.shortsId[grade]);
      }
   }
}
