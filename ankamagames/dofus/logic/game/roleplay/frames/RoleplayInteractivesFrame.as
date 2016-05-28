package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import flash.geom.Point;
   import com.ankamagames.jerakine.logger.Logger;
   import flash.filters.ColorMatrixFilter;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.utils.Dictionary;
   import flash.display.Sprite;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveMapUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveElementUpdatedMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveUsedMessage;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.dofus.network.messages.game.interactive.StatedMapUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.StatedElementUpdatedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapObstacleUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.zaap.ZaapListMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.zaap.TeleportDestinationsListMessage;
   import com.ankamagames.dofus.logic.game.roleplay.actions.TeleportRequestAction;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveUseEndedMessage;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import flash.utils.Timer;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import com.ankamagames.dofus.network.types.game.interactive.StatedElement;
   import com.ankamagames.dofus.network.types.game.interactive.MapObstacle;
   import com.ankamagames.dofus.network.messages.game.interactive.zaap.TeleportRequestMessage;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.jerakine.entities.interfaces.IAnimated;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import flash.events.TimerEvent;
   import com.ankamagames.dofus.types.enums.AnimationEnum;
   import com.ankamagames.tiphon.sequence.SetDirectionStep;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.dofus.network.enums.MapObstacleStateEnum;
   import com.ankamagames.dofus.internalDatacenter.taxi.TeleportDestinationWrapper;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.RoleplayHookList;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.dofus.logic.game.common.frames.ChatFrame;
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   import flash.display.DisplayObjectContainer;
   import flash.utils.clearTimeout;
   import flash.display.DisplayObject;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementMouseOverMessage;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementMouseOutMessage;
   import com.ankamagames.dofus.datacenter.interactives.MapInteractive;
   import com.ankamagames.dofus.datacenter.interactives.Interactive;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.factories.MenusFactory;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementActivationMessage;
   import com.ankamagames.dofus.logic.common.actions.ChangeWorldInteractionAction;
   
   public class RoleplayInteractivesFrame implements Frame
   {
      
      private static const INTERACTIVE_CURSOR_CLIP:Class = RoleplayInteractivesFrame_INTERACTIVE_CURSOR_CLIP;
      
      private static const INTERACTIVE_CURSOR_OFFSET:Point = new Point(13,15);
      
      private static const INTERACTIVE_CURSOR_NAME:String = "interactiveCursor";
      
      private static const LUMINOSITY_FACTOR:Number = 1.2;
      
      private static const LUMINOSITY_EFFECTS:Array = [new ColorMatrixFilter([LUMINOSITY_FACTOR,0,0,0,0,0,LUMINOSITY_FACTOR,0,0,0,0,0,LUMINOSITY_FACTOR,0,0,0,0,0,1,0])];
      
      private static const ALPHA_MODIFICATOR:Number = 0.2;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(RoleplayInteractivesFrame));
       
      private var _commonMod:Object;
      
      private var _rpContextFrame:com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
      
      private var _ie:Dictionary;
      
      private var _currentUsages:Array;
      
      private var _currentlyHighlighted:Sprite;
      
      private var _baseAlpha:Number;
      
      private var _spawnMapId:uint;
      
      private var i:int;
      
      private var _entities:Dictionary;
      
      public function RoleplayInteractivesFrame(parentFrame:com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame)
      {
         this._ie = new Dictionary(true);
         this._currentUsages = new Array();
         this._entities = new Dictionary();
         super();
         this._rpContextFrame = parentFrame;
         this._commonMod = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get spawnMapId() : uint
      {
         return this._spawnMapId;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var imumsg:InteractiveMapUpdateMessage = null;
         var ieumsg:InteractiveElementUpdatedMessage = null;
         var iumsg:InteractiveUsedMessage = null;
         var worldPos:MapPoint = null;
         var user:IEntity = null;
         var smumsg:StatedMapUpdateMessage = null;
         var seumsg:StatedElementUpdatedMessage = null;
         var moumsg:MapObstacleUpdateMessage = null;
         var zlmsg:ZaapListMessage = null;
         var destinationz:Array = null;
         var tdlmsg:TeleportDestinationsListMessage = null;
         var destinations:Array = null;
         var tra:TeleportRequestAction = null;
         var iuemsg:InteractiveUseEndedMessage = null;
         var ie:InteractiveElement = null;
         var useAnimation:String = null;
         var useDirection:uint = 0;
         var playerPos:MapPoint = null;
         var availableDirections:Array = null;
         var k:int = 0;
         var t:Timer = null;
         var fct:Function = null;
         var seq:SerialSequencer = null;
         var sprite:TiphonSprite = null;
         var se:StatedElement = null;
         var mo:MapObstacle = null;
         var trmsg:TeleportRequestMessage = null;
         switch(true)
         {
            case msg is InteractiveMapUpdateMessage:
               imumsg = msg as InteractiveMapUpdateMessage;
               this.clear();
               for each(ie in imumsg.interactiveElements)
               {
                  this.registerInteractive(ie);
               }
               return true;
            case msg is InteractiveElementUpdatedMessage:
               ieumsg = msg as InteractiveElementUpdatedMessage;
               this.registerInteractive(ieumsg.interactiveElement);
               return true;
            case msg is InteractiveUsedMessage:
               iumsg = msg as InteractiveUsedMessage;
               worldPos = Atouin.getInstance().getIdentifiedElementPosition(iumsg.elemId);
               user = DofusEntities.getEntity(iumsg.entityId);
               if(user is IAnimated)
               {
                  useAnimation = Skill.getSkillById(iumsg.skillId).useAnimation;
                  playerPos = (user as IMovable).position;
                  if(playerPos.x == worldPos.x && playerPos.y == worldPos.y)
                  {
                     useDirection = (user as TiphonSprite).getDirection();
                  }
                  else
                  {
                     useDirection = (user as IMovable).position.advancedOrientationTo(worldPos,true);
                  }
                  availableDirections = TiphonSprite(user).getAvaibleDirection(useAnimation);
                  if(availableDirections[useDirection] == false)
                  {
                     for(k = 0; k < 8; k++)
                     {
                        if(useDirection == 7)
                        {
                           useDirection = 0;
                        }
                        else
                        {
                           useDirection++;
                        }
                        if(availableDirections[useDirection] == true)
                        {
                           break;
                        }
                     }
                  }
                  if(iumsg.duration > 0)
                  {
                     (user as IAnimated).setAnimationAndDirection(useAnimation,useDirection);
                     t = new Timer(iumsg.duration * 100,1);
                     fct = function():void
                     {
                        t.removeEventListener(TimerEvent.TIMER,fct);
                        (user as IAnimated).setAnimation(AnimationEnum.ANIM_STATIQUE);
                     };
                     t.addEventListener(TimerEvent.TIMER,fct);
                     t.start();
                  }
                  else
                  {
                     seq = new SerialSequencer();
                     sprite = user as TiphonSprite;
                     seq.addStep(new SetDirectionStep(sprite,useDirection));
                     seq.addStep(new PlayAnimationStep(sprite,useAnimation));
                     seq.start();
                  }
               }
               if(iumsg.duration > 0)
               {
                  if(PlayedCharacterManager.getInstance().id == iumsg.entityId)
                  {
                     this.resetInteractiveApparence();
                     RoleplayWorldFrame.cellClickEnabled = false;
                  }
                  this._entities[iumsg.elemId] = iumsg.entityId;
               }
               return true;
            case msg is StatedMapUpdateMessage:
               smumsg = msg as StatedMapUpdateMessage;
               for each(se in smumsg.statedElements)
               {
                  this.updateStatedElement(se);
               }
               return true;
            case msg is StatedElementUpdatedMessage:
               seumsg = msg as StatedElementUpdatedMessage;
               this.updateStatedElement(seumsg.statedElement);
               return true;
            case msg is MapObstacleUpdateMessage:
               moumsg = msg as MapObstacleUpdateMessage;
               for each(mo in moumsg.obstacles)
               {
                  InteractiveCellManager.getInstance().updateCell(mo.obstacleCellId,mo.state == MapObstacleStateEnum.OBSTACLE_OPENED);
               }
               break;
            case msg is ZaapListMessage:
               zlmsg = msg as ZaapListMessage;
               destinationz = new Array();
               for(this.i = 0; this.i < zlmsg.mapIds.length; this.i++)
               {
                  destinationz.push(new TeleportDestinationWrapper(zlmsg.teleporterType,zlmsg.mapIds[this.i],zlmsg.subareaIds[this.i],zlmsg.costs[this.i],zlmsg.spawnMapId == zlmsg.mapIds[this.i]));
               }
               this._spawnMapId = zlmsg.spawnMapId;
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.TeleportDestinationList,destinationz);
               return true;
            case msg is TeleportDestinationsListMessage:
               tdlmsg = msg as TeleportDestinationsListMessage;
               destinations = new Array();
               for(this.i = 0; this.i < tdlmsg.mapIds.length; this.i++)
               {
                  destinations.push(new TeleportDestinationWrapper(tdlmsg.teleporterType,tdlmsg.mapIds[this.i],tdlmsg.subareaIds[this.i],tdlmsg.costs[this.i]));
               }
               KernelEventsManager.getInstance().processCallback(RoleplayHookList.TeleportDestinationList,destinations);
               return true;
            case msg is TeleportRequestAction:
               tra = msg as TeleportRequestAction;
               if(tra.cost <= PlayedCharacterManager.getInstance().characteristics.kamas)
               {
                  trmsg = new TeleportRequestMessage();
                  trmsg.initTeleportRequestMessage(tra.teleportType,tra.mapId);
                  ConnectionsHandler.getConnection().send(trmsg);
               }
               else
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,I18n.getText(I18nProxy.getKeyId("ui.popup.not_enough_rich")),ChatFrame.RED_CHANNEL_ID);
               }
               return true;
            case msg is InteractiveUseEndedMessage:
               iuemsg = InteractiveUseEndedMessage(msg);
               this.interactiveUsageFinished(this._entities[iuemsg.elemId],iuemsg.elemId,iuemsg.skillId);
               delete this._entities[iuemsg.elemId];
               return true;
         }
         return false;
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      private function registerInteractive(ie:InteractiveElement) : void
      {
         var worldObject:InteractiveObject = Atouin.getInstance().getIdentifiedElement(ie.elementId);
         if(!worldObject)
         {
            _log.error("Unknown identified element " + ie.elementId + "; unable to register it as interactive.");
            return;
         }
         var worldPos:MapPoint = Atouin.getInstance().getIdentifiedElementPosition(ie.elementId);
         if(!worldObject.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            worldObject.addEventListener(MouseEvent.MOUSE_OVER,this.over,false,0,true);
            worldObject.addEventListener(MouseEvent.MOUSE_OUT,this.out,false,0,true);
            worldObject.addEventListener(MouseEvent.CLICK,this.click,false,0,true);
         }
         if(worldObject is Sprite)
         {
            (worldObject as Sprite).useHandCursor = true;
            (worldObject as Sprite).buttonMode = true;
         }
         this._ie[worldObject] = {
            "element":ie,
            "position":worldPos
         };
      }
      
      private function removeInteractive(ie:InteractiveElement) : void
      {
         var interactiveElement:InteractiveObject = Atouin.getInstance().getIdentifiedElement(ie.elementId);
         if(interactiveElement != null)
         {
            interactiveElement.removeEventListener(MouseEvent.MOUSE_OVER,this.over);
            interactiveElement.removeEventListener(MouseEvent.MOUSE_OUT,this.out);
            interactiveElement.removeEventListener(MouseEvent.CLICK,this.click);
         }
         delete this._ie[interactiveElement];
      }
      
      private function updateStatedElement(se:StatedElement) : void
      {
         var worldObject:InteractiveObject = Atouin.getInstance().getIdentifiedElement(se.elementId);
         if(!worldObject)
         {
            _log.error("Unknown identified element " + se.elementId + "; unable to change its state to " + se.elementState + " !");
            return;
         }
         var ts:TiphonSprite = worldObject is DisplayObjectContainer?this.findTiphonSprite(worldObject as DisplayObjectContainer):null;
         if(!ts)
         {
            _log.warn("Unable to find an animated element for the stated element " + se.elementId + " on cell " + se.elementCellId + ", this element is probably invisible.");
            return;
         }
         ts.setAnimationAndDirection("AnimState" + se.elementState,0);
      }
      
      private function clear() : void
      {
         var timeout:int = 0;
         var obj:Object = null;
         for each(timeout in this._currentUsages)
         {
            clearTimeout(timeout);
         }
         for each(obj in this._ie)
         {
            this.removeInteractive(obj.element as InteractiveElement);
         }
      }
      
      private function findTiphonSprite(doc:DisplayObjectContainer) : TiphonSprite
      {
         var child:DisplayObject = null;
         if(doc is TiphonSprite)
         {
            return doc as TiphonSprite;
         }
         if(!doc.numChildren)
         {
            return null;
         }
         for(var i:uint = 0; i < doc.numChildren; i++)
         {
            child = doc.getChildAt(i);
            if(child is TiphonSprite)
            {
               return child as TiphonSprite;
            }
            if(child is DisplayObjectContainer)
            {
               return this.findTiphonSprite(child as DisplayObjectContainer);
            }
         }
         return null;
      }
      
      private function highlightInteractiveApparence(ie:Sprite) : void
      {
         if(this._currentlyHighlighted != null)
         {
            this.resetInteractiveApparence();
         }
         if(ie.getChildAt(0) is TiphonSprite)
         {
            (ie.getChildAt(0) as TiphonSprite).rawAnimation.filters = LUMINOSITY_EFFECTS;
         }
         else
         {
            ie.filters = LUMINOSITY_EFFECTS;
         }
         this._baseAlpha = ie.alpha;
         if(ie.alpha == 0)
         {
            ie.alpha = ALPHA_MODIFICATOR;
         }
         var lcd:LinkedCursorData = new LinkedCursorData();
         lcd.sprite = new INTERACTIVE_CURSOR_CLIP();
         lcd.offset = INTERACTIVE_CURSOR_OFFSET;
         LinkedCursorSpriteManager.getInstance().addItem(INTERACTIVE_CURSOR_NAME,lcd);
         this._currentlyHighlighted = ie;
      }
      
      private function resetInteractiveApparence() : void
      {
         if(this._currentlyHighlighted == null)
         {
            return;
         }
         if(this._currentlyHighlighted.getChildAt(0) is TiphonSprite)
         {
            (this._currentlyHighlighted.getChildAt(0) as TiphonSprite).rawAnimation.filters = null;
         }
         else
         {
            this._currentlyHighlighted.filters = null;
         }
         this._currentlyHighlighted.alpha = this._baseAlpha;
         LinkedCursorSpriteManager.getInstance().removeItem(INTERACTIVE_CURSOR_NAME);
         this._currentlyHighlighted = null;
      }
      
      private function over(me:MouseEvent) : void
      {
         if(RoleplayWorldFrame.cellClickEnabled == false || !this._rpContextFrame.hasWorldInteraction)
         {
            return;
         }
         this.highlightInteractiveApparence(me.target as Sprite);
         var ie:Object = this._ie[me.target as Sprite];
         Kernel.getWorker().process(new InteractiveElementMouseOverMessage(ie.element,me.target));
      }
      
      private function out(me:Object) : void
      {
         this.resetInteractiveApparence();
         var ie:Object = this._ie[me.target as Sprite];
         Kernel.getWorker().process(new InteractiveElementMouseOutMessage(ie.element));
      }
      
      private function click(me:MouseEvent) : void
      {
         var enabledSkill:uint = 0;
         var disabledSkill:uint = 0;
         if(RoleplayWorldFrame.cellClickEnabled == false || !this._rpContextFrame.hasWorldInteraction)
         {
            return;
         }
         var ie:Object = this._ie[me.target as Sprite];
         var mapInteractive:MapInteractive = MapInteractive.getMapInteractiveById(ie.element.elementId);
         var interactive:Interactive = null;
         if(mapInteractive.typeId)
         {
            interactive = Interactive.getInteractiveById(mapInteractive.typeId);
         }
         var skills:Array = [];
         _log.debug("Interactive element " + ie.element.elementId + " clicked !");
         for each(enabledSkill in ie.element.enabledSkillIds)
         {
            _log.debug("  Enabled skill :  " + Skill.getSkillById(enabledSkill).name);
            skills.push({
               "id":enabledSkill,
               "name":Skill.getSkillById(enabledSkill).name,
               "enabled":true
            });
         }
         for each(disabledSkill in ie.element.disabledSkillIds)
         {
            _log.debug("  Disabled skill : " + Skill.getSkillById(disabledSkill).name);
            skills.push({
               "id":disabledSkill,
               "name":Skill.getSkillById(disabledSkill).name,
               "enabled":false
            });
         }
         if(!mapInteractive.typeId && skills.length == 1 && Boolean(skills[0].enabled))
         {
            this.skillClicked(ie,skills[0].id);
            return;
         }
         this._commonMod = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
         var menu:Array = MenusFactory.create(skills,"skill",[ie,interactive]);
         this._commonMod.createContextMenu(menu);
      }
      
      private function skillClicked(ie:Object, skillId:int) : void
      {
         Kernel.getWorker().process(new InteractiveElementActivationMessage(ie.element,ie.position,skillId));
      }
      
      private function interactiveUsageFinished(entityId:int, elementId:uint, skillId:uint) : void
      {
         if(entityId == PlayedCharacterManager.getInstance().id)
         {
            Kernel.getWorker().process(ChangeWorldInteractionAction.create(true));
            RoleplayWorldFrame.cellClickEnabled = true;
         }
      }
   }
}
