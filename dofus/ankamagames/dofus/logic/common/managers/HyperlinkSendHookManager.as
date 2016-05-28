package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.berilia.types.data.Hook;
   import com.ankamagames.berilia.utils.errors.ApiError;
   import com.ankamagames.berilia.utils.errors.UntrustedApiCallError;
   import com.ankamagames.jerakine.utils.misc.CallWithParameters;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   
   public class HyperlinkSendHookManager
   {
       
      public function HyperlinkSendHookManager()
      {
         super();
      }
      
      public static function sendHook(hookName:String, ... params) : void
      {
         var targetedHook:Hook = Hook.getHookByName(hookName);
         if(!targetedHook)
         {
            throw new ApiError("Hook [" + hookName + "] does not exist");
         }
         if(targetedHook.nativeHook)
         {
            throw new UntrustedApiCallError("Hook " + hookName + " is a native hook. Native hooks cannot be dispatch by module");
         }
         CallWithParameters.call(KernelEventsManager.getInstance().processCallback,new Array(targetedHook).concat(params));
      }
   }
}
