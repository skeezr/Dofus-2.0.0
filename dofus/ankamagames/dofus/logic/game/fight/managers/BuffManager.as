package com.ankamagames.dofus.logic.game.fight.managers
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.logic.game.fight.frames.FightEntitiesFrame;
   import com.ankamagames.dofus.logic.game.fight.types.BasicBuff;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.FightHookList;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightFighterInformations;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class BuffManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.dofus.logic.game.fight.managers.BuffManager));
      
      private static var _self:com.ankamagames.dofus.logic.game.fight.managers.BuffManager;
       
      private var _fightentitiesFrame:FightEntitiesFrame;
      
      private var _buffs:Array;
      
      private var _boostCode:Array;
      
      public function BuffManager()
      {
         this._buffs = new Array();
         this._boostCode = new Array();
         super();
         if(_self)
         {
            throw new SingletonError();
         }
      }
      
      public static function getInstance() : com.ankamagames.dofus.logic.game.fight.managers.BuffManager
      {
         if(!_self)
         {
            _self = new com.ankamagames.dofus.logic.game.fight.managers.BuffManager();
         }
         return _self;
      }
      
      public function destroy() : void
      {
         _self = null;
      }
      
      public function decrementDuration(targetId:int) : void
      {
         var buffItem:BasicBuff = null;
         if(!this._buffs[targetId])
         {
            return;
         }
         var newBuffs:Array = [];
         for each(buffItem in this._buffs[targetId])
         {
            if(buffItem.duration == uint.MAX_VALUE)
            {
               newBuffs.push(buffItem);
            }
            else
            {
               buffItem.duration--;
               if(!buffItem.duration)
               {
                  BasicBuff(buffItem).onRemoved();
                  KernelEventsManager.getInstance().processCallback(FightHookList.BuffRemove,buffItem.id,buffItem.targetId,"CoolDown");
               }
               else
               {
                  if(BasicBuff(buffItem).effects.duration)
                  {
                     BasicBuff(buffItem).effects.duration--;
                  }
                  newBuffs.push(buffItem);
                  KernelEventsManager.getInstance().processCallback(FightHookList.BuffUpdate,buffItem.id,buffItem.targetId);
               }
            }
         }
         this._buffs[targetId] = newBuffs;
      }
      
      public function addBuff(buff:BasicBuff) : void
      {
         var sameBuff:BasicBuff = null;
         var actualBuff:BasicBuff = null;
         if(!this._buffs[buff.targetId])
         {
            this._buffs[buff.targetId] = new Array();
         }
         for each(actualBuff in this._buffs[buff.targetId])
         {
            if(actualBuff.targetId == buff.targetId && actualBuff.effects.effectId == buff.actionId && actualBuff.duration == buff.duration && getQualifiedClassName(actualBuff) == getQualifiedClassName(buff))
            {
               sameBuff = actualBuff;
               break;
            }
         }
         if(!sameBuff)
         {
            this._buffs[buff.targetId].push(buff);
         }
         else
         {
            sameBuff.param1 = sameBuff.param1 + buff.param1;
            sameBuff.param2 = sameBuff.param2 + buff.param2;
            sameBuff.param3 = sameBuff.param3 + buff.param3;
         }
         buff.onApplyed();
         if(!sameBuff)
         {
            KernelEventsManager.getInstance().processCallback(FightHookList.BuffAdd,buff.id,buff.targetId);
         }
         else
         {
            KernelEventsManager.getInstance().processCallback(FightHookList.BuffUpdate,sameBuff.id,sameBuff.targetId);
         }
      }
      
      public function dispell(targetId:int, forceUndispellable:Boolean = false, critical:Boolean = false) : void
      {
         var buff:BasicBuff = null;
         var deletedBuff:BasicBuff = null;
         var deletedBuffs:Array = new Array();
         var newBuffs:Array = new Array();
         for each(buff in this._buffs[targetId])
         {
            if(buff.canBeDispell(forceUndispellable,critical))
            {
               buff.onRemoved();
               deletedBuffs.push(buff);
            }
            else
            {
               newBuffs.push(buff);
            }
         }
         this._buffs[targetId] = newBuffs;
         for each(deletedBuff in deletedBuffs)
         {
            KernelEventsManager.getInstance().processCallback(FightHookList.BuffRemove,deletedBuff.id,targetId,"Dispell");
         }
         KernelEventsManager.getInstance().processCallback(FightHookList.BuffDispell,targetId);
      }
      
      public function dispellUniqueBuff(targetId:int, boostUID:int, forceUndispellable:Boolean = false, critical:Boolean = false) : void
      {
         var buff:BasicBuff = null;
         for each(buff in this._buffs[targetId])
         {
            if(buff.id == boostUID)
            {
               if(buff.canBeDispell(forceUndispellable,critical))
               {
                  this._buffs[targetId].splice(this._buffs[targetId].indexOf(buff),1);
                  buff.onRemoved();
                  KernelEventsManager.getInstance().processCallback(FightHookList.BuffRemove,buff.id,targetId,"Dispell");
               }
            }
         }
      }
      
      public function getFighterInfo(targetId:int) : GameFightFighterInformations
      {
         return this.fightEntitiesFrame.getEntityInfos(targetId) as GameFightFighterInformations;
      }
      
      public function getAllBuff(targetId:int) : Array
      {
         return this._buffs[targetId];
      }
      
      public function getBuff(buffId:uint) : BasicBuff
      {
         var targetBuff:Array = null;
         var buff:BasicBuff = null;
         for each(targetBuff in this._buffs)
         {
            for each(buff in targetBuff)
            {
               if(buffId == buff.id)
               {
                  return buff;
               }
            }
         }
         return null;
      }
      
      private function get fightEntitiesFrame() : FightEntitiesFrame
      {
         if(!this._fightentitiesFrame)
         {
            this._fightentitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
         }
         return this._fightentitiesFrame;
      }
   }
}
