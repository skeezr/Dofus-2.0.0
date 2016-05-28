package com.ankamagames.dofus.network.messages.connection
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.connection.GameServerInformations;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class ServersListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 30;
       
      private var _isInitialized:Boolean = false;
      
      public var servers:Vector.<GameServerInformations>;
      
      public function ServersListMessage()
      {
         this.servers = new Vector.<GameServerInformations>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 30;
      }
      
      public function initServersListMessage(servers:Vector.<GameServerInformations> = null) : ServersListMessage
      {
         this.servers = servers;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.servers = new Vector.<GameServerInformations>();
         this._isInitialized = false;
      }
      
      override public function pack(output:IDataOutput) : void
      {
         var data:ByteArray = new ByteArray();
         this.serialize(data);
         writePacket(output,this.getMessageId(),data);
      }
      
      override public function unpack(input:IDataInput, length:uint) : void
      {
         this.deserialize(input);
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_ServersListMessage(output);
      }
      
      public function serializeAs_ServersListMessage(output:IDataOutput) : void
      {
         output.writeShort(this.servers.length);
         for(var _i1:uint = 0; _i1 < this.servers.length; _i1++)
         {
            (this.servers[_i1] as GameServerInformations).serializeAs_GameServerInformations(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ServersListMessage(input);
      }
      
      public function deserializeAs_ServersListMessage(input:IDataInput) : void
      {
         var _item1:GameServerInformations = null;
         var _serversLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _serversLen; _i1++)
         {
            _item1 = new GameServerInformations();
            _item1.deserialize(input);
            this.servers.push(_item1);
         }
      }
   }
}
