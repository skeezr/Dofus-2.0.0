package com.ankamagames.jerakine.messages
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.utils.misc.PriorityComparer;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import flash.events.Event;
   import com.ankamagames.jerakine.utils.benchmark.FPS;
   import com.ankamagames.jerakine.handlers.messages.HumanInputMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   
   public class Worker implements MessageHandler
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Worker));
      
      private static const DEBUG_FRAMES:Boolean = true;
      
      private static const DEBUG_MESSAGES:Boolean = false;
      
      private static const MAX_MESSAGES_PER_FRAME:uint = 10;
       
      private var _running:Boolean;
      
      private var _messagesQueue:Vector.<com.ankamagames.jerakine.messages.Message>;
      
      private var _framesList:Vector.<com.ankamagames.jerakine.messages.Frame>;
      
      private var _processingMessage:Boolean;
      
      private var _framesToAddTop:Array;
      
      private var _framesToRemove:Array;
      
      private var _verboseException:Boolean = false;
      
      private var _networkMessageInPause:Boolean = false;
      
      private var _networkMessagesQueue:Vector.<com.ankamagames.jerakine.messages.Message>;
      
      public function Worker(verboseException:Boolean)
      {
         this._framesList = new Vector.<com.ankamagames.jerakine.messages.Frame>();
         this._framesToAddTop = new Array();
         this._framesToRemove = new Array();
         super();
         this._verboseException = true;
      }
      
      public function get running() : Boolean
      {
         return this._running;
      }
      
      public function get messagesQueue() : Vector.<com.ankamagames.jerakine.messages.Message>
      {
         return this._messagesQueue;
      }
      
      public function get framesList() : Vector.<com.ankamagames.jerakine.messages.Frame>
      {
         return this._framesList;
      }
      
      public function get maxMessagesPerFrame() : uint
      {
         return MAX_MESSAGES_PER_FRAME;
      }
      
      public function process(msg:com.ankamagames.jerakine.messages.Message) : Boolean
      {
         if(DEBUG_MESSAGES)
         {
            _log.info("Processing message: " + msg);
         }
         this._messagesQueue.push(msg);
         this.run();
         return true;
      }
      
      public function addFrame(frame:com.ankamagames.jerakine.messages.Frame) : void
      {
         var b:* = false;
         if(DEBUG_FRAMES)
         {
            _log.info("Adding frame: " + frame + " (Frame list before: " + this._framesList + ")");
         }
         var c:Class = Vector.<com.ankamagames.jerakine.messages.Frame> as Class;
         if(!this._processingMessage)
         {
            if(frame.pushed())
            {
               b = frame is com.ankamagames.jerakine.messages.Frame;
               this._framesList.push(frame);
               this._framesList.sort(PriorityComparer.compare);
            }
         }
         else
         {
            this._framesToAddTop.push(frame);
         }
      }
      
      public function removeFrame(frame:com.ankamagames.jerakine.messages.Frame) : void
      {
         var index:int = 0;
         if(!frame)
         {
            return;
         }
         if(DEBUG_FRAMES)
         {
            _log.info("Removing frame: " + frame + " (Frame list before: " + this._framesList + ")");
         }
         if(!this._processingMessage)
         {
            if(frame.pulled())
            {
               index = this._framesList.indexOf(frame);
               if(index > -1)
               {
                  this._framesList.splice(index,1);
               }
            }
         }
         else
         {
            this._framesToRemove.push(frame);
         }
      }
      
      public function contains(frameClass:Class) : Boolean
      {
         return this.getFrame(frameClass) != null;
      }
      
      public function getFrame(frameClass:Class) : com.ankamagames.jerakine.messages.Frame
      {
         var frame:com.ankamagames.jerakine.messages.Frame = null;
         for each(frame in this._framesList)
         {
            if(frame is frameClass)
            {
               return frame;
            }
         }
         return null;
      }
      
      public function clear() : void
      {
         var frame:com.ankamagames.jerakine.messages.Frame = null;
         if(DEBUG_FRAMES)
         {
            _log.info("Clearing worker (no more frames or messages in queue)");
         }
         for each(frame in this._framesList)
         {
            frame.pulled();
         }
         this._framesList = new Vector.<com.ankamagames.jerakine.messages.Frame>();
         this._messagesQueue = new Vector.<com.ankamagames.jerakine.messages.Message>();
         this._networkMessagesQueue = new Vector.<com.ankamagames.jerakine.messages.Message>();
         EnterFrameDispatcher.removeEventListener(this.onEnterFrame);
      }
      
      public function pauseNetworkProcess() : void
      {
         this._networkMessageInPause = true;
      }
      
      public function resumeNetworkProcess() : void
      {
         this._networkMessageInPause = false;
         this.processFramesInAndOut();
         this.runNetworkQueue();
         this.run();
      }
      
      private function run() : void
      {
         if(EnterFrameDispatcher.hasEventListener(this.onEnterFrame))
         {
            return;
         }
         EnterFrameDispatcher.addEventListener(this.onEnterFrame,"Worker");
      }
      
      private function processFramesInAndOut() : void
      {
         var frameToRemove:com.ankamagames.jerakine.messages.Frame = null;
         var index:int = 0;
         var frameToAddTop:com.ankamagames.jerakine.messages.Frame = null;
         if(this._framesToRemove.length > 0)
         {
            for each(frameToRemove in this._framesToRemove)
            {
               if(frameToRemove.pulled())
               {
                  index = this._framesList.indexOf(frameToRemove);
                  if(index > -1)
                  {
                     this._framesList.splice(index,1);
                  }
               }
               else
               {
                  _log.warn("A frame refused to be pulled out: " + frameToRemove);
               }
            }
            this._framesToRemove = new Array();
         }
         if(this._framesToAddTop.length > 0)
         {
            for each(frameToAddTop in this._framesToAddTop)
            {
               if(frameToAddTop.pushed())
               {
                  this._framesList.push(frameToAddTop);
                  this._framesList.sort(PriorityComparer.compare);
               }
               else
               {
                  _log.warn("A frame refused to be pushed in: " + frameToRemove);
               }
            }
            this._framesToAddTop = new Array();
         }
      }
      
      private function onEnterFrame(e:Event) : void
      {
         FPS.getInstance().Nouvelle_Valeur(0,true);
         if(this._verboseException)
         {
            this.processMessage();
         }
         else
         {
            this.processMessage();
         }
         FPS.getInstance().Nouvelle_Valeur(0);
      }
      
      private function runNetworkQueue() : void
      {
         var msg:com.ankamagames.jerakine.messages.Message = null;
         var processed:Boolean = false;
         var frame:com.ankamagames.jerakine.messages.Frame = null;
         var messagesProcessed:uint = 0;
         while(this._networkMessagesQueue.length > 0)
         {
            msg = this._networkMessagesQueue.shift() as com.ankamagames.jerakine.messages.Message;
            this._processingMessage = true;
            processed = false;
            for each(frame in this._framesList)
            {
               if(frame.process(msg))
               {
                  processed = true;
                  break;
               }
            }
            this._processingMessage = false;
            if(!processed && !(msg is HumanInputMessage))
            {
               _log.warn("Discarded message: " + msg);
            }
            else
            {
               _log.info("network message processed : " + msg);
            }
            this.processFramesInAndOut();
            messagesProcessed++;
         }
         if(this._networkMessagesQueue.length == 0)
         {
            EnterFrameDispatcher.removeEventListener(this.onEnterFrame);
         }
      }
      
      private function processMessage() : void
      {
         var msg:com.ankamagames.jerakine.messages.Message = null;
         var processed:Boolean = false;
         var frame:com.ankamagames.jerakine.messages.Frame = null;
         var messagesProcessed:uint = 0;
         var messageUnprocessed:uint = 0;
         while(messagesProcessed < MAX_MESSAGES_PER_FRAME && this._messagesQueue.length > 0)
         {
            msg = this._messagesQueue.shift() as com.ankamagames.jerakine.messages.Message;
            if(msg is INetworkMessage && Boolean(this._networkMessageInPause))
            {
               this._networkMessagesQueue.push(msg);
               _log.warn("Ce message sera surement traité plus tard : " + msg);
               messageUnprocessed++;
            }
            else
            {
               this._processingMessage = true;
               processed = false;
               for each(frame in this._framesList)
               {
                  if(frame.process(msg))
                  {
                     processed = true;
                     break;
                  }
               }
               this._processingMessage = false;
               if(!processed && !(msg is HumanInputMessage))
               {
                  _log.warn("Discarded message: " + msg);
               }
               this.processFramesInAndOut();
            }
            messagesProcessed++;
         }
         if(this._messagesQueue.length == 0 || Boolean(this._networkMessageInPause))
         {
            EnterFrameDispatcher.removeEventListener(this.onEnterFrame);
         }
      }
   }
}
