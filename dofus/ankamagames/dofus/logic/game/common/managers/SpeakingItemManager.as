package com.ankamagames.dofus.logic.game.common.managers
{
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import flash.utils.Timer;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.datacenter.livingObjects.SpeakingItemsTrigger;
   import com.ankamagames.dofus.datacenter.livingObjects.SpeakingItemText;
   import com.ankamagames.dofus.network.messages.game.inventory.items.LivingObjectMessageRequestMessage;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.network.enums.ChatChannelsMultiEnum;
   import flash.events.TimerEvent;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class SpeakingItemManager implements IDestroyable
   {
      
      private static const SPEAKING_ITEMS_MSG_COUNT:Number = 30;
      
      private static const SPEAKING_ITEMS_MSG_COUNT_DELTA:Number = 0.2;
      
      private static const SPEAKING_ITEMS_CHAT_PROBA:Number = 100;
      
      private static var _timer:Timer;
      
      public static var MINUTE_DELAY:int = 1000 * 60;
      
      public static var GREAT_DROP_LIMIT:int = 10;
      
      public static var SPEAK_TRIGGER_MINUTE:int = 1;
      
      public static var SPEAK_TRIGGER_AGRESS:int = 2;
      
      public static var SPEAK_TRIGGER_AGRESSED:int = 3;
      
      public static var SPEAK_TRIGGER_KILL_ENEMY:int = 4;
      
      public static var SPEAK_TRIGGER_KILLED_BY_ENEMY:int = 5;
      
      public static var SPEAK_TRIGGER_CC_OWNER:int = 6;
      
      public static var SPEAK_TRIGGER_EC_OWNER:int = 7;
      
      public static var SPEAK_TRIGGER_FIGHT_WON:int = 8;
      
      public static var SPEAK_TRIGGER_FIGHT_LOST:int = 9;
      
      public static var SPEAK_TRIGGER_NEW_ENEMY_WEAK:int = 10;
      
      public static var SPEAK_TRIGGER_NEW_ENEMY_STRONG:int = 11;
      
      public static var SPEAK_TRIGGER_CC_ALLIED:int = 12;
      
      public static var SPEAK_TRIGGER_EC_ALLIED:int = 13;
      
      public static var SPEAK_TRIGGER_CC_ENEMY:int = 14;
      
      public static var SPEAK_TRIGGER_EC_ENEMY:int = 15;
      
      public static var SPEAK_TRIGGER_ON_CONNECT:int = 16;
      
      public static var SPEAK_TRIGGER_KILL_ALLY:int = 17;
      
      public static var SPEAK_TRIGGER_KILLED_BY_ALLY:int = 18;
      
      public static var SPEAK_TRIGGER_GREAT_DROP:int = 19;
      
      public static var SPEAK_TRIGGER_KILLED_HIMSELF:int = 20;
      
      public static var SPEAK_TRIGGER_CRAFT_OK:int = 21;
      
      public static var SPEAK_TRIGGER_CRAFT_KO:int = 22;
      
      private static var _self:com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
       
      private var _nextMessageCount:int;
      
      public function SpeakingItemManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("TimeManager is a singleton and should not be instanciated directly.");
         }
         _timer = new Timer(MINUTE_DELAY);
         _timer.addEventListener("timer",this.onTimer);
         _timer.start();
         this.generateNextMsgCount(true);
      }
      
      public static function getInstance() : com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager
      {
         if(_self == null)
         {
            _self = new com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager();
         }
         return _self;
      }
      
      public function triggerEvent(nEvent:int) : void
      {
         var item:ItemWrapper = null;
         var triggersAssoc:SpeakingItemsTrigger = null;
         var itemWrapper:ItemWrapper = null;
         var tmpTriggersAssoc:Array = null;
         var i:int = 0;
         var msgId:Number = NaN;
         var ok:Boolean = false;
         var media:Number = NaN;
         var speakingText:SpeakingItemText = null;
         var chatProba:int = 0;
         var msg:LivingObjectMessageRequestMessage = null;
         if(!Kernel.getWorker().getFrame(ChatFrame))
         {
            return;
         }
         var opt:Boolean = OptionManager.getOptionManager("chat").letLivingObjectTalk;
         if(!opt)
         {
            return;
         }
         var items:Array = new Array();
         for each(item in PlayedCharacterManager.getInstance().inventory)
         {
            if(item.position != 63 && Boolean(item.isLivingObject))
            {
               items.push(item);
            }
         }
         if(items.length == 0)
         {
            return;
         }
         this._nextMessageCount--;
         this._nextMessageCount = this._nextMessageCount - (items.length - 1) / 4;
         if(this._nextMessageCount <= 0)
         {
            triggersAssoc = SpeakingItemsTrigger.getSpeakingItemsTriggerById(nEvent);
            itemWrapper = items[Math.floor(Math.random() * items.length)];
            tmpTriggersAssoc = new Array();
            if(triggersAssoc)
            {
               for(i = 0; i < triggersAssoc.textIds.length; i++)
               {
                  speakingText = SpeakingItemText.getSpeakingItemTextById(triggersAssoc.textIds[i]);
                  if(!(!speakingText || speakingText.textLevel > itemWrapper.maxSkin))
                  {
                     if(speakingText.textRestriction != "")
                     {
                     }
                     tmpTriggersAssoc.push(triggersAssoc.textIds[i]);
                  }
               }
               ok = false;
               for(i = 0; i < 10; i++)
               {
                  msgId = tmpTriggersAssoc[Math.floor(Math.random() * tmpTriggersAssoc.length)];
                  speakingText = SpeakingItemText.getSpeakingItemTextById(msgId);
                  if(Math.random() < speakingText.textProba)
                  {
                     ok = true;
                  }
               }
               if(!ok)
               {
                  return;
               }
               if(speakingText.textSound != -1)
               {
                  media = Math.floor(Math.random() * 3);
               }
               else
               {
                  media = 1;
               }
               chatProba = SPEAKING_ITEMS_CHAT_PROBA;
               if(Math.random() * SPEAKING_ITEMS_CHAT_PROBA <= -1)
               {
                  msg = new LivingObjectMessageRequestMessage();
                  msg.initLivingObjectMessageRequestMessage(speakingText.textStringId,null,itemWrapper.objectUID);
                  ConnectionsHandler.getConnection().send(msg);
               }
               else
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.ChatSpeakingItem,ChatChannelsMultiEnum.CHANNEL_GLOBAL,itemWrapper,speakingText.textString);
               }
            }
            this.generateNextMsgCount(false);
         }
      }
      
      public function destroy() : void
      {
         _self = null;
         _timer.removeEventListener("timer",this.onTimer);
      }
      
      private function generateNextMsgCount(noMin:Boolean) : void
      {
         var msgCount:Number = SPEAKING_ITEMS_MSG_COUNT;
         var delta:Number = SPEAKING_ITEMS_MSG_COUNT_DELTA;
         if(noMin)
         {
            this._nextMessageCount = Math.floor(msgCount * Math.random());
         }
         else
         {
            this._nextMessageCount = msgCount + Math.floor(2 * delta * Math.random());
         }
      }
      
      private function onTimer(event:TimerEvent) : void
      {
         this.triggerEvent(SPEAK_TRIGGER_MINUTE);
      }
   }
}
