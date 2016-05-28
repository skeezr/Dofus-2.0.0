package com.ankamagames.dofus.datacenter.servers
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.data.I18n;
   
   public class Server
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(Server));
      
      private static const MODULE:String = "Servers";
       
      public var id:int;
      
      public var nameId:uint;
      
      public var commentId:uint;
      
      public var rulesId:uint;
      
      public var openingDate:Number;
      
      public var language:String;
      
      public var populationId:int;
      
      public var gameTypeId:uint;
      
      public var communityId:int;
      
      public var restrictedToLanguages:Vector.<String>;
      
      public function Server()
      {
         super();
      }
      
      public static function getServerById(id:int) : Server
      {
         return GameData.getObject(MODULE,id) as Server;
      }
      
      public static function getServers() : Array
      {
         return GameData.getObjects(MODULE);
      }
      
      public static function create(id:int, nameId:uint, commentId:uint, openingDate:Number, lang:String, populationId:uint, gameTypeId:uint, communityId:uint, restricLang:Vector.<String>) : Server
      {
         var o:Server = new Server();
         o.id = id;
         o.nameId = nameId;
         o.commentId = commentId;
         o.openingDate = openingDate;
         o.language = lang;
         o.populationId = populationId;
         o.gameTypeId = gameTypeId;
         o.communityId = communityId;
         o.restrictedToLanguages = restricLang;
         return o;
      }
      
      public function get name() : String
      {
         return I18n.getText(this.nameId);
      }
      
      public function get comment() : String
      {
         return I18n.getText(this.commentId);
      }
      
      public function get rules() : String
      {
         return I18n.getText(this.rulesId);
      }
      
      public function get gameType() : ServerGameType
      {
         return ServerGameType.getServerGameTypeById(this.gameTypeId);
      }
      
      public function get community() : ServerCommunity
      {
         return ServerCommunity.getServerCommunityById(this.communityId);
      }
      
      public function get population() : ServerPopulation
      {
         return ServerPopulation.getServerPopulationById(this.populationId);
      }
   }
}
