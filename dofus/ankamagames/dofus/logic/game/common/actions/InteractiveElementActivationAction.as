package com.ankamagames.dofus.logic.game.common.actions
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   
   public class InteractiveElementActivationAction implements Action
   {
       
      private var _ie:InteractiveElement;
      
      private var _position:MapPoint;
      
      private var _skillId:uint;
      
      public function InteractiveElementActivationAction()
      {
         super();
      }
      
      public static function create(ie:InteractiveElement, position:MapPoint, skillId:uint) : InteractiveElementActivationAction
      {
         var a:InteractiveElementActivationAction = new InteractiveElementActivationAction();
         a._ie = ie;
         a._position = position;
         a._skillId = skillId;
         return a;
      }
      
      public function get interactiveElement() : InteractiveElement
      {
         return this._ie;
      }
      
      public function get position() : MapPoint
      {
         return this._position;
      }
      
      public function get skillId() : uint
      {
         return this._skillId;
      }
   }
}
