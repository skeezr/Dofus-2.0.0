package com.ankamagames.dofus.datacenter.quest.rewards
{
   import com.ankamagames.dofus.datacenter.items.Item;
   
   public class QuestRewardItem extends QuestReward
   {
       
      private var _itemId:uint;
      
      private var _quantity:uint;
      
      public function QuestRewardItem(itemId:uint, quantity:uint)
      {
         super(QuestRewardType.ITEM);
         this._itemId = itemId;
         this._quantity = quantity;
      }
      
      public function get itemId() : uint
      {
         return this._itemId;
      }
      
      public function get item() : Item
      {
         return Item.getItemById(this._itemId);
      }
      
      public function get quantity() : uint
      {
         return this._quantity;
      }
   }
}
