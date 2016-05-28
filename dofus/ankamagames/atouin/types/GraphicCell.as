package com.ankamagames.atouin.types
{
   import flash.display.Sprite;
   
   public class GraphicCell extends Sprite
   {
       
      private var _dropValidator:Function;
      
      private var _removeDropSource:Function;
      
      private var _processDrop:Function;
      
      public function GraphicCell(cellId:uint)
      {
         this._dropValidator = this.returnTrueFunction;
         this._removeDropSource = this.returnTrueFunction;
         this._processDrop = this.returnTrueFunction;
         super();
         name = cellId.toString();
         buttonMode = true;
         cacheAsBitmap = true;
      }
      
      public function set dropValidator(dv:Function) : void
      {
         this._dropValidator = dv;
      }
      
      public function get dropValidator() : Function
      {
         return this._dropValidator;
      }
      
      public function set removeDropSource(rds:Function) : void
      {
         this._removeDropSource = rds;
      }
      
      public function get removeDropSource() : Function
      {
         return this._removeDropSource;
      }
      
      public function set processDrop(pd:Function) : void
      {
         this._processDrop = pd;
      }
      
      public function get processDrop() : Function
      {
         return this._processDrop;
      }
      
      private function returnTrueFunction(... args) : Boolean
      {
         return true;
      }
   }
}
