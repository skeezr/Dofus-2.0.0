package com.ankamagames.dofus.datacenter.alignments
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class AlignmentSide
   {
      
      private static const MODULE:String = "AlignmentSides";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AlignmentSide));
       
      public var id:int;
      
      public var nameId:uint;
      
      public var canConquest:Boolean;
      
      public function AlignmentSide()
      {
         super();
      }
      
      public static function getAlignmentSideById(id:int) : AlignmentSide
      {
         return GameData.getObject(MODULE,id) as AlignmentSide;
      }
      
      public static function getAlignmentSides() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(id:int, nameId:uint, canConquest:Boolean) : AlignmentSide
      {
         var o:AlignmentSide = new AlignmentSide();
         o.id = id;
         o.nameId = nameId;
         o.canConquest = canConquest;
         return o;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
