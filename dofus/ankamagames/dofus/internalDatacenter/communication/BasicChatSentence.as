package com.ankamagames.dofus.internalDatacenter.communication
{
   public class BasicChatSentence
   {
       
      private var _id:uint;
      
      private var _msg:String;
      
      private var _channel:uint;
      
      private var _timestamp:Number;
      
      private var _fingerprint:String;
      
      public function BasicChatSentence(id:uint, msg:String, channel:uint = 0, time:Number = 0, finger:String = "")
      {
         super();
         this._id = id;
         this._msg = msg;
         this._channel = channel;
         this._timestamp = time;
         this._fingerprint = finger;
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get msg() : String
      {
         return this._msg;
      }
      
      public function get channel() : uint
      {
         return this._channel;
      }
      
      public function get timestamp() : Number
      {
         return this._timestamp;
      }
      
      public function get fingerprint() : String
      {
         return this._fingerprint;
      }
   }
}
