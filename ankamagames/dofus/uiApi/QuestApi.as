package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.logic.game.common.frames.QuestFrame;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class QuestApi
   {
       
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      public function QuestApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(QuestApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(value:UiModule) : void
      {
         this._module = value;
      }
      
      [Untrusted]
      public function getQuestInformations(questId:int) : Object
      {
         return this.getQuestFrame().getQuestInformations(questId);
      }
      
      [Untrusted]
      public function getAllQuests() : Vector.<Object>
      {
         var activeQuest:uint = 0;
         var completedQuests:Vector.<uint> = null;
         var completedQuest:uint = 0;
         var r:Vector.<Object> = new Vector.<Object>(0,false);
         var activeQuests:Vector.<uint> = this.getQuestFrame().getActiveQuests();
         for each(activeQuest in activeQuests)
         {
            r.push({
               "id":activeQuest,
               "status":true
            });
         }
         completedQuests = this.getQuestFrame().getCompletedQuests();
         for each(completedQuest in completedQuests)
         {
            r.push({
               "id":completedQuest,
               "status":false
            });
         }
         return r;
      }
      
      [Untrusted]
      public function getActiveQuests() : Vector.<uint>
      {
         return this.getQuestFrame().getActiveQuests();
      }
      
      [Untrusted]
      public function getCompletedQuests() : Vector.<uint>
      {
         return this.getQuestFrame().getCompletedQuests();
      }
      
      [Untrusted]
      public function getTutorialReward() : Vector.<ItemWrapper>
      {
         var itemWrapperList:Vector.<ItemWrapper> = new Vector.<ItemWrapper>();
         itemWrapperList.push(ItemWrapper.create(0,0,10785,1,null,false));
         itemWrapperList.push(ItemWrapper.create(0,0,10794,1,null,false));
         itemWrapperList.push(ItemWrapper.create(0,0,10797,1,null,false));
         itemWrapperList.push(ItemWrapper.create(0,0,10798,1,null,false));
         itemWrapperList.push(ItemWrapper.create(0,0,10799,1,null,false));
         itemWrapperList.push(ItemWrapper.create(0,0,10784,1,null,false));
         itemWrapperList.push(ItemWrapper.create(0,0,10800,1,null,false));
         itemWrapperList.push(ItemWrapper.create(0,0,10801,1,null,false));
         return itemWrapperList;
      }
      
      [Untrusted]
      public function getNotificationList() : Array
      {
         return QuestFrame.notificationList;
      }
      
      private function getQuestFrame() : QuestFrame
      {
         return Kernel.getWorker().getFrame(QuestFrame) as QuestFrame;
      }
   }
}
