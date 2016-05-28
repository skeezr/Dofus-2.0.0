package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.dofus.logic.game.common.frames.AlignmentFrame;
   import com.ankamagames.dofus.logic.game.common.frames.PrismFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.datacenter.world.MapPosition;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentBalance;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentEffect;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentGift;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentRankJntGift;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentOrder;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentRank;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentSide;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentTitle;
   import com.ankamagames.dofus.internalDatacenter.conquest.PrismFightersWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class AlignmentApi
   {
       
      protected var _log:Logger;
      
      private var _alignmentFrame:AlignmentFrame;
      
      private var _prismFrame:PrismFrame;
      
      private var _roleplayEntitiesFrame:RoleplayEntitiesFrame;
      
      private var _orderRanks:Array;
      
      private var _rankGifts:Array;
      
      private var _rankId:uint;
      
      private var _sideOrders:Array;
      
      private var _sideId:uint;
      
      private var _mapPositions:Array;
      
      private var include_mapPosition:MapPosition = null;
      
      public function AlignmentApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(DataApi));
         super();
         this._alignmentFrame = Kernel.getWorker().getFrame(AlignmentFrame) as AlignmentFrame;
      }
      
      private function get prismFrame() : PrismFrame
      {
         if(!this._prismFrame)
         {
            this._prismFrame = Kernel.getWorker().getFrame(PrismFrame) as PrismFrame;
         }
         return this._prismFrame;
      }
      
      [Untrusted]
      public function getBalance(balanceId:uint) : AlignmentBalance
      {
         return AlignmentBalance.getAlignmentBalanceById(balanceId);
      }
      
      [Untrusted]
      public function getBalances() : Array
      {
         return AlignmentBalance.getAlignmentBalances();
      }
      
      [Untrusted]
      public function getEffect(effectId:uint) : AlignmentEffect
      {
         return AlignmentEffect.getAlignmentEffectById(effectId);
      }
      
      [Untrusted]
      public function getGift(giftId:uint) : AlignmentGift
      {
         return AlignmentGift.getAlignmentGiftById(giftId);
      }
      
      [Untrusted]
      public function getGifts() : Array
      {
         return AlignmentGift.getAlignmentGifts();
      }
      
      [Untrusted]
      public function getRankGifts(rankId:uint) : AlignmentRankJntGift
      {
         return AlignmentRankJntGift.getAlignmentRankJntGiftById(rankId);
      }
      
      [Untrusted]
      public function getGiftEffect(giftId:uint) : AlignmentEffect
      {
         return this.getEffect(this.getGift(giftId).effectId);
      }
      
      [Untrusted]
      public function getOrder(orderId:uint) : AlignmentOrder
      {
         return AlignmentOrder.getAlignmentOrderById(orderId);
      }
      
      [Untrusted]
      public function getOrders() : Array
      {
         return AlignmentOrder.getAlignmentOrders();
      }
      
      [Untrusted]
      public function getRank(rankId:uint) : AlignmentRank
      {
         return AlignmentRank.getAlignmentRankById(rankId);
      }
      
      [Untrusted]
      public function getRanks() : Array
      {
         return AlignmentRank.getAlignmentRanks();
      }
      
      [Untrusted]
      public function getRankOrder(rankId:uint) : AlignmentOrder
      {
         return this.getOrder(this.getRank(rankId).orderId);
      }
      
      [Untrusted]
      public function getOrderRanks(orderId:uint) : Array
      {
         var alignmentRank:AlignmentRank = null;
         var listOrderRanks:Array = new Array();
         var listRanks:Array = AlignmentRank.getAlignmentRanks();
         var nRanks:int = listRanks.length;
         for(var i:int = 0; i < nRanks; i++)
         {
            alignmentRank = listRanks[i];
            if(alignmentRank)
            {
               if(alignmentRank.orderId == orderId)
               {
                  listOrderRanks.push(alignmentRank);
               }
            }
         }
         return listOrderRanks.sortOn("minimumAlignment",Array.NUMERIC);
      }
      
      [Untrusted]
      public function getSide(sideId:uint) : AlignmentSide
      {
         return AlignmentSide.getAlignmentSideById(sideId);
      }
      
      [Untrusted]
      public function getOrderSide(orderId:uint) : AlignmentSide
      {
         return this.getSide(this.getOrder(orderId).sideId);
      }
      
      [Untrusted]
      public function getSideOrders(sideId:uint) : Array
      {
         this._sideId = sideId;
         AlignmentRank.getAlignmentRanks().forEach(this.filterOrdersBySide);
         return this._sideOrders;
      }
      
      [Untrusted]
      public function getTitleName(sideId:uint, grade:int) : String
      {
         return AlignmentTitle.getAlignmentTitlesById(sideId).getNameFromGrade(grade);
      }
      
      [Untrusted]
      public function getTitleShortName(sideId:uint, grade:int) : String
      {
         return AlignmentTitle.getAlignmentTitlesById(sideId).getShortNameFromGrade(grade);
      }
      
      [Untrusted]
      public function getPVPActivationCost() : int
      {
         return this._alignmentFrame.activationCost;
      }
      
      [Untrusted]
      public function getAngelsSubAreas() : Vector.<int>
      {
         return this._alignmentFrame.angelsSubAreas;
      }
      
      [Untrusted]
      public function getEvilsSubAreas() : Vector.<int>
      {
         return this._alignmentFrame.evilsSubAreas;
      }
      
      [Untrusted]
      public function getPlayerRank() : int
      {
         return this._alignmentFrame.playerRank;
      }
      
      [Untrusted]
      public function getPrismAttackers() : Vector.<PrismFightersWrapper>
      {
         return this.prismFrame.attackers;
      }
      
      [Untrusted]
      public function getPrismReserves() : Vector.<PrismFightersWrapper>
      {
         return this.prismFrame.reserves;
      }
      
      [Untrusted]
      public function getPrismDefenders() : Vector.<PrismFightersWrapper>
      {
         return this.prismFrame.defenders;
      }
      
      [Untrusted]
      public function isPlayerDefender() : Boolean
      {
         var def:PrismFightersWrapper = null;
         var res:PrismFightersWrapper = null;
         var id:int = PlayedCharacterManager.getInstance().id;
         for each(def in this.getPrismDefenders())
         {
            if(def.playerCharactersInformations.id == id)
            {
               return true;
            }
         }
         for each(res in this.getPrismReserves())
         {
            if(def.playerCharactersInformations.id == id)
            {
               return true;
            }
         }
         return false;
      }
      
      [Untrusted]
      public function getPrismLocalisation() : Object
      {
         var obj:Object = new Object();
         obj.worldX = this.prismFrame.worldX;
         obj.worldY = this.prismFrame.worldY;
         obj.subareaId = this.prismFrame.subareaId;
         return obj;
      }
      
      [Untrusted]
      public function getCurrentSubAreaAlignment() : int
      {
         if(!this._roleplayEntitiesFrame)
         {
            this._roleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         }
         if(!this._alignmentFrame)
         {
            this._alignmentFrame = Kernel.getWorker().getFrame(AlignmentFrame) as AlignmentFrame;
         }
         var subAreaId:uint = this._roleplayEntitiesFrame.currentSubAreaId;
         if(this._alignmentFrame.angelsSubAreas.indexOf(subAreaId) != -1)
         {
            return 1;
         }
         if(this._alignmentFrame.evilsSubAreas.indexOf(subAreaId) != -1)
         {
            return 2;
         }
         return 0;
      }
      
      private function filterGiftsByRank(rankJntGift:*, index:int, rankJntGifts:Array) : void
      {
         var giftsIds:Array = null;
         var gifts:Array = null;
         var giftId:int = 0;
         var gift:* = undefined;
         this._rankGifts = new Array();
         if(rankJntGift.id == this._rankId)
         {
            giftsIds = rankJntGift.gifts;
            gifts = AlignmentGift.getAlignmentGifts();
            for each(giftId in giftsIds)
            {
               for each(gift in gifts)
               {
                  if(giftId == gift.id)
                  {
                     this._rankGifts.push(gift);
                  }
               }
            }
         }
      }
      
      private function filterOrdersBySide(order:*, index:int, orders:Array) : void
      {
         this._sideOrders = new Array();
         if(order.sideId == this._sideId)
         {
            this._sideOrders.push(order);
         }
      }
   }
}
