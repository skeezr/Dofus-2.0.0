package com.ankamagames.dofus.network.types.game.character
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class CharacterMinimalInformations implements INetworkType
   {
      
      public static const protocolId:uint = 110;
       
      public var id:uint = 0;
      
      public var name:String = "";
      
      public var level:uint = 0;
      
      public function CharacterMinimalInformations()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 110;
      }
      
      public function initCharacterMinimalInformations(id:uint = 0, name:String = "", level:uint = 0) : CharacterMinimalInformations
      {
         this.id = id;
         this.name = name;
         this.level = level;
         return this;
      }
      
      public function reset() : void
      {
         this.id = 0;
         this.name = "";
         this.level = 0;
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_CharacterMinimalInformations(output);
      }
      
      public function serializeAs_CharacterMinimalInformations(output:IDataOutput) : void
      {
         if(this.id < 0)
         {
            throw new Error("Forbidden value (" + this.id + ") on element id.");
         }
         output.writeInt(this.id);
         output.writeUTF(this.name);
         if(this.level < 1 || this.level > 200)
         {
            throw new Error("Forbidden value (" + this.level + ") on element level.");
         }
         output.writeByte(this.level);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_CharacterMinimalInformations(input);
      }
      
      public function deserializeAs_CharacterMinimalInformations(input:IDataInput) : void
      {
         this.id = input.readInt();
         if(this.id < 0)
         {
            throw new Error("Forbidden value (" + this.id + ") on element of CharacterMinimalInformations.id.");
         }
         this.name = input.readUTF();
         this.level = input.readUnsignedByte();
         if(this.level < 1 || this.level > 200)
         {
            throw new Error("Forbidden value (" + this.level + ") on element of CharacterMinimalInformations.level.");
         }
      }
   }
}
