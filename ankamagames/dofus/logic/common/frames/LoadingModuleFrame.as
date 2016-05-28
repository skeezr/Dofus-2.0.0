package com.ankamagames.dofus.logic.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.misc.utils.LoadingScreen;
   import flash.utils.Timer;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.dofus.datacenter.misc.Tips;
   import flash.events.TimerEvent;
   import flash.events.Event;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.berilia.types.messages.ModuleRessourceLoadFailedMessage;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.messages.ModuleLoadedMessage;
   import com.ankamagames.berilia.types.messages.ModuleExecErrorMessage;
   import com.ankamagames.berilia.types.messages.UiXmlParsedMessage;
   import com.ankamagames.berilia.types.messages.AllModulesLoadedMessage;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.connection.frames.AuthentificationFrame;
   import com.ankamagames.dofus.logic.connection.managers.AuthentificationManager;
   
   public class LoadingModuleFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(LoadingModuleFrame));
       
      private var _manageAuthentificationFrame:Boolean;
      
      private var _loadingScreen:LoadingScreen;
      
      private var _lastXmlParsedPrc:Number = 0;
      
      private var _tips:Array;
      
      private var _tipsTimer:Timer;
      
      private var _showContinueButton:Boolean = false;
      
      public function LoadingModuleFrame(manageAuthentificationFrame:Boolean = false)
      {
         this._tips = [];
         this._tipsTimer = new Timer(20 * 1000);
         super();
         this._manageAuthentificationFrame = manageAuthentificationFrame;
      }
      
      public function get priority() : int
      {
         return Priority.HIGH;
      }
      
      public function pushed() : Boolean
      {
         var tip:Tips = null;
         this._loadingScreen = new LoadingScreen();
         Dofus.getInstance().addChild(this._loadingScreen);
         for each(tip in Tips.getAllTips())
         {
            this._tips.push(tip);
         }
         this._tipsTimer.addEventListener(TimerEvent.TIMER,this.changeTip);
         this._tipsTimer.start();
         this.changeTip(null);
         return true;
      }
      
      private function changeTip(e:Event) : void
      {
         var tip:Tips = this._tips[Math.floor(this._tips.length * Math.random())] as Tips;
         if(tip)
         {
            this._loadingScreen.tip = tip.description;
         }
      }
      
      public function process(msg:Message) : Boolean
      {
         var mrlfm:ModuleRessourceLoadFailedMessage = null;
         var newPrc:Number = NaN;
         switch(true)
         {
            case msg is ModuleLoadedMessage:
               this._loadingScreen.value = this._loadingScreen.value + 100 / UiModuleManager.getInstance().moduleCount * 0.5;
               this._loadingScreen.log(ModuleLoadedMessage(msg).moduleName + " script loaded",LoadingScreen.IMPORTANT);
               return true;
            case msg is ModuleExecErrorMessage:
               this._loadingScreen.value = this._loadingScreen.value + 100 / UiModuleManager.getInstance().moduleCount * 0.5;
               this._loadingScreen.log("Error while executing " + ModuleExecErrorMessage(msg).moduleName + "\'s main script :\n" + ModuleExecErrorMessage(msg).stackTrace,LoadingScreen.ERROR);
               this._showContinueButton = true;
               return true;
            case msg is ModuleRessourceLoadFailedMessage:
               mrlfm = msg as ModuleRessourceLoadFailedMessage;
               this._loadingScreen.log("Module " + mrlfm.moduleName + " : Cannot load " + mrlfm.uri,!!mrlfm.isImportant?uint(LoadingScreen.ERROR):uint(LoadingScreen.WARNING));
               if(mrlfm.isImportant)
               {
                  this._showContinueButton = true;
               }
               return true;
            case msg is AllModulesLoadedMessage:
               if(this._manageAuthentificationFrame)
               {
                  if(!this._showContinueButton)
                  {
                     this.launchGame();
                  }
                  else
                  {
                     this._showContinueButton = false;
                     this._loadingScreen.continueCallbak = this.launchGame;
                  }
                  return true;
               }
               if(this._showContinueButton)
               {
                  this._showContinueButton = false;
                  this._loadingScreen.continueCallbak = this.dispatchEnd;
                  return true;
               }
               break;
            case msg is UiXmlParsedMessage:
               newPrc = 1 - UiModuleManager.getInstance().unparsedXmlCount / UiModuleManager.getInstance().unparsedXmlTotalCount;
               if(newPrc < this._lastXmlParsedPrc)
               {
                  break;
               }
               this._loadingScreen.log("Preparsing " + UiXmlParsedMessage(msg).url,LoadingScreen.INFO);
               this._loadingScreen.value = this._loadingScreen.value + (newPrc - this._lastXmlParsedPrc) * 100 * 0.5;
               this._lastXmlParsedPrc = newPrc;
               return true;
         }
         return false;
      }
      
      public function pulled() : Boolean
      {
         _log.debug("removed");
         this._tipsTimer.removeEventListener(TimerEvent.TIMER,this.changeTip);
         this._tipsTimer = null;
         this._loadingScreen.parent.removeChild(this._loadingScreen);
         this._loadingScreen = null;
         return true;
      }
      
      private function dispatchEnd() : void
      {
         Kernel.getWorker().process(new AllModulesLoadedMessage());
      }
      
      private function launchGame() : void
      {
         Kernel.getWorker().removeFrame(this);
         this._manageAuthentificationFrame = false;
         Kernel.getWorker().addFrame(new AuthentificationFrame(AuthentificationManager.getInstance().loginValidationAction == null));
         var nb:int = DisconnectionHandlerFrame.messagesAfterReset.length;
         for(var i:int = 0; i < nb; i++)
         {
            Kernel.getWorker().process(DisconnectionHandlerFrame.messagesAfterReset.shift());
         }
         if(AuthentificationManager.getInstance().loginValidationAction)
         {
            Kernel.getWorker().process(AuthentificationManager.getInstance().loginValidationAction);
         }
      }
   }
}
