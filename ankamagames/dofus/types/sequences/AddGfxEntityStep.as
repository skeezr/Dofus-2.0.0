package com.ankamagames.dofus.types.sequences
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.types.entities.Projectile;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.dofus.types.enums.AddGfxModeEnum;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import flash.events.Event;
   
   public class AddGfxEntityStep extends AbstractSequencable
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(AddGfxEntityStep));
       
      private var _gfxId:uint;
      
      private var _cellId:uint;
      
      private var _entity:Projectile;
      
      private var _shot:Boolean = false;
      
      private var _angle:Number;
      
      private var _yOffset:int;
      
      private var _mode:uint;
      
      private var _startCell:MapPoint;
      
      private var _endCell:MapPoint;
      
      private var _popUnderPlayer:Boolean;
      
      public function AddGfxEntityStep(gfxId:uint, cellId:uint, angle:Number = 0, yOffset:int = 0, mode:uint = 0, startCell:MapPoint = null, endCell:MapPoint = null, popUnderPlayer:Boolean = false)
      {
         super();
         this._mode = mode;
         this._gfxId = gfxId;
         this._cellId = cellId;
         this._angle = angle;
         this._yOffset = yOffset;
         this._startCell = startCell;
         this._endCell = endCell;
         this._popUnderPlayer = popUnderPlayer;
      }
      
      override public function start() : void
      {
         var dir:Array = null;
         var ad:Array = null;
         var i:uint = 0;
         var id:int = EntitiesManager.getInstance().getFreeEntityId();
         this._entity = new Projectile(id,TiphonEntityLook.fromString("{" + this._gfxId + "}"),true);
         TiphonSprite(this._entity).addEventListener(TiphonEvent.ANIMATION_SHOT,this.shot);
         TiphonSprite(this._entity).addEventListener(TiphonEvent.ANIMATION_END,this.remove);
         TiphonSprite(this._entity).addEventListener(TiphonEvent.RENDER_FAILED,this.remove);
         TiphonSprite(this._entity).rotation = this._angle;
         switch(this._mode)
         {
            case AddGfxModeEnum.NORMAL:
               this._entity.init();
               break;
            case AddGfxModeEnum.RANDOM:
               dir = TiphonSprite(this._entity).getAvaibleDirection();
               ad = new Array();
               for(i = 0; i < 8; i++)
               {
                  if(dir[i])
                  {
                     ad.push(i);
                  }
               }
               this._entity.init(ad[Math.floor(Math.random() * ad.length)]);
               break;
            case AddGfxModeEnum.ORIENTED:
               this._entity.init(this._startCell.advancedOrientationTo(this._endCell,true));
         }
         this._entity.position = MapPoint.fromCellId(this._cellId);
         if(this._popUnderPlayer)
         {
            this._entity.display(PlacementStrataEnums.STRATA_SPELL_BACKGROUND);
         }
         else
         {
            this._entity.display(PlacementStrataEnums.STRATA_SPELL_FOREGROUND);
         }
         TiphonSprite(this._entity).y = TiphonSprite(this._entity).y + this._yOffset;
      }
      
      private function remove(e:Event) : void
      {
         TiphonSprite(this._entity).removeEventListener(TiphonEvent.ANIMATION_END,this.remove);
         TiphonSprite(this._entity).removeEventListener(TiphonEvent.ANIMATION_SHOT,this.shot);
         TiphonSprite(this._entity).removeEventListener(TiphonEvent.RENDER_FAILED,this.remove);
         this._entity.remove();
         if(!this._shot)
         {
            this.shot(null);
         }
      }
      
      private function shot(e:Event) : void
      {
         this._shot = true;
         TiphonSprite(this._entity).removeEventListener(TiphonEvent.ANIMATION_SHOT,this.shot);
         this.executeCallbacks();
      }
      
      override protected function executeCallbacks() : void
      {
         super.executeCallbacks();
      }
   }
}
