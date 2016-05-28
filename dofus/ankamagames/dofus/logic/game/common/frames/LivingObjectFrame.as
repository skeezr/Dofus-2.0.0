package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.logic.game.common.actions.livingObject.LivingObjectDissociateAction;
   import com.ankamagames.dofus.network.messages.game.inventory.items.LivingObjectDissociateMessage;
   import com.ankamagames.dofus.logic.game.common.actions.livingObject.LivingObjectFeedAction;
   import com.ankamagames.dofus.network.messages.game.inventory.items.LivingObjectFeedMessage;
   import com.ankamagames.dofus.logic.game.common.actions.livingObject.LivingObjectChangeSkinRequestAction;
   import com.ankamagames.dofus.network.messages.game.inventory.items.LivingObjectChangeSkinRequestMessage;
   import com.ankamagames.dofus.network.messages.game.inventory.items.ObjectModifiedMessage;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.LivingObjectHookList;
   
   public class LivingObjectFrame implements Frame
   {
      
      private static const ACTION_TOSKIN:uint = 1;
      
      private static const ACTION_TOFEED:uint = 2;
      
      private static const ACTION_TODISSOCIATE:uint = 3;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(PrismFrame));
       
      private var livingObjectUID:uint = 0;
      
      private var action:uint = 0;
      
      public function LivingObjectFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var loda:LivingObjectDissociateAction = null;
         var lodmsg:LivingObjectDissociateMessage = null;
         var lofa:LivingObjectFeedAction = null;
         var lofmsg:LivingObjectFeedMessage = null;
         var locsra:LivingObjectChangeSkinRequestAction = null;
         var locsrmsg:LivingObjectChangeSkinRequestMessage = null;
         var omdmsg:ObjectModifiedMessage = null;
         var itemModified:ItemWrapper = null;
         switch(true)
         {
            case msg is LivingObjectDissociateAction:
               loda = msg as LivingObjectDissociateAction;
               lodmsg = new LivingObjectDissociateMessage();
               lodmsg.initLivingObjectDissociateMessage(loda.livingUID,loda.livingPosition);
               this.livingObjectUID = loda.livingUID;
               this.action = ACTION_TODISSOCIATE;
               ConnectionsHandler.getConnection().send(lodmsg);
               return true;
            case msg is LivingObjectFeedAction:
               lofa = msg as LivingObjectFeedAction;
               lofmsg = new LivingObjectFeedMessage();
               lofmsg.initLivingObjectFeedMessage(lofa.livingUID,lofa.livingPosition,lofa.foodUID);
               this.livingObjectUID = lofa.livingUID;
               this.action = ACTION_TOFEED;
               ConnectionsHandler.getConnection().send(lofmsg);
               return true;
            case msg is LivingObjectChangeSkinRequestAction:
               locsra = msg as LivingObjectChangeSkinRequestAction;
               locsrmsg = new LivingObjectChangeSkinRequestMessage();
               locsrmsg.initLivingObjectChangeSkinRequestMessage(locsra.livingUID,locsra.livingPosition,locsra.skinId);
               this.livingObjectUID = locsra.livingUID;
               this.action = ACTION_TOSKIN;
               ConnectionsHandler.getConnection().send(locsrmsg);
               return true;
            case msg is ObjectModifiedMessage:
               omdmsg = msg as ObjectModifiedMessage;
               itemModified = ItemWrapper.getItemFromUId(omdmsg.object.objectUID);
               if(!itemModified)
               {
                  return false;
               }
               if(this.livingObjectUID == omdmsg.object.objectUID)
               {
                  itemModified.update(omdmsg.object.position,omdmsg.object.objectUID,omdmsg.object.objectGID,omdmsg.object.quantity,omdmsg.object.effects);
                  switch(this.action)
                  {
                     case ACTION_TOFEED:
                        KernelEventsManager.getInstance().processCallback(LivingObjectHookList.LivingObjectFeed,itemModified);
                        break;
                     case ACTION_TODISSOCIATE:
                        KernelEventsManager.getInstance().processCallback(LivingObjectHookList.LivingObjectDissociate,itemModified);
                        break;
                     case ACTION_TOSKIN:
                     default:
                        KernelEventsManager.getInstance().processCallback(LivingObjectHookList.LivingObjectUpdate,itemModified);
                  }
               }
               else if(itemModified.livingObjectId != 0)
               {
                  KernelEventsManager.getInstance().processCallback(LivingObjectHookList.LivingObjectAssociate,itemModified);
               }
               this.livingObjectUID = 0;
               return false;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
   }
}
