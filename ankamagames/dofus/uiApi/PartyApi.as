package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.dofus.logic.game.common.frames.PartyManagementFrame;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class PartyApi
   {
       
      private var _module:UiModule;
      
      protected var _log:Logger;
      
      private var _partyManagementFrame:PartyManagementFrame;
      
      public function PartyApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(PartyApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(value:UiModule) : void
      {
         this._module = value;
      }
      
      [Untrusted]
      public function getPartyMembers() : Object
      {
         if(this._partyManagementFrame == null)
         {
            this._partyManagementFrame = Kernel.getWorker().getFrame(PartyManagementFrame) as PartyManagementFrame;
         }
         return this._partyManagementFrame.partyMembers;
      }
      
      [Untrusted]
      public function getPartyLeaderId() : int
      {
         var pMember:Object = null;
         for each(pMember in this._partyManagementFrame.partyMembers)
         {
            trace("vnzvnczeion");
            if(pMember.isLeader)
            {
               return pMember.infos.id;
            }
         }
         return -1;
      }
      
      [Untrusted]
      public function isInParty(pPlayerId:uint) : Boolean
      {
         var pMember:Object = null;
         for each(pMember in this._partyManagementFrame.partyMembers)
         {
            if(pPlayerId == pMember.infos.id)
            {
               return true;
            }
         }
         return false;
      }
      
      [Untrusted]
      public function getAllMemberFollowPlayerId() : uint
      {
         if(this._partyManagementFrame == null)
         {
            this._partyManagementFrame = Kernel.getWorker().getFrame(PartyManagementFrame) as PartyManagementFrame;
         }
         return this._partyManagementFrame.allMemberFollowPlayerId;
      }
   }
}
