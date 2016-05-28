package com.ankamagames.jerakine.console
{
   import com.ankamagames.jerakine.messages.MessageHandler;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import flash.utils.getTimer;
   
   public class ConsoleHandler implements MessageHandler, ConsoleInstructionHandler
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ConsoleHandler));
       
      private var _name:String;
      
      private var _handlers:Dictionary;
      
      private var _outputHandler:MessageHandler;
      
      private var _displayExecutionTime:Boolean;
      
      public function ConsoleHandler(outputHandler:MessageHandler, displayExecutionTime:Boolean = true)
      {
         super();
         this._outputHandler = outputHandler;
         this._handlers = new Dictionary();
         this._displayExecutionTime = displayExecutionTime;
         this._handlers["help"] = this;
      }
      
      public function get handlers() : Dictionary
      {
         return this._handlers;
      }
      
      public function get outputHandler() : MessageHandler
      {
         return this._outputHandler;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function set name(value:String) : void
      {
         this._name = value;
      }
      
      public function process(msg:Message) : Boolean
      {
         if(msg is ConsoleInstructionMessage)
         {
            this.dispatchMessage(ConsoleInstructionMessage(msg));
            return true;
         }
         return false;
      }
      
      public function output(text:String) : void
      {
         this._outputHandler.process(new ConsoleOutputMessage(this._name,text));
      }
      
      public function addHandler(cmd:*, handler:ConsoleInstructionHandler) : void
      {
         var s:String = null;
         if(cmd is Array)
         {
            for each(s in cmd)
            {
               this._handlers[String(s)] = handler;
            }
         }
         else
         {
            this._handlers[String(cmd)] = handler;
         }
      }
      
      public function changeOutputHandler(outputHandler:MessageHandler) : void
      {
         this._outputHandler = outputHandler;
      }
      
      public function removeHandler(cmd:String) : void
      {
         delete this._handlers[cmd];
      }
      
      public function isHandled(cmd:String) : Boolean
      {
         return this._handlers[cmd] != null;
      }
      
      public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
      {
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:ConsoleInstructionHandler = null;
         switch(param2)
         {
            case "help":
               if(param3.length == 0)
               {
                  param1.output(I18n.getText(I18nProxy.getKeyId("ui.console.generalHelp"),[this._name]));
                  _loc4_ = new Array();
                  for(param2 in this._handlers)
                  {
                     _loc4_.push(param2);
                  }
                  _loc4_.sort();
                  for each(_loc5_ in _loc4_)
                  {
                     param1.output("  - <b>" + _loc5_ + "</b>: " + (this._handlers[_loc5_] as ConsoleInstructionHandler).getHelp(_loc5_));
                  }
               }
               else
               {
                  _loc6_ = this._handlers[param3[0]];
                  if(_loc6_)
                  {
                     param1.output("<b>" + _loc5_ + "</b>: " + _loc6_.getHelp(param3[0]));
                  }
                  else
                  {
                     param1.output(I18n.getText(I18nProxy.getKeyId("ui.console.unknownCommand"),[param3[0]]));
                  }
               }
         }
      }
      
      public function getHelp(cmd:String) : String
      {
         switch(cmd)
         {
            case "help":
               return I18n.getText(I18nProxy.getKeyId("ui.console.displayhelp"));
            default:
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.noHelp"),[cmd]);
         }
      }
      
      public function getCmdHelp(sCmd:String) : String
      {
         var cih:ConsoleInstructionHandler = this._handlers[sCmd];
         if(cih)
         {
            return cih.getHelp(sCmd);
         }
         return null;
      }
      
      public function autoComplete(cmd:String) : String
      {
         var sCmd:* = null;
         var newCmd:String = null;
         var bMatch:Boolean = false;
         var i:uint = 0;
         var aMatch:Array = new Array();
         for(sCmd in this._handlers)
         {
            if(sCmd.indexOf(cmd) == 0)
            {
               aMatch.push(sCmd);
            }
         }
         if(aMatch.length > 1)
         {
            newCmd = "";
            bMatch = true;
            for(i = 1; i < 30; )
            {
               if(i > aMatch[0].length)
               {
                  break;
               }
               for each(sCmd in aMatch)
               {
                  bMatch = Boolean(bMatch) && sCmd.indexOf(aMatch[0].substr(0,i)) == 0;
                  if(!bMatch)
                  {
                     break;
                  }
               }
               if(bMatch)
               {
                  newCmd = aMatch[0].substr(0,i);
                  i++;
                  continue;
               }
               break;
            }
            return newCmd;
         }
         return aMatch[0];
      }
      
      private function dispatchMessage(msg:ConsoleInstructionMessage) : void
      {
         var handler:ConsoleInstructionHandler = null;
         var t1:uint = 0;
         if(this._handlers[msg.cmd] != null)
         {
            handler = this._handlers[msg.cmd] as ConsoleInstructionHandler;
            t1 = getTimer();
            handler.handle(this,msg.cmd,msg.args);
            if(this._displayExecutionTime)
            {
               this.output("Command " + msg.cmd + " executed in " + (getTimer() - t1) + " ms");
            }
            return;
         }
         throw new UnhandledConsoleInstructionError(I18n.getText(I18nProxy.getKeyId("ui.console.notfound"),[msg.cmd]));
      }
   }
}
