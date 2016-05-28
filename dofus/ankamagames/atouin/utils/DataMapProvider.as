package com.ankamagames.atouin.utils
{
   import com.ankamagames.jerakine.map.IDataMapProvider;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.interfaces.IObstacle;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.atouin.data.map.CellData;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.data.map.Cell;
   
   public class DataMapProvider implements IDataMapProvider
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.atouin.utils.DataMapProvider));
      
      private static var _self:com.ankamagames.atouin.utils.DataMapProvider;
      
      private static var _playerClass:Class;
       
      private var _updatedCell:Dictionary;
      
      public function DataMapProvider()
      {
         this._updatedCell = new Dictionary();
         super();
      }
      
      public static function getInstance() : com.ankamagames.atouin.utils.DataMapProvider
      {
         if(!_self)
         {
            throw new SingletonError("Init function wasn\'t call");
         }
         return _self;
      }
      
      public static function init(playerClass:Class) : void
      {
         _playerClass = playerClass;
         if(!_self)
         {
            _self = new com.ankamagames.atouin.utils.DataMapProvider();
         }
      }
      
      public function pointLos(x:int, y:int, bAllowTroughEntity:Boolean = true) : Boolean
      {
         var cellEntities:Array = null;
         var o:IObstacle = null;
         var cellId:uint = MapPoint.fromCoords(x,y).cellId;
         var los:Boolean = CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[cellId]).los;
         if(this._updatedCell[cellId] != null)
         {
            los = this._updatedCell[cellId];
         }
         if(!bAllowTroughEntity)
         {
            cellEntities = EntitiesManager.getInstance().getEntitiesOnCell(cellId,IObstacle);
            if(cellEntities.length)
            {
               for each(o in cellEntities)
               {
                  if(!IObstacle(o).canSeeThrough())
                  {
                     return false;
                  }
               }
            }
         }
         return los;
      }
      
      public function pointMov(x:int, y:int, bAllowTroughEntity:Boolean = true) : Boolean
      {
         var cellId:uint = 0;
         var mov:Boolean = false;
         var cellEntities:Array = null;
         var o:IObstacle = null;
         if(y <= x && y + x >= 0 && x - y < 2 * AtouinConstants.MAP_HEIGHT && x + y < 2 * AtouinConstants.MAP_WIDTH)
         {
            cellId = MapPoint.fromCoords(x,y).cellId;
            mov = CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[cellId]).mov;
            if(this._updatedCell[cellId] != null)
            {
               mov = this._updatedCell[cellId];
            }
            if(!bAllowTroughEntity)
            {
               cellEntities = EntitiesManager.getInstance().getEntitiesOnCell(cellId,IObstacle);
               if(cellEntities.length)
               {
                  for each(o in cellEntities)
                  {
                     if(!IObstacle(o).canSeeThrough())
                     {
                        return false;
                     }
                  }
               }
            }
         }
         else
         {
            mov = false;
         }
         return mov;
      }
      
      public function pointWeight(x:int, y:int, bAllowTroughEntity:Boolean = true) : int
      {
         var weight:int = 1;
         var speed:int = CellData(MapDisplayManager.getInstance().getDataMapContainer().dataMap.cells[MapPoint.fromCoords(x,y).cellId]).speed;
         if(bAllowTroughEntity)
         {
            if(speed >= 0)
            {
               weight = weight + (5 - speed);
            }
            else
            {
               weight = weight + 2 * Math.abs(speed);
            }
            if(EntitiesManager.getInstance().getEntityOnCell(Cell.cellIdByXY(x,y),_playerClass) != null)
            {
               weight = 10;
            }
         }
         else
         {
            if(EntitiesManager.getInstance().getEntityOnCell(Cell.cellIdByXY(x,y),_playerClass) != null)
            {
               weight = weight + 1;
            }
            if(EntitiesManager.getInstance().getEntityOnCell(Cell.cellIdByXY(x + 1,y),_playerClass) != null)
            {
               weight = weight + 1;
            }
            if(EntitiesManager.getInstance().getEntityOnCell(Cell.cellIdByXY(x,y + 1),_playerClass) != null)
            {
               weight = weight + 1;
            }
            if(EntitiesManager.getInstance().getEntityOnCell(Cell.cellIdByXY(x - 1,y),_playerClass) != null)
            {
               weight = weight + 1;
            }
            if(EntitiesManager.getInstance().getEntityOnCell(Cell.cellIdByXY(x,y - 1),_playerClass) != null)
            {
               weight = weight + 1;
            }
         }
         return weight;
      }
      
      public function get width() : int
      {
         return AtouinConstants.MAP_HEIGHT + AtouinConstants.MAP_WIDTH - 2;
      }
      
      public function get height() : int
      {
         return AtouinConstants.MAP_HEIGHT + AtouinConstants.MAP_WIDTH - 1;
      }
      
      public function hasEntity(x:int, y:int) : Boolean
      {
         var o:IObstacle = null;
         var cellEntities:Array = EntitiesManager.getInstance().getEntitiesOnCell(MapPoint.fromCoords(x,y).cellId,IObstacle);
         if(cellEntities.length)
         {
            for each(o in cellEntities)
            {
               if(!IObstacle(o).canSeeThrough())
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function updateCellMovLov(cellId:uint, canMove:Boolean) : void
      {
         this._updatedCell[cellId] = canMove;
      }
      
      public function resetUpdatedCell() : void
      {
         this._updatedCell = new Dictionary();
      }
   }
}
