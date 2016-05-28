package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class GameFightMinimalStats implements INetworkType
   {
      
      public static const protocolId:uint = 31;
       
      public var lifePoints:uint = 0;
      
      public var maxLifePoints:uint = 0;
      
      public var actionPoints:uint = 0;
      
      public var movementPoints:uint = 0;
      
      public var summoner:int = 0;
      
      public var neutralElementResistPercent:int = 0;
      
      public var earthElementResistPercent:int = 0;
      
      public var waterElementResistPercent:int = 0;
      
      public var airElementResistPercent:int = 0;
      
      public var fireElementResistPercent:int = 0;
      
      public var dodgePALostProbability:uint = 0;
      
      public var dodgePMLostProbability:uint = 0;
      
      public var invisibilityState:int = 0;
      
      public function GameFightMinimalStats()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 31;
      }
      
      public function initGameFightMinimalStats(lifePoints:uint = 0, maxLifePoints:uint = 0, actionPoints:uint = 0, movementPoints:uint = 0, summoner:int = 0, neutralElementResistPercent:int = 0, earthElementResistPercent:int = 0, waterElementResistPercent:int = 0, airElementResistPercent:int = 0, fireElementResistPercent:int = 0, dodgePALostProbability:uint = 0, dodgePMLostProbability:uint = 0, invisibilityState:int = 0) : GameFightMinimalStats
      {
         this.lifePoints = lifePoints;
         this.maxLifePoints = maxLifePoints;
         this.actionPoints = actionPoints;
         this.movementPoints = movementPoints;
         this.summoner = summoner;
         this.neutralElementResistPercent = neutralElementResistPercent;
         this.earthElementResistPercent = earthElementResistPercent;
         this.waterElementResistPercent = waterElementResistPercent;
         this.airElementResistPercent = airElementResistPercent;
         this.fireElementResistPercent = fireElementResistPercent;
         this.dodgePALostProbability = dodgePALostProbability;
         this.dodgePMLostProbability = dodgePMLostProbability;
         this.invisibilityState = invisibilityState;
         return this;
      }
      
      public function reset() : void
      {
         this.lifePoints = 0;
         this.maxLifePoints = 0;
         this.actionPoints = 0;
         this.movementPoints = 0;
         this.summoner = 0;
         this.neutralElementResistPercent = 0;
         this.earthElementResistPercent = 0;
         this.waterElementResistPercent = 0;
         this.airElementResistPercent = 0;
         this.fireElementResistPercent = 0;
         this.dodgePALostProbability = 0;
         this.dodgePMLostProbability = 0;
         this.invisibilityState = 0;
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_GameFightMinimalStats(output);
      }
      
      public function serializeAs_GameFightMinimalStats(output:IDataOutput) : void
      {
         if(this.lifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.lifePoints + ") on element lifePoints.");
         }
         output.writeInt(this.lifePoints);
         if(this.maxLifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.maxLifePoints + ") on element maxLifePoints.");
         }
         output.writeInt(this.maxLifePoints);
         if(this.actionPoints < 0)
         {
            throw new Error("Forbidden value (" + this.actionPoints + ") on element actionPoints.");
         }
         output.writeShort(this.actionPoints);
         if(this.movementPoints < 0)
         {
            throw new Error("Forbidden value (" + this.movementPoints + ") on element movementPoints.");
         }
         output.writeShort(this.movementPoints);
         output.writeInt(this.summoner);
         output.writeShort(this.neutralElementResistPercent);
         output.writeShort(this.earthElementResistPercent);
         output.writeShort(this.waterElementResistPercent);
         output.writeShort(this.airElementResistPercent);
         output.writeShort(this.fireElementResistPercent);
         if(this.dodgePALostProbability < 0)
         {
            throw new Error("Forbidden value (" + this.dodgePALostProbability + ") on element dodgePALostProbability.");
         }
         output.writeShort(this.dodgePALostProbability);
         if(this.dodgePMLostProbability < 0)
         {
            throw new Error("Forbidden value (" + this.dodgePMLostProbability + ") on element dodgePMLostProbability.");
         }
         output.writeShort(this.dodgePMLostProbability);
         output.writeByte(this.invisibilityState);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameFightMinimalStats(input);
      }
      
      public function deserializeAs_GameFightMinimalStats(input:IDataInput) : void
      {
         this.lifePoints = input.readInt();
         if(this.lifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.lifePoints + ") on element of GameFightMinimalStats.lifePoints.");
         }
         this.maxLifePoints = input.readInt();
         if(this.maxLifePoints < 0)
         {
            throw new Error("Forbidden value (" + this.maxLifePoints + ") on element of GameFightMinimalStats.maxLifePoints.");
         }
         this.actionPoints = input.readShort();
         if(this.actionPoints < 0)
         {
            throw new Error("Forbidden value (" + this.actionPoints + ") on element of GameFightMinimalStats.actionPoints.");
         }
         this.movementPoints = input.readShort();
         if(this.movementPoints < 0)
         {
            throw new Error("Forbidden value (" + this.movementPoints + ") on element of GameFightMinimalStats.movementPoints.");
         }
         this.summoner = input.readInt();
         this.neutralElementResistPercent = input.readShort();
         this.earthElementResistPercent = input.readShort();
         this.waterElementResistPercent = input.readShort();
         this.airElementResistPercent = input.readShort();
         this.fireElementResistPercent = input.readShort();
         this.dodgePALostProbability = input.readShort();
         if(this.dodgePALostProbability < 0)
         {
            throw new Error("Forbidden value (" + this.dodgePALostProbability + ") on element of GameFightMinimalStats.dodgePALostProbability.");
         }
         this.dodgePMLostProbability = input.readShort();
         if(this.dodgePMLostProbability < 0)
         {
            throw new Error("Forbidden value (" + this.dodgePMLostProbability + ") on element of GameFightMinimalStats.dodgePMLostProbability.");
         }
         this.invisibilityState = input.readByte();
      }
   }
}
