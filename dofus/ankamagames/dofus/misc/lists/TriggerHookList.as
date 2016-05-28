package com.ankamagames.dofus.misc.lists
{
   import com.ankamagames.berilia.types.data.Hook;
   
   public class TriggerHookList
   {
      
      public static const NotificationList:Hook = new Hook("NotificationList",false);
      
      public static const PlayerMove:Hook = new Hook("PlayerMove",false);
      
      public static const PlayerFightMove:Hook = new Hook("PlayerFightMove",false);
      
      public static const FightSpellCast:Hook = new Hook("FightSpellCast",false);
      
      public static const FightResultVictory:Hook = new Hook("FightResultVictory",false);
      
      public static const MapWithMonsters:Hook = new Hook("MapWithMonsters",false);
      
      public static const PlayerNewSpell:Hook = new Hook("PlayerNewSpell",false);
      
      public static const CreaturesMode:Hook = new Hook("CreaturesMode",false);
      
      public static const PlayerIsDead:Hook = new Hook("PlayerIsDead",false);
      
      public static const OpenGrimoireQuestTab:Hook = new Hook("OpenGrimoireQuestTab",false);
      
      public static const OpenGrimoireAlignmentTab:Hook = new Hook("OpenGrimoireAlignmentTab",false);
      
      public static const OpenGrimoireJobTab:Hook = new Hook("OpenGrimoireJobTab",false);
       
      public function TriggerHookList()
      {
         super();
      }
   }
}
