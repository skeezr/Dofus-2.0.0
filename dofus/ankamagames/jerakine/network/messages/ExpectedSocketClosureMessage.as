package com.ankamagames.jerakine.network.messages
{
   import com.ankamagames.jerakine.messages.Message;
   
   public class ExpectedSocketClosureMessage implements Message
   {
       
      private var _reason:uint;
      
      public function ExpectedSocketClosureMessage(reason:uint)
      {
         super();
         this._reason = reason;
      }
      
      public function get reason() : uint
      {
         return this._reason;
      }
   }
}
