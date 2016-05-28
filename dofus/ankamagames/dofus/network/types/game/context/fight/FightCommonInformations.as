package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   
   public class FightCommonInformations implements INetworkType
   {
      
      public static const protocolId:uint = 43;
       
      public var fightId:int = 0;
      
      public var fightType:uint = 0;
      
      public var fightTeams:Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightTeamInformations>;
      
      public var fightTeamsPositions:Vector.<uint>;
      
      public var fightTeamsOptions:Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightOptionsInformations>;
      
      public function FightCommonInformations()
      {
         this.fightTeams = new Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightTeamInformations>();
         this.fightTeamsPositions = new Vector.<uint>();
         this.fightTeamsOptions = new Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightOptionsInformations>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 43;
      }
      
      public function initFightCommonInformations(fightId:int = 0, fightType:uint = 0, fightTeams:Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightTeamInformations> = null, fightTeamsPositions:Vector.<uint> = null, fightTeamsOptions:Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightOptionsInformations> = null) : FightCommonInformations
      {
         this.fightId = fightId;
         this.fightType = fightType;
         this.fightTeams = fightTeams;
         this.fightTeamsPositions = fightTeamsPositions;
         this.fightTeamsOptions = fightTeamsOptions;
         return this;
      }
      
      public function reset() : void
      {
         this.fightId = 0;
         this.fightType = 0;
         this.fightTeams = new Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightTeamInformations>();
         this.fightTeamsPositions = new Vector.<uint>();
         this.fightTeamsOptions = new Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightOptionsInformations>();
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_FightCommonInformations(output);
      }
      
      public function serializeAs_FightCommonInformations(output:IDataOutput) : void
      {
         output.writeInt(this.fightId);
         output.writeByte(this.fightType);
         output.writeShort(this.fightTeams.length);
         for(var _i3:uint = 0; _i3 < this.fightTeams.length; _i3++)
         {
            output.writeShort((this.fightTeams[_i3] as com.ankamagames.dofus.network.types.game.context.fight.FightTeamInformations).getTypeId());
            (this.fightTeams[_i3] as com.ankamagames.dofus.network.types.game.context.fight.FightTeamInformations).serialize(output);
         }
         output.writeShort(this.fightTeamsPositions.length);
         for(var _i4:uint = 0; _i4 < this.fightTeamsPositions.length; _i4++)
         {
            if(this.fightTeamsPositions[_i4] < 0 || this.fightTeamsPositions[_i4] > 559)
            {
               throw new Error("Forbidden value (" + this.fightTeamsPositions[_i4] + ") on element 4 (starting at 1) of fightTeamsPositions.");
            }
            output.writeShort(this.fightTeamsPositions[_i4]);
         }
         output.writeShort(this.fightTeamsOptions.length);
         for(var _i5:uint = 0; _i5 < this.fightTeamsOptions.length; _i5++)
         {
            (this.fightTeamsOptions[_i5] as com.ankamagames.dofus.network.types.game.context.fight.FightOptionsInformations).serializeAs_FightOptionsInformations(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_FightCommonInformations(input);
      }
      
      public function deserializeAs_FightCommonInformations(input:IDataInput) : void
      {
         var _id3:uint = 0;
         var _item3:com.ankamagames.dofus.network.types.game.context.fight.FightTeamInformations = null;
         var _val4:uint = 0;
         var _item5:com.ankamagames.dofus.network.types.game.context.fight.FightOptionsInformations = null;
         this.fightId = input.readInt();
         this.fightType = input.readByte();
         if(this.fightType < 0)
         {
            throw new Error("Forbidden value (" + this.fightType + ") on element of FightCommonInformations.fightType.");
         }
         var _fightTeamsLen:uint = input.readUnsignedShort();
         for(var _i3:uint = 0; _i3 < _fightTeamsLen; _i3++)
         {
            _id3 = input.readUnsignedShort();
            _item3 = ProtocolTypeManager.getInstance(com.ankamagames.dofus.network.types.game.context.fight.FightTeamInformations,_id3);
            _item3.deserialize(input);
            this.fightTeams.push(_item3);
         }
         var _fightTeamsPositionsLen:uint = input.readUnsignedShort();
         for(var _i4:uint = 0; _i4 < _fightTeamsPositionsLen; _i4++)
         {
            _val4 = input.readShort();
            if(_val4 < 0 || _val4 > 559)
            {
               throw new Error("Forbidden value (" + _val4 + ") on elements of fightTeamsPositions.");
            }
            this.fightTeamsPositions.push(_val4);
         }
         var _fightTeamsOptionsLen:uint = input.readUnsignedShort();
         for(var _i5:uint = 0; _i5 < _fightTeamsOptionsLen; _i5++)
         {
            _item5 = new com.ankamagames.dofus.network.types.game.context.fight.FightOptionsInformations();
            _item5.deserialize(input);
            this.fightTeamsOptions.push(_item5);
         }
      }
   }
}
