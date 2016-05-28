package com.ankamagames.dofus.console.chat
{
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.dofus.network.messages.game.basic.BasicSwitchModeRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.death.GameRolePlayFreeSoulRequestMessage;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   
   public class StatusInstructionHandler implements ConsoleInstructionHandler
   {
       
      public function StatusInstructionHandler()
      {
         super();
      }
      
      public function handle(console:ConsoleHandler, cmd:String, args:Array) : void
      {
         var csmrm:BasicSwitchModeRequestMessage = null;
         var grpfsrmmsg:GameRolePlayFreeSoulRequestMessage = null;
         switch(cmd)
         {
            case "away":
               csmrm = new BasicSwitchModeRequestMessage();
               csmrm.initBasicSwitchModeRequestMessage();
               ConnectionsHandler.getConnection().send(csmrm);
               break;
            case "release":
               grpfsrmmsg = new GameRolePlayFreeSoulRequestMessage();
               ConnectionsHandler.getConnection().send(grpfsrmmsg);
         }
      }
      
      public function getHelp(cmd:String) : String
      {
         switch(cmd)
         {
            case "away":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.away"));
            case "release":
               return I18n.getText(I18nProxy.getKeyId("ui.common.freeSoul"));
            default:
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.noHelp"),[cmd]);
         }
      }
   }
}
