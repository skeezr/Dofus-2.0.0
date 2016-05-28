package com.ankamagames.dofus.misc.lists
{
   import com.ankamagames.berilia.types.data.Hook;
   
   public class RoleplayHookList
   {
      
      public static const PlayerFightRequestSent:Hook = new Hook("PlayerFightRequestSent",false);
      
      public static const PlayerFightFriendlyRequested:Hook = new Hook("PlayerFightFriendlyRequested",false);
      
      public static const FightRequestCanceled:Hook = new Hook("FightRequestCanceled",false);
      
      public static const PlayerFightFriendlyAnswer:Hook = new Hook("PlayerFightFriendlyAnswer",false);
      
      public static const PlayerFightFriendlyAnswered:Hook = new Hook("PlayerFightFriendlyAnswered",false);
      
      public static const EmoteListUpdated:Hook = new Hook("EmoteListUpdated",false);
      
      public static const SpellForgetUI:Hook = new Hook("SpellForgetUI",false);
      
      public static const DocumentReadingBegin:Hook = new Hook("DocumentReadingBegin",false);
      
      public static const TeleportDestinationList:Hook = new Hook("TeleportDestinationList",false);
       
      public function RoleplayHookList()
      {
         super();
      }
   }
}
