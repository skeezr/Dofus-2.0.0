package com.ankamagames.dofus.datacenter.alignments
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class AlignmentEffect
   {
      
      private static const MODULE:String = "AlignmentEffect";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AlignmentEffect));
       
      public var id:int;
      
      public var characteristicId:uint;
      
      public var descriptionId:uint;
      
      public function AlignmentEffect()
      {
         super();
      }
      
      public static function getAlignmentEffectById(id:int) : AlignmentEffect
      {
         return GameData.getObject(MODULE,id) as AlignmentEffect;
      }
      
      public static function getAlignmentEffects() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(id:uint, characteristicId:uint, descriptionId:uint) : AlignmentEffect
      {
         var o:AlignmentEffect = new AlignmentEffect();
         o.id = id;
         o.characteristicId = characteristicId;
         o.descriptionId = descriptionId;
         return o;
      }
      
      public function get description() : String
      {
         return I18n.getText(this.descriptionId);
      }
   }
}
