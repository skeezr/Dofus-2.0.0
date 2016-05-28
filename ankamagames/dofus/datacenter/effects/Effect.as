package com.ankamagames.dofus.datacenter.effects
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   
   public class Effect
   {
      
      private static const MODULE:String = "Effects";
       
      public var id:int;
      
      public var descriptionId:uint;
      
      public var iconId:uint;
      
      public var characteristic:int;
      
      public var category:uint;
      
      public var operator:String;
      
      public var showInTooltip:Boolean;
      
      public function Effect()
      {
         super();
      }
      
      public static function create(id:int, descriptionId:uint, iconId:uint, characteristic:int, category:uint, operator:String, showInTooltip:Boolean) : Effect
      {
         var o:Effect = new Effect();
         o.id = id;
         o.descriptionId = descriptionId;
         o.iconId = iconId;
         o.characteristic = characteristic;
         o.category = category;
         o.operator = operator;
         o.showInTooltip = showInTooltip;
         return o;
      }
      
      public static function getEffectById(id:uint) : Effect
      {
         return GameData.getObject(MODULE,id) as Effect;
      }
      
      public function get description() : String
      {
         return I18n.getText(this.descriptionId);
      }
   }
}
