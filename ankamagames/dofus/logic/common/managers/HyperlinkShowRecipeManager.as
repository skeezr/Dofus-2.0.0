package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.jerakine.utils.pattern.PatternDecoder;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   
   public class HyperlinkShowRecipeManager
   {
       
      public function HyperlinkShowRecipeManager()
      {
         super();
      }
      
      public static function showRecipe(recipeId:uint) : void
      {
         var item:ItemWrapper = ItemWrapper.create(0,0,recipeId,1,null);
         if(item)
         {
            KernelEventsManager.getInstance().processCallback(HookList.OpenRecipe,item);
         }
      }
      
      public static function getRecipeName(recipeId:int) : String
      {
         var item:Item = Item.getItemById(recipeId);
         if(item)
         {
            return "[" + PatternDecoder.combine(I18n.getText(I18nProxy.getKeyId("ui.common.recipes")),"n",true) + " : " + item.name + "]";
         }
         return "[null]";
      }
   }
}
