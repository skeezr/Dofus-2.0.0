package com.ankamagames.atouin.managers
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.atouin.renderers.TrapZoneRenderer;
   import com.ankamagames.atouin.types.GraphicCell;
   import flash.events.MouseEvent;
   import com.ankamagames.atouin.types.DataMapContainer;
   import com.ankamagames.atouin.types.CellReference;
   import flash.display.DisplayObject;
   import com.ankamagames.atouin.data.map.CellData;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.jerakine.types.zones.Lozenge;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.atouin.types.CellContainer;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import flash.display.Sprite;
   import com.ankamagames.atouin.utils.CellIdConverter;
   import flash.geom.Point;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.atouin.types.DebugToolTip;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.atouin.messages.CellOverMessage;
   import com.ankamagames.atouin.messages.CellOutMessage;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class InteractiveCellManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.atouin.managers.InteractiveCellManager));
      
      private static var _self:com.ankamagames.atouin.managers.InteractiveCellManager;
       
      private var _cellOverEnabled:Boolean = false;
      
      private var _aCells:Array;
      
      private var _aCellPool:Array;
      
      private var _bShowGrid:Boolean;
      
      private var _interaction_click:Boolean;
      
      private var _interaction_out:Boolean;
      
      private var _trapZoneRenderer:TrapZoneRenderer;
      
      public function InteractiveCellManager()
      {
         this._aCellPool = new Array();
         this._bShowGrid = Atouin.getInstance().options.alwaysShowGrid;
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         Atouin.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         this.init();
      }
      
      public static function getInstance() : com.ankamagames.atouin.managers.InteractiveCellManager
      {
         if(!_self)
         {
            _self = new com.ankamagames.atouin.managers.InteractiveCellManager();
         }
         return _self;
      }
      
      public function get cellOverEnabled() : Boolean
      {
         return this._cellOverEnabled;
      }
      
      public function set cellOverEnabled(value:Boolean) : void
      {
         this.overStateChanged(this._cellOverEnabled,value);
         this._cellOverEnabled = value;
      }
      
      public function get cellOutEnabled() : Boolean
      {
         return this._interaction_out;
      }
      
      public function get cellClickEnabled() : Boolean
      {
         return this._interaction_click;
      }
      
      public function initManager() : void
      {
         this._aCells = new Array();
      }
      
      public function setInteraction(click:Boolean = true, over:Boolean = false, out:Boolean = false) : void
      {
         var cell:GraphicCell = null;
         this._interaction_click = click;
         this._cellOverEnabled = over;
         this._interaction_out = out;
         for each(cell in this._aCells)
         {
            if(click)
            {
               cell.addEventListener(MouseEvent.CLICK,this.mouseClick);
            }
            else
            {
               cell.removeEventListener(MouseEvent.CLICK,this.mouseClick);
            }
            if(over)
            {
               cell.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
            }
            else
            {
               cell.removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
            }
            if(out)
            {
               cell.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
            }
            else
            {
               cell.removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
            }
            cell.mouseEnabled = Boolean(click) || Boolean(over) || Boolean(out);
         }
      }
      
      public function getCell(cellId:uint) : GraphicCell
      {
         this._aCells[cellId] = this._aCellPool[cellId];
         return this._aCells[cellId];
      }
      
      public function updateInteractiveCell(container:DataMapContainer) : void
      {
         var ind:uint = 0;
         var cellRef:CellReference = null;
         var currentCell:DisplayObject = null;
         var usedId:int = 0;
         var gCell:GraphicCell = null;
         var ZIndex:uint = 0;
         var addChild:Boolean = false;
         var truc:DisplayObject = null;
         var cellData:CellData = null;
         var sel:Selection = null;
         var firstCellIndex:uint = 0;
         if(!container)
         {
            _log.error("Can\'t update interactive cell of a NULL container");
            return;
         }
         this.setInteraction(true,Atouin.getInstance().options.showCellIdOnOver,Atouin.getInstance().options.showCellIdOnOver);
         var aCell:Array = container.getCell();
         var alpha:Number = Boolean(this._bShowGrid) || Boolean(Atouin.getInstance().options.alwaysShowGrid)?Number(1):Number(0);
         for(ind = 0; ind < this._aCells.length; ind++)
         {
            if(!(!this._aCells[ind] || !CellReference(aCell[ind])))
            {
               cellRef = aCell[ind];
               gCell = this._aCells[ind];
               gCell.y = cellRef.elevation;
               gCell.visible = Boolean(cellRef.mov) && !cellRef.isDisabled;
               gCell.alpha = alpha;
               if(Atouin.getInstance().options.showTransitions)
               {
                  cellData = MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[gCell.name] as CellData;
                  sel = SelectionManager.getInstance().getSelection("mapTransition" + gCell.name);
                  if(cellData.mapChangeData)
                  {
                     if(!sel)
                     {
                        sel = new Selection();
                        sel.color = new Color(16711680);
                        sel.renderer = new ZoneDARenderer();
                        sel.zone = new Lozenge(0,0,DataMapProvider.getInstance());
                        SelectionManager.getInstance().addSelection(sel,"mapTransition" + gCell.name,parseInt(gCell.name));
                     }
                     else
                     {
                        SelectionManager.getInstance().update("mapTransition" + gCell.name,parseInt(gCell.name));
                     }
                  }
                  else if(sel)
                  {
                     sel.remove();
                  }
               }
               truc = gCell;
               addChild = false;
               if(cellRef.heightestDecor)
               {
                  if(cellRef.heightestDecor.parent.getChildIndex(cellRef.heightestDecor) != cellRef.heightestDecor.parent.numChildren - 1)
                  {
                     currentCell = cellRef.heightestDecor.parent.getChildAt(cellRef.heightestDecor.parent.getChildIndex(cellRef.heightestDecor) + 1);
                  }
                  else
                  {
                     currentCell = cellRef.heightestDecor;
                  }
               }
               else if(!currentCell)
               {
                  currentCell = new CellContainer(cellRef.id);
                  for(firstCellIndex = 0; firstCellIndex < AtouinConstants.MAP_CELLS_COUNT; )
                  {
                     if(aCell[firstCellIndex])
                     {
                        break;
                     }
                     firstCellIndex++;
                  }
                  currentCell.x = CellReference(aCell[firstCellIndex]).x;
                  currentCell.y = CellReference(aCell[firstCellIndex]).y;
                  container.getLayer(2).addChildAt(currentCell,0);
                  usedId = ind;
               }
               if(currentCell)
               {
                  ZIndex = currentCell.parent.getChildIndex(currentCell);
                  currentCell.parent.addChildAt(truc,ZIndex);
               }
            }
         }
      }
      
      public function updateCell(cellId:uint, enabled:Boolean) : Boolean
      {
         DataMapProvider.getInstance().updateCellMovLov(cellId,enabled);
         if(this._aCells[cellId] != null)
         {
            this._aCells[cellId].visible = enabled;
            return true;
         }
         return false;
      }
      
      public function show(b:Boolean) : void
      {
         var cell:GraphicCell = null;
         this._bShowGrid = b;
         var alpha:Number = Boolean(this._bShowGrid) || Boolean(Atouin.getInstance().options.alwaysShowGrid)?Number(1):Number(0);
         for(var i:uint = 0; i < this._aCells.length; i++)
         {
            cell = GraphicCell(this._aCells[i]);
            if(cell)
            {
               cell.alpha = alpha;
            }
         }
      }
      
      public function clean() : void
      {
         var i:uint = 0;
         if(this._aCells)
         {
            for(i = 0; i < this._aCells.length; i++)
            {
               if(!(!this._aCells[i] || !this._aCells[i].parent))
               {
                  this._aCells[i].parent.removeChild(this._aCells[i]);
               }
            }
         }
      }
      
      private function init() : void
      {
         var c:GraphicCell = null;
         for(var i:uint = 0; i < AtouinConstants.MAP_CELLS_COUNT; i++)
         {
            c = new GraphicCell(i);
            c.mouseEnabled = false;
            c.mouseChildren = false;
            this._aCellPool[i] = c;
         }
      }
      
      private function overStateChanged(oldValue:Boolean, newValue:Boolean) : void
      {
         if(oldValue == newValue)
         {
            return;
         }
         if(!oldValue && Boolean(newValue))
         {
            this.registerOver(true);
         }
         else if(Boolean(oldValue) && !newValue)
         {
            this.registerOver(false);
         }
      }
      
      private function registerOver(enabled:Boolean) : void
      {
         for(var i:uint = 0; i < AtouinConstants.MAP_CELLS_COUNT; i++)
         {
            if(this._aCells[i])
            {
               if(enabled)
               {
                  this._aCells[i].addEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
                  this._aCells[i].addEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
               }
               else
               {
                  this._aCells[i].removeEventListener(MouseEvent.ROLL_OVER,this.mouseOver);
                  this._aCells[i].removeEventListener(MouseEvent.ROLL_OUT,this.mouseOut);
               }
            }
         }
      }
      
      private function mouseClick(e:MouseEvent) : void
      {
         var a:Array = null;
         var entity:IEntity = null;
         var msg:CellClickMessage = null;
         var target:Sprite = Sprite(e.target);
         if(!target.parent)
         {
            return;
         }
         var index:int = target.parent.getChildIndex(target);
         var targetCell:Point = CellIdConverter.cellIdToCoord(parseInt(target.name));
         if(Atouin.getInstance().options.virtualPlayerJump)
         {
            a = EntitiesManager.getInstance().entities;
            for each(entity in a)
            {
               if(entity is IMovable)
               {
                  IMovable(entity).jump(MapPoint.fromCellId(parseInt(target.name)));
               }
            }
         }
         else
         {
            msg = new CellClickMessage();
            msg.cellContainer = target;
            msg.cellDepth = index;
            msg.cell = MapPoint.fromCoords(targetCell.x,targetCell.y);
            msg.cellId = parseInt(target.name);
            Atouin.getInstance().handler.process(msg);
         }
      }
      
      private function mouseOver(e:MouseEvent) : void
      {
         var sel:Selection = null;
         var target:Sprite = Sprite(e.target);
         if(!target.parent)
         {
            return;
         }
         var index:int = target.parent.getChildIndex(target);
         var targetCell:Point = CellIdConverter.cellIdToCoord(parseInt(target.name));
         if(Atouin.getInstance().options.showCellIdOnOver)
         {
            DebugToolTip.getInstance().text = target.name + " (" + targetCell.x + "/" + targetCell.y + ")";
            sel = SelectionManager.getInstance().getSelection("infoOverCell");
            if(!sel)
            {
               sel = new Selection();
               sel.color = new Color(0);
               sel.renderer = new ZoneDARenderer();
               sel.zone = new Lozenge(0,0,DataMapProvider.getInstance());
               SelectionManager.getInstance().addSelection(sel,"infoOverCell",parseInt(target.name));
            }
            else
            {
               SelectionManager.getInstance().update("infoOverCell",parseInt(target.name));
            }
            StageShareManager.stage.addChild(DebugToolTip.getInstance());
            DebugToolTip.getInstance().x = e.stageX;
            DebugToolTip.getInstance().y = e.stageY + 20;
         }
         var msg:CellOverMessage = new CellOverMessage();
         msg.cellContainer = target;
         msg.cellDepth = index;
         msg.cell = MapPoint.fromCoords(targetCell.x,targetCell.y);
         msg.cellId = parseInt(target.name);
         Atouin.getInstance().handler.process(msg);
      }
      
      private function mouseOut(e:MouseEvent) : void
      {
         var target:Sprite = Sprite(e.target);
         if(!target.parent)
         {
            return;
         }
         var index:int = target.parent.getChildIndex(target);
         var targetCell:Point = CellIdConverter.cellIdToCoord(parseInt(target.name));
         if(Atouin.getInstance().worldContainer.contains(DebugToolTip.getInstance()))
         {
            Atouin.getInstance().worldContainer.removeChild(DebugToolTip.getInstance());
         }
         var msg:CellOutMessage = new CellOutMessage();
         msg.cellContainer = target;
         msg.cellDepth = index;
         msg.cell = MapPoint.fromCoords(targetCell.x,targetCell.y);
         msg.cellId = parseInt(target.name);
      }
      
      private function onPropertyChanged(e:PropertyChangeEvent) : void
      {
         if(e.propertyName == "alwaysShowGrid")
         {
            this.show(e.propertyValue);
         }
      }
   }
}
