package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.dofus.datacenter.spells.SpellLevel;
   import com.ankamagames.atouin.types.Selection;
   
   public class MarkInstance
   {
       
      public var markId:int;
      
      public var markType:int;
      
      public var associatedSpellRank:SpellLevel;
      
      public var selections:Vector.<Selection>;
      
      public function MarkInstance()
      {
         super();
      }
   }
}
