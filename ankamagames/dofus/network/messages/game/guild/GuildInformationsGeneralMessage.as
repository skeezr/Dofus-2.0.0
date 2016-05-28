package com.ankamagames.dofus.network.messages.game.guild
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GuildInformationsGeneralMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 5557;
       
      private var _isInitialized:Boolean = false;
      
      public var enabled:Boolean = false;
      
      public var level:uint = 0;
      
      public var expLevelFloor:Number = 0;
      
      public var experience:Number = 0;
      
      public var expNextLevelFloor:Number = 0;
      
      public function GuildInformationsGeneralMessage()
      {
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 5557;
      }
      
      public function initGuildInformationsGeneralMessage(enabled:Boolean = false, level:uint = 0, expLevelFloor:Number = 0, experience:Number = 0, expNextLevelFloor:Number = 0) : GuildInformationsGeneralMessage
      {
         this.enabled = enabled;
         this.level = level;
         this.expLevelFloor = expLevelFloor;
         this.experience = experience;
         this.expNextLevelFloor = expNextLevelFloor;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.enabled = false;
         this.level = 0;
         this.expLevelFloor = 0;
         this.experience = 0;
         this.expNextLevelFloor = 0;
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
         this.serializeAs_GuildInformationsGeneralMessage(output);
      }
      
      public function serializeAs_GuildInformationsGeneralMessage(output:IDataOutput) : void
      {
         output.writeBoolean(this.enabled);
         if(this.level < 0)
         {
            throw new Error("Forbidden value (" + this.level + ") on element level.");
         }
         output.writeByte(this.level);
         if(this.expLevelFloor < 0)
         {
            throw new Error("Forbidden value (" + this.expLevelFloor + ") on element expLevelFloor.");
         }
         output.writeDouble(this.expLevelFloor);
         if(this.experience < 0)
         {
            throw new Error("Forbidden value (" + this.experience + ") on element experience.");
         }
         output.writeDouble(this.experience);
         if(this.expNextLevelFloor < 0)
         {
            throw new Error("Forbidden value (" + this.expNextLevelFloor + ") on element expNextLevelFloor.");
         }
         output.writeDouble(this.expNextLevelFloor);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GuildInformationsGeneralMessage(input);
      }
      
      public function deserializeAs_GuildInformationsGeneralMessage(input:IDataInput) : void
      {
         this.enabled = input.readBoolean();
         this.level = input.readByte();
         if(this.level < 0)
         {
            throw new Error("Forbidden value (" + this.level + ") on element of GuildInformationsGeneralMessage.level.");
         }
         this.expLevelFloor = input.readDouble();
         if(this.expLevelFloor < 0)
         {
            throw new Error("Forbidden value (" + this.expLevelFloor + ") on element of GuildInformationsGeneralMessage.expLevelFloor.");
         }
         this.experience = input.readDouble();
         if(this.experience < 0)
         {
            throw new Error("Forbidden value (" + this.experience + ") on element of GuildInformationsGeneralMessage.experience.");
         }
         this.expNextLevelFloor = input.readDouble();
         if(this.expNextLevelFloor < 0)
         {
            throw new Error("Forbidden value (" + this.expNextLevelFloor + ") on element of GuildInformationsGeneralMessage.expNextLevelFloor.");
         }
      }
   }
}
