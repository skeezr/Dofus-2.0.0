package com.ankamagames.atouin.utils
{
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import flash.display.Sprite;
   
   public class CellUtil
   {
       
      public function CellUtil()
      {
         super();
      }
      
      public static function getPixelXFromMapPoint(p:MapPoint) : int
      {
         var cellSprite:Sprite = InteractiveCellManager.getInstance().getCell(p.cellId);
         return cellSprite.x + cellSprite.width / 2;
      }
      
      public static function getPixelYFromMapPoint(p:MapPoint) : int
      {
         var cellSprite:Sprite = InteractiveCellManager.getInstance().getCell(p.cellId);
         return cellSprite.y + cellSprite.height / 2;
      }
   }
}
