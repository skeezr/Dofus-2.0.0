package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.logic.game.roleplay.actions.SpellSetPositionAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellMoveMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.SpellMovementMessage;
   import com.ankamagames.dofus.internalDatacenter.spells.SpellWrapper;
   import com.ankamagames.dofus.network.messages.game.inventory.spells.SpellListMessage;
   import com.ankamagames.dofus.datacenter.breeds.Breed;
   import com.ankamagames.dofus.network.types.game.data.items.SpellItem;
   import com.ankamagames.dofus.datacenter.spells.Spell;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   
   public class SpellInventoryManagementFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpellInventoryManagementFrame));
       
      private var _fullSpellList:Array;
      
      public function SpellInventoryManagementFrame()
      {
         this._fullSpellList = new Array();
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get fullSpellList() : Array
      {
         return this._fullSpellList;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var sspa:SpellSetPositionAction = null;
         var smmsg:SpellMoveMessage = null;
         var spellmmsg:SpellMovementMessage = null;
         var spellItemMoved:SpellWrapper = null;
         var slmsg:SpellListMessage = null;
         var playerBreed:Breed = null;
         var spellsList:Array = null;
         var spell:SpellItem = null;
         var swBreed:Spell = null;
         var spellAllreadyIn:Boolean = false;
         var spellItem:SpellItem = null;
         var swrapper:SpellWrapper = null;
         var spellIdLevel0:uint = 0;
         var spellIt:SpellItem = null;
         var sw:SpellWrapper = null;
         switch(true)
         {
            case msg is SpellSetPositionAction:
               sspa = msg as SpellSetPositionAction;
               smmsg = new SpellMoveMessage();
               smmsg.initSpellMoveMessage(sspa.spellID,sspa.position);
               ConnectionsHandler.getConnection().send(smmsg);
               return true;
            case msg is SpellMovementMessage:
               spellmmsg = msg as SpellMovementMessage;
               spellItemMoved = SpellWrapper.getSpellWrapperById(spellmmsg.spellId,PlayedCharacterManager.getInstance().id);
               if(spellItemMoved)
               {
                  spellItemMoved.position = spellmmsg.position;
                  KernelEventsManager.getInstance().processCallback(HookList.SpellList,PlayedCharacterManager.getInstance().spellsInventory);
                  KernelEventsManager.getInstance().processCallback(HookList.SpellMovement,spellmmsg.spellId,spellmmsg.position);
               }
               else
               {
                  _log.error("Impossible de retrouver spell " + spellmmsg.spellId + " dans le cache de spell");
               }
               return true;
            case msg is SpellListMessage:
               slmsg = msg as SpellListMessage;
               for each(spell in slmsg.spells)
               {
                  this._fullSpellList.push(SpellWrapper.create(spell.position,spell.spellId,spell.spellLevel,true,PlayedCharacterManager.getInstance().id));
               }
               playerBreed = Breed.getBreedById(PlayedCharacterManager.getInstance().infos.breed);
               for each(swBreed in playerBreed.breedSpells)
               {
                  spellAllreadyIn = false;
                  for each(spellItem in slmsg.spells)
                  {
                     swrapper = SpellWrapper.create(spellItem.position,spellItem.spellId,spellItem.spellLevel,false);
                     spellIdLevel0 = swrapper.spell.spellLevels[0];
                     if(spellIdLevel0 == swBreed.spellLevels[0])
                     {
                        spellAllreadyIn = true;
                     }
                  }
                  if(!spellAllreadyIn)
                  {
                     this._fullSpellList.push(SpellWrapper.create(0,swBreed.id,1,true,PlayedCharacterManager.getInstance().id));
                  }
               }
               spellsList = new Array();
               for each(spellIt in slmsg.spells)
               {
                  sw = SpellWrapper.create(spellIt.position,spellIt.spellId,spellIt.spellLevel,true,PlayedCharacterManager.getInstance().id);
                  spellsList.push(sw);
               }
               PlayedCharacterManager.getInstance().spellsInventory = spellsList;
               KernelEventsManager.getInstance().processCallback(HookList.SpellList,spellsList);
               return true;
            default:
               return false;
         }
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
   }
}
