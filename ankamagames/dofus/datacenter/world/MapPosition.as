package com.ankamagames.dofus.datacenter.world
{
   import com.ankamagames.jerakine.types.DataStoreType;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.dofus.datacenter.ambientSounds.AmbientSound;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.jerakine.types.enums.DataStoreEnum;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class MapPosition
   {
      
      private static const MODULE:String = "MapPositions";
      
      private static const DST:DataStoreType = new DataStoreType(MODULE,true,DataStoreEnum.LOCATION_LOCAL,DataStoreEnum.BIND_COMPUTER);
      
      private static const CAPABILITY_ALLOW_CHALLENGE:int = 1;
      
      private static const CAPABILITY_ALLOW_AGGRESSION:int = 2;
      
      private static const CAPABILITY_ALLOW_TELEPORT_TO:int = 4;
      
      private static const CAPABILITY_ALLOW_TELEPORT_FROM:int = 8;
      
      private static const CAPABILITY_ALLOW_EXCHANGES_BETWEEN_PLAYERS:int = 16;
      
      private static const CAPABILITY_ALLOW_HUMAN_VENDOR:int = 32;
      
      private static const CAPABILITY_ALLOW_COLLECTOR:int = 64;
      
      private static const CAPABILITY_ALLOW_SOUL_CAPTURE:int = 128;
      
      private static const CAPABILITY_ALLOW_SOUL_SUMMON:int = 256;
      
      private static const CAPABILITY_ALLOW_TAVERN_REGEN:int = 512;
      
      private static const CAPABILITY_ALLOW_TOMB_MODE:int = 1024;
      
      private static const CAPABILITY_ALLOW_TELEPORT_EVERYWHERE:int = 2048;
      
      private static const CAPABILITY_ALLOW_FIGHT_CHALLENGES:int = 4096;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(MapPosition));
      
      public static var coordonates:Array;
       
      public var id:int;
      
      public var posX:int;
      
      public var posY:int;
      
      public var outdoor:Boolean;
      
      public var capabilities:int;
      
      public var nameId:int;
      
      public var sounds:Vector.<AmbientSound>;
      
      public function MapPosition()
      {
         super();
      }
      
      public static function getMapPositionById(id:int) : MapPosition
      {
         return GameData.getObject(MODULE,id) as MapPosition;
      }
      
      public static function getMapPositions() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(id:int, posX:int, posY:int, outdoor:Boolean, capabilities:int, nameId:uint, pSounds:Vector.<AmbientSound>) : MapPosition
      {
         if(!coordonates)
         {
            coordonates = new Array();
         }
         if(!coordonates[posX])
         {
            coordonates[posX] = new Array();
         }
         if(!coordonates[posX][posY])
         {
            coordonates[posX][posY] = new Array();
         }
         var o:MapPosition = new MapPosition();
         o.id = id;
         o.posX = posX;
         o.posY = posY;
         o.outdoor = outdoor;
         o.capabilities = capabilities;
         o.nameId = nameId;
         o.sounds = pSounds;
         coordonates[posX][posY].push(id);
         return o;
      }
      
      public static function endCreateSequence() : void
      {
         StoreDataManager.getInstance().setData(DST,"coordonates",coordonates);
      }
      
      public static function getMapIdByCoord(x:int, y:int) : Array
      {
         if(!coordonates)
         {
            coordonates = StoreDataManager.getInstance().getData(DST,"coordonates");
         }
         if(!coordonates[x])
         {
            return null;
         }
         return coordonates[x][y];
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
      
      public function get allowChallenge() : Boolean
      {
         return (this.capabilities & CAPABILITY_ALLOW_CHALLENGE) != 0;
      }
      
      public function get allowAggression() : Boolean
      {
         return (this.capabilities & CAPABILITY_ALLOW_AGGRESSION) != 0;
      }
      
      public function get allowTeleportTo() : Boolean
      {
         return (this.capabilities & CAPABILITY_ALLOW_TELEPORT_TO) != 0;
      }
      
      public function get allowTeleportFrom() : Boolean
      {
         return (this.capabilities & CAPABILITY_ALLOW_TELEPORT_FROM) != 0;
      }
      
      public function get allowExchanges() : Boolean
      {
         return (this.capabilities & CAPABILITY_ALLOW_EXCHANGES_BETWEEN_PLAYERS) != 0;
      }
      
      public function get allowHumanVendor() : Boolean
      {
         return (this.capabilities & CAPABILITY_ALLOW_HUMAN_VENDOR) != 0;
      }
      
      public function get allowTaxCollector() : Boolean
      {
         return (this.capabilities & CAPABILITY_ALLOW_COLLECTOR) != 0;
      }
      
      public function get allowSoulCapture() : Boolean
      {
         return (this.capabilities & CAPABILITY_ALLOW_SOUL_CAPTURE) != 0;
      }
      
      public function get allowSoulSummon() : Boolean
      {
         return (this.capabilities & CAPABILITY_ALLOW_SOUL_SUMMON) != 0;
      }
      
      public function get allowTavernRegen() : Boolean
      {
         return (this.capabilities & CAPABILITY_ALLOW_TAVERN_REGEN) != 0;
      }
      
      public function get allowTombMode() : Boolean
      {
         return (this.capabilities & CAPABILITY_ALLOW_TOMB_MODE) != 0;
      }
      
      public function get allowTeleportEverywhere() : Boolean
      {
         return (this.capabilities & CAPABILITY_ALLOW_TELEPORT_EVERYWHERE) != 0;
      }
      
      public function get allowFightChallenges() : Boolean
      {
         return (this.capabilities & CAPABILITY_ALLOW_FIGHT_CHALLENGES) != 0;
      }
   }
}
