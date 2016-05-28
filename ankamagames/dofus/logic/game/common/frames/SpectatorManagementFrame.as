package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapRunningFightListRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapRunningFightListMessage;
   import com.ankamagames.dofus.logic.game.common.actions.spectator.MapRunningFightDetailsRequestAction;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapRunningFightDetailsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.context.roleplay.MapRunningFightDetailsMessage;
   import com.ankamagames.dofus.logic.game.common.actions.spectator.JoinAsSpectatorRequestAction;
   import com.ankamagames.dofus.network.messages.game.context.fight.GameFightJoinRequestMessage;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.HookList;
   import com.ankamagames.dofus.datacenter.monsters.Monster;
   import com.ankamagames.dofus.logic.game.common.actions.OpenCurrentFightAction;
   
   public class SpectatorManagementFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(SpectatorManagementFrame));
       
      private var _rpContextFrame:RoleplayContextFrame;
      
      public function SpectatorManagementFrame(parentFrame:RoleplayContextFrame)
      {
         super();
         this._rpContextFrame = parentFrame;
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var mrflrmsg:MapRunningFightListRequestMessage = null;
         var mrflmsg:MapRunningFightListMessage = null;
         var mrfdra:MapRunningFightDetailsRequestAction = null;
         var mrfdrmsg:MapRunningFightDetailsRequestMessage = null;
         var mrfdmsg:MapRunningFightDetailsMessage = null;
         var usableNames:Vector.<String> = null;
         var jasra:JoinAsSpectatorRequestAction = null;
         var gfjrmsg:GameFightJoinRequestMessage = null;
         var idName:String = null;
         var test:* = undefined;
         switch(true)
         {
            case msg is OpenCurrentFightAction:
               mrflrmsg = new MapRunningFightListRequestMessage();
               mrflrmsg.initMapRunningFightListRequestMessage();
               ConnectionsHandler.getConnection().send(mrflrmsg);
               return true;
            case msg is MapRunningFightListMessage:
               mrflmsg = msg as MapRunningFightListMessage;
               KernelEventsManager.getInstance().processCallback(HookList.MapRunningFightList,mrflmsg.fights);
               return true;
            case msg is MapRunningFightDetailsRequestAction:
               mrfdra = msg as MapRunningFightDetailsRequestAction;
               mrfdrmsg = new MapRunningFightDetailsRequestMessage();
               mrfdrmsg.initMapRunningFightDetailsRequestMessage(mrfdra.fightId);
               ConnectionsHandler.getConnection().send(mrfdrmsg);
               return true;
            case msg is MapRunningFightDetailsMessage:
               mrfdmsg = msg as MapRunningFightDetailsMessage;
               usableNames = new Vector.<String>();
               for each(idName in mrfdmsg.names)
               {
                  test = int(idName).toString() == idName;
                  if(!test)
                  {
                     usableNames.push(idName);
                  }
                  else
                  {
                     usableNames.push(Monster.getMonsterById(uint(idName)).name);
                  }
               }
               KernelEventsManager.getInstance().processCallback(HookList.MapRunningFightDetails,mrfdmsg.fightId,usableNames,mrfdmsg.levels,mrfdmsg.teamSwap,mrfdmsg.alives);
               return true;
            case msg is JoinAsSpectatorRequestAction:
               jasra = msg as JoinAsSpectatorRequestAction;
               gfjrmsg = new GameFightJoinRequestMessage();
               gfjrmsg.initGameFightJoinRequestMessage(jasra.fightId);
               ConnectionsHandler.getConnection().send(gfjrmsg);
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
