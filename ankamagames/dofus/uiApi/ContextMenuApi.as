package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.jerakine.utils.misc.CheckCompatibility;
   import com.ankamagames.berilia.interfaces.IMenuMaker;
   import com.ankamagames.berilia.factories.MenusFactory;
   import com.ankamagames.berilia.utils.errors.ApiError;
   import com.ankamagames.jerakine.utils.misc.BoxingUnBoxing;
   
   [InstanciedApi]
   public class ContextMenuApi
   {
       
      public function ContextMenuApi()
      {
         super();
      }
      
      [Untrusted]
      public function registerMenuMaker(makerName:String, makerClass:Class) : void
      {
         if(CheckCompatibility.isCompatible(IMenuMaker,makerClass))
         {
            MenusFactory.registerMaker(makerName,makerClass);
            return;
         }
         throw new ApiError(makerName + " maker class is not compatible with IMenuMaker");
      }
      
      [NoBoxing]
      [Untrusted]
      public function create(data:*, makerName:String = null, makerParams:Array = null) : Array
      {
         var menu:Array = MenusFactory.create(BoxingUnBoxing.unbox(data),makerName,makerParams);
         return menu;
      }
      
      [NoBoxing]
      [Untrusted]
      public function getMenuMaker(makerName:String) : Object
      {
         return MenusFactory.getMenuMaker(makerName);
      }
   }
}
