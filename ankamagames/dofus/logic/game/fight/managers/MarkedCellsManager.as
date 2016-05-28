package com.ankamagames.dofus.logic.game.fight.managers
{
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.Dictionary;
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.dofus.network.types.game.actions.fight.GameActionMarkedCell;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.dofus.logic.game.fight.types.MarkInstance;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.atouin.renderers.TrapZoneRenderer;
   import com.ankamagames.atouin.enums.PlacementStrataEnums;
   import com.ankamagames.jerakine.types.zones.Lozenge;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.dofus.types.entities.Projectile;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class MarkedCellsManager implements IDestroyable
   {
      
      private static const MARK_SELECTIONS_PREFIX:String = "FightMark";
      
      private static var _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager));
      
      private static var _self:com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager;
       
      private var _marks:Dictionary;
      
      private var _glyphs:Dictionary;
      
      private var _markUid:uint;
      
      public function MarkedCellsManager()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("MarkedCellsManager is a singleton and should not be instanciated directly.");
         }
         this._marks = new Dictionary(true);
         this._glyphs = new Dictionary(true);
         this._markUid = 0;
      }
      
      public static function getInstance() : com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager
      {
         if(_self == null)
         {
            _self = new com.ankamagames.dofus.logic.game.fight.managers.MarkedCellsManager();
         }
         return _self;
      }
      
      public function addMark(markId:int, markType:int, associatedSpellRank:SpellLevel, cells:Vector.<GameActionMarkedCell>) : void
      {
         var markedCell:GameActionMarkedCell = null;
         var s:Selection = null;
         var mi:MarkInstance = new MarkInstance();
         mi.markId = markId;
         mi.markType = markType;
         mi.associatedSpellRank = associatedSpellRank;
         mi.selections = new Vector.<Selection>(0,false);
         for each(markedCell in cells)
         {
            s = new Selection();
            s.color = new Color(markedCell.cellColor);
            s.renderer = new TrapZoneRenderer(PlacementStrataEnums.STRATA_AREA);
            s.zone = new Lozenge(0,markedCell.zoneSize,DataMapProvider.getInstance());
            SelectionManager.getInstance().addSelection(s,this.getSelectionUid(),markedCell.cellId);
            mi.selections.push(s);
         }
         this._marks[markId] = mi;
      }
      
      public function getMarkDatas(markId:int) : MarkInstance
      {
         return this._marks[markId];
      }
      
      public function removeMark(markId:int) : void
      {
         var s:Selection = null;
         var selections:Vector.<Selection> = (this._marks[markId] as MarkInstance).selections;
         for each(s in selections)
         {
            s.remove();
         }
         delete this._marks[markId];
      }
      
      public function addGlyph(glyph:Projectile, markId:int) : void
      {
         this._glyphs[markId] = glyph;
      }
      
      public function getGlyph(markId:int) : Projectile
      {
         return this._glyphs[markId] as Projectile;
      }
      
      public function removeGlyph(markId:int) : void
      {
         if(this._glyphs[markId])
         {
            Projectile(this._glyphs[markId]).remove();
            delete this._glyphs[markId];
         }
      }
      
      public function destroy() : void
      {
         var mark:* = null;
         var glyph:* = null;
         var markId:int = 0;
         var glyphId:int = 0;
         for(mark in this._marks)
         {
            markId = parseInt(mark);
            this.removeMark(markId);
         }
         for(glyph in this._glyphs)
         {
            glyphId = parseInt(glyph);
            this.removeGlyph(glyphId);
         }
         _self = null;
      }
      
      private function getSelectionUid() : String
      {
         return MARK_SELECTIONS_PREFIX + this._markUid++;
      }
   }
}
