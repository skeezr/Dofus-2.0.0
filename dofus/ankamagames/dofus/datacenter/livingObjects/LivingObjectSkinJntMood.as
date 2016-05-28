package com.ankamagames.dofus.datacenter.livingObjects
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class LivingObjectSkinJntMood
   {
      
      private static const MODULE:String = "LivingObjectSkinJntMood";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpeakingItemText));
       
      public var skinId:int;
      
      public var moods:Vector.<Object>;
      
      public function LivingObjectSkinJntMood()
      {
         super();
      }
      
      public static function getLivingObjectSkin(categoryId:int, moodId:int, skinId:int) : int
      {
         var losjm:LivingObjectSkinJntMood = GameData.getObject(MODULE,categoryId) as LivingObjectSkinJntMood;
         if(!losjm || !losjm.moods[moodId])
         {
            return 0;
         }
         var ve:Vector.<int> = losjm.moods[moodId] as Vector.<int>;
         return ve[skinId - 1];
      }
      
      public static function getLivingObjectSkins() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(skinId:int, moods:Vector.<Object>) : LivingObjectSkinJntMood
      {
         var o:LivingObjectSkinJntMood = new LivingObjectSkinJntMood();
         o.skinId = skinId;
         o.moods = moods;
         return o;
      }
   }
}
