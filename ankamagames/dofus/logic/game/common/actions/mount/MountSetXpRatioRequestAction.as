package com.ankamagames.dofus.logic.game.common.actions.mount
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class MountSetXpRatioRequestAction implements Action
   {
       
      private var _xpRatio:uint;
      
      public function MountSetXpRatioRequestAction()
      {
         super();
      }
      
      public static function create(xpRatio:uint) : MountSetXpRatioRequestAction
      {
         var o:MountSetXpRatioRequestAction = new MountSetXpRatioRequestAction();
         o._xpRatio = xpRatio;
         return o;
      }
      
      public function get xpRatio() : uint
      {
         return this._xpRatio;
      }
   }
}
