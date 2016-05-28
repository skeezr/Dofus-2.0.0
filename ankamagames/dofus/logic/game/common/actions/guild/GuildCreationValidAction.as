package com.ankamagames.dofus.logic.game.common.actions.guild
{
   import com.ankamagames.jerakine.handlers.messages.Action;
   
   public class GuildCreationValidAction implements Action
   {
       
      private var _guildName:String;
      
      private var _upEmblemId:uint;
      
      private var _upColorEmblem:uint;
      
      private var _backEmblemId:uint;
      
      private var _backColorEmblem:uint;
      
      public function GuildCreationValidAction()
      {
         super();
      }
      
      public static function create(pGuildName:String, pUpEmblemId:uint, pUpColorEmblem:uint, pBackEmblemId:uint, pBackColorEmblem:uint) : GuildCreationValidAction
      {
         var action:GuildCreationValidAction = new GuildCreationValidAction();
         action._guildName = pGuildName;
         action._upEmblemId = pUpEmblemId;
         action._upColorEmblem = pUpColorEmblem;
         action._backEmblemId = pBackEmblemId;
         action._backColorEmblem = pBackColorEmblem;
         return action;
      }
      
      public function get guildName() : String
      {
         return this._guildName;
      }
      
      public function get upEmblemId() : uint
      {
         return this._upEmblemId;
      }
      
      public function get upColorEmblem() : uint
      {
         return this._upColorEmblem;
      }
      
      public function get backEmblemId() : uint
      {
         return this._backEmblemId;
      }
      
      public function get backColorEmblem() : uint
      {
         return this._backColorEmblem;
      }
   }
}
