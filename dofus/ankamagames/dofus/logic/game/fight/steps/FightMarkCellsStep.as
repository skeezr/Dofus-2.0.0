package com.ankamagames.dofus.logic.game.fight.steps
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.network.types.game.actions.fight.GameActionMarkedCell;
   import com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
   import com.ankamagames.dofus.logic.game.fight.types.MarkInstance;
   import com.ankamagames.dofus.logic.game.fight.types.FightEventEnum;
   import com.ankamagames.dofus.network.enums.GameActionMarkTypeEnum;
   
   public class FightMarkCellsStep extends AbstractSequencable implements IFightStep
   {
       
      private var _markId:int;
      
      private var _markType:int;
      
      private var _associatedSpellRank:SpellLevel;
      
      private var _cells:Vector.<GameActionMarkedCell>;
      
      public function FightMarkCellsStep(markId:int, markType:int, associatedSpellRank:SpellLevel, cells:Vector.<GameActionMarkedCell>)
      {
         super();
         this._markId = markId;
         this._cells = cells;
         this._markType = markType;
         this._associatedSpellRank = associatedSpellRank;
      }
      
      public function get stepType() : String
      {
         return "markCells";
      }
      
      override public function start() : void
      {
         MarkedCellsManager.getInstance().addMark(this._markId,this._markType,this._associatedSpellRank,this._cells);
         var mi:MarkInstance = MarkedCellsManager.getInstance().getMarkDatas(this._markId);
         var evt:String = FightEventEnum.UNKNOWN_FIGHT_EVENT;
         switch(mi.markType)
         {
            case GameActionMarkTypeEnum.GLYPH:
               evt = FightEventEnum.GLYPH_APPEARED;
               break;
            case GameActionMarkTypeEnum.TRAP:
               evt = FightEventEnum.TRAP_APPEARED;
               break;
            default:
               _log.warn("Unknown mark type (" + mi.markType + ").");
         }
         FightEventsHelper.sendFightEvent(evt,[mi.associatedSpellRank.id]);
         executeCallbacks();
      }
   }
}
