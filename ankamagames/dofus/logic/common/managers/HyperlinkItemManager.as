package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.display.Stage;
   import flash.geom.Rectangle;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.utils.api_namespace;
   import com.ankamagames.dofus.datacenter.items.Item;
   
   public class HyperlinkItemManager
   {
      
      private static var _itemId:int = 0;
      
      private static var _itemList:Array = new Array();
       
      public function HyperlinkItemManager()
      {
         super();
      }
      
      public static function showItem(objectGID:uint) : void
      {
         var itemWrapper:ItemWrapper = ItemWrapper.create(0,0,objectGID,1,null);
         var stage:Stage = StageShareManager.stage;
         var target:Rectangle = new Rectangle(stage.mouseX,stage.mouseY,10,10);
         TooltipManager.show(itemWrapper,target,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,"Hyperlink",6,2,50,true,null,UiApi.api_namespace::defaultTooltipUiScript);
      }
      
      public static function showChatItem(id:int) : void
      {
         var stage:Stage = StageShareManager.stage;
         var target:Rectangle = new Rectangle(stage.mouseX,stage.mouseY,10,10);
         TooltipManager.show(_itemList[id],target,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,"Hyperlink",6,2,50,true,null,UiApi.api_namespace::defaultTooltipUiScript);
      }
      
      public static function getItemName(objectGID:uint) : String
      {
         var item:Item = Item.getItemById(objectGID);
         if(item)
         {
            return "[" + item.name + "]";
         }
         return "[null]";
      }
      
      public static function newChatItem(item:ItemWrapper) : String
      {
         _itemList[_itemId] = item;
         var code:* = "{chatitem," + _itemId + "::[" + item.name + "]}";
         _itemId++;
         return code;
      }
   }
}
