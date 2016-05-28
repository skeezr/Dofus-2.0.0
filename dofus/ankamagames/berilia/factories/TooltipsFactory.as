package com.ankamagames.berilia.factories
{
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.berilia.types.tooltip.Tooltip;
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.utils.api_namespace;
   
   public class TooltipsFactory
   {
      
      private static var _registeredMaker:Array = new Array();
      
      private static var _makerAssoc:Array = new Array();
       
      public function TooltipsFactory()
      {
         super();
      }
      
      public static function registerMaker(makerName:String, maker:Class, scriptClass:Class = null) : void
      {
         _registeredMaker[makerName] = new TooltipData(maker,scriptClass);
      }
      
      public static function registerAssoc(dataClass:*, makerName:String) : void
      {
         _makerAssoc[getQualifiedClassName(dataClass)] = makerName;
      }
      
      public static function unregister(dataType:Class, maker:Class) : void
      {
         if(TooltipData(_registeredMaker[getQualifiedClassName(dataType)]).maker === maker)
         {
            delete _registeredMaker[getQualifiedClassName(dataType)];
         }
      }
      
      public static function create(data:*, makerName:String = null, script:Class = null, makerParam:Object = null) : Tooltip
      {
         var td:TooltipData = null;
         var maker:* = undefined;
         var tt:Tooltip = null;
         if(makerName)
         {
            td = _registeredMaker[makerName];
         }
         else
         {
            td = _registeredMaker[_makerAssoc[getQualifiedClassName(data)]];
         }
         if(td)
         {
            maker = new td.maker();
            tt = maker.createTooltip(data,makerParam);
            if(UiApi.api_namespace::defaultTooltipUiScript == script)
            {
               tt.scriptClass = !!td.scriptClass?td.scriptClass:script;
            }
            else
            {
               tt.scriptClass = script;
            }
            return tt;
         }
         return null;
      }
   }
}

class TooltipData
{
    
   public var maker:Class;
   
   public var scriptClass:Class;
   
   function TooltipData(maker:Class, scriptClass:Class)
   {
      super();
      this.maker = maker;
      this.scriptClass = scriptClass;
   }
}
