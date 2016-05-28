package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.UIComponent;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.tiphon.types.IAnimationModifier;
   import com.ankamagames.tiphon.types.ISubEntityBehavior;
   import flash.display.Shape;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import flash.display.DisplayObject;
   import com.ankamagames.jerakine.utils.display.EnterFrameDispatcher;
   import flash.events.EventDispatcher;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import com.ankamagames.tiphon.types.DisplayInfoSprite;
   import com.ankamagames.jerakine.utils.misc.BoxingUnBoxing;
   
   public class EntityDisplayer extends GraphicContainer implements UIComponent, IRectangle
   {
      
      public static var animationModifier:IAnimationModifier;
      
      public static var petSubEntityBehavior:ISubEntityBehavior;
       
      private var _entity;
      
      private var _oldEntity;
      
      private var _direction:uint = 1;
      
      private var _animation:String = "AnimStatique";
      
      private var _view:String;
      
      private var _scale:Number = 1;
      
      private var _mask:Shape;
      
      private var _mask2:Shape;
      
      private var _lookUpdate:Object;
      
      public var yOffset:uint = 0;
      
      public var xOffset:uint = 0;
      
      public var autoSize:Boolean = true;
      
      public var useFade:Boolean = true;
      
      public function EntityDisplayer()
      {
         super();
         mouseChildren = false;
      }
      
      public function get entity() : IDisplayable
      {
         return this._entity as IDisplayable;
      }
      
      public function set entity(oValue:IDisplayable) : void
      {
         this._entity = oValue;
         if(this._entity is TiphonSprite && EntityDisplayer.animationModifier != null)
         {
            (this._entity as TiphonSprite).animationModifier = EntityDisplayer.animationModifier;
         }
         if(EntityDisplayer.petSubEntityBehavior != null)
         {
            (this._entity as TiphonSprite).setSubEntityBehaviour(1,EntityDisplayer.petSubEntityBehavior);
         }
         var displayObject:DisplayObject = DisplayObject(this._entity);
         this.addChild(displayObject);
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function set look(look:*) : void
      {
         if(look != null)
         {
            look.resetSubEntities();
         }
         this._lookUpdate = look;
         EnterFrameDispatcher.addEventListener(this.needUpdate,"EntityDisplayerUpdater");
      }
      
      public function get look() : *
      {
         return this._lookUpdate;
      }
      
      public function set direction(n:uint) : void
      {
         this._direction = n;
         if(this._entity is TiphonSprite)
         {
            TiphonSprite(this._entity).setDirection(n);
         }
      }
      
      public function set animation(anim:String) : void
      {
         this._animation = anim;
         if(this._entity is TiphonSprite)
         {
            TiphonSprite(this._entity).setAnimation(anim);
         }
      }
      
      public function setAnimationAndDirection(anim:String, dir:uint) : void
      {
         this._animation = anim;
         this._direction = dir;
         if(this._entity is TiphonSprite)
         {
            TiphonSprite(this._entity).setAnimationAndDirection(anim,dir);
         }
      }
      
      override public function set scale(n:Number) : void
      {
         super.scale;
         this._scale = n;
      }
      
      override public function get scale() : Number
      {
         return this._scale;
      }
      
      public function get direction() : uint
      {
         return this._direction;
      }
      
      public function get animation() : String
      {
         return this._animation;
      }
      
      public function set view(value:String) : void
      {
         this._view = value;
         if(this._entity is TiphonSprite)
         {
            this._entity.setView(value);
         }
      }
      
      override public function remove() : void
      {
         super.remove();
         if(this._entity is IDisplayable)
         {
            (this._entity as EventDispatcher).removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onCharacterRendered);
            this._entity.remove();
            this._entity = null;
         }
         if(this._oldEntity is IDisplayable)
         {
            (this._oldEntity as EventDispatcher).removeEventListener(TiphonEvent.RENDER_SUCCEED,this.onCharacterRendered);
            this._oldEntity.remove();
            this._oldEntity = null;
         }
         EnterFrameDispatcher.removeEventListener(this.onFade);
      }
      
      public function resize(nW:int, nH:int) : void
      {
         var rect:IRectangle = this._entity.absoluteBounds;
         var rapportOld:int = rect.width / rect.height;
         var rapportNew:int = nW / nH;
         if(rapportOld > rapportNew)
         {
            width = nW;
            height = nH / rapportOld;
         }
         else if(rapportOld < rapportNew)
         {
            width = nH * rapportOld;
            height = nH;
         }
         else
         {
            width = nW;
            height = nH;
         }
      }
      
      public function setColor(index:uint, color:uint) : void
      {
         if(Boolean(TiphonSprite(this._entity)) && Boolean(TiphonSprite(this._entity).look))
         {
            TiphonSprite(this._entity).look.setColor(index,color);
         }
      }
      
      public function resetColor(index:uint) : void
      {
         if(Boolean(TiphonSprite(this._entity)) && Boolean(TiphonSprite(this._entity).look))
         {
            TiphonSprite(this._entity).look.resetColor(index);
         }
      }
      
      private function onCharacterRendered(event:Event) : void
      {
         EnterFrameDispatcher.addEventListener(this.onCharacterReady,"onCharacterReady");
      }
      
      private function onCharacterReady(e:Event) : void
      {
         var entRatio:Number = NaN;
         var b:Rectangle = null;
         var dis:DisplayInfoSprite = null;
         var r:Number = NaN;
         var m:Number = NaN;
         if(EntityDisplayer.animationModifier != null)
         {
            (this._entity as TiphonSprite).animationModifier = EntityDisplayer.animationModifier;
         }
         if(EntityDisplayer.petSubEntityBehavior != null)
         {
            (this._entity as TiphonSprite).setSubEntityBehaviour(1,EntityDisplayer.petSubEntityBehavior);
         }
         this._entity.cacheAsBitmap = true;
         EnterFrameDispatcher.removeEventListener(this.onCharacterReady);
         this._entity.visible = true;
         if(this._scale > 1 || this.yOffset != 0)
         {
            if(this._mask)
            {
               this._mask.graphics.clear();
            }
            else
            {
               this._mask = new Shape();
            }
            this._mask.graphics.beginFill(0);
            this._mask.graphics.drawRect(0,0,width,height);
            addChild(this._mask);
            TiphonSprite(this._entity).mask = this._mask;
            if(this._oldEntity)
            {
               if(this._mask2)
               {
                  this._mask2.graphics.clear();
               }
               else
               {
                  this._mask2 = new Shape();
               }
               this._mask2.graphics.beginFill(0);
               this._mask2.graphics.drawRect(0,0,width,height);
               addChild(this._mask2);
               TiphonSprite(this._oldEntity).mask = this._mask2;
            }
         }
         else
         {
            TiphonSprite(this._entity).mask = null;
            if(this._mask)
            {
               removeChild(this._mask);
            }
            this._mask = null;
         }
         if(this._oldEntity)
         {
            this._oldEntity.cacheAsBitmap = true;
            if(this.useFade)
            {
               this._oldEntity.alpha = 1;
               this._entity.alpha = 0;
               EnterFrameDispatcher.addEventListener(this.onFade,"entityDisplayerFade");
            }
            else
            {
               if(contains(this._oldEntity))
               {
                  removeChild(this._oldEntity);
               }
               this._oldEntity = null;
            }
         }
         if(!this._entity.height || !this.autoSize)
         {
            return;
         }
         if(this._view != null)
         {
            TiphonSprite(this._entity).look.setScales(1,1);
            dis = TiphonSprite(this._entity).getDisplayInfoSprite(this._view);
            if(dis != null)
            {
               TiphonSprite(this._entity).setView(this._view);
               entRatio = this._entity.width / this._entity.height;
               if(this._entity.width > this._entity.height)
               {
                  this._entity.height = width / entRatio * this._scale;
                  this._entity.width = width * this._scale;
               }
               else
               {
                  this._entity.width = height * entRatio * this._scale;
                  this._entity.height = height * this._scale;
               }
               b = TiphonSprite(this._entity).getBounds(this);
               this._entity.x = (width - this._entity.width) / 2 - b.left + this.xOffset;
               this._entity.y = (height - this._entity.height) / 2 - b.top + this.yOffset;
               r = dis.width / dis.height;
               m = width / height < dis.width / dis.height?Number(width / dis.getRect(this).width):Number(height / dis.getRect(this).height);
               this._entity.height = this._entity.height * m;
               this._entity.width = this._entity.width * m;
               this._entity.x = this._entity.x - dis.getRect(this).x;
               this._entity.y = this._entity.y - dis.getRect(this).y;
            }
         }
         else
         {
            entRatio = this._entity.width / this._entity.height;
            if(this._entity.width > this._entity.height)
            {
               this._entity.height = width / entRatio * this._scale;
               this._entity.width = width * this._scale;
            }
            else
            {
               this._entity.width = height * entRatio * this._scale;
               this._entity.height = height * this._scale;
            }
            b = TiphonSprite(this._entity).getBounds(this);
            this._entity.x = (width - this._entity.width) / 2 - b.left + this.xOffset;
            this._entity.y = (height - this._entity.height) / 2 - b.top + this.yOffset;
         }
         this._entity.visible = true;
      }
      
      private function needUpdate(E:Event) : void
      {
         EnterFrameDispatcher.removeEventListener(this.needUpdate);
         if(this._oldEntity)
         {
            if(contains(this._oldEntity))
            {
               removeChild(this._oldEntity as DisplayObject);
            }
            this._oldEntity = null;
         }
         if(!this._lookUpdate)
         {
            if(Boolean(this._entity) && Boolean(this._entity.parent))
            {
               this._entity.parent.removeChild(this._entity);
            }
            this._entity = null;
            return;
         }
         this._oldEntity = this._entity;
         this._entity = new TiphonSprite(BoxingUnBoxing.unbox(this._lookUpdate));
         if(EntityDisplayer.animationModifier != null)
         {
            (this._entity as TiphonSprite).animationModifier = EntityDisplayer.animationModifier;
         }
         if(EntityDisplayer.petSubEntityBehavior != null)
         {
            (this._entity as TiphonSprite).setSubEntityBehaviour(1,EntityDisplayer.petSubEntityBehavior);
         }
         (this._entity as EventDispatcher).addEventListener(TiphonEvent.RENDER_SUCCEED,this.onCharacterRendered);
         addChild(this._entity);
         this.setAnimationAndDirection(this._animation,this._direction);
         this._entity.visible = false;
      }
      
      private function onFade(e:Event) : void
      {
         if(this._entity)
         {
            this._entity.alpha = this._entity.alpha + (1 - this._entity.alpha) / 3;
            this._oldEntity.alpha = this._oldEntity.alpha + (0 - this._oldEntity.alpha) / 3;
            if(this._oldEntity.alpha < 0.05)
            {
               this._entity.alpha = 1;
               if(contains(this._oldEntity))
               {
                  removeChild(this._oldEntity);
               }
               this._oldEntity = null;
               EnterFrameDispatcher.removeEventListener(this.onFade);
            }
         }
         else
         {
            EnterFrameDispatcher.removeEventListener(this.onFade);
            _log.error("entity est null");
         }
      }
   }
}
