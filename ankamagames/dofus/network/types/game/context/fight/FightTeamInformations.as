package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   
   public class FightTeamInformations extends AbstractFightTeamInformations implements INetworkType
   {
      
      public static const protocolId:uint = 33;
       
      public var teamMembers:Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberInformations>;
      
      public function FightTeamInformations()
      {
         this.teamMembers = new Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberInformations>();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 33;
      }
      
      public function initFightTeamInformations(teamId:uint = 2, leaderId:int = 0, teamSide:int = 0, teamMembers:Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberInformations> = null) : FightTeamInformations
      {
         super.initAbstractFightTeamInformations(teamId,leaderId,teamSide);
         this.teamMembers = teamMembers;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.teamMembers = new Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberInformations>();
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_FightTeamInformations(output);
      }
      
      public function serializeAs_FightTeamInformations(output:IDataOutput) : void
      {
         super.serializeAs_AbstractFightTeamInformations(output);
         output.writeShort(this.teamMembers.length);
         for(var _i1:uint = 0; _i1 < this.teamMembers.length; _i1++)
         {
            output.writeShort((this.teamMembers[_i1] as com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberInformations).getTypeId());
            (this.teamMembers[_i1] as com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberInformations).serialize(output);
         }
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_FightTeamInformations(input);
      }
      
      public function deserializeAs_FightTeamInformations(input:IDataInput) : void
      {
         var _id1:uint = 0;
         var _item1:com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberInformations = null;
         super.deserialize(input);
         var _teamMembersLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _teamMembersLen; _i1++)
         {
            _id1 = input.readUnsignedShort();
            _item1 = ProtocolTypeManager.getInstance(com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberInformations,_id1);
            _item1.deserialize(input);
            this.teamMembers.push(_item1);
         }
      }
   }
}
