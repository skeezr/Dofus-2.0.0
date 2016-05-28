package com.ankamagames.dofus.logic.common.managers
{
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.display.Stage;
   import flash.geom.Rectangle;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.utils.api_namespace;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   
   public class HyperlinkSpellManager
   {
       
      public function HyperlinkSpellManager()
      {
         super();
      }
      
      public static function showSpell(spellId:int, spellLevel:int) : void
      {
         var spellWrapper:SpellWrapper = SpellWrapper.create(0,spellId,spellLevel);
         var stage:Stage = StageShareManager.stage;
         var target:Rectangle = new Rectangle(stage.mouseX,stage.mouseY,10,10);
         TooltipManager.show(spellWrapper,target,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,"Hyperlink",6,2,50,true,null,UiApi.api_namespace::defaultTooltipUiScript);
      }
      
      public static function getSpellName(spellId:int, spellLevel:int) : String
      {
         var spellWrapper:SpellWrapper = SpellWrapper.create(0,spellId,spellLevel);
         return "[" + spellWrapper.name + " " + I18n.getText(I18nProxy.getKeyId("ui.common.short.level")) + spellLevel + "]";
      }
   }
}
