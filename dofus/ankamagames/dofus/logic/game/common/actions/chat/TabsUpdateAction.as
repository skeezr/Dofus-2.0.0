package com.ankamagames.dofus.logic.game.common.actions.chat
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class TabsUpdateAction implements Action
   {
       
      private var _tabs:Array;
      
      private var _tabsNames:Array;
      
      public function TabsUpdateAction()
      {
         super();
      }
      
      public static function create(tabs:Array = null, tabsNames:Array = null) : TabsUpdateAction
      {
         var a:TabsUpdateAction = new TabsUpdateAction();
         a._tabs = tabs;
         a._tabsNames = tabsNames;
         return a;
      }
      
      public function get tabs() : Array
      {
         return this._tabs;
      }
      
      public function get tabsNames() : Array
      {
         return this._tabsNames;
      }
   }
}
