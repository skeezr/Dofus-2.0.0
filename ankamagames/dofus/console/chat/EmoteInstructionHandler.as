package com.ankamagames.dofus.console.chat
{
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmotePlayRequestMessage;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.enums.PlayerLifeStatusEnum;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   
   public class EmoteInstructionHandler implements ConsoleInstructionHandler
   {
       
      public function EmoteInstructionHandler()
      {
         super();
      }
      
      public function handle(console:ConsoleHandler, cmd:String, args:Array) : void
      {
         var emoteId:uint = 0;
         var eprmsg:EmotePlayRequestMessage = null;
         switch(cmd)
         {
            case "sit":
               emoteId = 1;
               break;
            case "bye":
               emoteId = 2;
               break;
            case "appl":
               emoteId = 3;
               break;
            case "mad":
               emoteId = 4;
               break;
            case "fear":
               emoteId = 5;
               break;
            case "weap":
               emoteId = 6;
               break;
            case "pipo":
               emoteId = 7;
               break;
            case "oups":
               emoteId = 8;
               break;
            case "hi":
               emoteId = 9;
               break;
            case "kiss":
               emoteId = 10;
               break;
            case "pfc1":
               emoteId = 11;
               break;
            case "pfc2":
               emoteId = 12;
               break;
            case "pfc3":
               emoteId = 13;
               break;
            case "cross":
               emoteId = 14;
               break;
            case "point":
               emoteId = 15;
               break;
            case "crow":
               emoteId = 16;
               break;
            case "rest":
               emoteId = 19;
               break;
            case "sit2":
               emoteId = 20;
               break;
            case "champ":
               emoteId = 21;
               break;
            case "aura":
               emoteId = 22;
               break;
            case "bat":
               emoteId = 23;
               break;
            default:
               return;
         }
         if(PlayedCharacterManager.getInstance().state == PlayerLifeStatusEnum.STATUS_ALIVE_AND_KICKING)
         {
            eprmsg = new EmotePlayRequestMessage();
            eprmsg.initEmotePlayRequestMessage(emoteId);
            ConnectionsHandler.getConnection().send(eprmsg);
         }
      }
      
      public function getHelp(cmd:String) : String
      {
         return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.emote"),[cmd]);
      }
   }
}
