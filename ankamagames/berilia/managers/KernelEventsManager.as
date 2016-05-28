package com.ankamagames.berilia.managers
{
   import com.ankamagames.berilia.types.data.Hook;
   import com.ankamagames.berilia.types.listener.GenericListener;
   import com.ankamagames.jerakine.utils.misc.BoxingUnBoxing;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.jerakine.interfaces.Secure;
   import com.ankamagames.berilia.types.event.HookLogEvent;
   import com.ankamagames.berilia.types.event.UiRenderEvent;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class KernelEventsManager extends GenericEventsManager
   {
      
      private static var _self:com.ankamagames.berilia.managers.KernelEventsManager;
       
      private var _aLoadingUi:Array;
      
      public function KernelEventsManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("KernelEventsManager is a singleton and should not be instanciated directly.");
         }
         this._aLoadingUi = new Array();
         Berilia.getInstance().addEventListener(UiRenderEvent.UIRenderComplete,this.processOldMessage);
         Berilia.getInstance().addEventListener(UiRenderEvent.UIRenderFailed,this.processOldMessage);
      }
      
      public static function getInstance() : com.ankamagames.berilia.managers.KernelEventsManager
      {
         if(_self == null)
         {
            _self = new com.ankamagames.berilia.managers.KernelEventsManager();
         }
         return _self;
      }
      
      public function isRegisteredEvent(name:String) : Boolean
      {
         return _aEvent[name] != null;
      }
      
      public function processCallback(hook:Hook, ... args) : void
      {
         var s:* = null;
         var i:uint = 0;
         var e:GenericListener = null;
         var boxedParam:Array = BoxingUnBoxing.boxParam(args);
         for(s in Berilia.getInstance().loadingUi)
         {
            if(Berilia.getInstance().loadingUi[s])
            {
               if(this._aLoadingUi[s] == null)
               {
                  this._aLoadingUi[s] = new Array();
               }
               this._aLoadingUi[s].push({
                  "hook":hook,
                  "args":boxedParam
               });
            }
         }
         for(i = 0; i < args.length; i++)
         {
            if(args[i] is Secure)
            {
               if(BoxingUnBoxing.unbox(args[i]))
               {
                  if(Object(args[i]).hasOwnProperty("name"))
                  {
                     args[i] = args[i].name + " (Secure)";
                  }
                  else
                  {
                     args[i] = args[i].toString();
                  }
               }
               else
               {
                  args[i] = null;
               }
            }
         }
         _log.logDirectly(new HookLogEvent(hook.name,args));
         if(!_aEvent[hook.name])
         {
            return;
         }
         var tmpListner:Array = [];
         for each(e in _aEvent[hook.name])
         {
            tmpListner.push(e);
         }
         for each(e in tmpListner)
         {
            if(e)
            {
               e.getCallback().apply(null,boxedParam);
            }
         }
      }
      
      private function processOldMessage(e:UiRenderEvent) : void
      {
         var hook:Hook = null;
         var args:Array = null;
         var s:* = null;
         var eGl:GenericListener = null;
         if(!this._aLoadingUi[e.uiTarget.name])
         {
            return;
         }
         if(e.type == UiRenderEvent.UIRenderFailed)
         {
            this._aLoadingUi[e.uiTarget.name] = null;
            return;
         }
         for(var i:uint = 0; i < this._aLoadingUi[e.uiTarget.name].length; i++)
         {
            hook = this._aLoadingUi[e.uiTarget.name][i].hook;
            args = this._aLoadingUi[e.uiTarget.name][i].args;
            for(s in _aEvent[hook.name])
            {
               if(_aEvent[hook.name][s])
               {
                  eGl = _aEvent[hook.name][s];
                  if(eGl.listener == e.uiTarget.name)
                  {
                     eGl.getCallback().apply(null,args);
                  }
                  if(_aEvent[hook.name] == null)
                  {
                     break;
                  }
               }
            }
         }
         delete this._aLoadingUi[e.uiTarget.name];
      }
   }
}
