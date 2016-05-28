package com.ankamagames.dofus.types.entities
{
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import org.flintparticles.twoD.emitters.Emitter2D;
   import org.flintparticles.twoD.renderers.DisplayObjectRenderer;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.types.Swl;
   import org.flintparticles.common.counters.Blast;
   import org.flintparticles.common.initializers.ImageClass;
   import org.flintparticles.common.initializers.ScaleImageInit;
   import org.flintparticles.twoD.initializers.Velocity;
   import org.flintparticles.twoD.zones.DiscZone;
   import flash.geom.Point;
   import org.flintparticles.common.initializers.Lifetime;
   import org.flintparticles.common.actions.Age;
   import org.flintparticles.common.energyEasing.Quadratic;
   import org.flintparticles.twoD.actions.Move;
   import org.flintparticles.common.actions.Fade;
   import org.flintparticles.twoD.actions.RandomDrift;
   import org.flintparticles.common.actions.RandomColorChange;
   import org.flintparticles.twoD.actions.Accelerate;
   import org.flintparticles.twoD.actions.ZonedAction;
   import org.flintparticles.twoD.actions.QuadraticDrag;
   import org.flintparticles.common.events.EmitterEvent;
   import flash.events.Event;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import org.flintparticles.twoD.particles.Particle2D;
   import org.flintparticles.common.displayObjects.Dot;
   import org.flintparticles.twoD.initializers.Position;
   import org.flintparticles.twoD.zones.PointZone;
   import org.flintparticles.common.actions.ColorChange;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   
   public class ExplosionEntity extends TiphonSprite implements IEntity
   {
       
      private var _emiter:Emitter2D;
      
      private var _renderer:DisplayObjectRenderer;
      
      private var _exploseParticleCount:uint;
      
      private var _fxLoader:IResourceLoader;
      
      private var _startColors:Array;
      
      private var _explode:Boolean;
      
      private var _particleCount:uint;
      
      public function ExplosionEntity(fxUri:Uri, startColors:Array, particleCount:uint = 40, explode:Boolean = false)
      {
         this._emiter = new Emitter2D();
         this._renderer = new DisplayObjectRenderer();
         super(new TiphonEntityLook());
         if(!fxUri)
         {
            return;
         }
         this._startColors = startColors;
         this._explode = explode;
         this._particleCount = particleCount;
         this._fxLoader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SINGLE_LOADER);
         this._fxLoader.addEventListener(ResourceLoadedEvent.LOADED,this.onResourceReady);
         this._fxLoader.load(fxUri);
      }
      
      private function onResourceReady(e:ResourceLoadedEvent) : void
      {
         var def:Array = Swl(e.resource).getDefinitions();
         this.init(Swl(e.resource).getDefinition(def[Math.floor(def.length * Math.random())]) as Class);
      }
      
      private function init(fxClass:Class) : void
      {
         this._emiter.counter = new Blast(this._particleCount);
         this._emiter.addInitializer(new ImageClass(fxClass));
         this._emiter.addInitializer(new ScaleImageInit(0.5,0.9));
         this._emiter.addInitializer(new Velocity(new DiscZone(new Point(0,0),600,0)));
         this._emiter.addInitializer(new Lifetime(3));
         this._emiter.addAction(new Age(Quadratic.easeInOut));
         this._emiter.addAction(new Move());
         this._emiter.addAction(new Fade());
         this._emiter.addAction(new RandomDrift(100,100));
         if(this._startColors)
         {
            this._emiter.addAction(new RandomColorChange(this._startColors,16777215));
         }
         this._emiter.addAction(new Accelerate(0,100));
         this._emiter.addAction(new ZonedAction(new QuadraticDrag(0.02),new DiscZone(new Point(400,400),40,0),true));
         this._renderer.addEmitter(this._emiter);
         if(this._explode)
         {
            this._exploseParticleCount = this._particleCount / 2;
            this._emiter.addEventListener(EmitterEvent.EMITTER_UPDATED,this.onFrame);
         }
         addChild(this._renderer);
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
      }
      
      public function get id() : int
      {
         return 0;
      }
      
      public function set id(nValue:int) : void
      {
      }
      
      public function get position() : MapPoint
      {
         return null;
      }
      
      public function set position(oValue:MapPoint) : void
      {
      }
      
      private function onAdded(e:Event) : void
      {
         if(!this._emiter.running)
         {
            this._emiter.start();
         }
      }
      
      public function onFrame(e:EmitterEvent) : void
      {
         var particle:Particle2D = null;
         var emitter:Emitter2D = null;
         var sourceEmitter:Emitter2D = Emitter2D(e.target);
         for each(particle in sourceEmitter.particles)
         {
            if(!(Boolean(particle.isDead) || !this._exploseParticleCount))
            {
               if(particle.age / particle.lifetime > 0.1 && particle.age / particle.lifetime < 0.5 && Math.random() > 0.99)
               {
                  particle.isDead = true;
                  emitter = new Emitter2D();
                  emitter.counter = new Blast(10);
                  emitter.addInitializer(new ImageClass(Dot,1.5));
                  emitter.addInitializer(new Velocity(new DiscZone(new Point(0,0),50,0)));
                  emitter.addInitializer(new Lifetime(1));
                  emitter.addInitializer(new Position(new PointZone(new Point(particle.x,particle.y))));
                  emitter.addAction(new Age(Quadratic.easeInOut));
                  emitter.addAction(new Move());
                  emitter.addAction(new Accelerate(0,200));
                  emitter.addAction(new Fade(1,0));
                  emitter.addAction(new ColorChange(16777215,0));
                  emitter.addAction(new RandomDrift(100,100));
                  emitter.start();
                  this._renderer.addEmitter(emitter);
                  this._exploseParticleCount--;
                  return;
               }
            }
         }
      }
   }
}
