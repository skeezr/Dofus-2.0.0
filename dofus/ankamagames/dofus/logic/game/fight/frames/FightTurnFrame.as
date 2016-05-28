package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.utils.clearTimeout;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.atouin.messages.CellOverMessage;
   import com.ankamagames.dofus.logic.game.fight.actions.GameFightSpellCastAction;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.messages.EntityMovementCompleteMessage;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.network.messages.game.context.GameMapNoMovementMessage;
   import com.ankamagames.dofus.logic.game.fight.actions.GameFightTurnFinishAction;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.pathfinding.Pathfinding;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.jerakine.types.positions.MovementPath;
   import com.ankamagames.jerakine.types.positions.PathElement;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.jerakine.types.zones.Custom;
   import com.ankamagames.dofus.network.messages.game.context.GameMapMovementRequestMessage;
   import com.ankamagames.dofus.logic.game.common.managers.MapMovementAdapter;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightTurnFinishMessage;
   import flash.utils.setTimeout;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import com.ankamagames.dofus.misc.lists.FightHookList;
   
   public class FightTurnFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightTurnFrame));
      
      private static const PATH_COLOR:Color = new Color(26112);
      
      private static const SELECTION_PATH:String = "FightMovementPath";
      
      private static const REMIND_TURN_DELAY:uint = 15000;
       
      private var _movementSelection:Selection;
      
      private var _isRequestingMovement:Boolean;
      
      private var _spellCastFrame:Frame;
      
      private var _finishingTurn:Boolean;
      
      private var _remindTurnTimeoutId:uint;
      
      private var _myTurn:Boolean;
      
      private var _turnDuration:uint;
      
      public function FightTurnFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.HIGH;
      }
      
      public function get myTurn() : Boolean
      {
         return this._myTurn;
      }
      
      public function set myTurn(b:Boolean) : void
      {
         this._myTurn = b;
         if(b)
         {
            this.startRemindTurn();
         }
         else
         {
            this._isRequestingMovement = false;
            if(this._remindTurnTimeoutId != 0)
            {
               clearTimeout(this._remindTurnTimeoutId);
            }
            this.removePath();
         }
      }
      
      public function set turnDuration(v:uint) : void
      {
         this._turnDuration = v;
      }
      
      public function pushed() : Boolean
      {
         Atouin.getInstance().cellOverEnabled = true;
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var conmsg:CellOverMessage = null;
         var gfsca:GameFightSpellCastAction = null;
         var entity:IMovable = null;
         var ccmsg:CellClickMessage = null;
         var emcmsg:EntityMovementCompleteMessage = null;
         switch(true)
         {
            case msg is CellOverMessage:
               if(!this.myTurn)
               {
                  return false;
               }
               conmsg = msg as CellOverMessage;
               this.drawPath(conmsg.cell);
               return true;
            case msg is GameFightSpellCastAction:
               gfsca = msg as GameFightSpellCastAction;
               entity = DofusEntities.getEntity(PlayedCharacterManager.getInstance().infos.id) as IMovable;
               if(entity.isMoving)
               {
                  return true;
               }
               if(this._spellCastFrame != null)
               {
                  Kernel.getWorker().removeFrame(this._spellCastFrame);
               }
               this.removePath();
               if(this._myTurn)
               {
                  this.startRemindTurn();
               }
               Kernel.getWorker().addFrame(this._spellCastFrame = new FightSpellCastFrame(gfsca.spellId));
               return true;
            case msg is CellClickMessage:
               if(!this.myTurn)
               {
                  return false;
               }
               ccmsg = msg as CellClickMessage;
               this.askMoveTo(ccmsg.cell);
               return true;
            case msg is GameMapNoMovementMessage:
               if(!this.myTurn)
               {
                  return false;
               }
               this._isRequestingMovement = false;
               this.removePath();
               return true;
            case msg is EntityMovementCompleteMessage:
               if(!this.myTurn)
               {
                  return false;
               }
               emcmsg = msg as EntityMovementCompleteMessage;
               if(emcmsg.entity.id == PlayedCharacterManager.getInstance().id)
               {
                  this._isRequestingMovement = false;
                  this.removePath();
                  this.startRemindTurn();
                  if(this._finishingTurn)
                  {
                     this.finishTurn();
                  }
               }
               return true;
            case msg is GameFightTurnFinishAction:
               if(!this.myTurn)
               {
                  return false;
               }
               if((DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as IMovable).isMoving)
               {
                  this._finishingTurn = true;
               }
               else
               {
                  this.finishTurn();
               }
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         if(this._remindTurnTimeoutId != 0)
         {
            clearTimeout(this._remindTurnTimeoutId);
         }
         Atouin.getInstance().cellOverEnabled = false;
         this.removePath();
         Kernel.getWorker().removeFrame(this._spellCastFrame);
         return true;
      }
      
      private function drawPath(cell:MapPoint) : void
      {
         var playerEntity:IEntity = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
         if(Boolean(IMovable(playerEntity).isMoving) || playerEntity.position.distanceToCell(cell) > PlayedCharacterManager.getInstance().characteristics.movementPointsCurrent)
         {
            this.removePath();
            return;
         }
         var path:MovementPath = Pathfinding.findPath(DataMapProvider.getInstance(),playerEntity.position,cell,false,false,this.displayPath);
      }
      
      private function displayPath(path:MovementPath) : void
      {
         var pe:PathElement = null;
         if(path.path.length == 0 || path.path.length > PlayedCharacterManager.getInstance().characteristics.movementPointsCurrent)
         {
            this.removePath();
            return;
         }
         var cells:Vector.<uint> = new Vector.<uint>();
         var isFirst:Boolean = true;
         for each(pe in path.path)
         {
            if(isFirst)
            {
               isFirst = false;
            }
            else
            {
               cells.push(pe.step.cellId);
            }
         }
         cells.push(path.end.cellId);
         if(this._movementSelection == null)
         {
            this._movementSelection = new Selection();
            this._movementSelection.renderer = new ZoneDARenderer();
            this._movementSelection.color = PATH_COLOR;
            SelectionManager.getInstance().addSelection(this._movementSelection,SELECTION_PATH);
         }
         this._movementSelection.zone = new Custom(cells);
         SelectionManager.getInstance().update(SELECTION_PATH);
      }
      
      private function removePath() : void
      {
         var s:Selection = SelectionManager.getInstance().getSelection(SELECTION_PATH);
         if(s)
         {
            s.remove();
            this._movementSelection = null;
         }
      }
      
      private function askMoveTo(cell:MapPoint) : Boolean
      {
         if(this._isRequestingMovement)
         {
            return false;
         }
         this._isRequestingMovement = true;
         var playerEntity:IEntity = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
         if(!playerEntity)
         {
            _log.warn("The player tried to move before its character was added to the scene. Aborting.");
            return this._isRequestingMovement = false;
         }
         if(IMovable(playerEntity).isMoving)
         {
            return this._isRequestingMovement = false;
         }
         var path:MovementPath = Pathfinding.findPath(DataMapProvider.getInstance(),playerEntity.position,cell,false,false);
         if(path.path.length == 0 || path.path.length > PlayedCharacterManager.getInstance().characteristics.movementPointsCurrent)
         {
            return this._isRequestingMovement = false;
         }
         var gmmrmsg:GameMapMovementRequestMessage = new GameMapMovementRequestMessage();
         gmmrmsg.initGameMapMovementRequestMessage(PlayedCharacterManager.getInstance().currentMap.mapId,MapMovementAdapter.getServerMovement(path));
         ConnectionsHandler.getConnection().send(gmmrmsg);
         return true;
      }
      
      private function finishTurn() : void
      {
         var gftfmsg:GameFightTurnFinishMessage = new GameFightTurnFinishMessage();
         ConnectionsHandler.getConnection().send(gftfmsg);
         this._finishingTurn = false;
      }
      
      private function startRemindTurn() : void
      {
         if(!this._myTurn)
         {
            return;
         }
         if(this._turnDuration > 0 && Boolean(Dofus.getInstance().options.remindTurn))
         {
            if(this._remindTurnTimeoutId != 0)
            {
               clearTimeout(this._remindTurnTimeoutId);
            }
            this._remindTurnTimeoutId = setTimeout(this.remindTurn,REMIND_TURN_DELAY);
         }
      }
      
      private function remindTurn() : void
      {
         var text:String = I18n.getText(I18nProxy.getKeyId("ui.fight.inactivity"));
         KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,text,ChatFrame.RED_CHANNEL_ID);
         KernelEventsManager.getInstance().processCallback(FightHookList.RemindTurn);
         clearTimeout(this._remindTurnTimeoutId);
         this._remindTurnTimeoutId = 0;
      }
   }
}
