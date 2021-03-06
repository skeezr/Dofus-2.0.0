package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class AbstractFightTeamInformations implements INetworkType
   {
      
      public static const protocolId:uint = 116;
       
      public var teamId:uint = 2;
      
      public var leaderId:int = 0;
      
      public var teamSide:int = 0;
      
      public function AbstractFightTeamInformations()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 116;
      }
      
      public function initAbstractFightTeamInformations(teamId:uint = 2, leaderId:int = 0, teamSide:int = 0) : AbstractFightTeamInformations
      {
         this.teamId = teamId;
         this.leaderId = leaderId;
         this.teamSide = teamSide;
         return this;
      }
      
      public function reset() : void
      {
         this.teamId = 2;
         this.leaderId = 0;
         this.teamSide = 0;
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_AbstractFightTeamInformations(output);
      }
      
      public function serializeAs_AbstractFightTeamInformations(output:IDataOutput) : void
      {
         output.writeByte(this.teamId);
         output.writeInt(this.leaderId);
         output.writeByte(this.teamSide);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_AbstractFightTeamInformations(input);
      }
      
      public function deserializeAs_AbstractFightTeamInformations(input:IDataInput) : void
      {
         this.teamId = input.readByte();
         if(this.teamId < 0)
         {
            throw new Error("Forbidden value (" + this.teamId + ") on element of AbstractFightTeamInformations.teamId.");
         }
         this.leaderId = input.readInt();
         this.teamSide = input.readByte();
      }
   }
}
