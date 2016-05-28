package com.ankamagames.dofus.misc.interClient
{
   import flash.net.SharedObject;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class InterClientManager
   {
      
      private static var _self:com.ankamagames.dofus.misc.interClient.InterClientManager;
       
      private var _client:com.ankamagames.dofus.misc.interClient.InterClientSlave;
      
      private var _master:com.ankamagames.dofus.misc.interClient.InterClientMaster;
      
      private var hex_chars:Array;
      
      public function InterClientManager()
      {
         this.hex_chars = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"];
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         var so:SharedObject = SharedObject.getLocal("uid");
         if(!so.data["identity"])
         {
            so.data["identity"] = this.getRandomFlashKey();
            so.flush();
         }
         so.close();
      }
      
      public static function getInstance() : com.ankamagames.dofus.misc.interClient.InterClientManager
      {
         if(!_self)
         {
            _self = new com.ankamagames.dofus.misc.interClient.InterClientManager();
         }
         return _self;
      }
      
      public static function destroy() : void
      {
         if(_self)
         {
            if(_self._client)
            {
               _self._client.destroy();
            }
            if(_self._master)
            {
               _self._master.destroy();
            }
         }
      }
      
      public static function isMaster() : Boolean
      {
         return _self._master != null;
      }
      
      public function get flashKey() : String
      {
         var so:SharedObject = SharedObject.getLocal("uid");
         var key:String = so.data["identity"];
         so.close();
         if(key)
         {
            return key;
         }
         return null;
      }
      
      public function update() : void
      {
         this._master = com.ankamagames.dofus.misc.interClient.InterClientMaster.etreLeCalif();
         if(!this._master && !this._client)
         {
            this._client = new com.ankamagames.dofus.misc.interClient.InterClientSlave();
         }
         if(Boolean(this._master) && Boolean(this._client))
         {
            this._client.destroy();
            this._client = null;
         }
      }
      
      private function getRandomFlashKey() : String
      {
         var sSentance:String = "";
         var nLen:Number = 20;
         for(var i:Number = 0; i < nLen; i++)
         {
            sSentance = sSentance + this.getRandomChar();
         }
         return sSentance + this.checksum(sSentance);
      }
      
      private function checksum(s:String) : String
      {
         var r:Number = 0;
         for(var i:Number = 0; i < s.length; i++)
         {
            r = r + s.charCodeAt(i) % 16;
         }
         return this.hex_chars[r % 16];
      }
      
      private function getRandomChar() : String
      {
         var n:Number = Math.ceil(Math.random() * 100);
         if(n <= 40)
         {
            return String.fromCharCode(Math.floor(Math.random() * 26) + 65);
         }
         if(n <= 80)
         {
            return String.fromCharCode(Math.floor(Math.random() * 26) + 97);
         }
         return String.fromCharCode(Math.floor(Math.random() * 10) + 48);
      }
   }
}
