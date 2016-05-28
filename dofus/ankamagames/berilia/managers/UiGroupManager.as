package com.ankamagames.berilia.managers
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.berilia.types.data.UiGroup;
   import com.ankamagames.berilia.utils.errors.BeriliaError;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.types.event.UiRenderAskEvent;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class UiGroupManager
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.berilia.managers.UiGroupManager));
      
      private static var _self:com.ankamagames.berilia.managers.UiGroupManager;
       
      private var _registeredGroup:Array;
      
      private var _uis:Array;
      
      public function UiGroupManager()
      {
         this._registeredGroup = new Array();
         this._uis = new Array();
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         Berilia.getInstance().addEventListener(UiRenderAskEvent.UI_RENDER_ASK,this.onUiRenderAsk);
      }
      
      public static function getInstance() : com.ankamagames.berilia.managers.UiGroupManager
      {
         if(!_self)
         {
            _self = new com.ankamagames.berilia.managers.UiGroupManager();
         }
         return _self;
      }
      
      public function registerGroup(g:UiGroup) : void
      {
         var rg:UiGroup = null;
         for each(rg in this._registeredGroup)
         {
            if(rg.name == g.name)
            {
               throw new BeriliaError(g.name + " is already used in UiGroupManager");
            }
         }
         this._registeredGroup[g.name] = g;
      }
      
      public function getGroup(name:String) : UiGroup
      {
         return this._registeredGroup[name];
      }
      
      public function destroy() : void
      {
         Berilia.getInstance().removeEventListener(UiRenderAskEvent.UI_RENDER_ASK,this.onUiRenderAsk);
         _self = null;
      }
      
      private function onUiRenderAsk(e:UiRenderAskEvent) : void
      {
         var group:UiGroup = null;
         var actualGroupUis:Array = null;
         var uiName:String = null;
         var close:Boolean = false;
         var uiName2:String = null;
         if(!e.uiData.uiGroupName || !this._registeredGroup[e.uiData.uiGroupName])
         {
            return;
         }
         if(!this._uis[e.uiData.uiGroupName])
         {
            this._uis[e.uiData.uiGroupName] = new Array();
         }
         var currentGroup:UiGroup = this.getGroup(e.uiData.uiGroupName);
         if(!currentGroup)
         {
            return;
         }
         for each(group in this._registeredGroup)
         {
            if(Boolean(currentGroup.exclusive) && !group.permanent && group.name != currentGroup.name)
            {
               if(this._uis[group.name] != null)
               {
                  actualGroupUis = this._registeredGroup[group.name].uis;
                  for each(uiName in actualGroupUis)
                  {
                     close = true;
                     for each(uiName2 in currentGroup.uis)
                     {
                        if(uiName == uiName2)
                        {
                           close = false;
                        }
                     }
                     if(Boolean(close) && uiName2 != null)
                     {
                        Berilia.getInstance().unloadUi(uiName);
                     }
                     delete this._uis[group.name][uiName];
                  }
               }
            }
         }
         this._uis[e.uiData.uiGroupName][e.name] = e.uiData;
      }
   }
}
