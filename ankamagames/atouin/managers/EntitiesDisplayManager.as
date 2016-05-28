package com.ankamagames.atouin.managers
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.display.Sprite;
   import flash.display.DisplayObject;
   import com.ankamagames.atouin.utils.errors.AtouinError;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.AtouinConstants;
   import com.ankamagames.atouin.types.GraphicCell;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.utils.display.Rectangle2;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.geom.Rectangle;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class EntitiesDisplayManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.atouin.managers.EntitiesDisplayManager));
      
      private static var _self:com.ankamagames.atouin.managers.EntitiesDisplayManager;
       
      private var _dStrataRef:Dictionary;
      
      public function EntitiesDisplayManager()
      {
         this._dStrataRef = new Dictionary(true);
         super();
         if(_self)
         {
            throw new SingletonError("Warning : MobilesManager is a singleton class and shoulnd\'t be instancied directly!");
         }
      }
      
      public static function getInstance() : com.ankamagames.atouin.managers.EntitiesDisplayManager
      {
         if(!_self)
         {
            _self = new com.ankamagames.atouin.managers.EntitiesDisplayManager();
         }
         return _self;
      }
      
      public function displayEntity(oEntity:IDisplayable, cellCoords:MapPoint, strata:uint = 0) : void
      {
         var displayObject:DisplayObject = null;
         try
         {
            displayObject = oEntity as DisplayObject;
         }
         catch(te:TypeError)
         {
            throw new AtouinError("Entities implementing IDisplayable should extends DisplayObject.");
         }
         this._dStrataRef[oEntity] = strata;
         var cellSprite:Sprite = InteractiveCellManager.getInstance().getCell(cellCoords.cellId);
         displayObject.x = cellSprite.x + cellSprite.width / 2;
         displayObject.y = cellSprite.y + cellSprite.height / 2;
         if(strata != PlacementStrataEnums.STRATA_FOREGROUND)
         {
            this.orderEntity(displayObject,cellSprite);
         }
         else
         {
            Atouin.getInstance().gfxContainer.addChild(displayObject);
         }
      }
      
      public function refreshAlphaEntity(oEntity:IDisplayable, cellCoords:MapPoint, strata:uint = 0) : void
      {
         var displayObject:DisplayObject = null;
         try
         {
            displayObject = oEntity as DisplayObject;
         }
         catch(te:TypeError)
         {
            throw new AtouinError("Entities implementing IDisplayable should extends DisplayObject.");
         }
         var cellSprite:Sprite = InteractiveCellManager.getInstance().getCell(cellCoords.cellId);
         this.orderEntity(displayObject,cellSprite);
      }
      
      public function removeEntity(oEntity:IDisplayable) : void
      {
         var displayObject:DisplayObject = null;
         try
         {
            displayObject = oEntity as DisplayObject;
         }
         catch(te:TypeError)
         {
            throw new AtouinError("Entities implementing IDisplayable should extends DisplayObject.");
         }
         if(Boolean(displayObject.parent) && Boolean(displayObject.parent.contains(displayObject)))
         {
            displayObject.parent.removeChild(displayObject);
         }
      }
      
      public function orderEntity(entity:DisplayObject, cellSprite:Sprite) : void
      {
         var currentElem:DisplayObject = null;
         if(Atouin.getInstance().options.transparentOverlayMode)
         {
            entity.alpha = entity.alpha != 1?Number(entity.alpha):Number(AtouinConstants.OVERLAY_MODE_ALPHA);
            Atouin.getInstance().overlayContainer.addChild(entity);
            return;
         }
         if(entity.alpha == AtouinConstants.OVERLAY_MODE_ALPHA)
         {
            entity.alpha = 1;
         }
         if(!cellSprite || !cellSprite.parent)
         {
            return;
         }
         var depth:uint = cellSprite.parent.getChildIndex(cellSprite);
         var nb:int = cellSprite.parent.numChildren;
         var firstLoop:Boolean = true;
         for(var i:uint = depth + 1; i < nb; i++)
         {
            currentElem = cellSprite.parent.getChildAt(i);
            if(currentElem is GraphicCell)
            {
               break;
            }
            if(this._dStrataRef[entity] < this._dStrataRef[currentElem])
            {
               break;
            }
            if(currentElem !== cellSprite && currentElem != entity)
            {
               depth++;
            }
            firstLoop = false;
         }
         cellSprite.parent.addChildAt(entity,depth + 1);
      }
      
      public function getAbsoluteBounds(entity:IDisplayable) : IRectangle
      {
         var d:DisplayObject = entity as DisplayObject;
         var r:Rectangle2 = new Rectangle2();
         var r2:Rectangle = d.getBounds(StageShareManager.stage);
         r.x = r2.x;
         r.width = r2.width;
         r.height = r2.height;
         r.y = r2.y;
         return r;
      }
   }
}
