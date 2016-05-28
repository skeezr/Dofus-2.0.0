package com.ankamagames.dofus.datacenter.spells
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   
   public class SpellState
   {
      
      private static const MODULE:String = "SpellStates";
       
      public var id:int;
      
      public var nameId:uint;
      
      public var preventsSpellCast:Boolean;
      
      public var preventsFight:Boolean;
      
      public var critical:Boolean;
      
      public function SpellState()
      {
         super();
      }
      
      public static function getSpellStateById(id:int) : SpellState
      {
         return GameData.getObject(MODULE,id) as SpellState;
      }
      
      public static function create(id:int, nameId:uint, preventsSpellCast:Boolean, preventsFight:Boolean, critical:Boolean) : SpellState
      {
         var o:SpellState = new SpellState();
         o.id = id;
         o.nameId = nameId;
         o.preventsSpellCast = preventsSpellCast;
         o.preventsFight = preventsFight;
         o.critical = critical;
         return o;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
   }
}
