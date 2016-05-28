package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.network.messages.game.context.fight.character.GameFightShowFighterMessage;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   
   public class FightSummonStep extends AbstractSequencable implements IFightStep
   {
       
      private var _summonerId:int;
      
      private var _summonInfos:GameFightFighterInformations;
      
      public function FightSummonStep(summonerId:int, summonInfos:GameFightFighterInformations)
      {
         super();
         this._summonerId = summonerId;
         this._summonInfos = summonInfos;
      }
      
      public function get stepType() : String
      {
         return "summon";
      }
      
      override public function start() : void
      {
         var gfsgmsg:GameFightShowFighterMessage = new GameFightShowFighterMessage();
         gfsgmsg.initGameFightShowFighterMessage(this._summonInfos);
         Kernel.getWorker().getFrame(FightEntitiesFrame).process(gfsgmsg);
         SpellWrapper.restricted_namespace::refreshAllPlayerSpellHolder(this._summonerId);
         FightEventsHelper.sendFightEvent(FightEventEnum.FIGHTER_SUMMONED,[this._summonerId,this._summonInfos.contextualId]);
         executeCallbacks();
      }
   }
}
