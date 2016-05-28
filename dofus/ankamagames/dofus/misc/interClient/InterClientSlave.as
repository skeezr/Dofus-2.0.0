package com.ankamagames.dofus.misc.interClient
{
   import flash.net.LocalConnection;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import flash.net.SharedObject;
   import flash.events.Event;
   import flash.events.StatusEvent;
   
   public class InterClientSlave
   {
       
      private var _receiving_lc:LocalConnection;
      
      private var _sending_lc:LocalConnection;
      
      private var _connId:String;
      
      private var _statusTimer:Timer;
      
      public function InterClientSlave()
      {
         super();
         this._receiving_lc = new LocalConnection();
         this._sending_lc = new LocalConnection();
         var idIsFree:Boolean = false;
         while(!idIsFree)
         {
            this._connId = "_dofus" + Math.floor(Math.random() * 100000000);
            try
            {
               this._receiving_lc.connect(this._connId);
               idIsFree = true;
            }
            catch(e:Error)
            {
               continue;
            }
         }
         this._sending_lc.addEventListener(StatusEvent.STATUS,this.onStatusChange);
         this._receiving_lc.client = new Object();
         this._receiving_lc.client.setUId = this.setUId;
         this._receiving_lc.client.pong = this.pong;
         this._statusTimer = new Timer(10000);
         this._statusTimer.addEventListener(TimerEvent.TIMER,this.onTick);
         this._statusTimer.start();
      }
      
      public function destroy() : void
      {
         this._receiving_lc.close();
         this._statusTimer.removeEventListener(TimerEvent.TIMER,this.onTick);
      }
      
      private function setUId(uid:String) : void
      {
         var so:SharedObject = SharedObject.getLocal("uid");
         so.data["identity"] = uid;
         so.flush();
         so.close();
      }
      
      private function pong() : void
      {
         trace("PONG");
      }
      
      private function onTick(e:Event) : void
      {
         trace("PING REQUEST");
         this._sending_lc.send("_dofus","ping",this._connId);
      }
      
      private function onStatusChange(e:StatusEvent) : void
      {
         if(e.level == "error")
         {
            InterClientManager.getInstance().update();
         }
      }
   }
}
