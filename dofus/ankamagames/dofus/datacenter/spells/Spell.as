package com.ankamagames.dofus.datacenter.spells
{
   import com.ankamagames.dofus.datacenter.interfaces.IDescribed;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.data.I18n;
   
   public class Spell implements IDescribed
   {
      
      private static const MODULE:String = "Spells";
       
      private var _indexedParam:Array;
      
      public var id:int;
      
      public var nameId:uint;
      
      public var descriptionId:uint;
      
      public var typeId:uint;
      
      public var scriptParams:String;
      
      public var scriptId:int;
      
      public var iconId:uint;
      
      public var spellLevels:Vector.<uint>;
      
      public var useParamCache:Boolean = true;
      
      public function Spell()
      {
         super();
      }
      
      public static function getSpellById(id:int) : Spell
      {
         return GameData.getObject(MODULE,id) as Spell;
      }
      
      public static function create(id:int, nameId:uint, descriptionId:uint, scriptParams:String, scriptId:int, iconId:uint, typeId:uint, spellLevel:Vector.<uint>) : Spell
      {
         var o:Spell = new Spell();
         o.id = id;
         o.nameId = nameId;
         o.descriptionId = descriptionId;
         o.scriptParams = scriptParams;
         o.scriptId = scriptId;
         o.iconId = iconId;
         o.typeId = typeId;
         o.spellLevels = spellLevel;
         return o;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
      
      public function get description() : String
      {
         return I18n.getText(this.descriptionId);
      }
      
      public function getSpellLevel(level:int) : SpellLevel
      {
         return SpellLevel.getLevelById(this.spellLevels[level - 1]);
      }
      
      public function getParamByName(name:String) : Number
      {
         var tmp:Array = null;
         var tmp2:Array = null;
         var param:String = null;
         if(!this._indexedParam || !this.useParamCache)
         {
            this._indexedParam = new Array();
            tmp = this.scriptParams.split(",");
            for each(param in tmp)
            {
               tmp2 = param.split(":");
               this._indexedParam[tmp2[0]] = parseFloat(tmp2[1]);
            }
         }
         return this._indexedParam[name];
      }
   }
}
