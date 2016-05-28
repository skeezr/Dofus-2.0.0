package com.ankamagames.jerakine.utils.display
{
   import flash.utils.ByteArray;
   import flash.events.KeyboardEvent;
   import flash.events.Event;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class KeyPoll
   {
      
      private static var _self:com.ankamagames.jerakine.utils.display.KeyPoll;
       
      private var states:ByteArray;
      
      public function KeyPoll()
      {
         super();
         if(_self)
         {
            throw new SingletonError();
         }
         this.states = new ByteArray();
         this.states.writeUnsignedInt(0);
         this.states.writeUnsignedInt(0);
         this.states.writeUnsignedInt(0);
         this.states.writeUnsignedInt(0);
         this.states.writeUnsignedInt(0);
         this.states.writeUnsignedInt(0);
         this.states.writeUnsignedInt(0);
         this.states.writeUnsignedInt(0);
         StageShareManager.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownListener,false,0,true);
         StageShareManager.stage.addEventListener(KeyboardEvent.KEY_UP,this.keyUpListener,false,0,true);
         StageShareManager.stage.addEventListener(Event.ACTIVATE,this.activateListener,false,0,true);
         StageShareManager.stage.addEventListener(Event.DEACTIVATE,this.deactivateListener,false,0,true);
      }
      
      public static function getInstance() : com.ankamagames.jerakine.utils.display.KeyPoll
      {
         if(!_self)
         {
            _self = new com.ankamagames.jerakine.utils.display.KeyPoll();
         }
         return _self;
      }
      
      private function keyDownListener(ev:KeyboardEvent) : void
      {
         this.states[ev.keyCode >>> 3] = this.states[ev.keyCode >>> 3] | 1 << (ev.keyCode & 7);
      }
      
      private function keyUpListener(ev:KeyboardEvent) : void
      {
         this.states[ev.keyCode >>> 3] = this.states[ev.keyCode >>> 3] & ~(1 << (ev.keyCode & 7));
      }
      
      private function activateListener(ev:Event) : void
      {
         for(var i:int = 0; i < 32; i++)
         {
            this.states[i] = 0;
         }
      }
      
      private function deactivateListener(ev:Event) : void
      {
         for(var i:int = 0; i < 32; i++)
         {
            this.states[i] = 0;
         }
      }
      
      public function isDown(keyCode:uint) : Boolean
      {
         return (this.states[keyCode >>> 3] & 1 << (keyCode & 7)) != 0;
      }
      
      public function isUp(keyCode:uint) : Boolean
      {
         return (this.states[keyCode >>> 3] & 1 << (keyCode & 7)) == 0;
      }
   }
}
