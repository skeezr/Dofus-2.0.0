package com.ankamagames.dofus.network.messages.game.guild
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GuildPaddockBoughtMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5952;
       
      private var _isInitialized:Boolean = false;
      
      public var worldX:int = 0;
      
      public var worldY:int = 0;
      
      public var nbMountMax:uint = 0;
      
      public var nbItemMax:uint = 0;
      
      public function GuildPaddockBoughtMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5952;
      }
      
      public function initGuildPaddockBoughtMessage(worldX:int = 0, worldY:int = 0, nbMountMax:uint = 0, nbItemMax:uint = 0) : GuildPaddockBoughtMessage
      {
         this.worldX = worldX;
         this.worldY = worldY;
         this.nbMountMax = nbMountMax;
         this.nbItemMax = nbItemMax;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.worldX = 0;
         this.worldY = 0;
         this.nbMountMax = 0;
         this.nbItemMax = 0;
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
         this.serializeAs_GuildPaddockBoughtMessage(output);
      }
      
      public function serializeAs_GuildPaddockBoughtMessage(output:IDataOutput) : void
      {
         if(this.worldX < -255 || this.worldX > 255)
         {
            throw new Error("Forbidden value (" + this.worldX + ") on element worldX.");
         }
         output.writeShort(this.worldX);
         if(this.worldY < -255 || this.worldY > 255)
         {
            throw new Error("Forbidden value (" + this.worldY + ") on element worldY.");
         }
         output.writeShort(this.worldY);
         if(this.nbMountMax < 0)
         {
            throw new Error("Forbidden value (" + this.nbMountMax + ") on element nbMountMax.");
         }
         output.writeByte(this.nbMountMax);
         if(this.nbItemMax < 0)
         {
            throw new Error("Forbidden value (" + this.nbItemMax + ") on element nbItemMax.");
         }
         output.writeByte(this.nbItemMax);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GuildPaddockBoughtMessage(input);
      }
      
      public function deserializeAs_GuildPaddockBoughtMessage(input:IDataInput) : void
      {
         this.worldX = input.readShort();
         if(this.worldX < -255 || this.worldX > 255)
         {
            throw new Error("Forbidden value (" + this.worldX + ") on element of GuildPaddockBoughtMessage.worldX.");
         }
         this.worldY = input.readShort();
         if(this.worldY < -255 || this.worldY > 255)
         {
            throw new Error("Forbidden value (" + this.worldY + ") on element of GuildPaddockBoughtMessage.worldY.");
         }
         this.nbMountMax = input.readByte();
         if(this.nbMountMax < 0)
         {
            throw new Error("Forbidden value (" + this.nbMountMax + ") on element of GuildPaddockBoughtMessage.nbMountMax.");
         }
         this.nbItemMax = input.readByte();
         if(this.nbItemMax < 0)
         {
            throw new Error("Forbidden value (" + this.nbItemMax + ") on element of GuildPaddockBoughtMessage.nbItemMax.");
         }
      }
   }
}
