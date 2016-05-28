package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.datacenter.communication.ChatChannel;
   import com.ankamagames.dofus.internalDatacenter.communication.BasicChatSentence;
   import com.ankamagames.dofus.internalDatacenter.communication.ChatSentenceWithSource;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.internalDatacenter.communication.ChatSentenceWithRecipient;
   import com.ankamagames.dofus.internalDatacenter.communication.ChatInformationSentence;
   import com.ankamagames.berilia.factories.HyperlinkFactory;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkItemManager;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class ChatApi
   {
       
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      private var _frame:ChatFrame;
      
      public function ChatApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(ChatApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(value:UiModule) : void
      {
         this._module = value;
         this._frame = Kernel.getWorker().getFrame(ChatFrame) as ChatFrame;
      }
      
      private function initialisationFrame() : void
      {
         this._frame = Kernel.getWorker().getFrame(ChatFrame) as ChatFrame;
      }
      
      [Untrusted]
      public function getChannelsId() : Array
      {
         var chan:* = undefined;
         if(!this._frame)
         {
            this.initialisationFrame();
         }
         var disallowed:Array = this._frame.disallowedChannels;
         var list:Array = new Array();
         for each(chan in ChatChannel.getChannels())
         {
            if(disallowed.indexOf(chan.id) == -1)
            {
               list.push(chan.id);
            }
         }
         return list;
      }
      
      [Untrusted]
      public function getDisallowedChannelsId() : Array
      {
         return this._frame.disallowedChannels;
      }
      
      [Untrusted]
      public function getMessagesByChannel(channel:uint) : Array
      {
         if(!this._frame)
         {
            this.initialisationFrame();
         }
         var list:Array = this._frame.getMessages();
         return list[channel];
      }
      
      [Untrusted]
      public function newBasicChatSentence(id:uint, msg:String, channel:uint = 0, time:Number = 0, finger:String = "") : BasicChatSentence
      {
         var bsc:BasicChatSentence = new BasicChatSentence(id,msg,channel,time,finger);
         return bsc;
      }
      
      [Untrusted]
      public function newChatSentenceWithSource(id:uint, msg:String, channel:uint = 0, time:Number = 0, finger:String = "", senderId:uint = 0, senderName:String = "", objects:Vector.<ItemWrapper> = null) : ChatSentenceWithSource
      {
         var csws:ChatSentenceWithSource = new ChatSentenceWithSource(id,msg,channel,time,finger,senderId,senderName,objects);
         return csws;
      }
      
      [Untrusted]
      public function newChatSentenceWithRecipient(id:uint, msg:String, channel:uint = 0, time:Number = 0, finger:String = "", senderId:uint = 0, senderName:String = "", receiverName:String = "", receiverId:uint = 0, objects:Vector.<ItemWrapper> = null) : ChatSentenceWithRecipient
      {
         var cswr:ChatSentenceWithRecipient = new ChatSentenceWithRecipient(id,msg,channel,time,finger,senderId,senderName,receiverName,receiverId,objects);
         return cswr;
      }
      
      [Untrusted]
      public function getTypeOfChatSentence(msg:Object) : String
      {
         if(msg is ChatSentenceWithRecipient)
         {
            return "recipientSentence";
         }
         if(msg is ChatSentenceWithSource)
         {
            return "sourceSentence";
         }
         if(msg is ChatInformationSentence)
         {
            return "informationSentence";
         }
         return "basicSentence";
      }
      
      [Untrusted]
      public function searchChannel(chan:String) : int
      {
         var i:* = undefined;
         var channels:Array = ChatChannel.getChannels();
         for(i in channels)
         {
            if(chan == channels[i].shortcut)
            {
               return channels[i].id;
            }
         }
         return -1;
      }
      
      [Untrusted]
      public function getHistoryByIndex(name:String, index:uint) : String
      {
         return "";
      }
      
      [Untrusted]
      public function getRedChannelId() : uint
      {
         if(!this._frame)
         {
            this.initialisationFrame();
         }
         return this._frame.getRedId();
      }
      
      [Untrusted]
      public function getStaticHyperlink(string:String) : String
      {
         return HyperlinkFactory.decode(string,false);
      }
      
      [Untrusted]
      public function newChatItem(item:ItemWrapper) : String
      {
         return HyperlinkItemManager.newChatItem(item);
      }
   }
}
