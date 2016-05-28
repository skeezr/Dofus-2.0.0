package com.ankamagames.berilia.managers
{
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import flash.geom.Rectangle;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.display.Sprite;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class LinkedCursorSpriteManager
   {
      
      private static var _self:com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
       
      private var items:Array;
      
      public function LinkedCursorSpriteManager()
      {
         this.items = new Array();
         super();
         if(_self)
         {
            throw new SingletonError();
         }
      }
      
      public static function getInstance() : com.ankamagames.berilia.managers.LinkedCursorSpriteManager
      {
         if(!_self)
         {
            _self = new com.ankamagames.berilia.managers.LinkedCursorSpriteManager();
         }
         return _self;
      }
      
      public function getItem(name:String) : LinkedCursorData
      {
         return this.items[name];
      }
      
      public function addItem(name:String, item:LinkedCursorData) : void
      {
         var bounds:Rectangle = null;
         if(this.items[name])
         {
            this.removeItem(name);
         }
         this.items[name] = item;
         item.sprite.mouseChildren = false;
         item.sprite.mouseEnabled = false;
         Berilia.getInstance().strataTooltip.addChild(item.sprite);
         var fmouseX:* = StageShareManager.mouseX;
         var fmouseY:* = StageShareManager.mouseY;
         item.sprite.x = (!!item.lockX?item.sprite.x:StageShareManager.mouseX) - (!!item.offset?item.offset.x:item.sprite.width / 2);
         item.sprite.y = (!!item.lockY?item.sprite.y:StageShareManager.mouseY) - (!!item.offset?item.offset.y:item.sprite.height / 2);
         if(Boolean(item.lockX) || Boolean(item.lockY))
         {
            bounds = new Rectangle();
            bounds.left = !!item.lockX?Number(item.sprite.x):Number(0);
            bounds.right = !!item.lockX?Number(item.sprite.x):Number(StageShareManager.startWidth);
            bounds.top = !!item.lockY?Number(item.sprite.y):Number(0);
            bounds.bottom = !!item.lockY?Number(item.sprite.y):Number(StageShareManager.startHeight);
            item.sprite.startDrag(false,bounds);
         }
         else
         {
            item.sprite.startDrag(false);
         }
      }
      
      public function removeItem(name:String) : Boolean
      {
         if(!this.items[name])
         {
            return false;
         }
         if(Sprite(this.items[name].sprite).parent)
         {
            Sprite(this.items[name].sprite).parent.removeChild(Sprite(this.items[name].sprite));
         }
         this.items[name] = null;
         delete this.items[name];
         return true;
      }
   }
}
