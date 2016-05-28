package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class GameFightFighterInformations extends GameContextActorInformations implements INetworkType
   {
      
      public static const protocolId:uint = 143;
       
      public var teamId:uint = 2;
      
      public var alive:Boolean = false;
      
      public var stats:com.ankamagames.dofus.network.types.game.context.fight.GameFightMinimalStats;
      
      public function GameFightFighterInformations()
      {
         this.stats = new com.ankamagames.dofus.network.types.game.context.fight.GameFightMinimalStats();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 143;
      }
      
      public function initGameFightFighterInformations(contextualId:int = 0, look:EntityLook = null, disposition:EntityDispositionInformations = null, teamId:uint = 2, alive:Boolean = false, stats:com.ankamagames.dofus.network.types.game.context.fight.GameFightMinimalStats = null) : GameFightFighterInformations
      {
         super.initGameContextActorInformations(contextualId,look,disposition);
         this.teamId = teamId;
         this.alive = alive;
         this.stats = stats;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.teamId = 2;
         this.alive = false;
         this.stats = new com.ankamagames.dofus.network.types.game.context.fight.GameFightMinimalStats();
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_GameFightFighterInformations(output);
      }
      
      public function serializeAs_GameFightFighterInformations(output:IDataOutput) : void
      {
         super.serializeAs_GameContextActorInformations(output);
         output.writeByte(this.teamId);
         output.writeBoolean(this.alive);
         this.stats.serializeAs_GameFightMinimalStats(output);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameFightFighterInformations(input);
      }
      
      public function deserializeAs_GameFightFighterInformations(input:IDataInput) : void
      {
         super.deserialize(input);
         this.teamId = input.readByte();
         if(this.teamId < 0)
         {
            throw new Error("Forbidden value (" + this.teamId + ") on element of GameFightFighterInformations.teamId.");
         }
         this.alive = input.readBoolean();
         this.stats = new com.ankamagames.dofus.network.types.game.context.fight.GameFightMinimalStats();
         this.stats.deserialize(input);
      }
   }
}
