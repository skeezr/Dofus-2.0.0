package com.ankamagames.dofus.logic.game.common.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.enums.Priority;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.dofus.logic.game.common.actions.alignment.GetPVPActivationCostAction;
   import com.ankamagames.dofus.network.messages.game.pvp.GetPVPActivationCostMessage;
   import com.ankamagames.dofus.logic.game.common.actions.alignment.SetEnablePVPRequestAction;
   import com.ankamagames.dofus.network.messages.game.pvp.SetEnablePVPRequestMessage;
   import com.ankamagames.dofus.network.messages.game.pvp.PVPActivationCostMessage;
   import com.ankamagames.dofus.network.messages.game.pvp.AlignmentRankUpdateMessage;
   import com.ankamagames.dofus.network.messages.game.pvp.AlignmentSubAreasListMessage;
   import com.ankamagames.dofus.network.messages.game.pvp.AlignmentAreaUpdateMessage;
   import com.ankamagames.dofus.datacenter.world.Area;
   import com.ankamagames.dofus.datacenter.alignments.AlignmentSide;
   import com.ankamagames.dofus.network.messages.game.pvp.AlignmentSubAreaUpdateMessage;
   import com.ankamagames.dofus.datacenter.world.SubArea;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.dofus.misc.lists.AlignmentHookList;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.dofus.misc.lists.ChatHookList;
   import com.ankamagames.dofus.network.enums.ChatChannelsMultiEnum;
   
   public class AlignmentFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(PrismFrame));
       
      private var _activationCost:int;
      
      private var _alignmentRank:int = -1;
      
      private var _angelsSubAreas:Vector.<int>;
      
      private var _evilsSubAreas:Vector.<int>;
      
      public function AlignmentFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.NORMAL;
      }
      
      public function get activationCost() : int
      {
         return this._activationCost;
      }
      
      public function get angelsSubAreas() : Vector.<int>
      {
         return this._angelsSubAreas.concat();
      }
      
      public function get evilsSubAreas() : Vector.<int>
      {
         return this._evilsSubAreas.concat();
      }
      
      public function get playerRank() : int
      {
         return this._alignmentRank;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function process(msg:Message) : Boolean
      {
         var gpacact:GetPVPActivationCostAction = null;
         var gpacmsg:GetPVPActivationCostMessage = null;
         var sepract:SetEnablePVPRequestAction = null;
         var seprmsg:SetEnablePVPRequestMessage = null;
         var pacmsg:PVPActivationCostMessage = null;
         var arumsg:AlignmentRankUpdateMessage = null;
         var asalmsg:AlignmentSubAreasListMessage = null;
         var aaumsg:AlignmentAreaUpdateMessage = null;
         var area:Area = null;
         var side:AlignmentSide = null;
         var text:String = null;
         var asaumsg:AlignmentSubAreaUpdateMessage = null;
         var subArea:SubArea = null;
         switch(true)
         {
            case msg is GetPVPActivationCostAction:
               gpacact = msg as GetPVPActivationCostAction;
               gpacmsg = new GetPVPActivationCostMessage();
               gpacmsg.initGetPVPActivationCostMessage();
               ConnectionsHandler.getConnection().send(gpacmsg);
               return true;
            case msg is SetEnablePVPRequestAction:
               sepract = msg as SetEnablePVPRequestAction;
               seprmsg = new SetEnablePVPRequestMessage();
               seprmsg.enable = sepract.enable;
               ConnectionsHandler.getConnection().send(seprmsg);
               return true;
            case msg is PVPActivationCostMessage:
               pacmsg = msg as PVPActivationCostMessage;
               this._activationCost = pacmsg.cost;
               KernelEventsManager.getInstance().processCallback(AlignmentHookList.GetActivationCost,pacmsg.cost);
               return true;
            case msg is AlignmentRankUpdateMessage:
               arumsg = msg as AlignmentRankUpdateMessage;
               this._alignmentRank = arumsg.alignmentRank;
               if(arumsg.verbose)
               {
                  KernelEventsManager.getInstance().processCallback(AlignmentHookList.AlignmentRankUpdate,arumsg.alignmentRank);
               }
               return true;
            case msg is AlignmentSubAreasListMessage:
               asalmsg = msg as AlignmentSubAreasListMessage;
               this._angelsSubAreas = asalmsg.angelsSubAreas;
               this._evilsSubAreas = asalmsg.evilsSubAreas;
               KernelEventsManager.getInstance().processCallback(AlignmentHookList.AlignmentSubAreasList);
               return true;
            case msg is AlignmentAreaUpdateMessage:
               aaumsg = msg as AlignmentAreaUpdateMessage;
               area = Area.getAreaById(aaumsg.areaId);
               side = AlignmentSide.getAlignmentSideById(aaumsg.side);
               text = I18n.getText(I18nProxy.getKeyId("ui.alignment.areaIs"),[area.name,side.name]);
               KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,text,ChatChannelsMultiEnum.CHANNEL_ALIGN);
               KernelEventsManager.getInstance().processCallback(AlignmentHookList.AlignmentAreaUpdate,aaumsg.areaId,aaumsg.side);
               return true;
            case msg is AlignmentSubAreaUpdateMessage:
               asaumsg = msg as AlignmentSubAreaUpdateMessage;
               subArea = SubArea.getSubAreaById(asaumsg.subAreaId);
               side = AlignmentSide.getAlignmentSideById(asaumsg.side);
               if(!asaumsg.quiet)
               {
                  text = I18n.getText(I18nProxy.getKeyId("ui.alignment.subareaIs"),[subArea.name,side.name]);
                  KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation,text,ChatChannelsMultiEnum.CHANNEL_ALIGN);
               }
               KernelEventsManager.getInstance().processCallback(AlignmentHookList.AlignmentAreaUpdate,asaumsg.subAreaId,asaumsg.side);
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
