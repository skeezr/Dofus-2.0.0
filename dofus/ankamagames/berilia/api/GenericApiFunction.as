package com.ankamagames.berilia.api
{
   import com.ankamagames.berilia.utils.errors.UntrustedApiCallError;
   
   public class GenericApiFunction
   {
       
      public function GenericApiFunction()
      {
         super();
      }
      
      public static function throwUntrustedCallError(... args) : void
      {
         throw new UntrustedApiCallError("Unstrusted script called a trusted method");
      }
   }
}
