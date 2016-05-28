package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class FightExternalInformations implements INetworkType
   {
      
      public static const protocolId:uint = 117;
       
      public var fightId:int = 0;
      
      public var fightStart:uint = 0;
      
      public var fightSpectatorLocked:Boolean = false;
      
      public var fightTeams:Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightTeamLightInformations>;
      
      public function FightExternalInformations()
      {
         this.fightTeams = new Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightTeamLightInformations>(2,true);
         super();
      }
      
      public function getTypeId() : uint
      {
         return 117;
      }
      
      public function initFightExternalInformations(fightId:int = 0, fightStart:uint = 0, fightSpectatorLocked:Boolean = false, fightTeams:Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightTeamLightInformations> = null) : FightExternalInformations
      {
         this.fightId = fightId;
         this.fightStart = fightStart;
         this.fightSpectatorLocked = fightSpectatorLocked;
         this.fightTeams = fightTeams;
         return this;
      }
      
      public function reset() : void
      {
         this.fightId = 0;
         this.fightStart = 0;
         this.fightSpectatorLocked = false;
         this.fightTeams = new Vector.<com.ankamagames.dofus.network.types.game.context.fight.FightTeamLightInformations>(2,true);
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_FightExternalInformations(output);
      }
      
      public function serializeAs_FightExternalInformations(output:IDataOutput) : void
      {
         output.writeInt(this.fightId);
         if(this.fightStart < 0)
         {
            throw new Error("Forbidden value (" + this.fightStart + ") on element fightStart.");
         }
         output.writeInt(this.fightStart);
         output.writeBoolean(this.fightSpectatorLocked);
         for(var _i4:uint = 0; _i4 < 2; _i4++)
         {
            this.fightTeams[_i4].serializeAs_FightTeamLightInformations(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_FightExternalInformations(input);
      }
      
      public function deserializeAs_FightExternalInformations(input:IDataInput) : void
      {
         this.fightId = input.readInt();
         this.fightStart = input.readInt();
         if(this.fightStart < 0)
         {
            throw new Error("Forbidden value (" + this.fightStart + ") on element of FightExternalInformations.fightStart.");
         }
         this.fightSpectatorLocked = input.readBoolean();
         for(var _i4:uint = 0; _i4 < 2; _i4++)
         {
            this.fightTeams[_i4] = new com.ankamagames.dofus.network.types.game.context.fight.FightTeamLightInformations();
            this.fightTeams[_i4].deserialize(input);
         }
      }
   }
}
