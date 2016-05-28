package com.ankamagames.dofus.misc.interClient
{
   import flash.net.LocalConnection;
   import flash.net.SharedObject;
   
   public class InterClientMaster
   {
      
      private static var _receiving_lc:LocalConnection;
       
      private var _sending_lc:LocalConnection;
      
      public function InterClientMaster()
      {
         super();
         this._sending_lc = new LocalConnection();
         _receiving_lc.client = new Object();
         _receiving_lc.client.getUId = this.getUId;
         _receiving_lc.client.ping = this.ping;
      }
      
      public static function etreLeCalif() : InterClientMaster
      {
         try
         {
            if(!_receiving_lc)
            {
               _receiving_lc = new LocalConnection();
            }
            _receiving_lc.connect("_dofus");
            return new InterClientMaster();
         }
         catch(e:ArgumentError)
         {
         }
         return null;
      }
      
      public function destroy() : void
      {
         this._sending_lc = null;
         _receiving_lc.close();
      }
      
      private function getUId(connId:String) : void
      {
         var so:SharedObject = SharedObject.getLocal("uid");
         if(so.data["identity"])
         {
            this._sending_lc.send(connId,"setUId",so.data["identity"]);
         }
         so.close();
      }
      
      private function ping(connId:String) : void
      {
         trace("PING");
         this._sending_lc.send(connId,"pong");
      }
   }
}
