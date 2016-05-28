package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEntitiesFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayInteractivesFrame;
   import com.ankamagames.dofus.logic.game.common.frames.SpellInventoryManagementFrame;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayEmoticonFrame;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.internalDatacenter.communication.EmoteWrapper;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class RoleplayApi
   {
       
      private var _module:UiModule;
      
      protected var _log:Logger;
      
      private var _entitiesFrame:RoleplayEntitiesFrame;
      
      private var _interactivesFrame:RoleplayInteractivesFrame;
      
      private var _spellInventoryManagementFrame:SpellInventoryManagementFrame;
      
      private var _emoticonFrame:RoleplayEmoticonFrame;
      
      public function RoleplayApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(RoleplayApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(value:UiModule) : void
      {
         this._module = value;
      }
      
      [Untrusted]
      public function getTotalFightOnCurrentMap() : uint
      {
         if(this._entitiesFrame == null)
         {
            this._entitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         }
         return this._entitiesFrame.fightNumber;
      }
      
      [Untrusted]
      public function getFullSpellList() : Object
      {
         if(this._spellInventoryManagementFrame == null)
         {
            this._spellInventoryManagementFrame = Kernel.getWorker().getFrame(SpellInventoryManagementFrame) as SpellInventoryManagementFrame;
         }
         return this._spellInventoryManagementFrame.fullSpellList;
      }
      
      [Untrusted]
      public function getSpellToForgetList() : Array
      {
         var spell:SpellWrapper = null;
         var spellList:Array = new Array();
         for each(spell in PlayedCharacterManager.getInstance().spellsInventory)
         {
            if(spell.spellLevel > 1)
            {
               spellList.push(spell);
            }
         }
         return spellList;
      }
      
      [Untrusted]
      public function getEmotesList() : Array
      {
         var emoteId:* = undefined;
         var list:Array = new Array();
         var pos:uint = 0;
         if(this._emoticonFrame == null)
         {
            this._emoticonFrame = Kernel.getWorker().getFrame(RoleplayEmoticonFrame) as RoleplayEmoticonFrame;
         }
         for each(emoteId in this._emoticonFrame.emotes)
         {
            list.push(EmoteWrapper.create(pos,emoteId));
            pos++;
         }
         return list;
      }
      
      [Untrusted]
      public function getSpawnMap() : uint
      {
         if(this._interactivesFrame == null)
         {
            this._interactivesFrame = Kernel.getWorker().getFrame(RoleplayInteractivesFrame) as RoleplayInteractivesFrame;
         }
         return this._interactivesFrame.spawnMapId;
      }
      
      [Untrusted]
      public function getPlayersIdOnCurrentMap() : Array
      {
         if(this._entitiesFrame == null)
         {
            this._entitiesFrame = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
         }
         return this._entitiesFrame.playersId;
      }
   }
}
