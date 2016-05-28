package com.ankamagames.dofus.types.characteristicContextual
{
   import flash.events.EventDispatcher;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import flash.text.TextFormat;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import flash.events.Event;
   import flash.utils.getTimer;
   import flash.display.DisplayObject;
   import com.ankamagames.jerakine.utils.errors.SingletonError;
   
   public class CharacteristicContextualManager extends EventDispatcher
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.dofus.types.characteristicContextual.CharacteristicContextualManager));
      
      private static var _self:com.ankamagames.dofus.types.characteristicContextual.CharacteristicContextualManager;
      
      private static var _aEntitiesTweening:Array;
       
      private var _bEnterFrameNeeded:Boolean;
      
      private var _tweeningCount:uint;
      
      private var _scrollSpeed:Number = 1;
      
      private var _scrollDuration:uint = 1500;
      
      private var _heightMax:uint = 50;
      
      private var _tweenByEntities:Dictionary;
      
      private var _type:uint = 1;
      
      public function CharacteristicContextualManager()
      {
         super();
         if(_self)
         {
            throw new SingletonError("Warning : CharacteristicContextualManager is a singleton class and shoulnd\'t be instancied directly!");
         }
         _aEntitiesTweening = new Array();
         this._bEnterFrameNeeded = true;
         this._tweeningCount = 0;
         this._tweenByEntities = new Dictionary(true);
      }
      
      public static function getInstance() : com.ankamagames.dofus.types.characteristicContextual.CharacteristicContextualManager
      {
         if(_self == null)
         {
            _self = new com.ankamagames.dofus.types.characteristicContextual.CharacteristicContextualManager();
         }
         return _self;
      }
      
      public function get scrollSpeed() : Number
      {
         return this._scrollSpeed;
      }
      
      public function set scrollSpeed(nValue:Number) : void
      {
         this._scrollSpeed = nValue;
      }
      
      public function get scrollDuration() : uint
      {
         return this._scrollDuration;
      }
      
      public function set scrollDuration(nValue:uint) : void
      {
         this._scrollDuration = nValue;
      }
      
      public function addStatContextual(sText:String, oEntity:IEntity, format:TextFormat, type:uint) : CharacteristicContextual
      {
         var txtCxt:TextContextual = null;
         var txtSCxt:StyledTextContextual = null;
         var data:TweenData = null;
         if(!oEntity || oEntity.position.cellId == -1)
         {
            return null;
         }
         this._type = type;
         var dist:Array = [Math.abs(16711680 - (format.color as uint)),Math.abs(255 - (format.color as uint)),Math.abs(26112 - (format.color as uint))];
         var style:uint = dist.indexOf(Math.min(dist[0],dist[1],dist[2]));
         switch(this._type)
         {
            case 1:
               txtCxt = new TextContextual();
               txtCxt.referedEntity = oEntity;
               txtCxt.text = sText;
               txtCxt.textFormat = format;
               txtCxt.finalize();
               if(!this._tweenByEntities[oEntity])
               {
                  this._tweenByEntities[oEntity] = new Array();
               }
               data = new TweenData(txtCxt,oEntity);
               (this._tweenByEntities[oEntity] as Array).unshift(data);
               if((this._tweenByEntities[oEntity] as Array).length == 1)
               {
                  _aEntitiesTweening.push(data);
               }
               this._tweeningCount++;
               this.beginTween(txtCxt);
               break;
            case 2:
               txtSCxt = new StyledTextContextual(sText,style);
               txtSCxt.referedEntity = oEntity;
               if(!this._tweenByEntities[oEntity])
               {
                  this._tweenByEntities[oEntity] = new Array();
               }
               data = new TweenData(txtSCxt,oEntity);
               (this._tweenByEntities[oEntity] as Array).unshift(data);
               if((this._tweenByEntities[oEntity] as Array).length == 1)
               {
                  _aEntitiesTweening.push(data);
               }
               this._tweeningCount++;
               this.beginTween(txtSCxt);
         }
         return !!txtCxt?txtCxt:txtSCxt;
      }
      
      private function removeStatContextual(nIndex:Number) : void
      {
         var entity:CharacteristicContextual = null;
         if(_aEntitiesTweening[nIndex] != null)
         {
            entity = _aEntitiesTweening[nIndex].context;
            entity.remove();
            Berilia.getInstance().strataLow.removeChild(entity);
            _aEntitiesTweening[nIndex] = null;
            delete _aEntitiesTweening[nIndex];
         }
      }
      
      private function beginTween(oEntity:CharacteristicContextual) : void
      {
         Berilia.getInstance().strataLow.addChild(oEntity);
         var display:IRectangle = IDisplayable(oEntity.referedEntity).absoluteBounds;
         oEntity.x = (display.x + display.width / 2 - oEntity.width / 2 - StageShareManager.stageOffsetX) / StageShareManager.stageScaleX;
         oEntity.y = (display.y - display.height + oEntity.height - StageShareManager.stageOffsetY) / StageShareManager.stageScaleY;
         oEntity.alpha = 0;
         if(this._bEnterFrameNeeded)
         {
            EnterFrameDispatcher.addEventListener(this.onScroll,"CharacteristicContextManager");
            this._bEnterFrameNeeded = false;
         }
      }
      
      private function onScroll(e:Event) : void
      {
         var index:* = null;
         var tweenData:TweenData = null;
         var entity:CharacteristicContextual = null;
         var entityTweenList:Array = null;
         var display:IRectangle = null;
         var addToNextTween:Array = [];
         for(index in _aEntitiesTweening)
         {
            tweenData = _aEntitiesTweening[index];
            if(tweenData)
            {
               entity = tweenData.context;
               entity.y = entity.y - this._scrollSpeed;
               tweenData._tweeningCurrentDistance = (getTimer() - tweenData.startTime) / this._scrollDuration;
               entityTweenList = this._tweenByEntities[tweenData.entity];
               if(Boolean(entityTweenList) && Boolean(entityTweenList[entityTweenList.length - 1] == tweenData) && tweenData._tweeningCurrentDistance > 0.5)
               {
                  entityTweenList.pop();
                  if(entityTweenList.length)
                  {
                     entityTweenList[entityTweenList.length - 1].startTime = getTimer();
                     addToNextTween.push(entityTweenList[entityTweenList.length - 1]);
                  }
                  else
                  {
                     delete this._tweenByEntities[tweenData.entity];
                  }
               }
               if(tweenData._tweeningCurrentDistance < 1 / 4)
               {
                  entity.alpha = tweenData._tweeningCurrentDistance * 4;
                  if(this._type == 2)
                  {
                     entity.scaleX = 5 - tweenData._tweeningCurrentDistance * 16;
                     entity.scaleY = 5 - tweenData._tweeningCurrentDistance * 16;
                     display = IDisplayable(entity.referedEntity).absoluteBounds;
                     if(!(entity.referedEntity is DisplayObject) || Boolean(DisplayObject(entity.referedEntity).parent))
                     {
                        entity.x = (display.x + display.width / 2 - entity.width / 2 - StageShareManager.stageOffsetX) / StageShareManager.stageScaleX;
                     }
                  }
               }
               else if(tweenData._tweeningCurrentDistance >= 3 / 4 && tweenData._tweeningCurrentDistance < 1)
               {
                  entity.alpha = 1 - tweenData._tweeningCurrentDistance;
               }
               else if(tweenData._tweeningCurrentDistance >= 1)
               {
                  this.removeStatContextual(int(index));
                  this._tweeningCount--;
                  if(this._tweeningCount == 0)
                  {
                     this._bEnterFrameNeeded = true;
                     EnterFrameDispatcher.removeEventListener(this.onScroll);
                  }
               }
               else
               {
                  entity.alpha = 1;
               }
            }
         }
         _aEntitiesTweening = _aEntitiesTweening.concat(addToNextTween);
      }
   }
}

import com.ankamagames.jerakine.entities.interfaces.IEntity;
import com.ankamagames.dofus.types.characteristicContextual.CharacteristicContextual;
import flash.utils.getTimer;

class TweenData
{
    
   public var entity:IEntity;
   
   public var context:CharacteristicContextual;
   
   public var _tweeningTotalDistance:uint = 40;
   
   public var _tweeningCurrentDistance:Number = 0;
   
   public var alpha:Number = 0;
   
   public var startTime:int;
   
   function TweenData(oEntity:CharacteristicContextual, entity:IEntity)
   {
      this.startTime = getTimer();
      super();
      this.context = oEntity;
      this.entity = entity;
   }
}
