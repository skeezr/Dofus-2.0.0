package com.ankamagames.jerakine.network
{
   public class ProxyedServerConnection extends ServerConnection
   {
       
      private var _proxy:com.ankamagames.jerakine.network.IConnectionProxy;
      
      public function ProxyedServerConnection(proxy:com.ankamagames.jerakine.network.IConnectionProxy, host:String = null, port:int = 0)
      {
         super(host,port);
         this._proxy = proxy;
      }
      
      public function get proxy() : com.ankamagames.jerakine.network.IConnectionProxy
      {
         return this._proxy;
      }
      
      public function set proxy(value:com.ankamagames.jerakine.network.IConnectionProxy) : void
      {
         this._proxy = value;
      }
      
      override protected function lowSend(msg:INetworkMessage, autoFlush:Boolean = true) : void
      {
         this._proxy.processAndSend(msg,this);
         if(autoFlush)
         {
            flush();
         }
      }
      
      override protected function lowReceive() : INetworkMessage
      {
         return this._proxy.processAndReceive(this);
      }
   }
}
