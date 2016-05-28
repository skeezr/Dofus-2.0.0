package com.ankamagames.dofus.types.entities
{
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.entities.interfaces.IAnimated;
   import com.ankamagames.jerakine.entities.interfaces.IInteractive;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import com.ankamagames.jerakine.interfaces.IObstacle;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.jerakine.entities.behaviours.IMovementBehavior;
   import com.ankamagames.jerakine.entities.behaviours.IDisplayBehavior;
   import com.ankamagames.jerakine.messages.MessageHandler;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.jerakine.types.enums.InteractionsEnum;
   import com.ankamagames.jerakine.types.positions.MovementPath;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.atouin.entities.behaviours.movements.SlideMovementBehavior;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayHumanoidInformations;
   import com.ankamagames.atouin.entities.behaviours.movements.FantomMovementBehavior;
   import com.ankamagames.atouin.entities.behaviours.movements.MountedMovementBehavior;
   import com.ankamagames.atouin.entities.behaviours.movements.RunningMovementBehavior;
   import com.ankamagames.atouin.entities.behaviours.movements.WalkingMovementBehavior;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.jerakine.map.IDataMapProvider;
   import com.ankamagames.jerakine.pathfinding.Pathfinding;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.dofus.network.enums.SubEntityBindingPointCategoryEnum;
   import com.ankamagames.atouin.entities.behaviours.display.AtouinDisplayBehavior;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   
   public class AnimatedCharacter extends TiphonSprite implements IEntity, IMovable, IDisplayable, IAnimated, IInteractive, IRectangle, IObstacle
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.dofus.types.entities.AnimatedCharacter));
       
      private var _id:int;
      
      private var _position:MapPoint;
      
      private var _displayed:Boolean;
      
      private var _followers:Vector.<IMovable>;
      
      private var _followed:com.ankamagames.dofus.types.entities.AnimatedCharacter;
      
      private var _entitiesFrame:RoleplayEntitiesFrame;
      
      protected var _movementBehavior:IMovementBehavior;
      
      protected var _displayBehavior:IDisplayBehavior;
      
      public var slideOnNextMove:Boolean;
      
      public function AnimatedCharacter(nId:int, look:TiphonEntityLook, followed:com.ankamagames.dofus.types.entities.AnimatedCharacter = null)
      {
         super(look);
         this._entitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         this._displayBehavior = AtouinDisplayBehavior.getInstance();
         this._movementBehavior = WalkingMovementBehavior.getInstance();
         setAnimationAndDirection("AnimStatique",DirectionsEnum.DOWN_RIGHT);
         this.id = nId;
         this._followers = new Vector.<IMovable>(0,false);
         this._followed = followed;
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
         return this._position;
      }
      
      public function set position(oValue:MapPoint) : void
      {
         this._position = oValue;
      }
      
      public function get movementBehavior() : IMovementBehavior
      {
         return this._movementBehavior;
      }
      
      public function set movementBehavior(oValue:IMovementBehavior) : void
      {
         this._movementBehavior = oValue;
      }
      
      public function get followers() : Vector.<IMovable>
      {
         return this._followers;
      }
      
      public function get followed() : com.ankamagames.dofus.types.entities.AnimatedCharacter
      {
         return this._followed;
      }
      
      public function get displayBehaviors() : IDisplayBehavior
      {
         return this._displayBehavior;
      }
      
      public function set displayBehaviors(oValue:IDisplayBehavior) : void
      {
         this._displayBehavior = oValue;
      }
      
      public function get displayed() : Boolean
      {
         return this._displayed;
      }
      
      public function get handler() : MessageHandler
      {
         return Kernel.getWorker();
      }
      
      public function get enabledInteractions() : uint
      {
         return InteractionsEnum.CLICK | InteractionsEnum.OUT | InteractionsEnum.OVER;
      }
      
      public function get isMoving() : Boolean
      {
         return this._movementBehavior.isMoving(this);
      }
      
      public function get absoluteBounds() : IRectangle
      {
         return this._displayBehavior.getAbsoluteBounds(this);
      }
      
      override public function get useHandCursor() : Boolean
      {
         return true;
      }
      
      public function canSeeThrough() : Boolean
      {
         return false;
      }
      
      public function move(path:MovementPath, callback:Function = null) : void
      {
         var follower:IMovable = null;
         var infos:GameContextActorInformations = null;
         var followerPoint:MapPoint = null;
         var tryCount:uint = 0;
         var avaibleDirection:Array = null;
         var avaibleDirectionCount:uint = 0;
         var b:Boolean = false;
         if(!path.start.equals(this.position))
         {
            _log.warn("Unsynchronized position for entity " + this.id + ", jumping from " + this.position + " to " + path.start + ".");
            this.jump(path.start);
         }
         var distance:uint = path.path.length + 1;
         this._movementBehavior = null;
         if(this.slideOnNextMove)
         {
            this._movementBehavior = SlideMovementBehavior.getInstance();
            this.slideOnNextMove = false;
         }
         else
         {
            if(this._entitiesFrame)
            {
               infos = this._entitiesFrame.getEntityInfos(this.id);
               if(infos is GameRolePlayHumanoidInformations)
               {
                  if((infos as GameRolePlayHumanoidInformations).humanoidInfo.restrictions.forceSlowWalk)
                  {
                     this._movementBehavior = FantomMovementBehavior.getInstance();
                  }
               }
            }
            if(!this._movementBehavior)
            {
               if(distance > 3)
               {
                  if(this.isMounted())
                  {
                     this._movementBehavior = MountedMovementBehavior.getInstance();
                  }
                  else
                  {
                     this._movementBehavior = RunningMovementBehavior.getInstance();
                  }
               }
               else if(distance > 0)
               {
                  this._movementBehavior = WalkingMovementBehavior.getInstance();
               }
               else
               {
                  return;
               }
            }
         }
         var followerDirection:int = this.getDirection();
         var mapData:IDataMapProvider = DataMapProvider.getInstance();
         for each(follower in this._followers)
         {
            followerPoint = null;
            tryCount = 0;
            do
            {
               followerPoint = path.end.getNearestFreeCellInDirection(followerDirection,mapData,false,false);
               followerDirection++;
               followerDirection = followerDirection % 8;
            }
            while(!followerPoint && ++tryCount < 8);
            
            if(followerPoint)
            {
               avaibleDirection = [];
               if(follower is TiphonSprite)
               {
                  avaibleDirection = TiphonSprite(follower).getAvaibleDirection();
               }
               avaibleDirectionCount = 0;
               for each(b in avaibleDirection)
               {
                  if(b)
                  {
                     avaibleDirectionCount++;
                  }
               }
               if(Boolean(avaibleDirection[1]) && !avaibleDirection[3])
               {
                  avaibleDirectionCount++;
               }
               if(!avaibleDirection[1] && Boolean(avaibleDirection[3]))
               {
                  avaibleDirectionCount++;
               }
               if(Boolean(avaibleDirection[7]) && !avaibleDirection[5])
               {
                  avaibleDirectionCount++;
               }
               if(!avaibleDirection[7] && Boolean(avaibleDirection[5]))
               {
                  avaibleDirectionCount++;
               }
               if(!avaibleDirection[0] && Boolean(avaibleDirection[4]))
               {
                  avaibleDirectionCount++;
               }
               if(Boolean(avaibleDirection[0]) && !avaibleDirection[4])
               {
                  avaibleDirectionCount++;
               }
               Pathfinding.findPath(mapData,follower.position,followerPoint,avaibleDirectionCount >= 8,true,this.processMove,new Array(follower,followerPoint));
            }
            else
            {
               _log.warn("Unable to get a proper destination for the follower.");
            }
         }
         this._movementBehavior.move(this,path,callback);
      }
      
      private function processMove(followPath:MovementPath, args:Array) : void
      {
         var followerPoint:MapPoint = null;
         var follower:IMovable = args[0];
         if(Boolean(followPath) && followPath.path.length > 0)
         {
            follower.movementBehavior = this._movementBehavior;
            follower.move(followPath);
         }
         else
         {
            followerPoint = args[1];
            _log.warn("There was no path from " + follower.position + " to " + followerPoint + " for a follower. Jumping !");
            follower.jump(followerPoint);
         }
      }
      
      public function jump(newPosition:MapPoint) : void
      {
         var fol:* = undefined;
         var mdp:IDataMapProvider = null;
         var mp:MapPoint = null;
         this._movementBehavior.jump(this,newPosition);
         for each(fol in this._followers)
         {
            mdp = DataMapProvider.getInstance();
            mp = this.position.getNearestFreeCell(mdp,false);
            if(!mp)
            {
               mp = this.position.getNearestFreeCell(mdp,true);
               if(!mp)
               {
                  return;
               }
            }
            fol.jump(mp);
         }
      }
      
      public function stop(forceStop:Boolean = false) : void
      {
         var fol:* = undefined;
         this._movementBehavior.stop(this,forceStop);
         for each(fol in this._followers)
         {
            fol.stop(forceStop);
         }
      }
      
      public function display(strata:uint = 0) : void
      {
         this._displayBehavior.display(this,strata);
         this._displayed = true;
      }
      
      public function remove() : void
      {
         this.removeAllFollowers();
         this._displayed = false;
         this._movementBehavior.stop(this,true);
         this._displayBehavior.remove(this);
      }
      
      public function getRootEntity() : com.ankamagames.dofus.types.entities.AnimatedCharacter
      {
         if(this._followed)
         {
            return this._followed.getRootEntity();
         }
         return this;
      }
      
      public function getFollowerFromLook(look:TiphonEntityLook) : com.ankamagames.dofus.types.entities.AnimatedCharacter
      {
         var i:* = undefined;
         for each(i in this._followers)
         {
            if(i.look.toString() == look.toString())
            {
               return i;
            }
         }
         _log.error("This character has no follower with specified look");
         return null;
      }
      
      public function removeFollower(follower:IMovable) : void
      {
         var dfollower:IDisplayable = null;
         if(this._followers.lastIndexOf(follower) < 0)
         {
            _log.error("Follower unknown, cannot be removed.");
         }
         else
         {
            this._followers.splice(this._followers.lastIndexOf(follower),1);
            if(follower is IDisplayable)
            {
               dfollower = follower as IDisplayable;
               dfollower.remove();
            }
            else
            {
               _log.error("Follower doesn\'t belong to IDisplayable, cannot be removed.");
            }
         }
      }
      
      public function removeAllFollowers() : void
      {
         var iFollower:* = undefined;
         var dfollower:IDisplayable = null;
         for(iFollower in this._followers)
         {
            if(this._followers[iFollower] is IDisplayable)
            {
               dfollower = this._followers[iFollower] as IDisplayable;
               dfollower.remove();
            }
            else
            {
               _log.error("Follower doesn\'t belong to IDisplayable, cannot be removed.");
            }
            this._followers[iFollower] = null;
         }
      }
      
      public function addFollower(follower:IMovable, instantSync:Boolean = false) : void
      {
         var dfollower:IDisplayable = null;
         this._followers.push(follower);
         var mdp:IDataMapProvider = DataMapProvider.getInstance();
         var mp:MapPoint = this.position.getNearestFreeCell(mdp,false);
         if(!mp)
         {
            mp = this.position.getNearestFreeCell(mdp,true);
            if(!mp)
            {
               return;
            }
         }
         if(follower.position == null)
         {
            follower.position = mp;
         }
         if(follower is IDisplayable)
         {
            dfollower = follower as IDisplayable;
            if(Boolean(this._displayed) && !dfollower.displayed)
            {
               dfollower.display();
            }
            else if(!this._displayed && Boolean(dfollower.displayed))
            {
               dfollower.remove();
            }
         }
         if(mp.equals(follower.position))
         {
            return;
         }
         if(instantSync)
         {
            follower.jump(mp);
         }
         else
         {
            follower.move(Pathfinding.findPath(mdp,follower.position,mp,false,false));
         }
      }
      
      public function isMounted() : Boolean
      {
         var subEntities:Array = this.look.getSubEntities(true);
         if(!subEntities)
         {
            return false;
         }
         var mountedEntities:Array = subEntities[SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER];
         if(!mountedEntities || mountedEntities.length == 0)
         {
            return false;
         }
         return true;
      }
   }
}
