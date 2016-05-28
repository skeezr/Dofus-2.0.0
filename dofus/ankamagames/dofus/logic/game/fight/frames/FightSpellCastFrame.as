package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.atouin.types.Selection;
   import flash.utils.Timer;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.atouin.messages.CellOverMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOverMessage;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityOverAction;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.jerakine.entities.messages.EntityClickMessage;
   import com.ankamagames.dofus.logic.game.fight.actions.TimelineEntityClickAction;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.atouin.messages.AdjacentMapClickMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseRightClickMessage;
   import com.ankamagames.dofus.logic.game.fight.actions.BannerEmptySlotClickAction;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseUpMessage;
   import com.ankamagames.dofus.network.messages.game.actions.fight.GameActionFightCastRequestMessage;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.dofus.network.types.game.character.characteristic.CharacterBaseCharacteristic;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.jerakine.types.zones.Cross;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.jerakine.types.zones.Lozenge;
   import com.ankamagames.jerakine.types.zones.Custom;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.jerakine.map.LosDetector;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.types.zones.IZone;
   import com.ankamagames.dofus.datacenter.effects.EffectInstance;
   import com.ankamagames.jerakine.types.zones.Line;
   import com.ankamagames.dofus.types.enums.SpellShapeEnum;
   import flash.events.TimerEvent;
   
   public class FightSpellCastFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightSpellCastFrame));
      
      private static const RANGE_COLOR:Color = new Color(1334693);
      
      private static const LOS_COLOR:Color = new Color(26316);
      
      private static const TARGET_COLOR:Color = new Color(16711680);
      
      private static const SELECTION_RANGE:String = "SpellCastRange";
      
      private static const SELECTION_LOS:String = "SpellCastLos";
      
      private static const SELECTION_TARGET:String = "SpellCastTarget";
       
      private var _spellLevel:Object;
      
      private var _spellId:uint;
      
      private var _rangeSelection:Selection;
      
      private var _losSelection:Selection;
      
      private var _targetSelection:Selection;
      
      private var _currentCell:uint;
      
      private var _virtualCast:Boolean;
      
      private var _cancelTimer:Timer;
      
      public function FightSpellCastFrame(spellId:uint)
      {
         var i:SpellWrapper = null;
         var weapon:* = undefined;
         super();
         this._spellId = spellId;
         this._cancelTimer = new Timer(50);
         this._cancelTimer.addEventListener(TimerEvent.TIMER,this.cancelCast);
         if(Boolean(spellId) || !PlayedCharacterManager.getInstance().currentWeapon)
         {
            for each(i in PlayedCharacterManager.getInstance().spellsInventory)
            {
               if(i.spellId == this._spellId)
               {
                  this._spellLevel = i;
               }
            }
         }
         else
         {
            weapon = PlayedCharacterManager.getInstance().currentWeapon;
            this._spellLevel = {
               "effects":weapon.effects,
               "castTestLos":weapon.castTestLos,
               "castInLine":weapon.castInLine,
               "minRange":weapon.minRange,
               "range":weapon.range
            };
         }
      }
      
      public function get priority() : int
      {
         return Priority.HIGHEST;
      }
      
      public function pushed() : Boolean
      {
         this._cancelTimer.reset();
         KernelEventsManager.getInstance().processCallback(HookList.CastSpellMode,SpellWrapper.getSpellWrapperById(this._spellId,PlayedCharacterManager.getInstance().id));
         this.drawRange();
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var conmsg:CellOverMessage = null;
         var emomsg:EntityMouseOverMessage = null;
         var teoa:TimelineEntityOverAction = null;
         var ccmsg:CellClickMessage = null;
         var ecmsg:EntityClickMessage = null;
         var teica:TimelineEntityClickAction = null;
         switch(true)
         {
            case msg is CellOverMessage:
               conmsg = msg as CellOverMessage;
               this.refreshTarget(conmsg.cellId);
               return true;
            case msg is EntityMouseOverMessage:
               emomsg = msg as EntityMouseOverMessage;
               this.refreshTarget(emomsg.entity.position.cellId);
               return false;
            case msg is TimelineEntityOverAction:
               teoa = msg as TimelineEntityOverAction;
               this.refreshTarget(DofusEntities.getEntity(teoa.targetId).position.cellId);
               return false;
            case msg is CellClickMessage:
               ccmsg = msg as CellClickMessage;
               this.castSpell(ccmsg.cellId);
               return true;
            case msg is EntityClickMessage:
               ecmsg = msg as EntityClickMessage;
               this.castSpell(ecmsg.entity.position.cellId);
               return true;
            case msg is TimelineEntityClickAction:
               teica = msg as TimelineEntityClickAction;
               this.castSpell(teica.cellId);
               return true;
            case msg is AdjacentMapClickMessage:
            case msg is MouseRightClickMessage:
               this.cancelCast();
               return true;
            case msg is BannerEmptySlotClickAction:
               this.cancelCast();
               return true;
            case msg is MouseUpMessage:
               this._cancelTimer.start();
               return false;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         this._cancelTimer.reset();
         this.removeRange();
         this.removeTarget();
         KernelEventsManager.getInstance().processCallback(HookList.CancelCastSpell,SpellWrapper.getSpellWrapperById(this._spellId,PlayedCharacterManager.getInstance().id));
         return true;
      }
      
      private function castSpell(cell:uint) : void
      {
         var gafcrmsg:GameActionFightCastRequestMessage = null;
         var fightTurnFrame:FightTurnFrame = Kernel.getWorker().getFrame(FightTurnFrame) as FightTurnFrame;
         if(Boolean(this.isValidCell(cell)) && Boolean(fightTurnFrame) && Boolean(fightTurnFrame.myTurn))
         {
            gafcrmsg = new GameActionFightCastRequestMessage();
            gafcrmsg.initGameActionFightCastRequestMessage(this._spellId,cell);
            _log.debug("Casting spell " + this._spellId + " on cell " + cell);
            ConnectionsHandler.getConnection().send(gafcrmsg);
         }
         this.cancelCast();
      }
      
      private function cancelCast(... args) : void
      {
         this._cancelTimer.reset();
         Kernel.getWorker().removeFrame(this);
      }
      
      private function drawRange() : void
      {
         var rangeCell:Vector.<uint> = null;
         var noLosRangeCell:Vector.<uint> = null;
         var cellId:uint = 0;
         var player:PlayedCharacterManager = PlayedCharacterManager.getInstance();
         var entity:IEntity = DofusEntities.getEntity(player.id);
         var playerRange:CharacterBaseCharacteristic = player.characteristics.range;
         var range:int = this._spellLevel.range;
         if(this._spellLevel["rangeCanBeBoosted"])
         {
            range = range + (playerRange.base + playerRange.objectsAndMountBonus + playerRange.alignGiftBonus + playerRange.contextModif);
            if(range < this._spellLevel.minRange)
            {
               range = this._spellLevel.minRange;
            }
         }
         range = Math.min(range,AtouinConstants.MAP_WIDTH * AtouinConstants.MAP_HEIGHT);
         this._rangeSelection = new Selection();
         this._rangeSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA);
         this._rangeSelection.color = RANGE_COLOR;
         this._rangeSelection.alpha = true;
         if(this._spellLevel.castInLine)
         {
            this._rangeSelection.zone = new Cross(this._spellLevel.minRange,range,DataMapProvider.getInstance());
         }
         else
         {
            this._rangeSelection.zone = new Lozenge(this._spellLevel.minRange,range,DataMapProvider.getInstance());
         }
         this._losSelection = null;
         if(Boolean(this._spellLevel.castTestLos) && Boolean(Dofus.getInstance().options.showLineOfSight))
         {
            this.drawLos();
         }
         if(this._losSelection)
         {
            this._rangeSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_AREA,0.5);
            rangeCell = new Vector.<uint>();
            noLosRangeCell = this._rangeSelection.zone.getCells(entity.position.cellId);
            for each(cellId in noLosRangeCell)
            {
               if(this._losSelection.cells.indexOf(cellId) == -1)
               {
                  rangeCell.push(cellId);
               }
            }
            this._rangeSelection.zone = new Custom(rangeCell);
         }
         SelectionManager.getInstance().addSelection(this._rangeSelection,SELECTION_RANGE,entity.position.cellId);
      }
      
      private function drawLos() : void
      {
         var entity:IEntity = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
         this._losSelection = new Selection();
         this._losSelection.renderer = new ZoneDARenderer();
         this._losSelection.color = LOS_COLOR;
         var cells:Vector.<uint> = this._rangeSelection.zone.getCells(entity.position.cellId);
         this._losSelection.zone = new Custom(LosDetector.getCell(DataMapProvider.getInstance(),cells,MapPoint.fromCellId(entity.position.cellId)));
         SelectionManager.getInstance().addSelection(this._losSelection,SELECTION_LOS,entity.position.cellId);
      }
      
      private function removeRange() : void
      {
         var s:Selection = SelectionManager.getInstance().getSelection(SELECTION_RANGE);
         if(s)
         {
            s.remove();
            this._rangeSelection = null;
         }
         var los:Selection = SelectionManager.getInstance().getSelection(SELECTION_LOS);
         if(los)
         {
            los.remove();
            this._losSelection = null;
         }
      }
      
      private function refreshTarget(target:uint) : void
      {
         if(this._currentCell == target)
         {
            return;
         }
         this._currentCell = target;
         if(this.isValidCell(target))
         {
            if(!this._targetSelection)
            {
               this._targetSelection = new Selection();
               this._targetSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_SPELL_BACKGROUND);
               this._targetSelection.color = TARGET_COLOR;
               this._targetSelection.zone = this.getSpellZone();
               SelectionManager.getInstance().addSelection(this._targetSelection,SELECTION_TARGET);
            }
            this._targetSelection.zone.direction = MapPoint(DofusEntities.getEntity(PlayedCharacterManager.getInstance().id).position).advancedOrientationTo(MapPoint.fromCellId(target));
            SelectionManager.getInstance().update(SELECTION_TARGET,target);
         }
         else
         {
            this.removeTarget();
         }
      }
      
      private function removeTarget() : void
      {
         var s:Selection = SelectionManager.getInstance().getSelection(SELECTION_TARGET);
         if(s)
         {
            s.remove();
            this._rangeSelection = null;
         }
      }
      
      private function getSpellZone() : IZone
      {
         var ray:uint = 0;
         var i:EffectInstance = null;
         var shapeT:Cross = null;
         var shape:uint = 88;
         ray = 666;
         if(!this._spellLevel.hasOwnProperty("shape"))
         {
            for each(i in this._spellLevel["effects"])
            {
               if(i.zoneShape != 0 && i.zoneSize < ray && i.zoneSize > 0)
               {
                  ray = i.zoneSize;
                  shape = i.zoneShape;
               }
            }
         }
         else
         {
            shape = this._spellLevel.shape;
            ray = this._spellLevel.ray;
         }
         if(ray == 666)
         {
            ray = 0;
         }
         switch(shape)
         {
            case SpellShapeEnum.X:
               return new Cross(0,ray,DataMapProvider.getInstance());
            case SpellShapeEnum.L:
               return new Line(ray,DataMapProvider.getInstance());
            case SpellShapeEnum.T:
               shapeT = new Cross(0,ray,DataMapProvider.getInstance());
               shapeT.onlyPerpendicular = true;
               return shapeT;
            case SpellShapeEnum.D:
               return new Cross(0,ray,DataMapProvider.getInstance());
            case SpellShapeEnum.C:
               return new Lozenge(0,ray,DataMapProvider.getInstance());
            case SpellShapeEnum.O:
               return new Cross(ray - 1,ray,DataMapProvider.getInstance());
            case SpellShapeEnum.P:
            default:
               return new Cross(0,0,DataMapProvider.getInstance());
         }
      }
      
      private function isValidCell(cell:uint) : Boolean
      {
         if(Boolean(this._spellLevel.castTestLos) && Boolean(Dofus.getInstance().options.showLineOfSight))
         {
            return SelectionManager.getInstance().isInside(cell,SELECTION_LOS);
         }
         return SelectionManager.getInstance().isInside(cell,SELECTION_RANGE);
      }
   }
}
