package com.ankamagames.dofus.logic.common.managers
{
   import flash.display.Sprite;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import flash.display.DisplayObject;
   import com.ankamagames.berilia.Berilia;
   import flash.geom.Rectangle;
   
   public class HyperlinkShowEntityManager
   {
       
      public function HyperlinkShowEntityManager()
      {
         super();
      }
      
      public static function showEntity(entityId:int) : Sprite
      {
         var entity:DisplayObject = DofusEntities.getEntity(entityId) as DisplayObject;
         var rect:Rectangle = entity.getRect(Berilia.getInstance().docMain);
         return HyperlinkDisplayArrowManager.showAbsoluteArrow(int(rect.x),int(rect.y));
      }
   }
}
