package com.ankamagames.dofus.network.types.game.character.restriction
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import com.ankamagames.jerakine.network.utils.BooleanByteWrapper;
   import flash.utils.IDataInput;
   
   public class ActorRestrictionsInformations implements INetworkType
   {
      
      public static const protocolId:uint = 204;
       
      public var cantBeAggressed:Boolean = false;
      
      public var cantBeChallenged:Boolean = false;
      
      public var cantTrade:Boolean = false;
      
      public var cantBeAttackedByMutant:Boolean = false;
      
      public var cantRun:Boolean = false;
      
      public var forceSlowWalk:Boolean = false;
      
      public var cantMinimize:Boolean = false;
      
      public var cantMove:Boolean = false;
      
      public var cantAggress:Boolean = false;
      
      public var cantChallenge:Boolean = false;
      
      public var cantExchange:Boolean = false;
      
      public var cantAttack:Boolean = false;
      
      public var cantChat:Boolean = false;
      
      public var cantBeMerchant:Boolean = false;
      
      public var cantUseObject:Boolean = false;
      
      public var cantUseTaxCollector:Boolean = false;
      
      public var cantUseInteractive:Boolean = false;
      
      public var cantSpeakToNPC:Boolean = false;
      
      public var cantChangeZone:Boolean = false;
      
      public var cantAttackMonster:Boolean = false;
      
      public var cantWalk8Directions:Boolean = false;
      
      public function ActorRestrictionsInformations()
      {
         super();
      }
      
      public function getTypeId() : uint
      {
         return 204;
      }
      
      public function initActorRestrictionsInformations(cantBeAggressed:Boolean = false, cantBeChallenged:Boolean = false, cantTrade:Boolean = false, cantBeAttackedByMutant:Boolean = false, cantRun:Boolean = false, forceSlowWalk:Boolean = false, cantMinimize:Boolean = false, cantMove:Boolean = false, cantAggress:Boolean = false, cantChallenge:Boolean = false, cantExchange:Boolean = false, cantAttack:Boolean = false, cantChat:Boolean = false, cantBeMerchant:Boolean = false, cantUseObject:Boolean = false, cantUseTaxCollector:Boolean = false, cantUseInteractive:Boolean = false, cantSpeakToNPC:Boolean = false, cantChangeZone:Boolean = false, cantAttackMonster:Boolean = false, cantWalk8Directions:Boolean = false) : ActorRestrictionsInformations
      {
         this.cantBeAggressed = cantBeAggressed;
         this.cantBeChallenged = cantBeChallenged;
         this.cantTrade = cantTrade;
         this.cantBeAttackedByMutant = cantBeAttackedByMutant;
         this.cantRun = cantRun;
         this.forceSlowWalk = forceSlowWalk;
         this.cantMinimize = cantMinimize;
         this.cantMove = cantMove;
         this.cantAggress = cantAggress;
         this.cantChallenge = cantChallenge;
         this.cantExchange = cantExchange;
         this.cantAttack = cantAttack;
         this.cantChat = cantChat;
         this.cantBeMerchant = cantBeMerchant;
         this.cantUseObject = cantUseObject;
         this.cantUseTaxCollector = cantUseTaxCollector;
         this.cantUseInteractive = cantUseInteractive;
         this.cantSpeakToNPC = cantSpeakToNPC;
         this.cantChangeZone = cantChangeZone;
         this.cantAttackMonster = cantAttackMonster;
         this.cantWalk8Directions = cantWalk8Directions;
         return this;
      }
      
      public function reset() : void
      {
         this.cantBeAggressed = false;
         this.cantBeChallenged = false;
         this.cantTrade = false;
         this.cantBeAttackedByMutant = false;
         this.cantRun = false;
         this.forceSlowWalk = false;
         this.cantMinimize = false;
         this.cantMove = false;
         this.cantAggress = false;
         this.cantChallenge = false;
         this.cantExchange = false;
         this.cantAttack = false;
         this.cantChat = false;
         this.cantBeMerchant = false;
         this.cantUseObject = false;
         this.cantUseTaxCollector = false;
         this.cantUseInteractive = false;
         this.cantSpeakToNPC = false;
         this.cantChangeZone = false;
         this.cantAttackMonster = false;
         this.cantWalk8Directions = false;
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_ActorRestrictionsInformations(output);
      }
      
      public function serializeAs_ActorRestrictionsInformations(output:IDataOutput) : void
      {
         var _box0:uint = 0;
         BooleanByteWrapper.setFlag(_box0,0,this.cantBeAggressed);
         BooleanByteWrapper.setFlag(_box0,1,this.cantBeChallenged);
         BooleanByteWrapper.setFlag(_box0,2,this.cantTrade);
         BooleanByteWrapper.setFlag(_box0,3,this.cantBeAttackedByMutant);
         BooleanByteWrapper.setFlag(_box0,4,this.cantRun);
         BooleanByteWrapper.setFlag(_box0,5,this.forceSlowWalk);
         BooleanByteWrapper.setFlag(_box0,6,this.cantMinimize);
         BooleanByteWrapper.setFlag(_box0,7,this.cantMove);
         output.writeByte(_box0);
         var _box1:uint = 0;
         BooleanByteWrapper.setFlag(_box1,0,this.cantAggress);
         BooleanByteWrapper.setFlag(_box1,1,this.cantChallenge);
         BooleanByteWrapper.setFlag(_box1,2,this.cantExchange);
         BooleanByteWrapper.setFlag(_box1,3,this.cantAttack);
         BooleanByteWrapper.setFlag(_box1,4,this.cantChat);
         BooleanByteWrapper.setFlag(_box1,5,this.cantBeMerchant);
         BooleanByteWrapper.setFlag(_box1,6,this.cantUseObject);
         BooleanByteWrapper.setFlag(_box1,7,this.cantUseTaxCollector);
         output.writeByte(_box1);
         var _box2:uint = 0;
         BooleanByteWrapper.setFlag(_box2,0,this.cantUseInteractive);
         BooleanByteWrapper.setFlag(_box2,1,this.cantSpeakToNPC);
         BooleanByteWrapper.setFlag(_box2,2,this.cantChangeZone);
         BooleanByteWrapper.setFlag(_box2,3,this.cantAttackMonster);
         BooleanByteWrapper.setFlag(_box2,4,this.cantWalk8Directions);
         output.writeByte(_box2);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_ActorRestrictionsInformations(input);
      }
      
      public function deserializeAs_ActorRestrictionsInformations(input:IDataInput) : void
      {
         var _box0:uint = input.readByte();
         this.cantBeAggressed = BooleanByteWrapper.getFlag(_box0,0);
         this.cantBeChallenged = BooleanByteWrapper.getFlag(_box0,1);
         this.cantTrade = BooleanByteWrapper.getFlag(_box0,2);
         this.cantBeAttackedByMutant = BooleanByteWrapper.getFlag(_box0,3);
         this.cantRun = BooleanByteWrapper.getFlag(_box0,4);
         this.forceSlowWalk = BooleanByteWrapper.getFlag(_box0,5);
         this.cantMinimize = BooleanByteWrapper.getFlag(_box0,6);
         this.cantMove = BooleanByteWrapper.getFlag(_box0,7);
         var _box1:uint = input.readByte();
         this.cantAggress = BooleanByteWrapper.getFlag(_box1,0);
         this.cantChallenge = BooleanByteWrapper.getFlag(_box1,1);
         this.cantExchange = BooleanByteWrapper.getFlag(_box1,2);
         this.cantAttack = BooleanByteWrapper.getFlag(_box1,3);
         this.cantChat = BooleanByteWrapper.getFlag(_box1,4);
         this.cantBeMerchant = BooleanByteWrapper.getFlag(_box1,5);
         this.cantUseObject = BooleanByteWrapper.getFlag(_box1,6);
         this.cantUseTaxCollector = BooleanByteWrapper.getFlag(_box1,7);
         var _box2:uint = input.readByte();
         this.cantUseInteractive = BooleanByteWrapper.getFlag(_box2,0);
         this.cantSpeakToNPC = BooleanByteWrapper.getFlag(_box2,1);
         this.cantChangeZone = BooleanByteWrapper.getFlag(_box2,2);
         this.cantAttackMonster = BooleanByteWrapper.getFlag(_box2,3);
         this.cantWalk8Directions = BooleanByteWrapper.getFlag(_box2,4);
      }
   }
}
