package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class GameRolePlayMutantInformations extends GameRolePlayHumanoidInformations implements INetworkType
   {
      
      public static const protocolId:uint = 3;
       
      public var powerLevel:int = 0;
      
      public function GameRolePlayMutantInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 3;
      }
      
      public function initGameRolePlayMutantInformations(contextualId:int = 0, look:EntityLook = null, disposition:EntityDispositionInformations = null, name:String = "", humanoidInfo:HumanInformations = null, powerLevel:int = 0) : GameRolePlayMutantInformations
      {
         super.initGameRolePlayHumanoidInformations(contextualId,look,disposition,name,humanoidInfo);
         this.powerLevel = powerLevel;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.powerLevel = 0;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_GameRolePlayMutantInformations(output);
      }
      
      public function serializeAs_GameRolePlayMutantInformations(output:IDataOutput) : void
      {
         super.serializeAs_GameRolePlayHumanoidInformations(output);
         output.writeByte(this.powerLevel);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameRolePlayMutantInformations(input);
      }
      
      public function deserializeAs_GameRolePlayMutantInformations(input:IDataInput) : void
      {
         super.deserialize(input);
         this.powerLevel = input.readByte();
      }
   }
}
