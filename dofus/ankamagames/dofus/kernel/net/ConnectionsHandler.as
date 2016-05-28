package com.ankamagames.dofus.kernel.net
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.network.IServerConnection;
   import com.ankamagames.jerakine.data.XmlConfig;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.jerakine.messages.ConnectionResumedMessage;
   import com.ankamagames.jerakine.network.IConnectionProxy;
   import com.ankamagames.jerakine.network.SnifferServerConnection;
   import com.ankamagames.jerakine.network.ProxyedServerConnection;
   import com.ankamagames.jerakine.network.ServerConnection;
   import com.ankamagames.dofus.network.MessageReceiver;
   import com.ankamagames.dofus.logic.connection.frames.HandshakeFrame;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class ConnectionsHandler
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(ConnectionsHandler));
      
      private static var _useSniffer:Boolean;
      
      private static var _currentConnection:IServerConnection;
      
      private static var _currentConnectionType:uint;
      
      private static var _wantedSocketLost:Boolean;
      
      private static var _wantedSocketLostReason:uint;
       
      public function ConnectionsHandler()
      {
         super();
      }
      
      public static function get useSniffer() : Boolean
      {
         return _useSniffer;
      }
      
      public static function set useSniffer(sniffer:Boolean) : void
      {
         _useSniffer = sniffer;
      }
      
      public static function get connectionType() : uint
      {
         return _currentConnectionType;
      }
      
      public static function getConnection() : IServerConnection
      {
         return _currentConnection;
      }
      
      public static function connectToLoginServer() : void
      {
         if(_currentConnection != null)
         {
            closeConnection();
         }
         var host:String = XmlConfig.getInstance().getEntry("config.connection.host");
         var port:uint = uint(XmlConfig.getInstance().getEntry("config.connection.port"));
         etablishConnection(host,port,_useSniffer);
         _currentConnectionType = ConnectionType.TO_LOGIN_SERVER;
      }
      
      public static function connectToGameServer(gameServerHost:String, gameServerPort:uint) : void
      {
         if(_currentConnection != null)
         {
            closeConnection();
         }
         etablishConnection(gameServerHost,gameServerPort,_useSniffer);
         _currentConnectionType = ConnectionType.TO_GAME_SERVER;
      }
      
      public static function closeConnection() : void
      {
         if(Boolean(_currentConnection) && Boolean(_currentConnection.connected))
         {
            _currentConnection.close();
         }
         _currentConnection = null;
         _currentConnectionType = ConnectionType.DISCONNECTED;
      }
      
      public static function handleDisconnection() : DisconnectionReason
      {
         closeConnection();
         var reason:DisconnectionReason = new DisconnectionReason(_wantedSocketLost,_wantedSocketLostReason);
         _wantedSocketLost = false;
         _wantedSocketLostReason = DisconnectionReasonEnum.UNEXPECTED;
         return reason;
      }
      
      public static function connectionGonnaBeClosed(expectedReason:uint) : void
      {
         _wantedSocketLostReason = expectedReason;
         _wantedSocketLost = true;
      }
      
      public static function pause() : void
      {
         _log.debug("Pause connection");
         _currentConnection.pause();
      }
      
      public static function resume() : void
      {
         _log.debug("Resume connection");
         _currentConnection.resume();
         Kernel.getWorker().process(new ConnectionResumedMessage());
      }
      
      private static function etablishConnection(host:String, port:int, useSniffer:Boolean = false, proxy:IConnectionProxy = null) : void
      {
         if(useSniffer)
         {
            if(proxy != null)
            {
               throw new ArgumentError("Can\'t etablish a connection using a proxy and the sniffer.");
            }
            _currentConnection = new SnifferServerConnection();
         }
         else if(proxy != null)
         {
            _currentConnection = new ProxyedServerConnection(proxy);
         }
         else
         {
            _currentConnection = new ServerConnection();
         }
         _currentConnection.handler = Kernel.getWorker();
         _currentConnection.rawParser = new MessageReceiver();
         Kernel.getWorker().addFrame(new HandshakeFrame());
         _currentConnection.connect(host,port);
      }
   }
}
