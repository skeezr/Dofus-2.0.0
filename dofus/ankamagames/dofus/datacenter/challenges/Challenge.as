package com.ankamagames.dofus.datacenter.challenges
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class Challenge
   {
      
      private static const MODULE:String = "Challenge";
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Challenge));
       
      public var id:int;
      
      public var nameId:uint;
      
      public var descriptionId:uint;
      
      public function Challenge()
      {
         super();
      }
      
      public static function getChallengeById(id:int) : Challenge
      {
         return GameData.getObject(MODULE,id) as Challenge;
      }
      
      public static function getChallenges() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(id:uint, nameId:uint, descriptionId:uint) : Challenge
      {
         var o:Challenge = new Challenge();
         o.id = id;
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
         return I18n.getText(this.descriptionId);
      }
   }
}
