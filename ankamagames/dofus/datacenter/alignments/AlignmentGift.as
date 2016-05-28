package com.ankamagames.dofus.datacenter.alignments
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class AlignmentGift
   {
      
      private static const MODULE:String = "AlignmentGift";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AlignmentGift));
       
      public var id:int;
      
      public var nameId:uint;
      
      public var effectId:int;
      
      public var gfxId:uint;
      
      public function AlignmentGift()
      {
         super();
      }
      
      public static function getAlignmentGiftById(id:int) : AlignmentGift
      {
         return GameData.getObject(MODULE,id) as AlignmentGift;
      }
      
      public static function getAlignmentGifts() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(id:int, nameId:uint, effectId:int, gfxId:uint) : AlignmentGift
      {
         var o:AlignmentGift = new AlignmentGift();
         o.id = id;
         o.nameId = nameId;
         o.effectId = effectId;
         o.gfxId = gfxId;
         return o;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
