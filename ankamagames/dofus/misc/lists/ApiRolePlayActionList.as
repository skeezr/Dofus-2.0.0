package com.ankamagames.dofus.misc.lists
{
   import com.ankamagames.berilia.types.data.ApiAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.PlayerFightRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.PlayerFightFriendlyAnswerAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.EmotePlayRequestAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.ValidateSpellForgetAction;
   import com.ankamagames.dofus.logic.game.roleplay.actions.NpcGenericActionRequestAction;
   
   public class ApiRolePlayActionList
   {
      
      public static const PlayerFightRequest:ApiAction = new ApiAction("PlayerFightRequest",PlayerFightRequestAction,true);
      
      public static const PlayerFightFriendlyAnswer:ApiAction = new ApiAction("PlayerFightFriendlyAnswer",PlayerFightFriendlyAnswerAction,false);
      
      public static const EmotePlayRequest:ApiAction = new ApiAction("EmotePlayRequest",EmotePlayRequestAction,true);
      
      public static const ValidateSpellForget:ApiAction = new ApiAction("ValidateSpellForget",ValidateSpellForgetAction,true);
      
      public static const NpcGenericActionRequest:ApiAction = new ApiAction("NpcGenericActionRequest",NpcGenericActionRequestAction,true);
       
      public function ApiRolePlayActionList()
      {
         super();
      }
   }
}
