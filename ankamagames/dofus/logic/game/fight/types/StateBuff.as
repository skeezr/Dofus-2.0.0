package com.ankamagames.dofus.logic.game.fight.types
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   public class StateBuff extends BasicBuff
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(StateBuff));
       
      private var _statName:String;
      
      public function StateBuff(targetId:int, castingSpell:CastingSpell, actionId:uint, stateId:int, duration:uint, statName:String)
      {
         super(targetId,castingSpell,actionId,stateId,null,null,duration);
         this._statName = statName;
      }
      
      override public function get type() : String
      {
         return "StateBuff";
      }
      
      public function get statName() : String
      {
         return this._statName;
      }
      
      override public function onApplyed() : void
      {
      }
      
      override public function onRemoved() : void
      {
      }
   }
}
