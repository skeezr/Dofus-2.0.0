package com.ankamagames.dofus.network.types.game.friend
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   import com.ankamagames.dofus.network.enums.PlayableBreedEnum;
   
   public class IgnoredOnlineInformations extends IgnoredInformations implements INetworkType
   {
      
      public static const protocolId:uint = 105;
       
      public var playerName:String = "";
      
      public var breed:int = 0;
      
      public var sex:Boolean = false;
      
      public function IgnoredOnlineInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 105;
      }
      
      public function initIgnoredOnlineInformations(name:String = "", playerName:String = "", breed:int = 0, sex:Boolean = false) : IgnoredOnlineInformations
      {
         super.initIgnoredInformations(name);
         this.playerName = playerName;
         this.breed = breed;
         this.sex = sex;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.playerName = "";
         this.breed = 0;
         this.sex = false;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_IgnoredOnlineInformations(output);
      }
      
      public function serializeAs_IgnoredOnlineInformations(output:IDataOutput) : void
      {
         super.serializeAs_IgnoredInformations(output);
         output.writeUTF(this.playerName);
         output.writeByte(this.breed);
         output.writeBoolean(this.sex);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_IgnoredOnlineInformations(input);
      }
      
      public function deserializeAs_IgnoredOnlineInformations(input:IDataInput) : void
      {
         super.deserialize(input);
         this.playerName = input.readUTF();
         this.breed = input.readByte();
         if(this.breed < PlayableBreedEnum.Feca || this.breed > PlayableBreedEnum.Pandawa)
         {
            throw new Error("Forbidden value (" + this.breed + ") on element of IgnoredOnlineInformations.breed.");
         }
         this.sex = input.readBoolean();
      }
   }
}
