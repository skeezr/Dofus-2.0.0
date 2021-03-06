package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.tiphon.types.IAnimationModifier;
   import com.ankamagames.tiphon.types.ISubEntityBehavior;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.jerakine.utils.misc.BoxingUnBoxing;
   import com.ankamagames.jerakine.entities.interfaces.IAnimated;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.tiphon.sequence.SetDirectionStep;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.tiphon.sequence.SetAnimationStep;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.berilia.types.event.InstanceEvent;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.berilia.enums.EventEnums;
   import com.ankamagames.berilia.managers.UIEventManager;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import com.ankamagames.jerakine.interfaces.IInterfaceListener;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.jerakine.messages.Message;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class CharacterWheel extends GraphicContainer implements FinalizableUIComponent
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(CharacterWheel));
      
      public static var animationModifier:IAnimationModifier;
      
      public static var petSubEntityBehavior:ISubEntityBehavior;
       
      private var _nSelectedChara:int;
      
      private var _nNbCharacters:uint = 1;
      
      private var _aCharactersList:Object;
      
      private var _aEntitiesLook:Array;
      
      private var _ctrDepth:Array;
      
      private var _uiClass:UiRootContainer;
      
      private var _aMountainsCtr:Array;
      
      private var _aSprites:Array;
      
      private var _charaSelCtr:Object;
      
      private var _midZCtr:Object;
      
      private var _frontZCtr:Object;
      
      private var _sMountainUri:String;
      
      private var _nWidthEllipsis:int = 390;
      
      private var _nHeightEllipsis:int = 164;
      
      private var _nXCenterEllipsis:int = 540;
      
      private var _nYCenterEllipsis:int = 360;
      
      private var _nRotationStep:Number = 0;
      
      private var _nRotation:Number = 0;
      
      private var _nRotationPieceTrg:Number;
      
      private var _sens:int;
      
      private var _bMovingMountains:Boolean = false;
      
      private var _finalized:Boolean = false;
      
      public function CharacterWheel()
      {
         super();
         this._aEntitiesLook = new Array();
         this._aMountainsCtr = new Array();
         this._aSprites = new Array();
         this._ctrDepth = new Array();
      }
      
      public function get widthEllipsis() : int
      {
         return this._nWidthEllipsis;
      }
      
      public function set widthEllipsis(i:int) : void
      {
         this._nWidthEllipsis = i;
      }
      
      public function get heightEllipsis() : int
      {
         return this._nHeightEllipsis;
      }
      
      public function set heightEllipsis(i:int) : void
      {
         this._nHeightEllipsis = i;
      }
      
      public function get xEllipsis() : int
      {
         return this._nXCenterEllipsis;
      }
      
      public function set xEllipsis(i:int) : void
      {
         this._nXCenterEllipsis = i;
      }
      
      public function get yEllipsis() : int
      {
         return this._nYCenterEllipsis;
      }
      
      public function set yEllipsis(i:int) : void
      {
         this._nYCenterEllipsis = i;
      }
      
      public function get charaCtr() : Object
      {
         return this._charaSelCtr;
      }
      
      public function set charaCtr(ctr:Object) : void
      {
         this._charaSelCtr = ctr;
      }
      
      public function get frontCtr() : Object
      {
         return this._frontZCtr;
      }
      
      public function set frontCtr(ctr:Object) : void
      {
         this._frontZCtr = ctr;
      }
      
      public function get midCtr() : Object
      {
         return this._midZCtr;
      }
      
      public function set midCtr(ctr:Object) : void
      {
         this._midZCtr = ctr;
      }
      
      public function get mountainUri() : String
      {
         return this._sMountainUri;
      }
      
      public function set mountainUri(s:String) : void
      {
         this._sMountainUri = s;
      }
      
      public function get selectedChara() : int
      {
         return this._nSelectedChara;
      }
      
      public function set selectedChara(i:int) : void
      {
         this._nSelectedChara = i;
      }
      
      public function get isWheeling() : Boolean
      {
         return this._bMovingMountains;
      }
      
      public function set entities(data:*) : void
      {
         if(!this.isIterable(data))
         {
            throw new ArgumentError("entities must be either Array or Vector.");
         }
         this._aEntitiesLook = BoxingUnBoxing.unboxParam(data);
      }
      
      public function get entities() : *
      {
         return BoxingUnBoxing.boxParam(this._aEntitiesLook);
      }
      
      public function set dataProvider(data:*) : void
      {
         if(!this.isIterable(data))
         {
            throw new ArgumentError("dataProvider must be either Array or Vector.");
         }
         this._aCharactersList = data;
         this.finalize();
      }
      
      public function get dataProvider() : *
      {
         return this._aCharactersList;
      }
      
      public function get finalized() : Boolean
      {
         return this._finalized;
      }
      
      public function set finalized(b:Boolean) : void
      {
         this._finalized = b;
      }
      
      public function finalize() : void
      {
         this._uiClass = getUi();
         if(this._aCharactersList)
         {
            this._nNbCharacters = this._aCharactersList.length;
            this._nSelectedChara = 0;
            if(this._nNbCharacters > 0)
            {
               this.charactersDisplay();
            }
         }
         this._finalized = true;
         if(getUi())
         {
            getUi().iAmFinalized(this);
         }
      }
      
      override public function remove() : void
      {
         var g:GraphicContainer = null;
         for each(g in this._aMountainsCtr)
         {
            g.remove();
         }
         while(this._charaSelCtr.numChildren)
         {
            this._charaSelCtr.removeChildAt(0);
         }
         this._aCharactersList = null;
         this._aEntitiesLook = null;
         this._ctrDepth = null;
         this._uiClass = null;
         this._aMountainsCtr = null;
         this._aSprites = null;
         this._charaSelCtr = null;
         this._midZCtr = null;
         this._frontZCtr = null;
         super.remove();
      }
      
      public function wheel(sens:int) : void
      {
         this.rotateMountains(sens);
      }
      
      public function wheelChara(sens:int) : void
      {
         var dir:int = IAnimated(this._aSprites[this._nSelectedChara]).getDirection() + sens;
         dir = dir == 8?0:int(dir);
         dir = dir < 0?7:int(dir);
         IAnimated(this._aSprites[this._nSelectedChara]).setDirection(dir);
      }
      
      public function setAnimation(animationName:String, direction:int = 0) : void
      {
         var seq:SerialSequencer = new SerialSequencer();
         var sprite:TiphonSprite = this._aSprites[this._nSelectedChara];
         if(animationName == "AnimStatique")
         {
            sprite.setAnimationAndDirection("AnimStatique",direction);
         }
         else
         {
            seq.addStep(new SetDirectionStep(sprite,direction));
            seq.addStep(new PlayAnimationStep(sprite,animationName,false));
            seq.addStep(new SetAnimationStep(sprite,"AnimStatique"));
            seq.start();
         }
      }
      
      public function equipCharacter(list:Array) : void
      {
         var sprite:TiphonSprite = this._aSprites[this._nSelectedChara];
         var base:Array = sprite.look.toString().split("|");
         list.unshift(base[1].split(",")[0]);
         base[1] = list.join(",");
         var tel:TiphonEntityLook = TiphonEntityLook.fromString(base.join("|"));
         sprite.look.updateFrom(tel);
      }
      
      public function getMountainCtr(i:int) : Object
      {
         return this._aMountainsCtr[i];
      }
      
      private function charactersDisplay() : void
      {
         var children:uint = 0;
         var j:int = 0;
         var t:Number = NaN;
         var i:int = 0;
         var angle:Number = NaN;
         var coef:Number = NaN;
         var ctr:GraphicContainer = null;
         var characterInfo:CBI = null;
         var oPerso:TiphonEntity = null;
         var mountain:Texture = null;
         var ie:InstanceEvent = null;
         if(this._aMountainsCtr.length > 0)
         {
            children = this._charaSelCtr.numChildren;
            for(j = children - 1; j >= 0; j--)
            {
               this._charaSelCtr.removeChild(this._charaSelCtr.getChildAt(j));
            }
            this._aMountainsCtr = new Array();
            this._ctrDepth = new Array();
         }
         if(this._nNbCharacters == 0)
         {
            _log.error("Error : The character list is empty.");
         }
         else
         {
            t = 2 * Math.PI / this._nNbCharacters;
            this._nRotation = 0;
            this._nRotationPieceTrg = 0;
            for(i = 0; i < this._nNbCharacters; i++)
            {
               if(this._aCharactersList[i])
               {
                  angle = t * i % (2 * Math.PI);
                  coef = Math.abs(angle - Math.PI) / Math.PI;
                  ctr = new GraphicContainer();
                  ctr.x = this._nWidthEllipsis * Math.cos(angle + Math.PI / 2) + this._nXCenterEllipsis;
                  ctr.y = this._nHeightEllipsis * Math.sin(angle + Math.PI / 2) + this._nYCenterEllipsis;
                  characterInfo = new CBI(this._aCharactersList[i].id,this._aCharactersList[i].gfxId,this._aCharactersList[i].breed,new Array());
                  this._aEntitiesLook[i].look = BoxingUnBoxing.unbox(this._aEntitiesLook[i].look);
                  oPerso = new TiphonEntity(this._aEntitiesLook[i].id,this._aEntitiesLook[i].look);
                  if(CharacterWheel.animationModifier != null)
                  {
                     oPerso.animationModifier = CharacterWheel.animationModifier;
                  }
                  if(CharacterWheel.petSubEntityBehavior != null)
                  {
                     oPerso.setSubEntityBehaviour(1,CharacterWheel.petSubEntityBehavior);
                  }
                  if(oPerso.look.getBone() == 1)
                  {
                     oPerso.setAnimationAndDirection("AnimStatique",2);
                  }
                  else
                  {
                     oPerso.setAnimationAndDirection("AnimStatique",3);
                  }
                  oPerso.x = -5;
                  oPerso.y = -64;
                  oPerso.scaleX = 2.2;
                  oPerso.scaleY = 2.2;
                  oPerso.cacheAsBitmap = true;
                  this._aSprites[i] = oPerso;
                  ctr.scaleX = ctr.scaleY = Math.max(0.3,coef);
                  ctr.alpha = Math.max(0.3,coef);
                  ctr.useHandCursor = true;
                  ctr.buttonMode = true;
                  if(this._nNbCharacters == 2)
                  {
                     if(i == 1)
                     {
                        ctr.x = this._nWidthEllipsis * Math.cos(angle + Math.PI / 6 + Math.PI / 2) + this._nXCenterEllipsis;
                        ctr.y = this._nHeightEllipsis * Math.sin(angle + Math.PI / 6 + Math.PI / 2) + this._nYCenterEllipsis;
                     }
                  }
                  if(this._nNbCharacters == 4)
                  {
                     if(i == 2)
                     {
                        ctr.x = this._nWidthEllipsis * Math.cos(angle + Math.PI / 6 + Math.PI / 2) + this._nXCenterEllipsis;
                        ctr.y = this._nHeightEllipsis * Math.sin(angle + Math.PI / 6 + Math.PI / 2) + this._nYCenterEllipsis;
                     }
                  }
                  mountain = new Texture();
                  mountain.width = 488;
                  mountain.height = 635;
                  mountain.y = -62;
                  mountain.uri = new Uri(this._sMountainUri + "assets.swf|base_" + characterInfo.breed);
                  mountain.finalize();
                  ie = new InstanceEvent(ctr,this._uiClass.uiClass);
                  ie.push(EventEnums.EVENT_ONRELEASE_MSG);
                  ie.push(EventEnums.EVENT_ONDOUBLECLICK_MSG);
                  UIEventManager.getInstance().registerInstance(ie);
                  if(i == 0)
                  {
                     this._charaSelCtr.addChild(this._midZCtr);
                  }
                  ctr.addChild(mountain);
                  ctr.addChild(oPerso);
                  this._charaSelCtr.addChild(ctr);
                  this._ctrDepth.push(this._charaSelCtr.getChildIndex(ctr));
                  this._aMountainsCtr[i] = ctr;
               }
            }
            this._charaSelCtr.addChild(this._frontZCtr);
         }
      }
      
      private function endRotationMountains() : void
      {
         EnterFrameDispatcher.removeEventListener(this.onRotateMountains);
         this._bMovingMountains = false;
      }
      
      private function rotateMountains(sens:int) : void
      {
         var listener:IInterfaceListener = null;
         var listener2:IInterfaceListener = null;
         this._nSelectedChara = this._nSelectedChara - sens;
         if(this._nSelectedChara >= this._aCharactersList.length)
         {
            this._nSelectedChara = this._nSelectedChara - this._aCharactersList.length;
         }
         if(this._nSelectedChara < 0)
         {
            this._nSelectedChara = this._aCharactersList.length + this._nSelectedChara;
         }
         var t:Number = 2 * Math.PI / this._nNbCharacters;
         this._sens = sens;
         this._nRotationStep = t;
         if(isNaN(this._nRotationPieceTrg))
         {
            this._nRotationPieceTrg = this._nRotation + this._nRotationStep * this._sens;
         }
         else
         {
            this._nRotationPieceTrg = this._nRotationPieceTrg + this._nRotationStep * this._sens;
         }
         if(sens == 1)
         {
            for each(listener in Berilia.getInstance().UISoundListeners)
            {
               listener.playUISound("16079");
            }
         }
         else
         {
            for each(listener2 in Berilia.getInstance().UISoundListeners)
            {
               listener2.playUISound("16080");
            }
         }
         EnterFrameDispatcher.addEventListener(this.onRotateMountains,"mountainsRotation",StageShareManager.stage.frameRate);
      }
      
      private function isIterable(obj:*) : Boolean
      {
         if(obj is Array)
         {
            return true;
         }
         if(obj["length"] != null && obj["length"] != 0 && !isNaN(obj["length"]) && obj[0] != null && !(obj is String))
         {
            return true;
         }
         return false;
      }
      
      override public function process(msg:Message) : Boolean
      {
         return false;
      }
      
      public function eventOnRelease(target:DisplayObject) : void
      {
      }
      
      public function eventOnDoubleClick(target:DisplayObject) : void
      {
         if(this._bMovingMountains)
         {
         }
      }
      
      public function eventOnRollOver(target:DisplayObject) : void
      {
      }
      
      public function eventOnRollOut(target:DisplayObject) : void
      {
      }
      
      public function eventOnShortcut(s:String) : Boolean
      {
         return false;
      }
      
      private function onRotateMountains(e:Event) : void
      {
         var ctr:GraphicContainer = null;
         var angle:Number = NaN;
         var coef:Number = NaN;
         this._bMovingMountains = true;
         if(this._nRotationStep == 0)
         {
            this.endRotationMountains();
         }
         if(Math.abs(this._nRotationPieceTrg - this._nRotation) < 0.01)
         {
            this._nRotation = this._nRotationPieceTrg;
         }
         else
         {
            this._nRotation = this._nRotation + (this._nRotationPieceTrg - this._nRotation) / 3;
         }
         var zOrder:Array = new Array();
         var i:int = 0;
         for each(ctr in this._aMountainsCtr)
         {
            angle = (this._nRotation + this._nRotationStep * i) % (2 * Math.PI);
            coef = Math.abs(Math.PI - (angle < 0?angle + 2 * Math.PI:angle) % (2 * Math.PI)) / Math.PI;
            zOrder.push({
               "ctr":ctr,
               "z":coef
            });
            ctr.x = this._nWidthEllipsis * Math.cos(angle + Math.PI / 2) + this._nXCenterEllipsis;
            ctr.y = this._nHeightEllipsis * Math.sin(angle + Math.PI / 2) + this._nYCenterEllipsis;
            if(this._nNbCharacters == 2)
            {
               if(ctr.y < 300)
               {
                  ctr.x = this._nWidthEllipsis * Math.cos(angle + Math.PI / 6 + Math.PI / 2) + this._nXCenterEllipsis;
                  ctr.y = this._nHeightEllipsis * Math.sin(angle + Math.PI / 6 + Math.PI / 2) + this._nYCenterEllipsis;
               }
            }
            if(this._nNbCharacters == 4)
            {
               if(ctr.y < 300)
               {
                  ctr.x = this._nWidthEllipsis * Math.cos(angle + Math.PI / 6 + Math.PI / 2) + this._nXCenterEllipsis;
                  ctr.y = this._nHeightEllipsis * Math.sin(angle + Math.PI / 6 + Math.PI / 2) + this._nYCenterEllipsis;
               }
            }
            ctr.scaleX = ctr.scaleY = Math.max(0.3,coef);
            ctr.alpha = Math.max(0.3,coef);
            i++;
         }
         zOrder.sortOn("z",Array.NUMERIC);
         for(i = 0; i < zOrder.length; i++)
         {
            zOrder[i].ctr.parent.addChildAt(zOrder[i].ctr,this._ctrDepth[i]);
         }
         if(this._nRotationPieceTrg == this._nRotation)
         {
            this.endRotationMountains();
         }
      }
   }
}

import com.ankamagames.tiphon.display.TiphonSprite;
import com.ankamagames.jerakine.entities.interfaces.IEntity;
import com.ankamagames.jerakine.types.positions.MapPoint;
import com.ankamagames.tiphon.types.look.TiphonEntityLook;

class TiphonEntity extends TiphonSprite implements IEntity
{
    
   private var _id:uint;
   
   function TiphonEntity(id:uint, look:TiphonEntityLook)
   {
      super(look);
      this._id = id;
   }
   
   public function get id() : int
   {
      return this._id;
   }
   
   public function set id(nValue:int) : void
   {
      this._id = nValue;
   }
   
   public function get position() : MapPoint
   {
      return null;
   }
   
   public function set position(oValue:MapPoint) : void
   {
   }
}

class CBI
{
    
   public var id:int;
   
   public var gfxId:int;
   
   public var breed:int;
   
   public var colors:Array;
   
   function CBI(id:uint, gfxId:int, breed:int, colors:Array)
   {
      this.colors = new Array();
      super();
      this.id = id;
      this.gfxId = gfxId;
      this.breed = breed;
      this.colors = colors;
   }
}
