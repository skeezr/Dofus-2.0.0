package com.ankamagames.dofus.types.sequences
{
   import com.ankamagames.jerakine.sequencer.AbstractSequencable;
   import com.ankamagames.dofus.types.entities.Projectile;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
   
   public class AddGlyphGfxStep extends AbstractSequencable
   {
       
      private var _gfxId:uint;
      
      private var _cellId:uint;
      
      private var _entity:Projectile;
      
      private var _markId:int;
      
      public function AddGlyphGfxStep(gfxId:uint, cellId:uint, markId:int)
      {
         super();
         this._gfxId = gfxId;
         this._cellId = cellId;
         this._markId = markId;
      }
      
      override public function start() : void
      {
         var id:int = EntitiesManager.getInstance().getFreeEntityId();
         this._entity = new Projectile(id,TiphonEntityLook.fromString("{" + this._gfxId + "}"),true);
         this._entity.init();
         this._entity.position = MapPoint.fromCellId(this._cellId);
         this._entity.display(PlacementStrataEnums.STRATA_AREA);
         MarkedCellsManager.getInstance().addGlyph(this._entity,this._markId);
         executeCallbacks();
      }
   }
}
