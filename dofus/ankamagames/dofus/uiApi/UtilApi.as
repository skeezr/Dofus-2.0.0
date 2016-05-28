package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.jerakine.utils.misc.CallWithParameters;
   
   [InstanciedApi]
   public class UtilApi
   {
       
      private var _module:UiModule;
      
      public function UtilApi()
      {
         super();
      }
      
      [ApiData(name="module")]
      public function set module(value:UiModule) : void
      {
         this._module = value;
      }
      
      [Untrusted]
      public function callWithParameters(method:Function, parameters:Array) : void
      {
         CallWithParameters.call(method,parameters);
      }
      
      [Untrusted]
      public function callConstructorWithParameters(callClass:Class, parameters:Array) : *
      {
         return CallWithParameters.callConstructor(callClass,parameters);
      }
      
      [Untrusted]
      public function callRWithParameters(method:Function, parameters:Array) : *
      {
         return CallWithParameters.callR(method,parameters);
      }
   }
}
