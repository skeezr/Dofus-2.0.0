package com.ankamagames.tiphon.engine
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.tiphon.types.EventListener;
   import com.ankamagames.jerakine.interfaces.IFLAEventHandler;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import flash.display.Scene;
   import flash.display.FrameLabel;
   import com.ankamagames.tiphon.types.TiphonEventInfo;
   import com.ankamagames.tiphon.events.TiphonEvent;
   
   public class TiphonEventsManager
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(TiphonEventsManager));
      
      private static var _listeners:Vector.<EventListener>;
      
      private static var _eventsDic:Array;
      
      private static const EVENT_SHOT:String = "SHOT";
      
      private static const EVENT_END:String = "END";
      
      private static const PLAYER_STOP:String = "STOP";
      
      private static const EVENT_SOUND:String = "SOUND";
      
      private static var BALISE_SOUND:String = "Sound";
      
      private static var BALISE_EVT:String = "Evt";
      
      private static var BALISE_PARAM_BEGIN:String = "(";
      
      private static var BALISE_PARAM_END:String = ")";
       
      private var _tiphonSprite:TiphonSprite;
      
      private var _events:Array;
      
      public function TiphonEventsManager(pTiphonSprite:TiphonSprite)
      {
         super();
         this._tiphonSprite = pTiphonSprite;
         this._events = new Array();
         if(_eventsDic == null)
         {
            _eventsDic = new Array();
         }
      }
      
      public static function get listeners() : Vector.<EventListener>
      {
         return _listeners;
      }
      
      public static function addListener(pListener:IFLAEventHandler, pTypes:String) : void
      {
         if(TiphonEventsManager._listeners == null)
         {
            TiphonEventsManager._listeners = new Vector.<EventListener>();
         }
         var eventListener:EventListener = new EventListener(pListener,pTypes);
         if(!TiphonEventsManager._listeners.indexOf(eventListener))
         {
            return;
         }
         TiphonEventsManager._listeners.push(eventListener);
      }
      
      public static function removeListener(pListener:IFLAEventHandler) : void
      {
         var index:int = TiphonEventsManager._listeners.indexOf(pListener);
         if(index)
         {
            TiphonEventsManager._listeners.splice(index,1);
         }
      }
      
      public function parseLabels(pScene:Scene, pAnimationName:String) : void
      {
         var curLabel:FrameLabel = null;
         var curLabelName:String = null;
         var curLabelFrame:int = 0;
         var numLabels:int = pScene.labels.length;
         var curLabelIndex:int = -1;
         while(++curLabelIndex < numLabels)
         {
            curLabel = pScene.labels[curLabelIndex] as FrameLabel;
            curLabelName = curLabel.name;
            curLabelFrame = curLabel.frame;
            this.addEvent(curLabelName,curLabelFrame,pAnimationName);
         }
      }
      
      public function dispatchEvents(pFrame:*) : void
      {
         var event:TiphonEventInfo = null;
         var eListener:EventListener = null;
         if(pFrame == 0)
         {
            pFrame = 1;
         }
         var spriteDirection:uint = this._tiphonSprite.getDirection();
         if(spriteDirection == 3)
         {
            spriteDirection = 1;
         }
         if(spriteDirection == 7)
         {
            spriteDirection = 5;
         }
         var spriteAnimation:String = this._tiphonSprite.getAnimation();
         if(this._events[pFrame])
         {
            for each(event in this._events[pFrame])
            {
               for each(eListener in TiphonEventsManager._listeners)
               {
                  if(eListener.typesEvents == event.type && event.animationType == spriteAnimation && event.direction == spriteDirection)
                  {
                     eListener.listener.handleFLAEvent(event.params,this._tiphonSprite);
                  }
               }
            }
         }
      }
      
      private function addEvent(pLabelName:String, pFrame:int, pAnimationName:String) : void
      {
         var event:TiphonEventInfo = null;
         var newEvent:TiphonEventInfo = null;
         var labelEvent:TiphonEventInfo = null;
         if(this._events[pFrame] == null)
         {
            this._events[pFrame] = new Vector.<TiphonEventInfo>();
         }
         for each(event in this._events[pFrame])
         {
            if(event.animationName == pAnimationName && event.label == pLabelName)
            {
               return;
            }
         }
         if(_eventsDic[pLabelName])
         {
            newEvent = _eventsDic[pLabelName] as TiphonEventInfo;
            newEvent.label = pLabelName;
            this._events[pFrame].push(newEvent);
            newEvent.animationName = pAnimationName;
         }
         else
         {
            labelEvent = this.parseLabel(pLabelName);
            if(labelEvent)
            {
               _eventsDic[pLabelName] = labelEvent;
               labelEvent.animationName = pAnimationName;
               labelEvent.label = pLabelName;
               this._events[pFrame].push(labelEvent);
            }
            else if(pLabelName != "END")
            {
               _log.error("Found label \'" + pLabelName + "\' on sprite " + this._tiphonSprite.look.getBone() + " (anim " + this._tiphonSprite.getAnimation() + ")");
            }
         }
      }
      
      private function parseLabel(pLabelName:String) : TiphonEventInfo
      {
         var returnEvent:TiphonEventInfo = null;
         var param:String = null;
         var eventName:String = pLabelName.split(BALISE_PARAM_BEGIN)[0];
         var r:RegExp = /^\s*(.*?)\s*$/g;
         eventName = eventName.replace(r,"$1");
         switch(eventName.toUpperCase())
         {
            case BALISE_SOUND.toUpperCase():
               param = pLabelName.split(BALISE_PARAM_BEGIN)[1];
               param = param.split(BALISE_PARAM_END)[0];
               returnEvent = new TiphonEventInfo(TiphonEvent.SOUND_EVENT,param);
               break;
            case BALISE_EVT.toUpperCase():
               param = pLabelName.split(BALISE_PARAM_BEGIN)[1];
               param = param.split(BALISE_PARAM_END)[0];
               returnEvent = new TiphonEventInfo(TiphonEvent.EVT_EVENT,param);
               break;
            default:
               returnEvent = this.convertOldLabel(pLabelName);
         }
         return returnEvent;
      }
      
      private function convertOldLabel(pLabelName:String) : TiphonEventInfo
      {
         var returnEvent:TiphonEventInfo = null;
         switch(pLabelName)
         {
            case EVENT_END:
               returnEvent = new TiphonEventInfo(TiphonEvent.EVT_EVENT,EVENT_END);
               break;
            case EVENT_SHOT:
               returnEvent = new TiphonEventInfo(TiphonEvent.EVT_EVENT,EVENT_SHOT);
         }
         return returnEvent;
      }
   }
}
