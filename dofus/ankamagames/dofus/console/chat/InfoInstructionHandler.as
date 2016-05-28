package com.ankamagames.dofus.console.chat
{
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.dofus.network.messages.game.basic.BasicWhoIsRequestMessage;
   import com.ankamagames.dofus.network.messages.game.basic.BasicWhoAmIRequestMessage;
   import com.ankamagames.dofus.kernel.net.ConnectionsHandler;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.jerakine.data.I18n;
   import com.ankamagames.jerakine.utils.misc.I18nProxy;
   import com.ankamagames.atouin.managers.EntitiesManager;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.logic.game.common.managers.TimeManager;
   import com.ankamagames.dofus.BuildInfos;
   import flash.system.Capabilities;
   import com.ankamagames.dofus.datacenter.misc.Month;
   
   public class InfoInstructionHandler implements ConsoleInstructionHandler
   {
       
      public function InfoInstructionHandler()
      {
         super();
      }
      
      public function handle(console:ConsoleHandler, cmd:String, args:Array) : void
      {
         var bwrm:BasicWhoIsRequestMessage = null;
         var bwai:BasicWhoAmIRequestMessage = null;
         var currentMap:String = null;
         var mapId:String = null;
         var currentCell:String = null;
         var date:Date = null;
         var timestamp:Number = NaN;
         switch(cmd)
         {
            case "whois":
               if(args.length == 0)
               {
                  return;
               }
               bwrm = new BasicWhoIsRequestMessage();
               bwrm.initBasicWhoIsRequestMessage(args.shift());
               ConnectionsHandler.getConnection().send(bwrm);
               break;
            case "version":
               console.output(this.getVersion());
               break;
            case "ver":
               console.output(this.getVersion());
               break;
            case "about":
               console.output(this.getVersion());
               break;
            case "whoami":
               bwai = new BasicWhoAmIRequestMessage();
               ConnectionsHandler.getConnection().send(bwai);
               break;
            case "mapid":
               currentMap = MapDisplayManager.getInstance().currentMapPoint.x + "/" + MapDisplayManager.getInstance().currentMapPoint.y;
               mapId = MapDisplayManager.getInstance().currentMapPoint.mapId.toString();
               console.output(I18n.getText(I18nProxy.getKeyId("ui.chat.console.currentMap"),[currentMap,mapId]));
               break;
            case "cellid":
               currentCell = EntitiesManager.getInstance().getEntity(PlayedCharacterManager.getInstance().id).position.cellId.toString();
               console.output(I18n.getText(I18nProxy.getKeyId("ui.console.chat.currentCell"),[currentCell]));
               break;
            case "time":
               date = new Date();
               timestamp = date.getTime() + TimeManager.getInstance().serverTimeLag;
               console.output(this.getDofusDate(timestamp) + " - " + this.getClock(timestamp));
         }
      }
      
      private function getVersion() : String
      {
         return "----------------------------------------------\n" + "DOFUS CLIENT v " + BuildInfos.BUILD_VERSION + " (build " + BuildInfos.BUILD_REVISION + ")\n" + "(c) ANKAMA GAMES (" + BuildInfos.BUILD_DATE + ") \n" + "Flash player " + Capabilities.version + "\n----------------------------------------------";
      }
      
      private function getDofusDate(time:Number = 0) : String
      {
         var date:Date = null;
         var sDate:String = null;
         if(time != 0)
         {
            date = new Date(time);
         }
         else
         {
            date = new Date();
         }
         var nday:Number = date.getDate();
         var nmonth:Number = date.getMonth();
         var nyear:Number = date.getFullYear() + TimeManager.getInstance().dofusTimeYearLag;
         var day:String = nday.toString();
         var year:String = nyear.toString();
         var month:String = Month.getMonthById(nmonth).name;
         sDate = day + " " + month + " " + year;
         return sDate;
      }
      
      private function getClock(time:Number = 0) : String
      {
         var date:Date = null;
         var date0:Date = null;
         if(time == 0)
         {
            date0 = new Date();
            date = new Date(date0.getTime() + TimeManager.getInstance().serverTimeLag);
         }
         else
         {
            date = new Date(time);
         }
         var nhour:Number = date.getUTCHours();
         var nminute:Number = date.getUTCMinutes();
         var hour:String = nhour >= 10?nhour.toString():"0" + nhour;
         var minute:String = nminute >= 10?nminute.toString():"0" + nminute;
         return hour + ":" + minute;
      }
      
      public function getHelp(cmd:String) : String
      {
         switch(cmd)
         {
            case "version":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.version"));
            case "ver":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.version"));
            case "about":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.version"));
            case "whois":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.whois"));
            case "whoami":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.whoami"));
            case "cellid":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.cellid"));
            case "mapid":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.mapid"));
            case "time":
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.help.time"));
            default:
               return I18n.getText(I18nProxy.getKeyId("ui.chat.console.noHelp"),[cmd]);
         }
      }
   }
}
