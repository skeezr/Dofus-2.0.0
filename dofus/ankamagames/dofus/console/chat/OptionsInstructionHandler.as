package com.ankamagames.dofus.console.chat
{
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   
   public class OptionsInstructionHandler implements ConsoleInstructionHandler
   {
       
      public function OptionsInstructionHandler()
      {
         super();
      }
      
      public function handle(console:ConsoleHandler, cmd:String, args:Array) : void
      {
         switch(cmd)
         {
            case "tab":
               if(!args[0] || args[0] < 1)
               {
                  console.output("Error : need a valid tab index.");
                  return;
               }
               KernelEventsManager.getInstance().processCallback(ChatHookList.TabNameChange,args[0],args[1]);
               break;
         }
      }
      
      public function getHelp(cmd:String) : String
      {
         switch(cmd)
         {
            case "tab":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.tab"));
            default:
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.noHelp"),[cmd]);
         }
      }
   }
}
