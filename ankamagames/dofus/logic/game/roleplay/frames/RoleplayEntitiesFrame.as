package com.ankamagames.dofus.logic.game.roleplay.frames
{
   import com.ankamagames.dofus.logic.game.common.frames.AbstractEntitiesFrame;
   import com.ankamagames.jerakine.messages.Frame;
   import flash.utils.Dictionary;
   import com.ankamagames.jerakine.resources.loaders.IResourceLoader;
   import com.ankamagames.jerakine.newCache.ICache;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapInformationsRequestMessage;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderFactory;
   import com.ankamagames.jerakine.resources.loaders.ResourceLoaderType;
   import com.ankamagames.jerakine.resources.events.ResourceLoadedEvent;
   import com.ankamagames.jerakine.resources.events.ResourceErrorEvent;
   import com.ankamagames.jerakine.types.events.PropertyChangeEvent;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.atlas.AtlasPointInformationsMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapComplementaryInformationsDataMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.InteractiveMapUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.interactive.StatedMapUpdateMessage;
   import com.ankamagames.dofus.network.types.game.house.HouseInformations;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.GameRolePlayShowActorMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextRefreshEntityLookMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameMapChangeOrientationMessage;
   import com.ankamagames.dofus.logic.game.roleplay.messages.GameRolePlaySetAnimationMessage;
   import com.ankamagames.dofus.types.entities.AnimatedCharacter;
   import com.ankamagames.dofus.logic.game.roleplay.messages.CharacterMovementStoppedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayShowChallengeMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightOptionStateUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightUpdateTeamMessage;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightRemoveTeamMemberMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.GameRolePlayRemoveChallengeMessage;
   import com.ankamagames.dofus.network.messages.game.context.GameContextRemoveElementMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapFightCountMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.objects.ObjectGroundAddedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.objects.ObjectGroundRemovedMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.objects.ObjectGroundListAddedMessage;
   import com.ankamagames.dofus.logic.game.common.actions.mount.PaddockRemoveItemRequestAction;
   import com.ankamagames.dofus.network.messages.game.context.mount.PaddockRemoveItemRequestMessage;
   import com.ankamagames.dofus.logic.game.common.actions.mount.PaddockMoveItemRequestAction;
   import com.ankamagames.berilia.components.Texture;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   import com.ankamagames.dofus.network.messages.game.context.mount.GameDataPaddockObjectRemoveMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.GameDataPaddockObjectAddMessage;
   import com.ankamagames.dofus.network.messages.game.context.mount.GameDataPaddockObjectListAddMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.paddock.GameDataPlayFarmObjectAnimationMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.MapNpcsQuestStatusUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.context.ShowCellMessage;
   import com.ankamagames.dofus.network.types.game.context.MapCoordinatesExtended;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayActorInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightCommonInformations;
   import com.ankamagames.dofus.internalDatacenter.house.HouseWrapper;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.HousePropertiesMessage;
   import com.ankamagames.dofus.network.types.game.interactive.MapObstacle;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayCharacterInformations;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.EmotePlayRequestMessage;
   import com.ankamagames.dofus.network.types.game.paddock.PaddockItem;
   import com.ankamagames.tiphon.display.TiphonSprite;
   import flash.display.Sprite;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.network.enums.ChatChannelsMultiEnum;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.berilia.managers.TooltipManager;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayGroupMonsterInformations;
   import com.ankamagames.dofus.misc.lists.TriggerHookList;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.dofus.network.enums.MapObstacleStateEnum;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayNpcInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayHumanoidInformations;
   import com.ankamagames.dofus.logic.game.common.managers.SpeakingItemManager;
   import com.ankamagames.dofus.logic.game.common.misc.DofusEntities;
   import flash.utils.setTimeout;
   import flash.utils.clearTimeout;
   import com.ankamagames.tiphon.events.TiphonEvent;
   import com.ankamagames.jerakine.managers.OptionManager;
   import com.ankamagames.jerakine.types.enums.DirectionsEnum;
   import com.ankamagames.dofus.network.enums.PlayerLifeStatusEnum;
   import com.ankamagames.dofus.network.enums.FightOptionsEnum;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.dofus.logic.common.managers.HyperlinkShowCellManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.dofus.network.enums.ChatActivableChannelsEnum;
   import com.ankamagames.dofus.logic.game.roleplay.types.Fight;
   import com.ankamagames.dofus.logic.game.roleplay.types.FightTeam;
   import com.ankamagames.dofus.logic.game.roleplay.types.GameContextPaddockItemInformations;
   import com.ankamagames.dofus.network.types.game.context.GameContextActorInformations;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupInformations;
   import com.ankamagames.dofus.logic.game.fight.miscs.CustomAnimStatiqueAnimationModifier;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayMerchantInformations;
   import com.ankamagames.dofus.network.types.game.context.GameRolePlayTaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.context.roleplay.GameRolePlayPrismInformations;
   import com.ankamagames.tiphon.types.look.TiphonEntityLook;
   import com.ankamagames.dofus.misc.EntityLookAdapter;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamInformations;
   import com.ankamagames.jerakine.entities.interfaces.IEntity;
   import com.ankamagames.dofus.factories.RolePlayEntitiesFactory;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.jerakine.entities.interfaces.IDisplayable;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.jerakine.managers.LangManager;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.types.entities.RoleplayObjectEntity;
   import com.ankamagames.jerakine.entities.interfaces.IInteractive;
   import com.ankamagames.dofus.logic.game.roleplay.types.GroundObject;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberInformations;
   import com.ankamagames.dofus.network.types.game.context.fight.FightTeamMemberMonsterInformations;
   import com.ankamagames.jerakine.sequencer.SerialSequencer;
   import com.ankamagames.tiphon.sequence.PlayAnimationStep;
   import com.ankamagames.berilia.managers.UiModuleManager;
   import com.ankamagames.berilia.types.LocationEnum;
   import com.ankamagames.berilia.api.UiApi;
   import com.ankamagames.berilia.utils.api_namespace;
   import flash.display.MovieClip;
   import com.ankamagames.dofus.network.messages.game.context.mount.PaddockMoveItemRequestMessage;
   import com.ankamagames.jerakine.newCache.impl.Cache;
   import com.ankamagames.jerakine.newCache.garbage.LruGarbageCollector;
   
   public class RoleplayEntitiesFrame extends AbstractEntitiesFrame implements Frame
   {
      
      private static const QUEST_CLIP:Class = RoleplayEntitiesFrame_QUEST_CLIP;
       
      private var _fights:Dictionary;
      
      private var _objects:Dictionary;
      
      private var _uri:Dictionary;
      
      private var _paddockItem:Dictionary;
      
      private var _fightNumber:uint = 0;
      
      private var _timeout:Number;
      
      private var _loader:IResourceLoader;
      
      private var _groundObjectCache:ICache;
      
      private var _interactiveElements:Vector.<InteractiveElement>;
      
      private var _currentSubAreaId:uint;
      
      private var _worldPoint:Object;
      
      private var _currentPaddockItemCellId:uint;
      
      private var _currentEmoticon:uint = 0;
      
      private var _bRequestingAura:Boolean = false;
      
      private var _playersId:Array;
      
      private var _npcList:Dictionary;
      
      private var _housesList:Dictionary;
      
      public function RoleplayEntitiesFrame()
      {
         this._paddockItem = new Dictionary();
         this._groundObjectCache = new Cache(20,new LruGarbageCollector());
         super();
      }
      
      public function get currentEmoticon() : uint
      {
         return this._currentEmoticon;
      }
      
      public function set currentEmoticon(emoteId:uint) : void
      {
         this._currentEmoticon = emoteId;
      }
      
      public function get fightNumber() : uint
      {
         return this._fightNumber;
      }
      
      public function get interactiveElements() : Vector.<InteractiveElement>
      {
         return this._interactiveElements;
      }
      
      public function get currentSubAreaId() : uint
      {
         return this._currentSubAreaId;
      }
      
      public function get playersId() : Array
      {
         return this._playersId;
      }
      
      public function get housesInformations() : Dictionary
      {
         return this._housesList;
      }
      
      public function get fights() : Dictionary
      {
         return this._fights;
      }
      
      override public function pushed() : Boolean
      {
         this._playersId = new Array();
         var mirmsg:MapInformationsRequestMessage = new MapInformationsRequestMessage();
         ConnectionsHandler.getConnection().send(mirmsg);
         this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.PARALLEL_LOADER);
         this._loader.addEventListener(ResourceLoadedEvent.LOADED,this.onGroundObjectLoaded);
         this._loader.addEventListener(ResourceErrorEvent.ERROR,this.onGroundObjectLoadFailed);
         this._interactiveElements = new Vector.<InteractiveElement>();
         Dofus.getInstance().options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGED,this.onPropertyChanged);
         return super.pushed();
      }
      
      override public function process(msg:Message) : Boolean
      {
         var apimsg:AtlasPointInformationsMessage = null;
         var mcidmsg:MapComplementaryInformationsDataMessage = null;
         var mapWithNoMonsters:Boolean = false;
         var imumsg:InteractiveMapUpdateMessage = null;
         var smumsg:StatedMapUpdateMessage = null;
         var houseInformations:HouseInformations = null;
         var grpsamsg:GameRolePlayShowActorMessage = null;
         var gcrelmsg:GameContextRefreshEntityLookMessage = null;
         var gmcomsg:GameMapChangeOrientationMessage = null;
         var grsamsg:GameRolePlaySetAnimationMessage = null;
         var characterEntity:AnimatedCharacter = null;
         var cmsmsg:CharacterMovementStoppedMessage = null;
         var characterEntityStopped:AnimatedCharacter = null;
         var grpsclmsg:GameRolePlayShowChallengeMessage = null;
         var gfosumsg:GameFightOptionStateUpdateMessage = null;
         var gfutmsg:GameFightUpdateTeamMessage = null;
         var gfrtmmsg:GameFightRemoveTeamMemberMessage = null;
         var grprcmsg:GameRolePlayRemoveChallengeMessage = null;
         var gcremsg:GameContextRemoveElementMessage = null;
         var playerCompt:uint = 0;
         var mfcmsg:MapFightCountMessage = null;
         var ogamsg:ObjectGroundAddedMessage = null;
         var ogrmsg:ObjectGroundRemovedMessage = null;
         var oglamsg:ObjectGroundListAddedMessage = null;
         var comptObjects:uint = 0;
         var prira:PaddockRemoveItemRequestAction = null;
         var prirmsg:PaddockRemoveItemRequestMessage = null;
         var pmira:PaddockMoveItemRequestAction = null;
         var cursorIcon:Texture = null;
         var iw:ItemWrapper = null;
         var gdpormsg:GameDataPaddockObjectRemoveMessage = null;
         var roleplayContextFrame:RoleplayContextFrame = null;
         var gdpoamsg:GameDataPaddockObjectAddMessage = null;
         var gdpolamsg:GameDataPaddockObjectListAddMessage = null;
         var gdpfoamsg:GameDataPlayFarmObjectAnimationMessage = null;
         var mnqsumsg:MapNpcsQuestStatusUpdateMessage = null;
         var scmsg:ShowCellMessage = null;
         var roleplayContextFrame2:RoleplayContextFrame = null;
         var name:String = null;
         var text:String = null;
         var coord:MapCoordinatesExtended = null;
         var actor:GameRolePlayActorInformations = null;
         var actor1:GameRolePlayActorInformations = null;
         var fight:FightCommonInformations = null;
         var house:HouseInformations = null;
         var houseWrapper:HouseWrapper = null;
         var numDoors:int = 0;
         var i:int = 0;
         var hpmsg:HousePropertiesMessage = null;
         var mo:MapObstacle = null;
         var actor2:GameRolePlayActorInformations = null;
         var rpInfos:GameRolePlayCharacterInformations = null;
         var eprmsg:EmotePlayRequestMessage = null;
         var playerId:uint = 0;
         var objectId:uint = 0;
         var item:PaddockItem = null;
         var cellId:uint = 0;
         var nbnpcq:int = 0;
         var npc:TiphonSprite = null;
         var iq:int = 0;
         var nbnpcnq:int = 0;
         var inq:int = 0;
         var questClip:Sprite = null;
         switch(true)
         {
            case msg is AtlasPointInformationsMessage:
               apimsg = msg as AtlasPointInformationsMessage;
               for each(coord in apimsg.type.coords)
               {
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,"(MESSAGE TEMPORAIRE) Un phénix se trouve sur la map " + coord.worldX + "," + coord.worldY + "(TED)",ChatChannelsMultiEnum.CHANNEL_GLOBAL);
               }
               return true;
            case msg is MapComplementaryInformationsDataMessage:
               mcidmsg = msg as MapComplementaryInformationsDataMessage;
               this._npcList = new Dictionary(true);
               this._fights = new Dictionary();
               this._objects = new Dictionary();
               this._uri = new Dictionary();
               this._paddockItem = new Dictionary();
               _humanNumber = 0;
               this._interactiveElements = mcidmsg.interactiveElements;
               this._fightNumber = mcidmsg.fights.length;
               this._worldPoint = WorldPoint.fromMapId(MapComplementaryInformationsDataMessage(msg).mapId);
               this._currentSubAreaId = MapComplementaryInformationsDataMessage(msg).subareaId;
               PlayedCharacterManager.getInstance().currentMap = this._worldPoint as WorldPoint;
               PlayedCharacterManager.getInstance().currentSubArea = SubArea.getSubAreaById(this._currentSubAreaId);
               TooltipManager.hide();
               updateCreaturesLimit();
               for each(actor in mcidmsg.actors)
               {
                  _humanNumber++;
                  if(_creaturesLimit < 50 && _humanNumber >= _creaturesLimit)
                  {
                     _creaturesMode = true;
                  }
                  else
                  {
                     _creaturesMode = false;
                  }
               }
               mapWithNoMonsters = true;
               for each(actor1 in mcidmsg.actors)
               {
                  this.addOrUpdateActor(actor1);
                  if(mapWithNoMonsters)
                  {
                     if(actor1 is GameRolePlayGroupMonsterInformations)
                     {
                        mapWithNoMonsters = false;
                        KernelEventsManager.getInstance().processCallback(TriggerHookList.MapWithMonsters);
                     }
                  }
               }
               for each(fight in mcidmsg.fights)
               {
                  this.addFight(fight);
               }
               this._housesList = new Dictionary();
               for each(house in mcidmsg.houses)
               {
                  houseWrapper = HouseWrapper.create(house);
                  numDoors = house.doorsOnMap.length;
                  for(i = 0; i < numDoors; i++)
                  {
                     this._housesList[house.doorsOnMap[i]] = houseWrapper;
                  }
                  hpmsg = new HousePropertiesMessage();
                  hpmsg.initHousePropertiesMessage(house);
                  Kernel.getWorker().process(hpmsg);
               }
               for each(mo in mcidmsg.obstacles)
               {
                  InteractiveCellManager.getInstance().updateCell(mo.obstacleCellId,mo.state == MapObstacleStateEnum.OBSTACLE_OPENED);
               }
               imumsg = new InteractiveMapUpdateMessage();
               imumsg.initInteractiveMapUpdateMessage(mcidmsg.interactiveElements);
               Kernel.getWorker().process(imumsg);
               smumsg = new StatedMapUpdateMessage();
               smumsg.initStatedMapUpdateMessage(mcidmsg.statedElements);
               Kernel.getWorker().process(smumsg);
               KernelEventsManager.getInstance().processCallback(HookList.MapComplementaryInformationsData,WorldPoint.fromMapId(MapComplementaryInformationsDataMessage(msg).mapId),this._currentSubAreaId,Dofus.getInstance().options.mapCoordinates);
               KernelEventsManager.getInstance().processCallback(HookList.MapFightCount,0);
               return true;
            case msg is HousePropertiesMessage:
               houseInformations = (msg as HousePropertiesMessage).properties;
               houseWrapper = HouseWrapper.create(houseInformations);
               numDoors = houseInformations.doorsOnMap.length;
               for(i = 0; i < numDoors; i++)
               {
                  this._housesList[houseInformations.doorsOnMap[i]] = houseWrapper;
               }
               KernelEventsManager.getInstance().processCallback(HookList.HouseProperties,houseInformations.houseId,houseInformations.doorsOnMap,houseInformations.ownerName,houseInformations.isOnSale,houseInformations.modelId);
               return true;
            case msg is GameRolePlayShowActorMessage:
               grpsamsg = msg as GameRolePlayShowActorMessage;
               updateCreaturesLimit();
               _humanNumber++;
               if(_creaturesLimit < 50 && _humanNumber >= _creaturesLimit)
               {
                  _creaturesMode = true;
               }
               else
               {
                  _creaturesMode = false;
               }
               if(_creaturesMode)
               {
                  KernelEventsManager.getInstance().processCallback(TriggerHookList.CreaturesMode);
                  for each(actor2 in _entities)
                  {
                     if(!(grpsamsg.informations is GameRolePlayNpcInformations) && grpsamsg.informations is GameRolePlayHumanoidInformations)
                     {
                        updateActorLook(actor2.contextualId,actor2.look);
                     }
                  }
               }
               this.addOrUpdateActor(grpsamsg.informations);
               if(grpsamsg is GameRolePlayCharacterInformations && Boolean(PlayedCharacterManager.getInstance().characteristics.alignmentInfos.pvpEnabled))
               {
                  rpInfos = grpsamsg.informations as GameRolePlayCharacterInformations;
                  switch(PlayedCharacterManager.getInstance().levelDiff(rpInfos.alignmentInfos.characterPower - grpsamsg.informations.contextualId))
                  {
                     case -1:
                        SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_NEW_ENEMY_WEAK);
                        break;
                     case 1:
                        SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_NEW_ENEMY_STRONG);
                  }
               }
               this._bRequestingAura = false;
               return true;
            case msg is GameContextRefreshEntityLookMessage:
               gcrelmsg = msg as GameContextRefreshEntityLookMessage;
               if(!_creaturesMode)
               {
                  updateActorLook(gcrelmsg.id,gcrelmsg.look);
               }
               return true;
            case msg is GameMapChangeOrientationMessage:
               gmcomsg = msg as GameMapChangeOrientationMessage;
               updateActorOrientation(gmcomsg.id,gmcomsg.direction);
               return true;
            case msg is GameRolePlaySetAnimationMessage:
               grsamsg = msg as GameRolePlaySetAnimationMessage;
               characterEntity = DofusEntities.getEntity(grsamsg.informations.contextualId) as AnimatedCharacter;
               if(grsamsg.animation == "AnimStatique")
               {
                  this._currentEmoticon = 0;
                  characterEntity.setAnimation(grsamsg.animation);
               }
               else if(!_creaturesMode)
               {
                  if(!grsamsg.directions8)
                  {
                     if(characterEntity.getDirection() % 2 == 0)
                     {
                        characterEntity.setDirection(characterEntity.getDirection() + 1);
                     }
                  }
                  if(grsamsg.duration > 0)
                  {
                     this._timeout = setTimeout(this.timeoutStop,grsamsg.duration * 100,characterEntity);
                  }
                  else
                  {
                     clearTimeout(this._timeout);
                     if(grsamsg.instant)
                     {
                        characterEntity.addEventListener(TiphonEvent.ANIMATION_END,this.onAnimationEnd);
                        characterEntity.removeEventListener(TiphonEvent.ANIMATION_END,this.onAnimationStatiqueEnd);
                     }
                     else
                     {
                        characterEntity.addEventListener(TiphonEvent.ANIMATION_END,this.onAnimationStatiqueEnd);
                        characterEntity.removeEventListener(TiphonEvent.ANIMATION_END,this.onAnimationEnd);
                     }
                  }
                  characterEntity.setAnimation(grsamsg.animation);
               }
               return true;
            case msg is CharacterMovementStoppedMessage:
               cmsmsg = msg as CharacterMovementStoppedMessage;
               characterEntityStopped = DofusEntities.getEntity(PlayedCharacterManager.getInstance().infos.id) as AnimatedCharacter;
               if(Boolean(OptionManager.getOptionManager("tiphon").alwaysShowAuraOnFront && characterEntityStopped.getDirection() == DirectionsEnum.DOWN) && Boolean(characterEntityStopped.getAnimation() == "AnimStatique") && PlayedCharacterManager.getInstance().state == PlayerLifeStatusEnum.STATUS_ALIVE_AND_KICKING)
               {
                  eprmsg = new EmotePlayRequestMessage();
                  eprmsg.initEmotePlayRequestMessage(22);
                  ConnectionsHandler.getConnection().send(eprmsg);
               }
               return true;
            case msg is GameRolePlayShowChallengeMessage:
               grpsclmsg = msg as GameRolePlayShowChallengeMessage;
               this.addFight(grpsclmsg.commonsInfos);
               return true;
            case msg is GameFightOptionStateUpdateMessage:
               gfosumsg = msg as GameFightOptionStateUpdateMessage;
               if(gfosumsg.option == FightOptionsEnum.FIGHT_OPTION_SET_SECRET)
               {
                  KernelEventsManager.getInstance().processCallback(HookList.GameRolePlayAllowSpectatorInFight,gfosumsg.fightId,!gfosumsg.state);
               }
               this.updateSwordOptions(gfosumsg.fightId,gfosumsg.teamId,gfosumsg.option,gfosumsg.state);
               return true;
            case msg is GameFightUpdateTeamMessage:
               gfutmsg = msg as GameFightUpdateTeamMessage;
               this.updateFight(gfutmsg.fightId,gfutmsg.team);
               return true;
            case msg is GameFightRemoveTeamMemberMessage:
               gfrtmmsg = msg as GameFightRemoveTeamMemberMessage;
               this.removeFighter(gfrtmmsg.fightId,gfrtmmsg.teamId,gfrtmmsg.charId);
               return true;
            case msg is GameRolePlayRemoveChallengeMessage:
               grprcmsg = msg as GameRolePlayRemoveChallengeMessage;
               KernelEventsManager.getInstance().processCallback(HookList.GameRolePlayRemoveFight,grprcmsg.fightId);
               this.removeFight(grprcmsg.fightId);
               return true;
            case msg is GameContextRemoveElementMessage:
               gcremsg = msg as GameContextRemoveElementMessage;
               playerCompt = 0;
               for each(playerId in this._playersId)
               {
                  if(playerId == gcremsg.id)
                  {
                     this._playersId.splice(playerCompt,1);
                  }
                  else
                  {
                     playerCompt++;
                  }
               }
               removeActor(gcremsg.id);
               return true;
            case msg is MapFightCountMessage:
               mfcmsg = msg as MapFightCountMessage;
               trace("Nombre de combat(s) sur la carte : " + mfcmsg.fightCount);
               KernelEventsManager.getInstance().processCallback(HookList.MapFightCount,mfcmsg.fightCount);
               return true;
            case msg is ObjectGroundAddedMessage:
               ogamsg = msg as ObjectGroundAddedMessage;
               this.addObject(ogamsg.objectGID,ogamsg.cellId);
               return true;
            case msg is ObjectGroundRemovedMessage:
               ogrmsg = msg as ObjectGroundRemovedMessage;
               this.removeObject(ogrmsg.cell);
               return true;
            case msg is ObjectGroundListAddedMessage:
               oglamsg = msg as ObjectGroundListAddedMessage;
               comptObjects = 0;
               for each(objectId in oglamsg.referenceIds)
               {
                  this.addObject(objectId,oglamsg.cells[comptObjects]);
                  comptObjects++;
               }
               return true;
            case msg is PaddockRemoveItemRequestAction:
               prira = msg as PaddockRemoveItemRequestAction;
               prirmsg = new PaddockRemoveItemRequestMessage();
               prirmsg.initPaddockRemoveItemRequestMessage(prira.cellId);
               ConnectionsHandler.getConnection().send(prirmsg);
               return true;
            case msg is PaddockMoveItemRequestAction:
               pmira = msg as PaddockMoveItemRequestAction;
               this._currentPaddockItemCellId = pmira.object.disposition.cellId;
               cursorIcon = new Texture();
               iw = ItemWrapper.create(0,0,pmira.object.item.id,0,null,false);
               cursorIcon.uri = iw.iconUri;
               cursorIcon.finalize();
               Kernel.getWorker().addFrame(new RoleplayPointCellFrame(this.onCellPointed,cursorIcon,true));
               return true;
            case msg is GameDataPaddockObjectRemoveMessage:
               gdpormsg = msg as GameDataPaddockObjectRemoveMessage;
               roleplayContextFrame = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
               this.removePaddockItem(gdpormsg.cellId);
               break;
            case msg is GameDataPaddockObjectAddMessage:
               gdpoamsg = msg as GameDataPaddockObjectAddMessage;
               this.addPaddockItem(gdpoamsg.paddockItemDescription);
               break;
            case msg is GameDataPaddockObjectListAddMessage:
               gdpolamsg = msg as GameDataPaddockObjectListAddMessage;
               for each(item in gdpolamsg.paddockItemDescription)
               {
                  this.addPaddockItem(item);
               }
               break;
            case msg is GameDataPlayFarmObjectAnimationMessage:
               gdpfoamsg = msg as GameDataPlayFarmObjectAnimationMessage;
               for each(cellId in gdpfoamsg.cellId)
               {
                  this.activatePaddockItem(cellId);
               }
               break;
            case msg is MapNpcsQuestStatusUpdateMessage:
               mnqsumsg = msg as MapNpcsQuestStatusUpdateMessage;
               if(MapDisplayManager.getInstance().currentMapPoint.mapId == mnqsumsg.mapId)
               {
                  nbnpcq = mnqsumsg.npcsIdsCanGiveQuest.length;
                  for(iq = 0; iq < nbnpcq; iq++)
                  {
                     questClip = new QUEST_CLIP() as Sprite;
                     npc = this._npcList[mnqsumsg.npcsIdsCanGiveQuest[iq]];
                     if(npc)
                     {
                        npc.addBackground("questClip",questClip,true);
                     }
                  }
                  nbnpcnq = mnqsumsg.npcsIdsCannotGiveQuest.length;
                  for(inq = 0; inq < nbnpcnq; inq++)
                  {
                     npc = this._npcList[mnqsumsg.npcsIdsCannotGiveQuest[inq]];
                     if(npc)
                     {
                        npc.removeBackground("questClip");
                     }
                  }
               }
               break;
            case msg is ShowCellMessage:
               scmsg = msg as ShowCellMessage;
               HyperlinkShowCellManager.showCell(scmsg.cellId);
               roleplayContextFrame2 = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
               name = roleplayContextFrame2.getActorName(scmsg.sourceId);
               text = I18n.getText(I18nProxy.getKeyId("ui.fight.showCell"),[name,scmsg.cellId]);
               _log.debug("showcell : " + text);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,text,ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO);
               return true;
         }
         return false;
      }
      
      override public function pulled() : Boolean
      {
         var fight:Fight = null;
         var team:FightTeam = null;
         for each(fight in this._fights)
         {
            for each(team in fight.teams)
            {
               TooltipManager.hide("fightOptions_" + fight.fightId + "_" + team.teamInfos.teamId);
            }
         }
         this._fights = null;
         this._objects = null;
         return super.pulled();
      }
      
      public function isFight(entityId:int) : Boolean
      {
         return _entities[entityId] is FightTeam;
      }
      
      public function isPaddockItem(entityId:int) : Boolean
      {
         return _entities[entityId] is GameContextPaddockItemInformations;
      }
      
      public function getFightTeam(entityId:int) : FightTeam
      {
         return _entities[entityId] as FightTeam;
      }
      
      public function getFightId(entityId:int) : uint
      {
         return (_entities[entityId] as FightTeam).fight.fightId;
      }
      
      public function getFightLeaderId(entityId:int) : uint
      {
         return (_entities[entityId] as FightTeam).teamInfos.leaderId;
      }
      
      override public function addOrUpdateActor(infos:GameContextActorInformations) : AnimatedCharacter
      {
         var questClip:Sprite = null;
         var monstersInfos:GameRolePlayGroupMonsterInformations = null;
         var followersLooks:Vector.<EntityLook> = null;
         var i:uint = 0;
         var underling:MonsterInGroupInformations = null;
         var ac:AnimatedCharacter = super.addOrUpdateActor(infos);
         switch(true)
         {
            case infos is GameRolePlayNpcInformations:
               this._npcList[infos.contextualId] = ac;
               if((infos as GameRolePlayNpcInformations).canGiveQuest)
               {
                  questClip = new QUEST_CLIP() as Sprite;
                  ac.addBackground("questClip",questClip,true);
               }
               if(ac.look.getBone() == 1)
               {
                  ac.animationModifier = new CustomAnimStatiqueAnimationModifier();
               }
               if(Boolean(_creaturesMode) || ac.getAnimation() == "AnimStatique")
               {
                  ac.setAnimation("AnimStatique");
               }
               break;
            case infos is GameRolePlayGroupMonsterInformations:
               if(Dofus.getInstance().options.showEveryMonsters)
               {
                  monstersInfos = infos as GameRolePlayGroupMonsterInformations;
                  followersLooks = new Vector.<EntityLook>(monstersInfos.underlings.length,true);
                  i = 0;
                  for each(underling in monstersInfos.underlings)
                  {
                     followersLooks[i++] = underling.look;
                  }
                  this.manageFollowers(ac,followersLooks);
               }
               break;
            case infos is GameRolePlayHumanoidInformations:
               this._playersId.push(infos.contextualId);
               this.manageFollowers(ac,(infos as GameRolePlayHumanoidInformations).humanoidInfo.followingCharactersLook);
               if(ac.look.getBone() == 1)
               {
                  ac.animationModifier = new CustomAnimStatiqueAnimationModifier();
               }
               if(Boolean(_creaturesMode) || ac.getAnimation() == "AnimStatique")
               {
                  ac.setAnimation("AnimStatique");
               }
               break;
            case infos is GameRolePlayMerchantInformations:
               if(ac.look.getBone() == 1)
               {
                  ac.animationModifier = new CustomAnimStatiqueAnimationModifier();
               }
               if(Boolean(_creaturesMode) || ac.getAnimation() == "AnimStatique")
               {
                  ac.setAnimation("AnimStatique");
               }
               trace("Affichage d\'un personnage en mode marchand");
               break;
            case infos is GameRolePlayTaxCollectorInformations:
            case infos is GameRolePlayPrismInformations:
               break;
            default:
               _log.warn("Unknown GameRolePlayActorInformations type : " + infos + ".");
         }
         return ac;
      }
      
      private function manageFollowers(char:AnimatedCharacter, followers:Vector.<EntityLook>) : void
      {
         var addedF:int = 0;
         var followerEntityLook:TiphonEntityLook = null;
         var followerEntityA:AnimatedCharacter = null;
         var oldFollower:* = undefined;
         var oldFollowersNumber:uint = !!char.followers?uint(char.followers.length):uint(0);
         var nbNewFollowers:int = followers.length - oldFollowersNumber;
         if(nbNewFollowers > 0)
         {
            for(addedF = 0; addedF < nbNewFollowers; addedF++)
            {
               followerEntityLook = EntityLookAdapter.fromNetwork(followers[oldFollowersNumber + addedF]);
               followerEntityA = new AnimatedCharacter(EntitiesManager.getInstance().getFreeEntityId(),followerEntityLook,char);
               char.addFollower(followerEntityA);
            }
         }
         else if(nbNewFollowers < 0)
         {
            for each(oldFollower in char.followers)
            {
               if(followers.lastIndexOf(oldFollower) == -1)
               {
                  char.removeFollower(oldFollower);
                  nbNewFollowers++;
               }
            }
         }
      }
      
      private function addFight(infos:FightCommonInformations) : void
      {
         var team:FightTeamInformations = null;
         var teamEntity:IEntity = null;
         var fightTeam:FightTeam = null;
         var teams:Vector.<FightTeam> = new Vector.<FightTeam>(0,false);
         var fight:Fight = new Fight(infos.fightId,teams);
         var teamCounter:uint = 0;
         for each(team in infos.fightTeams)
         {
            teamEntity = RolePlayEntitiesFactory.createFightEntity(infos,team,MapPoint.fromCellId(infos.fightTeamsPositions[teamCounter]));
            (teamEntity as IDisplayable).display();
            fightTeam = new FightTeam(fight,team.teamId,teamEntity,team,infos.fightTeamsOptions[team.teamId]);
            _entities[teamEntity.id] = fightTeam;
            teams.push(fightTeam);
            teamCounter++;
         }
         this._fights[infos.fightId] = fight;
         for each(team in infos.fightTeams)
         {
            this.updateSwordOptions(infos.fightId,team.teamId);
         }
      }
      
      private function addObject(pObjectUID:uint, pCellId:uint) : void
      {
         var objectUri:Uri = new Uri(LangManager.getInstance().getEntry("config.gfx.path.item.vector") + Item.getItemById(pObjectUID).iconId + ".swf");
         var objectEntity:IInteractive = new RoleplayObjectEntity(pObjectUID,MapPoint.fromCellId(pCellId));
         (objectEntity as IDisplayable).display();
         var groundObject:GameContextActorInformations = new GroundObject(Item.getItemById(pObjectUID));
         groundObject.contextualId = objectEntity.id;
         groundObject.disposition.cellId = pCellId;
         groundObject.disposition.direction = DirectionsEnum.DOWN_RIGHT;
         if(this._objects == null)
         {
            this._objects = new Dictionary();
         }
         this._objects[objectUri] = objectEntity;
         this._uri[pCellId] = this._objects[objectUri];
         _entities[objectEntity.id] = groundObject;
         this._loader.load(objectUri);
      }
      
      private function removeObject(pCellId:uint) : void
      {
         (this._uri[pCellId] as IDisplayable).remove();
         delete this._objects[this._uri[pCellId]];
         delete _entities[this._uri[pCellId].id];
         delete this._uri[pCellId];
      }
      
      private function updateFight(fightId:uint, team:FightTeamInformations) : void
      {
         var newMember:FightTeamMemberInformations = null;
         var teamMemberIsMonster:Boolean = false;
         var newTeamMemberIsMonster:Boolean = false;
         var teamMemberId:int = 0;
         var newTeamMemberId:int = 0;
         var present:Boolean = false;
         var teamMember:FightTeamMemberInformations = null;
         var fight:Fight = this._fights[fightId];
         if(fight == null)
         {
            return;
         }
         var fightTeam:FightTeam = fight.getTeamByType(team.teamId);
         var tInfo:FightTeamInformations = (_entities[fightTeam.teamEntity.id] as FightTeam).teamInfos;
         if(tInfo.teamMembers == team.teamMembers)
         {
            return;
         }
         for each(newMember in team.teamMembers)
         {
            teamMemberIsMonster = false;
            newTeamMemberIsMonster = false;
            if(newMember is FightTeamMemberMonsterInformations)
            {
               newTeamMemberIsMonster = true;
               newTeamMemberId = (newMember as FightTeamMemberMonsterInformations).monsterId;
            }
            else
            {
               newTeamMemberId = newMember.id;
            }
            present = false;
            for each(teamMember in tInfo.teamMembers)
            {
               if(teamMember is FightTeamMemberMonsterInformations)
               {
                  teamMemberIsMonster = true;
                  teamMemberId = (teamMember as FightTeamMemberMonsterInformations).monsterId;
               }
               else
               {
                  teamMemberId = teamMember.id;
               }
               if(teamMemberId == newTeamMemberId)
               {
                  present = true;
               }
            }
            if(!present)
            {
               tInfo.teamMembers.push(newMember);
            }
         }
      }
      
      private function removeFighter(fightId:uint, teamId:uint, charId:int) : void
      {
         var member:FightTeamMemberInformations = null;
         var fight:Fight = this._fights[fightId];
         var fightTeam:FightTeam = fight.getTeamByType(teamId);
         var teamInfos:FightTeamInformations = fightTeam.teamInfos;
         var newMembers:Vector.<FightTeamMemberInformations> = new Vector.<FightTeamMemberInformations>(0,false);
         for each(member in teamInfos.teamMembers)
         {
            if(member.id != charId)
            {
               newMembers.push(member);
            }
         }
         teamInfos.teamMembers = newMembers;
      }
      
      private function removeFight(fightId:uint) : void
      {
         var team:FightTeam = null;
         var fight:Fight = this._fights[fightId];
         if(fight == null)
         {
            return;
         }
         for each(team in fight.teams)
         {
            (team.teamEntity as IDisplayable).remove();
            TooltipManager.hide("fightOptions_" + fightId + "_" + team.teamInfos.teamId);
            delete _entities[team.teamEntity.id];
         }
         delete this._fights[fightId];
      }
      
      private function addPaddockItem(item:PaddockItem) : void
      {
         var i:Item = Item.getItemById(item.objectGID);
         var gcpii:GameContextPaddockItemInformations = new GameContextPaddockItemInformations(i.appearance,item.cellId,item.durability,i);
         var e:IEntity = this.addOrUpdateActor(gcpii);
         this._paddockItem[item.cellId] = e;
      }
      
      private function removePaddockItem(cellId:uint) : void
      {
         var e:IEntity = this._paddockItem[cellId];
         if(!e)
         {
            return;
         }
         (e as IDisplayable).remove();
         delete this._paddockItem[cellId];
      }
      
      private function activatePaddockItem(cellId:uint) : void
      {
         var seq:SerialSequencer = null;
         var item:TiphonSprite = this._paddockItem[cellId];
         if(item)
         {
            seq = new SerialSequencer();
            seq.addStep(new PlayAnimationStep(item,"AnimHit"));
            seq.addStep(new PlayAnimationStep(item,"AnimStatique"));
            seq.start();
         }
      }
      
      private function updateSwordOptions(fightId:uint, teamId:uint, option:int = -1, state:Boolean = false) : void
      {
         var opt:* = undefined;
         var fight:Fight = this._fights[fightId];
         var fightTeam:FightTeam = fight.getTeamByType(teamId);
         if(fightTeam == null)
         {
            return;
         }
         if(option != -1)
         {
            fightTeam.teamOptions[option] = state;
         }
         var textures:Vector.<String> = new Vector.<String>();
         for(opt in fightTeam.teamOptions)
         {
            if(fightTeam.teamOptions[opt])
            {
               textures.push("fightOption" + opt);
            }
         }
         TooltipManager.show(textures,(fightTeam.teamEntity as IDisplayable).absoluteBounds,UiModuleManager.getInstance().getModule("Ankama_Tooltips"),false,"fightOptions_" + fightId + "_" + teamId,LocationEnum.POINT_BOTTOM,LocationEnum.POINT_TOP,0,true,null,UiApi.api_namespace::defaultTooltipUiScript);
      }
      
      private function onGroundObjectLoaded(e:ResourceLoadedEvent) : void
      {
         var objectMc:MovieClip = e.resource;
         objectMc.x = objectMc.x - objectMc.width / 2;
         objectMc.y = objectMc.y - objectMc.height / 2;
         this._objects[e.uri].addChild(objectMc);
      }
      
      private function onGroundObjectLoadFailed(e:ResourceErrorEvent) : void
      {
         trace("l\'objet au sol n\'a pas pu être chargé / uri : " + e.uri);
      }
      
      public function timeoutStop(character:AnimatedCharacter) : void
      {
         clearTimeout(this._timeout);
         character.setAnimation("AnimStatique");
         this._currentEmoticon = 0;
      }
      
      private function onAnimationEnd(e:TiphonEvent) : void
      {
         e.currentTarget.removeEventListener(TiphonEvent.ANIMATION_END,this.onAnimationEnd);
         this._currentEmoticon = 0;
         e.currentTarget.setAnimation("AnimStatique");
      }
      
      private function onPropertyChanged(e:PropertyChangeEvent) : void
      {
         if(e.propertyName == "mapCoordinates")
         {
            KernelEventsManager.getInstance().processCallback(HookList.MapComplementaryInformationsData,this._worldPoint,this._currentSubAreaId,e.propertyValue);
         }
      }
      
      private function onAnimationStatiqueEnd(e:TiphonEvent) : void
      {
         e.currentTarget.removeEventListener(TiphonEvent.ANIMATION_END,this.onAnimationStatiqueEnd);
         var animNam:String = e.currentTarget.getAnimation();
         var name:String = animNam.replace("_","_Statique_");
         e.currentTarget.setAnimation(name);
         if(e.currentTarget.getAnimation() == "AnimStatique")
         {
            this._currentEmoticon = 0;
         }
      }
      
      private function onCellPointed(success:Boolean, cellId:uint, entityId:int) : void
      {
         var m:PaddockMoveItemRequestMessage = null;
         if(success)
         {
            m = new PaddockMoveItemRequestMessage();
            m.initPaddockMoveItemRequestMessage(this._currentPaddockItemCellId,cellId);
            ConnectionsHandler.getConnection().send(m);
         }
      }
   }
}
