package com.ankamagames.dofus.datacenter.quest
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class QuestObjectiveType
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(QuestObjectiveType));
      
      private static const MODULE:String = "QuestObjectiveTypes";
       
      public var id:uint;
      
      public var nameId:uint;
      
      public function QuestObjectiveType()
      {
         super();
      }
      
      public static function create(id:int, nameId:uint) : QuestObjectiveType
      {
         var o:QuestObjectiveType = new QuestObjectiveType();
         o.id = id;
         o.nameId = nameId;
         return o;
      }
      
      public static function getQuestObjectiveTypeById(id:int) : QuestObjectiveType
      {
         return GameData.getObject(MODULE,id) as QuestObjectiveType;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
