package com.ankamagames.dofus.logic.game.roleplay.messages
{
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   
   public class GameRolePlaySetAnimationMessage implements Message
   {
       
      private var _informations:GameContextActorInformations;
      
      private var _animation:String;
      
      private var _duration:uint;
      
      private var _instant:Boolean;
      
      private var _directions8:Boolean;
      
      public function GameRolePlaySetAnimationMessage(informations:GameContextActorInformations, animation:String, duration:uint = 0, instant:Boolean = true, directions8:Boolean = true)
      {
         super();
         this._informations = informations;
         this._animation = animation;
         this._duration = duration;
         this._instant = instant;
         this._directions8 = directions8;
      }
      
      public function get informations() : GameContextActorInformations
      {
         return this._informations;
      }
      
      public function get animation() : String
      {
         return this._animation;
      }
      
      public function get duration() : uint
      {
         return this._duration;
      }
      
      public function get instant() : Boolean
      {
         return this._instant;
      }
      
      public function get directions8() : Boolean
      {
         return this._directions8;
      }
   }
}
