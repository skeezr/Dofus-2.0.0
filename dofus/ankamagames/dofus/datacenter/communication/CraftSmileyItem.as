package com.ankamagames.dofus.datacenter.communication
{
   public class CraftSmileyItem
   {
       
      public var playerId:int;
      
      public var iconId:int;
      
      public var craftResult:uint;
      
      public function CraftSmileyItem(pPlayerId:uint, pIconId:int, pCraftResult:uint)
      {
         super();
         this.playerId = pPlayerId;
         this.iconId = pIconId;
         this.craftResult = pCraftResult;
      }
   }
}
