package com.ankamagames.dofus.network.types.game.character.choice
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class CharacterToRecolorInformation implements INetworkType
   {
      
      public static const protocolId:uint = 212;
       
      public var id:uint = 0;
      
      public var colors:Vector.<int>;
      
      public function CharacterToRecolorInformation()
      {
         this.colors = new Vector.<int>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 212;
      }
      
      public function initCharacterToRecolorInformation(id:uint = 0, colors:Vector.<int> = null) : CharacterToRecolorInformation
      {
         this.id = id;
         this.colors = colors;
         return this;
      }
      
      public function reset() : void
      {
         this.id = 0;
         this.colors = new Vector.<int>();
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_CharacterToRecolorInformation(output);
      }
      
      public function serializeAs_CharacterToRecolorInformation(output:IDataOutput) : void
      {
         if(this.id < 0)
         {
            throw new Error("Forbidden value (" + this.id + ") on element id.");
         }
         output.writeInt(this.id);
         output.writeShort(this.colors.length);
         for(var _i2:uint = 0; _i2 < this.colors.length; _i2++)
         {
            output.writeInt(this.colors[_i2]);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_CharacterToRecolorInformation(input);
      }
      
      public function deserializeAs_CharacterToRecolorInformation(input:IDataInput) : void
      {
         var _val2:int = 0;
         this.id = input.readInt();
         if(this.id < 0)
         {
            throw new Error("Forbidden value (" + this.id + ") on element of CharacterToRecolorInformation.id.");
         }
         var _colorsLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _colorsLen; _i2++)
         {
            _val2 = input.readInt();
            this.colors.push(_val2);
         }
      }
   }
}
