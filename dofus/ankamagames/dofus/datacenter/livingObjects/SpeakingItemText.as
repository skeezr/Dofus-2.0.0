package com.ankamagames.dofus.datacenter.livingObjects
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class SpeakingItemText
   {
      
      private static const MODULE:String = "SpeakingItemsText";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpeakingItemText));
       
      public var textId:int;
      
      public var textProba:Number;
      
      public var textStringId:uint;
      
      public var textLevel:int;
      
      public var textSound:int;
      
      public var textRestriction:String;
      
      public function SpeakingItemText()
      {
         super();
      }
      
      public static function getSpeakingItemTextById(id:int) : SpeakingItemText
      {
         return GameData.getObject(MODULE,id) as SpeakingItemText;
      }
      
      public static function getSpeakingItemsText() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(textId:int, textProba:Number, textStringId:uint, textLevel:int, textSound:int, textRestriction:String) : SpeakingItemText
      {
         var o:SpeakingItemText = new SpeakingItemText();
         o.textId = textId;
         o.textProba = textProba;
         o.textStringId = textStringId;
         o.textLevel = textLevel;
         o.textSound = textSound;
         o.textRestriction = textRestriction;
         return o;
      }
      
      public function get textString() : String
      {
         return I18n.getText(this.textStringId);
      }
   }
}
