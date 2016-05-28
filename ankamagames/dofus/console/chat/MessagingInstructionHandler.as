package com.ankamagames.dofus.console.chat
{
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   
   public class MessagingInstructionHandler implements ConsoleInstructionHandler
   {
       
      public function MessagingInstructionHandler()
      {
         super();
      }
      
      public function handle(console:ConsoleHandler, cmd:String, args:Array) : void
      {
         if(0)
         {
         }
      }
      
      public function getHelp(cmd:String) : String
      {
         switch(cmd)
         {
            case "w":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.whisper"));
            case "whisper":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.whisper"));
            case "msg":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.whisper"));
            case "t":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.teammessage"));
            case "g":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.guildmessage"));
            case "p":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.groupmessage"));
            case "a":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.alignmessage"));
            case "r":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.aroundguildmessage"));
            case "b":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.sellbuymessage"));
            case "m":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.meetmessage"));
            default:
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.noHelp"),[cmd]);
         }
      }
   }
}
