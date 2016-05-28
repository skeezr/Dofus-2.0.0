package com.ankamagames.dofus.misc.lists
{
   import com.ankamagames.berilia.types.data.ApiAction;
   import com.ankamagames.dofus.logic.game.common.actions.chat.ChannelEnablingAction;
   import com.ankamagames.dofus.logic.game.common.actions.chat.TabsUpdateAction;
   import com.ankamagames.dofus.logic.game.common.actions.chat.ChatClientMultiAction;
   import com.ankamagames.dofus.logic.game.common.actions.chat.ChatClientMultiWithObjectAction;
   import com.ankamagames.dofus.logic.game.common.actions.chat.ChatClientPrivateAction;
   import com.ankamagames.dofus.logic.game.common.actions.chat.ChatClientPrivateWithObjectAction;
   import com.ankamagames.dofus.logic.game.common.actions.chat.ChatSmileyRequestAction;
   import com.ankamagames.dofus.logic.game.common.actions.chat.ChatRefreshChannelAction;
   import com.ankamagames.dofus.logic.game.common.actions.chat.ChatRefreshChatAction;
   import com.ankamagames.dofus.logic.game.common.actions.chat.ChatTextOutputAction;
   import com.ankamagames.dofus.logic.game.common.actions.chat.SaveMessageAction;
   import com.ankamagames.dofus.logic.game.common.actions.chat.FightOutputAction;
   import com.ankamagames.dofus.logic.game.common.actions.chat.LivingObjectMessageRequestAction;
   
   public class ApiChatActionList
   {
      
      public static const ChannelEnabling:ApiAction = new ApiAction("ChannelEnabling",ChannelEnablingAction,true);
      
      public static const TabsUpdate:ApiAction = new ApiAction("TabsUpdate",TabsUpdateAction,true);
      
      public static const ChatClientMulti:ApiAction = new ApiAction("ChatClientMulti",ChatClientMultiAction,true);
      
      public static const ChatClientMultiWithObject:ApiAction = new ApiAction("ChatClientMultiWithObject",ChatClientMultiWithObjectAction,true);
      
      public static const ChatClientPrivate:ApiAction = new ApiAction("ChatClientPrivate",ChatClientPrivateAction,true);
      
      public static const ChatClientPrivateWithObject:ApiAction = new ApiAction("ChatClientPrivateWithObject",ChatClientPrivateWithObjectAction,true);
      
      public static const ChatSmileyRequest:ApiAction = new ApiAction("ChatSmileyRequest",ChatSmileyRequestAction,true);
      
      public static const ChatRefreshChannel:ApiAction = new ApiAction("ChatRefreshChannel",ChatRefreshChannelAction,true);
      
      public static const ChatRefreshChat:ApiAction = new ApiAction("ChatRefreshChat",ChatRefreshChatAction,true);
      
      public static const ChatTextOutput:ApiAction = new ApiAction("ChatTextOutput",ChatTextOutputAction,true);
      
      public static const SaveMessage:ApiAction = new ApiAction("SaveMessage",SaveMessageAction,true);
      
      public static const FightOutput:ApiAction = new ApiAction("FightOutput",FightOutputAction,true);
      
      public static const LivingObjectMessageRequest:ApiAction = new ApiAction("LivingObjectMessageRequest",LivingObjectMessageRequestAction,true);
       
      public function ApiChatActionList()
      {
         super();
      }
   }
}
