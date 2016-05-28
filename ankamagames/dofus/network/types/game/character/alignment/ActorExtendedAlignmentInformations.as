package com.ankamagames.dofus.network.types.game.character.alignment
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class ActorExtendedAlignmentInformations extends ActorAlignmentInformations implements INetworkType
   {
      
      public static const protocolId:uint = 202;
       
      public var honor:uint = 0;
      
      public var dishonor:uint = 0;
      
      public var pvpEnabled:Boolean = false;
      
      public function ActorExtendedAlignmentInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 202;
      }
      
      public function initActorExtendedAlignmentInformations(alignmentSide:int = 0, alignmentValue:uint = 0, alignmentGrade:uint = 0, characterPower:uint = 0, honor:uint = 0, dishonor:uint = 0, pvpEnabled:Boolean = false) : ActorExtendedAlignmentInformations
      {
         super.initActorAlignmentInformations(alignmentSide,alignmentValue,alignmentGrade,characterPower);
         this.honor = honor;
         this.dishonor = dishonor;
         this.pvpEnabled = pvpEnabled;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.honor = 0;
         this.dishonor = 0;
         this.pvpEnabled = false;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_ActorExtendedAlignmentInformations(output);
      }
      
      public function serializeAs_ActorExtendedAlignmentInformations(output:IDataOutput) : void
      {
         super.serializeAs_ActorAlignmentInformations(output);
         if(this.honor < 0 || this.honor > 18000)
         {
            throw new Error("Forbidden value (" + this.honor + ") on element honor.");
         }
         output.writeShort(this.honor);
         if(this.dishonor < 0 || this.dishonor > 500)
         {
            throw new Error("Forbidden value (" + this.dishonor + ") on element dishonor.");
         }
         output.writeShort(this.dishonor);
         output.writeBoolean(this.pvpEnabled);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ActorExtendedAlignmentInformations(input);
      }
      
      public function deserializeAs_ActorExtendedAlignmentInformations(input:IDataInput) : void
      {
         super.deserialize(input);
         this.honor = input.readUnsignedShort();
         if(this.honor < 0 || this.honor > 18000)
         {
            throw new Error("Forbidden value (" + this.honor + ") on element of ActorExtendedAlignmentInformations.honor.");
         }
         this.dishonor = input.readUnsignedShort();
         if(this.dishonor < 0 || this.dishonor > 500)
         {
            throw new Error("Forbidden value (" + this.dishonor + ") on element of ActorExtendedAlignmentInformations.dishonor.");
         }
         this.pvpEnabled = input.readBoolean();
      }
   }
}
