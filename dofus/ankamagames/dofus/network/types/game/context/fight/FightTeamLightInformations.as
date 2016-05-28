package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class FightTeamLightInformations extends AbstractFightTeamInformations implements INetworkType
   {
      
      public static const protocolId:uint = 115;
       
      public var teamMembersCount:uint = 0;
      
      public function FightTeamLightInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 115;
      }
      
      public function initFightTeamLightInformations(teamId:uint = 2, leaderId:int = 0, teamSide:int = 0, teamMembersCount:uint = 0) : FightTeamLightInformations
      {
         super.initAbstractFightTeamInformations(teamId,leaderId,teamSide);
         this.teamMembersCount = teamMembersCount;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.teamMembersCount = 0;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_FightTeamLightInformations(output);
      }
      
      public function serializeAs_FightTeamLightInformations(output:IDataOutput) : void
      {
         super.serializeAs_AbstractFightTeamInformations(output);
         if(this.teamMembersCount < 0)
         {
            throw new Error("Forbidden value (" + this.teamMembersCount + ") on element teamMembersCount.");
         }
         output.writeByte(this.teamMembersCount);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_FightTeamLightInformations(input);
      }
      
      public function deserializeAs_FightTeamLightInformations(input:IDataInput) : void
      {
         super.deserialize(input);
         this.teamMembersCount = input.readByte();
         if(this.teamMembersCount < 0)
         {
            throw new Error("Forbidden value (" + this.teamMembersCount + ") on element of FightTeamLightInformations.teamMembersCount.");
         }
      }
   }
}
