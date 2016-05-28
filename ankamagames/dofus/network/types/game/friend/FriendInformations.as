package com.ankamagames.dofus.network.types.game.friend
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class FriendInformations implements INetworkType
   {
      
      public static const protocolId:uint = 78;
       
      public var name:String = "";
      
      public var playerState:uint = 99;
      
      public var lastConnection:uint = 0;
      
      public function FriendInformations()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 78;
      }
      
      public function initFriendInformations(name:String = "", playerState:uint = 99, lastConnection:uint = 0) : FriendInformations
      {
         this.name = name;
         this.playerState = playerState;
         this.lastConnection = lastConnection;
         return this;
      }
      
      public function reset() : void
      {
         this.name = "";
         this.playerState = 99;
         this.lastConnection = 0;
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_FriendInformations(output);
      }
      
      public function serializeAs_FriendInformations(output:IDataOutput) : void
      {
         output.writeUTF(this.name);
         output.writeByte(this.playerState);
         if(this.lastConnection < 0)
         {
            throw new Error("Forbidden value (" + this.lastConnection + ") on element lastConnection.");
         }
         output.writeInt(this.lastConnection);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_FriendInformations(input);
      }
      
      public function deserializeAs_FriendInformations(input:IDataInput) : void
      {
         this.name = input.readUTF();
         this.playerState = input.readByte();
         if(this.playerState < 0)
         {
            throw new Error("Forbidden value (" + this.playerState + ") on element of FriendInformations.playerState.");
         }
         this.lastConnection = input.readInt();
         if(this.lastConnection < 0)
         {
            throw new Error("Forbidden value (" + this.lastConnection + ") on element of FriendInformations.lastConnection.");
         }
      }
   }
}
