package com.ankamagames.dofus.logic.game.fight.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.atouin.messages.CellOverMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOverMessage;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.jerakine.entities.messages.EntityClickMessage;
   import com.ankamagames.atouin.messages.AdjacentMapClickMessage;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.jerakine.types.zones.Cross;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.network.messages.game.context.ShowCellRequestMessage;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.kernel.Kernel;
   
   public class FightPointCellFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(FightPointCellFrame));
      
      private static const TARGET_COLOR:Color = new Color(16548386);
      
      private static const SELECTION_TARGET:String = "SpellCastTarget";
       
      private var _targetSelection:Selection;
      
      public function FightPointCellFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.HIGHEST;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var conmsg:CellOverMessage = null;
         var emomsg:EntityMouseOverMessage = null;
         var ccmsg:CellClickMessage = null;
         var ecmsg:EntityClickMessage = null;
         switch(true)
         {
            case msg is CellOverMessage:
               conmsg = msg as CellOverMessage;
               this.refreshTarget(conmsg.cellId);
               return true;
            case msg is EntityMouseOverMessage:
               emomsg = msg as EntityMouseOverMessage;
               this.refreshTarget(emomsg.entity.position.cellId);
               return true;
            case msg is CellClickMessage:
               ccmsg = msg as CellClickMessage;
               this.showCell(ccmsg.cellId);
               return true;
            case msg is EntityClickMessage:
               ecmsg = msg as EntityClickMessage;
               this.showCell(ecmsg.entity.position.cellId);
               return true;
            case msg is AdjacentMapClickMessage:
               this.cancelShow();
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      private function refreshTarget(target:uint) : void
      {
         if(this.isValidCell(target))
         {
            if(!this._targetSelection)
            {
               this._targetSelection = new Selection();
               this._targetSelection.renderer = new ZoneDARenderer(PlacementStrataEnums.STRATA_SPELL_BACKGROUND);
               this._targetSelection.color = TARGET_COLOR;
               this._targetSelection.zone = new Cross(0,0,DataMapProvider.getInstance());
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
            this._targetSelection = null;
         }
      }
      
      private function showCell(cell:uint) : void
      {
         var scrmsg:ShowCellRequestMessage = null;
         if(this.isValidCell(cell))
         {
            scrmsg = new ShowCellRequestMessage();
            scrmsg.initShowCellRequestMessage(cell);
            ConnectionsHandler.getConnection().send(scrmsg);
         }
         this.cancelShow();
      }
      
      private function cancelShow() : void
      {
         this.removeTarget();
         KernelEventsManager.getInstance().processCallback(HookList.ShowCell);
         Kernel.getWorker().removeFrame(this);
      }
      
      private function isValidCell(cell:uint) : Boolean
      {
         return DataMapProvider.getInstance().pointMov(MapPoint.fromCellId(cell).x,MapPoint.fromCellId(cell).y,true);
      }
   }
}
