package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.atouin.messages.CellOverMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOverMessage;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.jerakine.entities.messages.EntityClickMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.atouin.messages.AdjacentMapClickMessage;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.jerakine.types.zones.Cross;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import flash.display.Sprite;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import flash.geom.Point;
   
   public class RoleplayPointCellFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(RoleplayPointCellFrame));
      
      private static const TARGET_COLOR:Color = new Color(16548386);
      
      private static const SELECTION_TARGET:String = "SpellCastTarget";
      
      private static const LINKED_CURSOR_NAME:String = "RoleplayPointCellFrame_Pointer";
       
      private var _targetSelection:Selection;
      
      private var _InteractiveCellManager_click:Boolean;
      
      private var _InteractiveCellManager_over:Boolean;
      
      private var _InteractiveCellManager_out:Boolean;
      
      private var _freeCellOnly:Boolean;
      
      private var _callBack:Function;
      
      public function RoleplayPointCellFrame(callBack:Function = null, cursorIcon:Sprite = null, freeCellOnly:Boolean = false)
      {
         var lkd:LinkedCursorData = null;
         super();
         this._callBack = callBack;
         this._freeCellOnly = freeCellOnly;
         if(cursorIcon)
         {
            lkd = new LinkedCursorData();
            lkd.sprite = cursorIcon;
            lkd.offset = new Point(-20,-20);
            LinkedCursorSpriteManager.getInstance().addItem(LINKED_CURSOR_NAME,lkd);
         }
      }
      
      public function get priority() : int
      {
         return Priority.ULTIMATE_HIGHEST_DEPTH_OF_DOOM;
      }
      
      public function pushed() : Boolean
      {
         this._InteractiveCellManager_click = InteractiveCellManager.getInstance().cellClickEnabled;
         this._InteractiveCellManager_over = InteractiveCellManager.getInstance().cellOverEnabled;
         this._InteractiveCellManager_out = InteractiveCellManager.getInstance().cellOutEnabled;
         InteractiveCellManager.getInstance().setInteraction(true,true,true);
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
               return false;
            case msg is CellClickMessage:
               ccmsg = msg as CellClickMessage;
               this.showCell(ccmsg.cellId);
               return true;
            case msg is EntityClickMessage:
               ecmsg = msg as EntityClickMessage;
               this.showCell(ecmsg.entity.position.cellId,ecmsg.entity.id);
               return true;
            case msg is AdjacentMapClickMessage:
               this.cancelShow();
               if(this._callBack != null)
               {
                  this._callBack(false,0,-1);
               }
               return true;
            case msg is MouseClickMessage:
               if(MouseClickMessage(msg).target is GraphicCell || MouseClickMessage(msg).target is IEntity)
               {
                  return false;
               }
               this.cancelShow();
               if(this._callBack != null)
               {
                  this._callBack(false,0,-1);
               }
               return false;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         LinkedCursorSpriteManager.getInstance().removeItem(LINKED_CURSOR_NAME);
         InteractiveCellManager.getInstance().setInteraction(this._InteractiveCellManager_click,this._InteractiveCellManager_over,this._InteractiveCellManager_out);
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
      
      private function showCell(cell:uint, entityId:int = -1) : void
      {
         if(this.isValidCell(cell))
         {
            if(this._callBack != null)
            {
               this._callBack(true,cell,entityId);
            }
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
         return Boolean(DataMapProvider.getInstance().pointMov(MapPoint.fromCellId(cell).x,MapPoint.fromCellId(cell).y,true)) && (!this._freeCellOnly || EntitiesManager.getInstance().getEntityOnCell(cell) == null);
      }
   }
}
