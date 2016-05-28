package com.ankamagames.dofus.misc.utils
{
   import com.ankamagames.jerakine.logger.targets.AbstractTarget;
   import flash.filesystem.File;
   import flash.filesystem.FileStream;
   import com.ankamagames.jerakine.logger.LogEvent;
   import com.ankamagames.berilia.types.event.HookLogEvent;
   import com.ankamagames.dofus.types.events.SendActionLogEvent;
   import com.ankamagames.jerakine.network.NetworkLogEvent;
   import com.ankamagames.jerakine.types.events.RegisterClassLogEvent;
   import com.ankamagames.jerakine.logger.TextLogEvent;
   import com.ankamagames.jerakine.logger.ExceptionLogEvent;
   import flash.utils.getTimer;
   import flash.utils.ByteArray;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.utils.crypto.Base64;
   import flash.filesystem.FileMode;
   
   public class DebugTarget extends AbstractTarget
   {
      
      private static const LOG_TEXT:uint = 0;
      
      private static const LOG_HOOK:uint = 1;
      
      private static const LOG_ACTION:uint = 2;
      
      private static const LOG_NETWORK:uint = 3;
      
      private static const LOG_REGISTERCLASS:uint = 4;
      
      private static const LOG_EXCEPTION:uint = 5;
       
      private var _file:File;
      
      private var _fileStream:FileStream;
      
      public function DebugTarget()
      {
         super();
      }
      
      override public function logEvent(event:LogEvent) : void
      {
         var hle:HookLogEvent = null;
         var sale:SendActionLogEvent = null;
         var nle:NetworkLogEvent = null;
         if(!this._file)
         {
            this.init();
         }
         try
         {
            switch(true)
            {
               case event is HookLogEvent:
                  hle = event as HookLogEvent;
                  this.addLine(LOG_HOOK,hle.name + ";" + this.encode(hle.params));
                  break;
               case event is SendActionLogEvent:
                  sale = event as SendActionLogEvent;
                  this.addLine(LOG_ACTION,sale.name + ";" + this.encode(sale.params));
                  break;
               case event is NetworkLogEvent:
                  nle = event as NetworkLogEvent;
                  this.addLine(LOG_NETWORK,(!!nle.isServerMsg?0:1) + ";" + this.encode(nle.networkMessage));
                  break;
               case event is TextLogEvent:
                  this.addLine(LOG_TEXT,event.level + ";" + event.message);
                  break;
               case event is RegisterClassLogEvent:
                  this.addLine(LOG_REGISTERCLASS,RegisterClassLogEvent(event).className);
                  break;
               case event is ExceptionLogEvent:
                  this.addLine(LOG_EXCEPTION,event.level + ";" + event.message.split("\n").join("|"));
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function addLine(type:uint, data:String) : void
      {
         this._fileStream.writeUTFBytes(getTimer() + ";" + type + ";" + data + "\n");
      }
      
      private function encode(obj:*) : String
      {
         var baObject:ByteArray = null;
         var encodedString:String = null;
         switch(true)
         {
            case obj is Array:
               if(!(obj as Array).length)
               {
                  return "A";
               }
            case obj is Object:
               StoreDataManager.getInstance().registerClass(obj,true,false);
               baObject = new ByteArray();
               baObject.writeObject(obj);
               baObject.position = 0;
               encodedString = Base64.encodeByteArray(baObject);
               return "O" + encodedString;
            default:
               return null;
         }
      }
      
      private function init() : void
      {
         var deleteFile:File = null;
         var date:Date = new Date();
         this._file = File.applicationStorageDirectory.resolvePath("logs/log_" + date.fullYear + "-" + date.month + "-" + date.day + "_" + date.hours + "h" + date.minutes + "m" + date.seconds + "s" + date.milliseconds + ".txt");
         this._file.parent.createDirectory();
         this._fileStream = new FileStream();
         this._fileStream.open(this._file,FileMode.WRITE);
         var log_files:Array = this._file.parent.getDirectoryListing();
         log_files.sortOn("creationDate",Array.DESCENDING);
         try
         {
            while(log_files.length > 20)
            {
               deleteFile = log_files.pop();
               if(deleteFile.url.indexOf("log_") != -1 && deleteFile.extension == "txt")
               {
                  deleteFile.deleteFile();
               }
            }
         }
         catch(e:Error)
         {
         }
      }
   }
}
