package com.ankamagames.dofus.logic.game.roleplay.messages
{
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   
   public class InteractiveElementActivationMessage implements Message
   {
       
      private var _ie:InteractiveElement;
      
      private var _position:MapPoint;
      
      private var _skillId:uint;
      
      public function InteractiveElementActivationMessage(ie:InteractiveElement, position:MapPoint, skillId:uint)
      {
         super();
         this._ie = ie;
         this._position = position;
         this._skillId = skillId;
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
