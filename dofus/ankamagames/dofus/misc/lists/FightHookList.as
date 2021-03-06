package com.ankamagames.dofus.misc.lists
{
   import com.ankamagames.berilia.types.data.Hook;
   
   public class FightHookList
   {
      
      public static const BuffUpdate:Hook = new Hook("BuffUpdate",false);
      
      public static const BuffRemove:Hook = new Hook("BuffRemove",false);
      
      public static const BuffDispell:Hook = new Hook("BuffDispell",false);
      
      public static const BuffAdd:Hook = new Hook("BuffAdd",false);
      
      public static const FighterSelected:Hook = new Hook("FighterSelected",false);
      
      public static const ChallengeInfoUpdate:Hook = new Hook("ChallengeInfoUpdate",false);
      
      public static const RemindTurn:Hook = new Hook("RemindTurn",false);
      
      public static const SpectatorWantLeave:Hook = new Hook("SpectatorWantLeave",false);
      
      public static const FightResultClosed:Hook = new Hook("FightResultClosed",false);
      
      public static const GameEntityDisposition:Hook = new Hook("GameEntityDisposition",false);
       
      public function FightHookList()
      {
         super();
      }
   }
}
