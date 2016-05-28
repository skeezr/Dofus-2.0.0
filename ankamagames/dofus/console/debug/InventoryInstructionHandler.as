package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.network.messages.authorized.AdminQuietCommandMessage;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   
   public class InventoryInstructionHandler implements ConsoleInstructionHandler
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(InventoryInstructionHandler));
       
      public function InventoryInstructionHandler()
      {
         super();
      }
      
      public function handle(console:ConsoleHandler, cmd:String, args:Array) : void
      {
         var items:Array = null;
         var searchWord:String = null;
         var items2:Array = null;
         var len:uint = 0;
         var item:ItemWrapper = null;
         var currentItem:Item = null;
         var currentItem2:Item = null;
         var aqcmsg:AdminQuietCommandMessage = null;
         switch(cmd)
         {
            case "listinventory":
               for each(item in PlayedCharacterManager.getInstance().inventory)
               {
                  console.output("[UID: " + item.objectUID + ", ID:" + item.objectGID + "] " + item.quantity + " x " + item["name"]);
               }
               break;
            case "searchitem":
               if(args.length != 1)
               {
                  console.output(cmd + " need only one arg");
                  break;
               }
               items = Item.getItems();
               searchWord = (args[0] as String).toLowerCase();
               for each(currentItem in items)
               {
                  if(Boolean(currentItem) && currentItem.name.toLowerCase().indexOf(args[0]) != -1)
                  {
                     console.output(currentItem.name + " (id: " + currentItem.id + ")");
                  }
               }
               break;
            case "makeinventory":
               items2 = Item.getItems();
               len = parseInt(args[0],10);
               for each(currentItem2 in items2)
               {
                  if(currentItem2)
                  {
                     if(!len)
                     {
                        break;
                     }
                     aqcmsg = new AdminQuietCommandMessage();
                     aqcmsg.initAdminQuietCommandMessage("item * " + currentItem2.id + " " + Math.ceil(Math.random() * 10));
                     ConnectionsHandler.getConnection().send(aqcmsg);
                     len--;
                  }
               }
         }
      }
      
      public function getHelp(cmd:String) : String
      {
         switch(cmd)
         {
            case "listinventory":
               return "List player inventory content.";
            case "searchitem":
               return "Search item name/id, param : [part of searched item name]";
            case "makeinventory":
               return "Create an inventory";
            default:
               return "Unknown command \'" + cmd + "\'.";
         }
      }
   }
}
