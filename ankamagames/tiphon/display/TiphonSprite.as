package com.ankamagames.tiphon.display
{
   import flash.display.Sprite;
   import com.ankamagames.jerakine.entities.interfaces.IAnimated;
   import com.ankamagames.tiphon.types.IAnimationSpriteHandler;
   import com.ankamagames.jerakine.interfaces.IDestroyable;
   import com.ankamagames.tiphon.types.look.EntityLookObserver;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.display.MovieClip;
   import com.ankamagames.tiphon.types.Skin;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.tiphon.engine.TiphonEventsManager;
   import com.ankamagames.tiphon.types.IAnimationModifier;
   import com.ankamagames.tiphon.types.IDirectionModifier;
   import com.ankamagames.tiphon.error.TiphonError;
   import flash.events.Event;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.geom.Matrix;
   import com.ankamagames.tiphon.types.EventListener;
   import com.ankamagames.jerakine.utils.benchmark.FPS;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.tiphon.types.BehaviorData;
   import com.ankamagames.tiphon.types.ISubEntityBehavior;
   import com.ankamagames.tiphon.engine.BoneIndexManager;
   import com.ankamagames.tiphon.types.DisplayInfoSprite;
   import com.ankamagames.tiphon.types.TiphonUtility;
   import com.ankamagames.tiphon.engine.Tiphon;
   import com.ankamagames.jerakine.types.Swl;
   import flash.geom.ColorTransform;
   import com.ankamagames.jerakine.types.DefaultableColor;
   import com.ankamagames.tiphon.types.EquipmentSprite;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import com.ankamagames.tiphon.types.ColoredSprite;
   import com.ankamagames.tiphon.TiphonConstants;
   import com.ankamagames.jerakine.types.Callback;
   import com.ankamagames.tiphon.types.ScriptedAnimation;
   import com.ankamagames.jerakine.utils.display.MovieClipUtils;
   import com.ankamagames.jerakine.utils.display.FpsControler;
   import com.ankamagames.tiphon.events.AnimationEvent;
   
   public class TiphonSprite extends Sprite implements IAnimated, IAnimationSpriteHandler, IDestroyable, EntityLookObserver
   {
      
      private static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.tiphon.display.TiphonSprite));
      
      private static var _listeners:Dictionary;
       
      public var _currentAnimation:String;
      
      private var _lastAnimation:String;
      
      private var _targetAnimation:String;
      
      private var _currentDirection:int;
      
      private var _animMovieClip:MovieClip;
      
      private var _customColoredParts:Array;
      
      private var _displayInfoParts:Dictionary;
      
      private var _customView:String;
      
      private var _aTransformColors:Array;
      
      private var _skin:Skin;
      
      private var _aSubEntities:Array;
      
      private var _subEntitiesList:Array;
      
      private var _look:TiphonEntityLook;
      
      private var _lookCode:String;
      
      private var _rasterize:Boolean = false;
      
      private var _parentSprite:com.ankamagames.tiphon.display.TiphonSprite;
      
      private var _rendered:Boolean = false;
      
      private var _libReady:Boolean = false;
      
      private var _subEntityBehaviors:Array;
      
      private var _fliped:Boolean = false;
      
      private var _backgroundTemp:Array;
      
      private var _subEntitiesTemp:Array;
      
      private var _background:Array;
      
      private var _backgroundOnly:Boolean = false;
      
      private var _tiphonEventManager:TiphonEventsManager;
      
      private var _refuseCustomAnim:Boolean = false;
      
      public var animationModifier:IAnimationModifier;
      
      public var directionModifier:IDirectionModifier;
      
      public function TiphonSprite(look:TiphonEntityLook)
      {
         var cat:* = null;
         var num:int = 0;
         var i:int = 0;
         var skin:uint = 0;
         var subIndex:uint = 0;
         var subEntity:com.ankamagames.tiphon.display.TiphonSprite = null;
         this._backgroundTemp = new Array();
         this._subEntitiesTemp = new Array();
         super();
         this._libReady = false;
         this._background = new Array();
         this.initializeLibrary(look.getBone());
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemove,false,0,true);
         this._subEntityBehaviors = new Array();
         this._currentAnimation = null;
         this._currentDirection = -1;
         this._customColoredParts = new Array();
         this._displayInfoParts = new Dictionary();
         this._aTransformColors = new Array();
         this._aSubEntities = new Array();
         this._subEntitiesList = new Array();
         this._look = look;
         this._lookCode = this._look.toString();
         this._skin = new Skin();
         this._skin.addEventListener(Event.COMPLETE,this.checkRessourceState,false,0,true);
         var skinList:Vector.<uint> = this._look.getSkins(true);
         if(skinList)
         {
            num = skinList.length;
            for(i = 0; i < num; i++)
            {
               skin = skinList[i];
               this._skin.add(skin);
               Tiphon.skinLibrary.watchRessource(this,skin);
            }
         }
         var subEntitiesLook:Array = this._look.getSubEntities(true);
         for(cat in subEntitiesLook)
         {
            for(subIndex = 0; subIndex < subEntitiesLook[uint(cat)].length; subIndex++)
            {
               subEntity = new com.ankamagames.tiphon.display.TiphonSprite(this._look.getSubEntity(uint(cat),subIndex));
               subEntity.addEventListener(TiphonEvent.RENDER_SUCCEED,this.onSubEntityRendered,false,0,true);
               this.addSubEntity(subEntity,uint(cat),subIndex);
            }
         }
         this._look.addObserver(this);
         this.mouseChildren = false;
         this._tiphonEventManager = new TiphonEventsManager(this);
      }
      
      public function get tiphonEventManager() : TiphonEventsManager
      {
         if(this._tiphonEventManager == null)
         {
            throw new TiphonError("_tiphonEventManager is null, can\'t access so");
         }
         return this._tiphonEventManager;
      }
      
      override public function set visible(v:Boolean) : void
      {
         super.visible = v;
      }
      
      override public function set alpha(a:Number) : void
      {
         super.alpha = a;
      }
      
      private function onRemove(e:Event) : void
      {
      }
      
      public function get bitmapData() : BitmapData
      {
         var bounds:Rectangle = getBounds(this);
         if(bounds.height * bounds.width == 0)
         {
            return null;
         }
         var bitmapdata:BitmapData = new BitmapData(bounds.right - bounds.left,bounds.bottom - bounds.top,true,22015);
         var m:Matrix = new Matrix();
         m.translate(-bounds.left,-bounds.top);
         bitmapdata.draw(this,m);
         return bitmapdata;
      }
      
      public function get look() : TiphonEntityLook
      {
         return this._look;
      }
      
      public function get rasterize() : Boolean
      {
         return this._rasterize;
      }
      
      public function set rasterize(b:Boolean) : void
      {
         this._rasterize = b;
      }
      
      public function get rawAnimation() : MovieClip
      {
         return this._animMovieClip;
      }
      
      public function get libraryIsAvaible() : Boolean
      {
         return this._libReady;
      }
      
      public function get fliped() : Boolean
      {
         return this._fliped;
      }
      
      public function get parentSprite() : com.ankamagames.tiphon.display.TiphonSprite
      {
         return this._parentSprite;
      }
      
      public function get maxFrame() : uint
      {
         if(this._animMovieClip)
         {
            return this._animMovieClip.totalFrames;
         }
         return 0;
      }
      
      public function stopAnimation() : void
      {
         this._animMovieClip.stop();
      }
      
      public function setDirection(newDirection:uint) : void
      {
         this.setAnimationAndDirection(this._currentAnimation,newDirection);
      }
      
      public function getDirection() : uint
      {
         return this._currentDirection > 0?uint(this._currentDirection):uint(0);
      }
      
      public function setAnimation(newAnimation:String) : void
      {
         this.setAnimationAndDirection(newAnimation,this._currentDirection);
      }
      
      public function getAnimation() : String
      {
         return this._currentAnimation;
      }
      
      public function setAnimationAndDirection(animation:String, direction:uint) : void
      {
         var catId:* = null;
         var eListener:EventListener = null;
         var cat:Array = null;
         var subEntity:com.ankamagames.tiphon.display.TiphonSprite = null;
         var transitionalAnim:String = null;
         FPS.getInstance().Nouvelle_Valeur(2,true);
         if(this is IEntity)
         {
            if((this._currentAnimation == "AnimMarche" || this._currentAnimation == "AnimCourse") && animation == "AnimStatique")
            {
               for each(eListener in TiphonEventsManager.listeners)
               {
                  eListener.listener.removeEntitySound(this as IEntity);
               }
            }
         }
         if(Boolean(this.animationModifier) && !this._refuseCustomAnim)
         {
            animation = this.animationModifier.getModifiedAnimation(animation,this.look);
         }
         this._refuseCustomAnim = false;
         if((animation == this._currentAnimation || animation == this._targetAnimation) && direction == this._currentDirection)
         {
            this.dispatchEvent(new TiphonEvent(TiphonEvent.RENDER_SUCCEED,this));
            return;
         }
         var behaviorData:BehaviorData = new BehaviorData(animation,direction,this);
         for(catId in this._aSubEntities)
         {
            cat = this._aSubEntities[catId];
            if(cat)
            {
               for each(subEntity in cat)
               {
                  if(this._subEntityBehaviors[catId])
                  {
                     (this._subEntityBehaviors[catId] as ISubEntityBehavior).updateFromParentEntity(subEntity,behaviorData);
                  }
                  else
                  {
                     this.updateFromParentEntity(subEntity,behaviorData);
                  }
               }
            }
         }
         this._lastAnimation = this._currentAnimation;
         this._currentDirection = behaviorData.direction;
         if(BoneIndexManager.getInstance().hasTransition(this._look.getBone(),this._lastAnimation,behaviorData.animation,this._currentDirection))
         {
            transitionalAnim = BoneIndexManager.getInstance().getTransition(this._look.getBone(),this._lastAnimation,behaviorData.animation,this._currentDirection);
            this._currentAnimation = transitionalAnim;
            this._targetAnimation = behaviorData.animation;
         }
         else
         {
            this._currentAnimation = behaviorData.animation;
         }
         if(BoneIndexManager.getInstance().hasCustomBone(this._look.getBone()))
         {
            this.initializeLibrary(this._look.getBone(),BoneIndexManager.getInstance().getBoneFile(this._look.getBone(),this._currentAnimation));
         }
         this._rendered = false;
         this.finalize();
         FPS.getInstance().Nouvelle_Valeur(2);
      }
      
      public function setView(view:String) : void
      {
         this._customView = view;
         var infoSprite:DisplayInfoSprite = this.getDisplayInfoSprite(view);
         if(infoSprite)
         {
            if(this.mask != null)
            {
               this.mask.parent.removeChild(this.mask);
            }
            addChild(infoSprite);
            this.mask = infoSprite;
         }
      }
      
      public function setSubEntityBehaviour(category:int, behaviour:ISubEntityBehavior) : void
      {
         this._subEntityBehaviors[category] = behaviour;
      }
      
      public function updateFromParentEntity(subEntity:com.ankamagames.tiphon.display.TiphonSprite, parentData:BehaviorData) : void
      {
         var parentIsFlipped:* = false;
         var animExist:Boolean = false;
         var ad:Array = subEntity.getAvaibleDirection(parentData.animation);
         for(var i:uint = 0; i < 8; i++)
         {
            animExist = Boolean(ad[i]) || Boolean(animExist);
         }
         if(Boolean(animExist) || !this._libReady)
         {
            parentIsFlipped = !parentData.parent.getAvaibleDirection(parentData.animation)[parentData.direction];
            subEntity.setAnimationAndDirection(parentData.animation,!!parentIsFlipped?uint(TiphonUtility.getFlipDirection(parentData.direction)):uint(parentData.direction));
         }
      }
      
      public function destroy() : void
      {
         this._look.removeObserver(this);
         this.clearAnimation();
      }
      
      public function getAvaibleDirection(anim:String = null) : Array
      {
         var lib:Swl = Tiphon.skullLibrary.getResourceById(this._look.getBone());
         var res:Array = new Array();
         if(!lib)
         {
            return [];
         }
         for(var i:uint = 0; i < 8; i++)
         {
            res[i] = lib.getDefinitions().indexOf((!!anim?anim:this._currentAnimation) + "_" + i) != -1;
         }
         return res;
      }
      
      public function getColorTransform(index:uint) : ColorTransform
      {
         var ct:ColorTransform = null;
         if(this._aTransformColors[index])
         {
            return this._aTransformColors[index];
         }
         var c:DefaultableColor = this._look.getColor(index);
         if(!c.isDefault)
         {
            ct = new ColorTransform();
            ct.color = c.color;
            this._aTransformColors[index] = ct;
            return ct;
         }
         return null;
      }
      
      public function getSkinSprite(sprite:EquipmentSprite) : Sprite
      {
         var className:String = getQualifiedClassName(sprite);
         return this._skin.getPart(className);
      }
      
      public function addSubEntity(entity:DisplayObject, category:uint, slot:uint) : void
      {
         if(category == 2)
         {
            this.setAnimationAndDirection("AnimStatique",this._currentDirection);
         }
         if(entity is com.ankamagames.tiphon.display.TiphonSprite)
         {
            TiphonSprite(entity)._parentSprite = this;
            TiphonSprite(entity).setDirection(!this._fliped?uint(this._currentDirection):uint(TiphonUtility.getFlipDirection(this._currentDirection)));
         }
         if(this._rendered)
         {
            if(!this._aSubEntities[category])
            {
               this._aSubEntities[category] = new Array();
            }
            this._aSubEntities[category][slot] = entity;
            this._subEntitiesList.push(entity);
            this.finalize();
         }
         else
         {
            this._subEntitiesTemp.push([entity,category,slot]);
            if(category == 2)
            {
               this.setAnimationAndDirection("AnimStatique",this._currentDirection);
            }
         }
      }
      
      public function removeSubEntity(entity:DisplayObject) : void
      {
         var found:Boolean = false;
         var i:* = null;
         var index:int = 0;
         var j:* = null;
         for(i in this._aSubEntities)
         {
            for(j in this._aSubEntities[i])
            {
               if(entity === this._aSubEntities[i][j])
               {
                  delete this._aSubEntities[i][j];
                  found = true;
                  break;
               }
            }
            if(found)
            {
               break;
            }
         }
         index = this._subEntitiesList.indexOf(entity);
         if(index != -1)
         {
            this._subEntitiesList.splice(index,1);
         }
         if(entity is com.ankamagames.tiphon.display.TiphonSprite)
         {
            TiphonSprite(entity)._parentSprite = null;
         }
      }
      
      public function getSubEntitySlot(category:uint, slot:uint) : DisplayObjectContainer
      {
         if(Boolean(this._aSubEntities[category]) && Boolean(this._aSubEntities[category][slot]))
         {
            (this._aSubEntities[category][slot] as com.ankamagames.tiphon.display.TiphonSprite)._parentSprite = this;
            return this._aSubEntities[category][slot];
         }
         return null;
      }
      
      public function getSubEntitiesList() : Array
      {
         return this._subEntitiesList;
      }
      
      public function registerColoredSprite(sprite:ColoredSprite, nColorIndex:uint) : void
      {
         if(!this._customColoredParts[nColorIndex])
         {
            this._customColoredParts[nColorIndex] = new Array();
         }
         this._customColoredParts[nColorIndex].push(sprite);
      }
      
      public function registerInfoSprite(sprite:DisplayInfoSprite, nViewIndex:String) : void
      {
         this._displayInfoParts[nViewIndex] = sprite;
         if(nViewIndex == this._customView)
         {
            this.setView(nViewIndex);
         }
      }
      
      public function getDisplayInfoSprite(nViewIndex:String) : DisplayInfoSprite
      {
         return this._displayInfoParts[nViewIndex];
      }
      
      public function addBackground(name:String, sprite:DisplayObject, posAuto:Boolean = false) : void
      {
         var pos:Rectangle = null;
         if(!this._background[name])
         {
            this._background[name] = sprite;
            if(this._rendered)
            {
               if(name == "teamCircle")
               {
                  trace("addBackground (teamCircle)");
                  trace("On peut afficher le sprite car _render = true");
               }
               if(posAuto)
               {
                  pos = this.getRect(this);
                  sprite.y = pos.y - 10;
               }
               addChildAt(sprite,0);
            }
            else
            {
               if(name == "teamCircle")
               {
                  trace("addBackground (teamCircle)");
                  trace("On NE PEUT PAS afficher le sprite car _render = false");
               }
               this._backgroundTemp.push(sprite,posAuto);
            }
         }
      }
      
      public function removeBackground(name:String) : void
      {
         if(name == "teamCircle")
         {
            trace("removeBackground (teamCircle)");
         }
         if(Boolean(this._rendered) && Boolean(this._background[name]))
         {
            removeChild(this._background[name]);
         }
         this._background[name] = null;
      }
      
      public function showOnlyBackground(pOnlyBackground:Boolean) : void
      {
         this._backgroundOnly = pOnlyBackground;
         if(Boolean(pOnlyBackground) && Boolean(contains(this._animMovieClip)))
         {
            removeChild(this._animMovieClip);
         }
         else if(!pOnlyBackground)
         {
            addChild(this._animMovieClip);
         }
      }
      
      private function initializeLibrary(gfxId:uint, file:String = null) : void
      {
         if(!file)
         {
            if(BoneIndexManager.getInstance().hasCustomBone(gfxId))
            {
               return;
            }
            file = TiphonConstants.SWF_SKULL_PATH + gfxId + ".swl";
         }
         Tiphon.skullLibrary.addResource(gfxId,file);
         Tiphon.skullLibrary.askResource(gfxId,this._currentAnimation,new Callback(this.onSkullLibraryReady),new Callback(this.onSkullLibraryError));
      }
      
      private function applyColor(index:uint) : void
      {
         var cs:ColoredSprite = null;
         if(this._customColoredParts[index])
         {
            for each(cs in this._customColoredParts[index])
            {
               cs.colorize(this.getColorTransform(index));
            }
         }
      }
      
      private function resetSkins() : void
      {
         var skin:uint = 0;
         this._skin.validate = false;
         this._skin.reset();
         for each(skin in this._look.getSkins(true))
         {
            this._skin.add(skin);
            Tiphon.skinLibrary.watchRessource(this,skin);
         }
         this._skin.validate = true;
      }
      
      private function resetSubEntities() : void
      {
         var subEntitiesCategory:* = null;
         var subEntityIndex:* = null;
         var subEntityLook:TiphonEntityLook = null;
         var subEntity:com.ankamagames.tiphon.display.TiphonSprite = null;
         this._subEntitiesList = [];
         this._aSubEntities = [];
         var subEntities:Array = this._look.getSubEntities(true);
         for(subEntitiesCategory in subEntities)
         {
            for(subEntityIndex in subEntities[subEntitiesCategory])
            {
               subEntityLook = subEntities[subEntitiesCategory][subEntityIndex];
               subEntity = new com.ankamagames.tiphon.display.TiphonSprite(subEntityLook);
               subEntity.setAnimationAndDirection("AnimStatique",this._currentDirection);
               this.addSubEntity(subEntity,parseInt(subEntitiesCategory),parseInt(subEntityIndex));
            }
         }
      }
      
      private function finalize() : void
      {
         Tiphon.skullLibrary.askResource(this._look.getBone(),this._currentAnimation,new Callback(this.checkRessourceState),new Callback(this.onRenderFail));
      }
      
      private function checkRessourceState(e:Event = null) : void
      {
         if(Boolean(this._skin.complete) && Boolean(Tiphon.skullLibrary.isLoaded(this._look.getBone(),this._currentAnimation)) && this._currentAnimation != null && this._currentDirection >= 0)
         {
            this.render();
         }
      }
      
      private function render() : void
      {
         var bgElement:DisplayObject = null;
         var log:String = null;
         var rasterizedSyncAnimation:RasterizedSyncAnimation = null;
         var sprite:Sprite = null;
         var pos:Rectangle = null;
         var subEntityInfo:Object = null;
         var subEntity:com.ankamagames.tiphon.display.TiphonSprite = null;
         FPS.getInstance().Nouvelle_Valeur(2,true);
         var animClass:Class = null;
         var lib:Swl = Tiphon.skullLibrary.getResourceById(this._look.getBone(),this._currentAnimation);
         var finalDirection:uint = this._currentDirection;
         if(this.directionModifier)
         {
            finalDirection = this.directionModifier.getModifiedDirection(finalDirection,this);
         }
         if(lib.hasDefinition(this._currentAnimation + "_" + finalDirection))
         {
            animClass = lib.getDefinition(this._currentAnimation + "_" + finalDirection) as Class;
            this._fliped = false;
         }
         else if(lib.hasDefinition(this._currentAnimation + "_" + TiphonUtility.getFlipDirection(finalDirection)))
         {
            animClass = lib.getDefinition(this._currentAnimation + "_" + TiphonUtility.getFlipDirection(finalDirection)) as Class;
            this._fliped = true;
         }
         if(animClass == null)
         {
            log = "Class [" + this._currentAnimation + "_" + finalDirection + "] or [" + this._currentAnimation + "_" + TiphonUtility.getFlipDirection(finalDirection) + "] cannot be found in library " + this._look.getBone();
            if(this._currentAnimation.indexOf("AnimStatique") != -1)
            {
               this._refuseCustomAnim = true;
               this.setAnimationAndDirection("AnimStatique",this._currentDirection);
            }
            else
            {
               this.dispatchEvent(new TiphonEvent(TiphonEvent.RENDER_FAILED,this,log));
            }
            _log.error(log);
            return;
         }
         this.clearAnimation();
         for each(bgElement in this._background)
         {
            if(bgElement)
            {
               addChild(bgElement);
            }
         }
         this._customColoredParts = new Array();
         this._displayInfoParts = new Dictionary();
         ScriptedAnimation.currentSpriteHandler = this;
         this._animMovieClip = new animClass() as ScriptedAnimation;
         Tiphon.skullLibrary.watchRessource(this,this._look.getBone());
         this._animMovieClip.addEventListener(Event.ADDED_TO_STAGE,this.onAdded,false,0,true);
         if(!this._animMovieClip)
         {
            _log.error("Class [" + this._currentAnimation + "_" + finalDirection + "] is not a ScriptedAnimation");
            return;
         }
         if(this._fliped)
         {
            this._animMovieClip.scaleX = this._animMovieClip.scaleX * -1;
         }
         var isSingleFrame:Boolean = MovieClipUtils.isSingleFrame(this._animMovieClip);
         this._animMovieClip.cacheAsBitmap = isSingleFrame;
         if(!this._backgroundOnly)
         {
            this.addChild(this._animMovieClip);
         }
         if(Boolean(isSingleFrame) || !this._rasterize && !Tiphon.getInstance().isRasterizeAnimation(this._currentAnimation))
         {
            FpsControler.controlFps(this._animMovieClip,lib.frameRate);
            this._animMovieClip.addEventListener(AnimationEvent.EVENT,this.animEventHandler,false,0,true);
            this._animMovieClip.addEventListener(AnimationEvent.ANIM,this.animSwitchHandler,false,0,true);
         }
         else
         {
            this._animMovieClip.visible = false;
            rasterizedSyncAnimation = new RasterizedSyncAnimation(this._animMovieClip,this._lookCode);
            FpsControler.controlFps(rasterizedSyncAnimation,lib.frameRate);
            rasterizedSyncAnimation.addEventListener(AnimationEvent.EVENT,this.animEventHandler,false,0,true);
            rasterizedSyncAnimation.addEventListener(AnimationEvent.ANIM,this.animSwitchHandler,false,0,true);
            if(!this._backgroundOnly)
            {
               this.addChild(rasterizedSyncAnimation);
            }
            this._animMovieClip = rasterizedSyncAnimation;
         }
         this._rendered = true;
         if(this._subEntitiesList.length)
         {
            this.dispatchEvent(new TiphonEvent(TiphonEvent.RENDER_FATHER_SUCCEED,this));
         }
         var nbb:int = this._backgroundTemp.length;
         for(var m:int = 0; m < nbb; m = m + 2)
         {
            sprite = this._backgroundTemp.shift();
            if(this._backgroundTemp.shift())
            {
               pos = this.getRect(this);
               sprite.y = pos.y - 10;
            }
            addChildAt(sprite,0);
         }
         FPS.getInstance().Nouvelle_Valeur(2);
         if(this._subEntitiesTemp.length)
         {
            while(this._subEntitiesTemp.length)
            {
               subEntityInfo = this._subEntitiesTemp.shift();
               subEntity = subEntityInfo[0] as com.ankamagames.tiphon.display.TiphonSprite;
               subEntity.setAnimationAndDirection("AnimStatique",this._currentDirection);
               this.addSubEntity(subEntity,subEntityInfo[1],subEntityInfo[2]);
            }
         }
         this.checkRenderState();
      }
      
      protected function clearAnimation() : void
      {
         if(this._animMovieClip)
         {
            this._animMovieClip.removeEventListener(AnimationEvent.EVENT,this.animEventHandler);
            this._animMovieClip.removeEventListener(AnimationEvent.ANIM,this.animSwitchHandler);
            this._animMovieClip.removeEventListener(Event.ADDED_TO_STAGE,this.onAdded);
            FpsControler.uncontrolFps(this._animMovieClip);
            this._animMovieClip = null;
         }
         while(numChildren)
         {
            this.removeChildAt(0);
         }
      }
      
      private function animEventHandler(event:AnimationEvent) : void
      {
         this.dispatchEvent(new TiphonEvent(event.id,this));
         this.dispatchEvent(new TiphonEvent(TiphonEvent.ANIMATION_EVENT,this));
      }
      
      private function animSwitchHandler(event:AnimationEvent) : void
      {
         this.setAnimation(event.id);
      }
      
      override public function dispatchEvent(event:Event) : Boolean
      {
         var anim:String = null;
         if(event.type == TiphonEvent.ANIMATION_END && Boolean(this._targetAnimation))
         {
            anim = this._targetAnimation;
            this._targetAnimation = null;
            this.setAnimation(anim);
            return false;
         }
         return super.dispatchEvent(event);
      }
      
      private function checkRenderState() : void
      {
         var subEntity:com.ankamagames.tiphon.display.TiphonSprite = null;
         for each(subEntity in this._subEntitiesList)
         {
            if(!subEntity._rendered)
            {
               return;
            }
         }
         this.dispatchEvent(new TiphonEvent(TiphonEvent.RENDER_SUCCEED,this));
      }
      
      private function updateScale() : void
      {
         var bg:DisplayObject = null;
         var parentSprite:com.ankamagames.tiphon.display.TiphonSprite = null;
         if(!this._animMovieClip)
         {
            return;
         }
         var p:DisplayObject = this.parent;
         while(Boolean(p) && !(p is com.ankamagames.tiphon.display.TiphonSprite))
         {
            p = p.parent;
         }
         if(p is com.ankamagames.tiphon.display.TiphonSprite && (TiphonSprite(p).look.getScaleX() != 1 || TiphonSprite(p).look.getScaleY() != 1))
         {
            parentSprite = p as com.ankamagames.tiphon.display.TiphonSprite;
            this._animMovieClip.scaleX = this.look.getScaleX() / parentSprite.look.getScaleX() * (this._animMovieClip.scaleX < 0?-1:1);
            this._animMovieClip.scaleY = this.look.getScaleY() / parentSprite.look.getScaleY();
         }
         else
         {
            this._animMovieClip.scaleX = this.look.getScaleX() * (this._animMovieClip.scaleX < 0?-1:1);
            this._animMovieClip.scaleY = this.look.getScaleY();
         }
         for each(bg in this._background)
         {
            if(bg)
            {
               if(p is com.ankamagames.tiphon.display.TiphonSprite)
               {
                  bg.scaleX = 1 / parentSprite.look.getScaleX();
                  bg.scaleY = 1 / parentSprite.look.getScaleY();
               }
               else
               {
                  bg.scaleX = bg.scaleY = 1;
               }
            }
         }
      }
      
      public function onAnimationEvent(eventName:String) : void
      {
         this.dispatchEvent(new TiphonEvent(eventName,this));
         this.dispatchEvent(new TiphonEvent(TiphonEvent.ANIMATION_EVENT,this));
      }
      
      private function onRenderFail() : void
      {
         this.dispatchEvent(new TiphonEvent(TiphonEvent.RENDER_FAILED,this));
      }
      
      private function onSubEntityRendered(e:Event) : void
      {
         this.checkRenderState();
      }
      
      private function onSkullLibraryReady() : void
      {
         this._libReady = true;
         this.dispatchEvent(new TiphonEvent(TiphonEvent.SPRITE_INIT,this));
      }
      
      private function onSkullLibraryError() : void
      {
         this.dispatchEvent(new TiphonEvent(TiphonEvent.SPRITE_INIT_FAILED,this));
      }
      
      private function onAdded(e:Event) : void
      {
         this.updateScale();
      }
      
      public function boneChanged(look:TiphonEntityLook) : void
      {
         this._look = look;
         this._lookCode = this._look.toString();
         this._tiphonEventManager = new TiphonEventsManager(this);
         this._rendered = false;
         this.initializeLibrary(look.getBone(),BoneIndexManager.getInstance().getBoneFile(this._look.getBone(),this._currentAnimation));
      }
      
      public function skinsChanged(look:TiphonEntityLook) : void
      {
         this._look = look;
         this._lookCode = this._look.toString();
         this._rendered = false;
         this.resetSkins();
         this.finalize();
      }
      
      public function colorsChanged(look:TiphonEntityLook) : void
      {
         var colorIndex:* = null;
         this._look = look;
         this._lookCode = this._look.toString();
         this._aTransformColors = new Array();
         if(this._rasterize)
         {
            this.finalize();
         }
         else
         {
            for(colorIndex in this._customColoredParts)
            {
               this.applyColor(uint(colorIndex));
            }
         }
      }
      
      public function scalesChanged(look:TiphonEntityLook) : void
      {
         this._look = look;
         this._lookCode = this._look.toString();
         if(this._rasterize)
         {
            this.finalize();
         }
         else if(this._animMovieClip != null)
         {
            this.updateScale();
         }
      }
      
      public function subEntitiesChanged(look:TiphonEntityLook) : void
      {
         this._look = look;
         this._lookCode = this._look.toString();
         this.resetSubEntities();
         this.finalize();
      }
   }
}
