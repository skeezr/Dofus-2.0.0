package com.ankamagames.atouin.types
{
   import flash.display.Sprite;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.behaviours.IDisplayBehavior;
   import flash.geom.Point;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.atouin.managers.EntitiesDisplayManager;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   
   public class ZoneTile extends Sprite implements IDisplayable
   {
       
      private var _displayBehavior:IDisplayBehavior;
      
      private var _displayed:Boolean;
      
      private var _currentCell:Point;
      
      private var _cellId:uint;
      
      public var strata:uint = 0;
      
      public function ZoneTile()
      {
         super();
      }
      
      public function get displayBehaviors() : IDisplayBehavior
      {
         return this._displayBehavior;
      }
      
      public function set displayBehaviors(oValue:IDisplayBehavior) : void
      {
         this._displayBehavior = oValue;
      }
      
      public function get currentCellPosition() : Point
      {
         return this._currentCell;
      }
      
      public function set currentCellPosition(pValue:Point) : void
      {
         this._currentCell = pValue;
      }
      
      public function get displayed() : Boolean
      {
         return this._displayed;
      }
      
      public function get absoluteBounds() : IRectangle
      {
         return this._displayBehavior.getAbsoluteBounds(this);
      }
      
      public function get cellId() : uint
      {
         return this._cellId;
      }
      
      public function set cellId(nValue:uint) : void
      {
         this._cellId = nValue;
      }
      
      public function display(wishedStrata:uint = 0) : void
      {
         EntitiesDisplayManager.getInstance().displayEntity(this,MapPoint.fromCellId(this._cellId),this.strata);
         this._displayed = true;
      }
      
      public function remove() : void
      {
         this._displayed = false;
         EntitiesDisplayManager.getInstance().removeEntity(this);
      }
   }
}
