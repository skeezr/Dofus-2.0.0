package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.atouin.managers.FrustumManager;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.atouin.messages.AdjacentMapOverMessage;
   import flash.geom.Point;
   import flash.display.Sprite;
   import com.ankamagames.berilia.types.data.LinkedCursorData;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOverMessage;
   import com.ankamagames.jerakine.entities.interfaces.IInteractive;
   import com.ankamagames.jerakine.interfaces.IRectangle;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseRightClickMessage;
   import com.ankamagames.jerakine.entities.messages.EntityClickMessage;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementActivationMessage;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementMouseOverMessage;
   import com.ankamagames.dofus.internalDatacenter.house.HouseWrapper;
   import com.ankamagames.dofus.logic.game.roleplay.messages.InteractiveElementMouseOutMessage;
   import com.ankamagames.atouin.messages.CellClickMessage;
   import com.ankamagames.atouin.messages.AdjacentMapClickMessage;
   import com.ankamagames.dofus.logic.game.roleplay.types.FightTeam;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightJoinRequestMessage;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import flash.geom.Rectangle;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.berilia.managers.LinkedCursorSpriteManager;
   import com.ankamagames.atouin.utils.CellIdConverter;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayActorInformations;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.dofus.logic.game.roleplay.types.RoleplayTeamFightersTooltipInformation;
   import com.ankamagames.dofus.logic.game.roleplay.types.CharacterTooltipInformation;
   import com.ankamagames.dofus.logic.game.roleplay.types.TaxCollectorTooltipInformation;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.network.types.game.context.GameRolePlayTaxCollectorInformations;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMutantInformations;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.utils.api_namespace;
   import com.ankamagames.jerakine.entities.interfaces.IMovable;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import com.ankamagames.atouin.messages.AdjacentMapOutMessage;
   import com.ankamagames.jerakine.entities.messages.EntityMouseOutMessage;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMountInformations;
   import com.ankamagames.berilia.factories.MenusFactory;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMerchantInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPrismInformations;
   import com.ankamagames.dofus.logic.game.roleplay.types.GameContextPaddockItemInformations;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.network.messages.game.inventory.exchanges.ExchangeOnHumanVendorRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.party.PartyInvitationRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.HouseKickIndoorMerchantRequestMessage;
   
   public class RoleplayWorldFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(RoleplayWorldFrame));
      
      public static var cellClickEnabled:Boolean = true;
       
      private const _common:String = "mod://Ankama_Common/graphics/";
      
      private var _mouseTop:Texture;
      
      private var _mouseBottom:Texture;
      
      private var _mouseRight:Texture;
      
      private var _mouseLeft:Texture;
      
      private var _texturesReady:Boolean;
      
      private var _rpContextFrame:com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
      
      private var _movFrame:com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayMovementFrame;
      
      private var _playerEntity:AnimatedCharacter;
      
      private var _playerName:String;
      
      public function RoleplayWorldFrame(parentFrame:com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame, movementFrame:com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayMovementFrame)
      {
         super();
         this._rpContextFrame = parentFrame;
         this._movFrame = movementFrame;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function pushed() : Boolean
      {
         FrustumManager.getInstance().setBorderInteraction(true);
         if(this._texturesReady)
         {
            return true;
         }
         this._mouseBottom = new Texture();
         this._mouseBottom.x = 0;
         this._mouseBottom.y = 0;
         this._mouseBottom.uri = new Uri(this._common + "assets.swf|cursorBottom");
         this._mouseBottom.width = 31;
         this._mouseBottom.height = 25;
         this._mouseBottom.finalize();
         this._mouseTop = new Texture();
         this._mouseTop.x = 0;
         this._mouseTop.y = 0;
         this._mouseTop.uri = new Uri(this._common + "assets.swf|cursorTop");
         this._mouseTop.width = 31;
         this._mouseTop.height = 20;
         this._mouseTop.finalize();
         this._mouseRight = new Texture();
         this._mouseRight.x = 0;
         this._mouseRight.y = 0;
         this._mouseRight.uri = new Uri(this._common + "assets.swf|cursorRight");
         this._mouseRight.width = 25;
         this._mouseRight.height = 24;
         this._mouseRight.finalize();
         this._mouseLeft = new Texture();
         this._mouseLeft.x = 0;
         this._mouseLeft.y = 0;
         this._mouseLeft.uri = new Uri(this._common + "assets.swf|cursorLeft");
         this._mouseLeft.width = 25;
         this._mouseLeft.height = 24;
         this._mouseLeft.finalize();
         this._texturesReady = true;
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var amomsg:AdjacentMapOverMessage = null;
         var targetCell:Point = null;
         var cellSprite:Sprite = null;
         var item:LinkedCursorData = null;
         var emomsg:EntityMouseOverMessage = null;
         var entity:IInteractive = null;
         var infos:* = undefined;
         var targetBounds:IRectangle = null;
         var tooltipMaker:String = null;
         var fightsOnMap:Dictionary = null;
         var entityFight:IEntity = null;
         var mrcmsg:MouseRightClickMessage = null;
         var rightClickedEntity:IInteractive = null;
         var ecmsg:EntityClickMessage = null;
         var entityc:IInteractive = null;
         var EntityClickInfo:GameContextActorInformations = null;
         var menuResult:Boolean = false;
         var ieamsg:InteractiveElementActivationMessage = null;
         var playerEntity:IEntity = null;
         var iemovmsg:InteractiveElementMouseOverMessage = null;
         var enabledSkillIds:Vector.<uint> = null;
         var i:int = 0;
         var len:int = 0;
         var elementId:uint = 0;
         var roleplayEntitiesFrame:RoleplayEntitiesFrame = null;
         var houseWrapper:HouseWrapper = null;
         var iemomsg:InteractiveElementMouseOutMessage = null;
         var climsg:CellClickMessage = null;
         var amcmsg:AdjacentMapClickMessage = null;
         var playedEntity:IEntity = null;
         var fight:FightTeam = null;
         var targetLevel:uint = 0;
         var playerLevel:uint = 0;
         var rightClickedinfos:GameContextActorInformations = null;
         var fightId:uint = 0;
         var fightTeamLeader:int = 0;
         var gfjrmsg:GameFightJoinRequestMessage = null;
         var playerEntity3:IEntity = null;
         var nearestCell:MapPoint = null;
         var target:Rectangle = null;
         switch(true)
         {
            case msg is CellClickMessage:
               if(cellClickEnabled)
               {
                  climsg = msg as CellClickMessage;
                  this._movFrame.resetNextMoveMapChange();
                  _log.debug("Player clicked on cell " + climsg.cellId + ".");
                  this._movFrame.setFollowingInteraction(null);
                  this._movFrame.askMoveTo(MapPoint.fromCellId(climsg.cellId));
               }
               return true;
            case msg is AdjacentMapClickMessage:
               if(cellClickEnabled)
               {
                  amcmsg = msg as AdjacentMapClickMessage;
                  playedEntity = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
                  if(!playedEntity)
                  {
                     _log.warn("The player tried to move before its character was added to the scene. Aborting.");
                     return false;
                  }
                  this._movFrame.setNextMoveMapChange(amcmsg.adjacentMapId);
                  if(!playedEntity.position.equals(MapPoint.fromCellId(amcmsg.cellId)))
                  {
                     this._movFrame.setFollowingInteraction(null);
                     this._movFrame.askMoveTo(MapPoint.fromCellId(amcmsg.cellId));
                  }
                  else
                  {
                     this._movFrame.setFollowingInteraction(null);
                     this._movFrame.askMapChange();
                  }
               }
               return true;
            case msg is AdjacentMapOutMessage:
               LinkedCursorSpriteManager.getInstance().removeItem("changeMapCursor");
               return true;
            case msg is AdjacentMapOverMessage:
               amomsg = AdjacentMapOverMessage(msg);
               targetCell = CellIdConverter.cellIdToCoord(amomsg.cellId);
               cellSprite = InteractiveCellManager.getInstance().getCell(amomsg.cellId);
               item = new LinkedCursorData();
               switch(amomsg.direction)
               {
                  case DirectionsEnum.LEFT:
                     item.sprite = Sprite(this._mouseLeft);
                     item.lockX = true;
                     item.sprite.x = amomsg.zone.x + amomsg.zone.width;
                     item.offset = new Point(0,0);
                     item.lockY = true;
                     item.sprite.y = cellSprite.y + cellSprite.height / 2;
                     break;
                  case DirectionsEnum.UP:
                     item.sprite = Sprite(this._mouseTop);
                     item.lockY = true;
                     item.sprite.y = amomsg.zone.y + amomsg.zone.height;
                     item.offset = new Point(0,0);
                     item.lockX = true;
                     item.sprite.x = cellSprite.x + cellSprite.width / 2;
                     break;
                  case DirectionsEnum.DOWN:
                     item.sprite = Sprite(this._mouseBottom);
                     item.lockY = true;
                     item.sprite.y = amomsg.zone.getBounds(amomsg.zone).top;
                     item.offset = new Point(0,10);
                     item.lockX = true;
                     item.sprite.x = cellSprite.x + cellSprite.width / 2;
                     break;
                  case DirectionsEnum.RIGHT:
                     item.sprite = Sprite(this._mouseRight);
                     item.lockX = true;
                     item.sprite.x = amomsg.zone.getBounds(amomsg.zone).left;
                     item.offset = new Point(0,0);
                     item.lockY = true;
                     item.sprite.y = cellSprite.y + cellSprite.height / 2;
               }
               LinkedCursorSpriteManager.getInstance().addItem("changeMapCursor",item);
               return true;
            case msg is EntityMouseOverMessage:
               emomsg = msg as EntityMouseOverMessage;
               entity = emomsg.entity as IInteractive;
               if(entity is AnimatedCharacter)
               {
                  entity = (entity as AnimatedCharacter).getRootEntity();
               }
               infos = this._rpContextFrame.entitiesFrame.getEntityInfos(entity.id) as GameRolePlayActorInformations;
               targetBounds = (entity as IDisplayable).absoluteBounds;
               tooltipMaker = null;
               fightsOnMap = this._rpContextFrame.entitiesFrame.fights;
               entityFight = DofusEntities.getEntity(entity.id);
               if(this._rpContextFrame.entitiesFrame.isFight(entity.id))
               {
                  fight = this._rpContextFrame.entitiesFrame.getFightTeam(entity.id);
                  infos = new RoleplayTeamFightersTooltipInformation(fight);
                  tooltipMaker = "roleplayFight";
               }
               else
               {
                  switch(true)
                  {
                     case infos is GameRolePlayCharacterInformations:
                        targetLevel = infos.alignmentInfos.characterPower - emomsg.entity.id;
                        playerLevel = PlayedCharacterManager.getInstance().infos.level;
                        infos = new CharacterTooltipInformation(infos,PlayedCharacterManager.getInstance().levelDiff(targetLevel));
                        break;
                     case infos is GameRolePlayMutantInformations:
                        infos = new CharacterTooltipInformation(infos,0);
                        break;
                     case infos is GameRolePlayTaxCollectorInformations:
                        infos = new TaxCollectorTooltipInformation(TaxCollectorName.getTaxCollectorNameById((infos as GameRolePlayTaxCollectorInformations).lastNameId).name,TaxCollectorFirstname.getTaxCollectorFirstnameById((infos as GameRolePlayTaxCollectorInformations).firstNameId).firstname,(infos as GameRolePlayTaxCollectorInformations).guildIdentity);
                  }
               }
               if(!infos)
               {
                  _log.warn("Rolling over a unknown entity (" + emomsg.entity.id + ").");
                  return false;
               }
               TooltipManager.show(infos,targetBounds,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,TooltipManager.TOOLTIP_STANDAR_NAME,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,tooltipMaker,UiApi.api_namespace::defaultTooltipUiScript);
               return true;
            case msg is MouseRightClickMessage:
               mrcmsg = msg as MouseRightClickMessage;
               rightClickedEntity = mrcmsg.target as IInteractive;
               if(rightClickedEntity is AnimatedCharacter)
               {
                  rightClickedEntity = (rightClickedEntity as AnimatedCharacter).getRootEntity();
                  rightClickedinfos = this._rpContextFrame.entitiesFrame.getEntityInfos(rightClickedEntity.id);
                  this.displayContextualMenu(rightClickedinfos,rightClickedEntity);
               }
               return true;
            case msg is EntityMouseOutMessage:
               TooltipManager.hide();
               return true;
            case msg is EntityClickMessage:
               ecmsg = msg as EntityClickMessage;
               entityc = ecmsg.entity as IInteractive;
               if(entityc is AnimatedCharacter)
               {
                  entityc = (entityc as AnimatedCharacter).getRootEntity();
               }
               EntityClickInfo = this._rpContextFrame.entitiesFrame.getEntityInfos(entityc.id);
               menuResult = this.displayContextualMenu(EntityClickInfo,entityc);
               if(this._rpContextFrame.entitiesFrame.isFight(entityc.id))
               {
                  fightId = this._rpContextFrame.entitiesFrame.getFightId(entityc.id);
                  fightTeamLeader = this._rpContextFrame.entitiesFrame.getFightLeaderId(entityc.id);
                  gfjrmsg = new GameFightJoinRequestMessage();
                  gfjrmsg.initGameFightJoinRequestMessage(fightId,fightTeamLeader);
                  playerEntity3 = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
                  if((playerEntity3 as IMovable).isMoving)
                  {
                     this._movFrame.setFollowingMessage(gfjrmsg);
                     (playerEntity3 as IMovable).stop();
                  }
                  else
                  {
                     ConnectionsHandler.getConnection().send(gfjrmsg);
                  }
               }
               else if(entityc.id != PlayedCharacterManager.getInstance().id && !menuResult)
               {
                  this._movFrame.setFollowingInteraction(null);
                  this._movFrame.askMoveTo(entityc.position);
               }
               return true;
            case msg is InteractiveElementActivationMessage:
               ieamsg = msg as InteractiveElementActivationMessage;
               playerEntity = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
               if(playerEntity.position.distanceTo(ieamsg.position) <= 1)
               {
                  this._movFrame.activateSkill(ieamsg.skillId,ieamsg.interactiveElement);
               }
               else
               {
                  nearestCell = ieamsg.position.getNearestFreeCellInDirection(ieamsg.position.advancedOrientationTo(playerEntity.position),DataMapProvider.getInstance(),true);
                  if(!nearestCell)
                  {
                     nearestCell = ieamsg.position;
                  }
                  this._movFrame.setFollowingInteraction({
                     "ie":ieamsg.interactiveElement,
                     "skillId":ieamsg.skillId
                  });
                  this._movFrame.askMoveTo(nearestCell);
               }
               return true;
            case msg is InteractiveElementMouseOverMessage:
               iemovmsg = msg as InteractiveElementMouseOverMessage;
               enabledSkillIds = iemovmsg.interactiveElement.enabledSkillIds;
               i = -1;
               len = enabledSkillIds.length;
               while(++i < len)
               {
                  if(enabledSkillIds[i] == 175)
                  {
                     infos = this._rpContextFrame.currentPaddock;
                     break;
                  }
               }
               elementId = iemovmsg.interactiveElement.elementId;
               roleplayEntitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
               houseWrapper = roleplayEntitiesFrame.housesInformations[elementId];
               if(Boolean(houseWrapper) && Boolean(houseWrapper.ownerName))
               {
                  infos = houseWrapper;
               }
               if(infos)
               {
                  target = iemovmsg.sprite.getRect(StageShareManager.stage);
                  TooltipManager.show(infos,new Rectangle(int(target.x + target.width),target.y,0,0),UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,TooltipManager.TOOLTIP_STANDAR_NAME,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,null,UiApi.api_namespace::defaultTooltipUiScript);
               }
               return true;
            case msg is InteractiveElementMouseOutMessage:
               iemomsg = msg as InteractiveElementMouseOutMessage;
               TooltipManager.hide();
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         LinkedCursorSpriteManager.getInstance().removeItem("changeMapCursor");
         FrustumManager.getInstance().setBorderInteraction(false);
         return true;
      }
      
      public function destroy() : void
      {
         this._rpContextFrame = null;
      }
      
      private function displayContextualMenu(pGameContextActorInformations:GameContextActorInformations, pEntity:IInteractive) : Boolean
      {
         var mount:GameRolePlayMountInformations = null;
         var player:PlayedCharacterManager = PlayedCharacterManager.getInstance();
         var menu:Array = new Array();
         var _commonMod:Object = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
         switch(true)
         {
            case pGameContextActorInformations is GameRolePlayMutantInformations:
               menu = MenusFactory.create(pGameContextActorInformations,null,[pEntity]);
               break;
            case pGameContextActorInformations is GameRolePlayCharacterInformations:
               menu = MenusFactory.create(pGameContextActorInformations,null,[pEntity]);
               break;
            case pGameContextActorInformations is GameRolePlayMerchantInformations:
               menu = MenusFactory.create(pGameContextActorInformations,null,[pEntity]);
               break;
            case pGameContextActorInformations is GameRolePlayNpcInformations:
               menu = MenusFactory.create(pGameContextActorInformations,null,[pEntity]);
               break;
            case pGameContextActorInformations is GameRolePlayTaxCollectorInformations:
               menu = MenusFactory.create(pGameContextActorInformations,null,[pEntity]);
               break;
            case pGameContextActorInformations is GameRolePlayPrismInformations:
               menu = MenusFactory.create(pGameContextActorInformations,null,[pEntity]);
               break;
            case pGameContextActorInformations is GameContextPaddockItemInformations:
               menu = MenusFactory.create(pGameContextActorInformations,null,[pEntity]);
               break;
            case pGameContextActorInformations is GameRolePlayMountInformations:
               mount = pGameContextActorInformations as GameRolePlayMountInformations;
         }
         if(menu.length > 1)
         {
            _commonMod.createContextMenu(menu);
            return true;
         }
         return false;
      }
      
      private function onWisperMessage(playerName:String) : void
      {
         KernelEventsManager.getInstance().processCallback(ChatHookList.ChatFocus,playerName);
      }
      
      private function onMerchantPlayerBuyClick(vendorId:int, vendorCellId:uint) : void
      {
         var eohvrmsg:ExchangeOnHumanVendorRequestMessage = new ExchangeOnHumanVendorRequestMessage();
         eohvrmsg.initExchangeOnHumanVendorRequestMessage(vendorId,vendorCellId);
         ConnectionsHandler.getConnection().send(eohvrmsg);
      }
      
      private function onInviteMenuClicked(playerName:String) : void
      {
         var invitemsg:PartyInvitationRequestMessage = new PartyInvitationRequestMessage();
         invitemsg.initPartyInvitationRequestMessage(playerName);
         ConnectionsHandler.getConnection().send(invitemsg);
      }
      
      private function onMerchantHouseKickOff(cellId:uint) : void
      {
         var kickRequest:HouseKickIndoorMerchantRequestMessage = new HouseKickIndoorMerchantRequestMessage();
         kickRequest.initHouseKickIndoorMerchantRequestMessage(cellId);
         ConnectionsHandler.getConnection().send(kickRequest);
      }
   }
}
