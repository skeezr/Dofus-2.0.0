package com.ankamagames.jerakine.network
{
   import com.ankamagames.jerakine.messages.Message;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public interface INetworkMessage extends Message
   {
       
      function pack(param1:IDataOutput) : void;
      
      function unpack(param1:IDataInput, param2:uint) : void;
      
      function getMessageId() : uint;
      
      function get isInitialized() : Boolean;
   }
}
