package com.ankamagames.dofus.misc.lists
{
   import com.ankamagames.berilia.types.data.Hook;
   
   public class QuestHookList
   {
      
      public static const QuestListUpdated:Hook = new Hook("QuestListUpdated",true);
      
      public static const QuestInfosUpdated:Hook = new Hook("QuestInfosUpdated",true);
      
      public static const QuestStarted:Hook = new Hook("QuestStarted",true);
      
      public static const QuestValidated:Hook = new Hook("QuestValidated",true);
      
      public static const QuestObjectiveValidated:Hook = new Hook("QuestObjectiveValidated",true);
      
      public static const QuestStepValidated:Hook = new Hook("QuestStepValidated",true);
      
      public static const QuestStepStarted:Hook = new Hook("QuestStepStarted",true);
       
      public function QuestHookList()
      {
         super();
      }
   }
}
