package com.ankamagames.dofus.internalDatacenter.fight
{
   import com.ankamagames.dofus.network.types.game.context.fight.FightLoot;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   
   public class FightLootWrapper
   {
       
      public var objects:Array;
      
      public var kamas:uint;
      
      public function FightLootWrapper(loot:FightLoot)
      {
         super();
         this.objects = new Array();
         for(var i:uint = 0; i < loot.objects.length; i = i + 2)
         {
            this.objects.push(ItemWrapper.create(63,0,loot.objects[i],loot.objects[i + 1],null,false));
         }
         this.kamas = loot.kamas;
      }
   }
}
