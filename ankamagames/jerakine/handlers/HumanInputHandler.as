package com.ankamagames.jerakine.handlers
{
   import com.ankamagames.jerakine.messages.MessageDispatcher;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.messages.MessageHandler;
   import com.ankamagames.jerakine.utils.display.KeyPoll;
   import com.ankamagames.jerakine.utils.memory.WeakReference;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.events.MouseEvent;
   import flash.events.KeyboardEvent;
   import flash.utils.getTimer;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseDoubleClickMessage;
   import flash.display.InteractiveObject;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseWheelMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOverMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseOutMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseRightClickMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseDownMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseReleaseOutsideMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseUpMessage;
   import flash.ui.Keyboard;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardKeyDownMessage;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardKeyUpMessage;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class HumanInputHandler extends MessageDispatcher
   {
      
      private static var _self:com.ankamagames.jerakine.handlers.HumanInputHandler;
      
      private static const DOUBLE_CLICK_DELAY:uint = 250;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.jerakine.handlers.HumanInputHandler));
       
      private var _handler:MessageHandler;
      
      private var _keyPoll:KeyPoll;
      
      private var _lastTarget:WeakReference;
      
      private var _lastClick:uint;
      
      public function HumanInputHandler()
      {
         super();
         if(_self != null)
         {
            throw new SingletonError("HumanInputHandler constructor should not be called directly.");
         }
         this.initialize();
      }
      
      public static function getInstance() : com.ankamagames.jerakine.handlers.HumanInputHandler
      {
         if(_self == null)
         {
            _self = new com.ankamagames.jerakine.handlers.HumanInputHandler();
         }
         return _self;
      }
      
      public function get handler() : MessageHandler
      {
         return this._handler;
      }
      
      public function set handler(value:MessageHandler) : void
      {
         this._handler = value;
      }
      
      public function getKeyboardPoll() : KeyPoll
      {
         return this._keyPoll;
      }
      
      private function initialize() : void
      {
         this._keyPoll = new KeyPoll();
         this.registerListeners();
      }
      
      public function registerListeners() : void
      {
         StageShareManager.stage.addEventListener(MouseEvent.CLICK,this.onClick,true,1,true);
         StageShareManager.stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel,true,1,true);
         StageShareManager.stage.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver,true,1,true);
         StageShareManager.stage.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,true,1,true);
         StageShareManager.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown,true,1,true);
         StageShareManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp,true,1,true);
         StageShareManager.stage.addEventListener(MouseEvent.RIGHT_CLICK,this.onRightClick,true,1,true);
         StageShareManager.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,1,true);
         StageShareManager.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp,false,1,true);
      }
      
      private function onClick(me:MouseEvent) : void
      {
         var now:uint = getTimer();
         if(this._lastClick + DOUBLE_CLICK_DELAY > now)
         {
            this._handler.process(new MouseDoubleClickMessage(InteractiveObject(me.target),me));
         }
         else
         {
            this._handler.process(new MouseClickMessage(InteractiveObject(me.target),me));
         }
         this._lastClick = now;
      }
      
      private function onMouseWheel(me:MouseEvent) : void
      {
         this._handler.process(new MouseWheelMessage(InteractiveObject(me.target),me));
      }
      
      private function onMouseOver(me:MouseEvent) : void
      {
         this._handler.process(new MouseOverMessage(InteractiveObject(me.target),me));
      }
      
      private function onMouseOut(me:MouseEvent) : void
      {
         this._handler.process(new MouseOutMessage(InteractiveObject(me.target),me));
      }
      
      private function onRightClick(me:MouseEvent) : void
      {
         this._lastTarget = new WeakReference(me.target);
         this._handler.process(new MouseRightClickMessage(InteractiveObject(me.target),me));
      }
      
      private function onMouseDown(me:MouseEvent) : void
      {
         this._lastTarget = new WeakReference(me.target);
         this._handler.process(new MouseDownMessage(InteractiveObject(me.target),me));
      }
      
      private function onMouseUp(me:MouseEvent) : void
      {
         if(this._lastTarget != null && this._lastTarget.object != me.target)
         {
            this._handler.process(new MouseReleaseOutsideMessage(InteractiveObject(this._lastTarget.object),me));
         }
         FocusHandler.getInstance().setFocus(InteractiveObject(me.target));
         this._handler.process(new MouseUpMessage(InteractiveObject(me.target),me));
      }
      
      private function onKeyDown(ke:KeyboardEvent) : void
      {
         if(ke.keyCode == Keyboard.ESCAPE)
         {
            ke.preventDefault();
         }
         this._handler.process(new KeyboardKeyDownMessage(FocusHandler.getInstance().getFocus(),ke));
      }
      
      private function onKeyUp(ke:KeyboardEvent) : void
      {
         this._handler.process(new KeyboardKeyUpMessage(FocusHandler.getInstance().getFocus(),ke));
      }
   }
}
