package com.ankamagames.dofus.console.chat
{
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyInvitationRequestMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendAddRequestMessage;
   import com.ankamagames.dofus.network.messages.game.friend.FriendDeleteRequestMessage;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredAddRequestMessage;
   import com.ankamagames.dofus.network.messages.game.friend.IgnoredDeleteRequestMessage;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   
   public class SocialInstructionHandler implements ConsoleInstructionHandler
   {
       
      public function SocialInstructionHandler()
      {
         super();
      }
      
      public function handle(console:ConsoleHandler, cmd:String, args:Array) : void
      {
         var s:String = null;
         var friend:String = null;
         var name:String = null;
         var pirmsg:PartyInvitationRequestMessage = null;
         var reason:String = null;
         var farmsg:FriendAddRequestMessage = null;
         var frdmsg:FriendDeleteRequestMessage = null;
         var iarmsg:IgnoredAddRequestMessage = null;
         var irdmsg:IgnoredDeleteRequestMessage = null;
         switch(cmd)
         {
            case "f":
               if(args.length != 2)
               {
                  return;
               }
               s = args[0] as String;
               friend = args[1] as String;
               if(friend.length < 3 || friend.length > 20)
               {
                  reason = I18n.getText(I18nProxy.getKeyId("ui.social.friend.addFailureNotFound"));
                  console.output(reason);
                  return;
               }
               if(friend != PlayedCharacterManager.getInstance().infos.name)
               {
                  if(s == "a" || s == "+")
                  {
                     farmsg = new FriendAddRequestMessage();
                     farmsg.initFriendAddRequestMessage(friend);
                     ConnectionsHandler.getConnection().send(farmsg);
                  }
                  else if(s == "d" || s == "-" || s == "r")
                  {
                     frdmsg = new FriendDeleteRequestMessage();
                     frdmsg.initFriendDeleteRequestMessage(friend);
                     ConnectionsHandler.getConnection().send(frdmsg);
                  }
               }
               else
               {
                  console.output(I18n.getText(I18nProxy.getKeyId("ui.social.friend.addFailureEgocentric")));
               }
               break;
            case "ignore":
               if(args.length != 2)
               {
                  return;
               }
               s = args[0] as String;
               friend = args[1] as String;
               if(friend.length < 3 || friend.length > 20)
               {
                  reason = I18n.getText(I18nProxy.getKeyId("ui.social.friend.addFailureNotFound"));
                  console.output(reason);
                  return;
               }
               if(friend == PlayedCharacterManager.getInstance().infos.name)
               {
                  console.output(I18n.getText(I18nProxy.getKeyId("ui.social.friend.addFailureEgocentric")));
                  return;
               }
               if(s == "a" || s == "+")
               {
                  iarmsg = new IgnoredAddRequestMessage();
                  iarmsg.initIgnoredAddRequestMessage(friend);
                  ConnectionsHandler.getConnection().send(iarmsg);
               }
               else if(s == "d" || s == "-" || s == "r")
               {
                  irdmsg = new IgnoredDeleteRequestMessage();
                  irdmsg.initIgnoredDeleteRequestMessage(friend);
                  ConnectionsHandler.getConnection().send(irdmsg);
               }
               break;
            case "invite":
               if(args.length != 1)
               {
                  return;
               }
               name = args[1] as String;
               pirmsg = new PartyInvitationRequestMessage();
               pirmsg.initPartyInvitationRequestMessage(name);
               ConnectionsHandler.getConnection().send(pirmsg);
               break;
         }
      }
      
      public function getHelp(cmd:String) : String
      {
         switch(cmd)
         {
            case "f":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.friendhelp"));
            case "ignore":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.enemyhelp"));
            case "invite":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.invite"));
            default:
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.noHelp"),[cmd]);
         }
      }
   }
}
