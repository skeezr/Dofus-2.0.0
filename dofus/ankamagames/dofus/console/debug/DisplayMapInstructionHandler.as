package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.atouin.managers.MapDisplayManager;
   import com.ankamagames.atouin.utils.map.getWorldPointFromMapId;
   import com.ankamagames.jerakine.types.positions.WorldPoint;
   import com.ankamagames.atouin.utils.map.getMapIdFromCoord;
   import com.ankamagames.atouin.Atouin;
   import com.ankamagames.atouin.managers.InteractiveCellManager;
   import com.ankamagames.jerakine.managers.OptionManager;
   
   public class DisplayMapInstructionHandler implements ConsoleInstructionHandler
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(DisplayMapInstructionHandler));
       
      private var _console:ConsoleHandler;
      
      public function DisplayMapInstructionHandler()
      {
         super();
      }
      
      public function handle(console:ConsoleHandler, cmd:String, args:Array) : void
      {
         var val:* = undefined;
         var prop:Array = null;
         var name:* = null;
         var p:Object = null;
         this._console = console;
         switch(cmd)
         {
            case "displaymapdebug":
            case "displaymap":
               if(!args[0])
               {
                  console.output("Error : need mapId or map location as first parameter");
                  return;
               }
               if(args[0].indexOf(",") == -1)
               {
                  MapDisplayManager.getInstance().display(getWorldPointFromMapId(args[0]));
               }
               else
               {
                  MapDisplayManager.getInstance().display(WorldPoint.fromCoords(0,args[0].split(",")[0],args[0].split(",")[1]));
               }
               break;
            case "getmapcoord":
               console.output("Map world point for " + args[0] + " : " + getWorldPointFromMapId(int(args[0])).x + "/" + getWorldPointFromMapId(int(args[0])).y + " (world : " + WorldPoint.fromMapId(int(args[0])).worldId + ")");
               break;
            case "getmapid":
               console.output("Map id : " + getMapIdFromCoord(int(args[0]),parseInt(args[1]),parseInt(args[2])));
               break;
            case "testatouin":
               Atouin.getInstance().display(new WorldPoint());
               break;
            case "mapid":
               console.output("Current map : " + MapDisplayManager.getInstance().currentMapPoint.x + "/" + MapDisplayManager.getInstance().currentMapPoint.y + " (map id : " + MapDisplayManager.getInstance().currentMapPoint.mapId + ")");
               break;
            case "showcellid":
               Atouin.getInstance().options.showCellIdOnOver = !Atouin.getInstance().options.showCellIdOnOver;
               console.output("showCellIdOnOver : " + Atouin.getInstance().options.showCellIdOnOver);
               InteractiveCellManager.getInstance().setInteraction(true,Atouin.getInstance().options.showCellIdOnOver,Atouin.getInstance().options.showCellIdOnOver);
               break;
            case "playerjump":
               Atouin.getInstance().options.virtualPlayerJump = !Atouin.getInstance().options.virtualPlayerJump;
               console.output("playerJump : " + Atouin.getInstance().options.virtualPlayerJump);
               break;
            case "configatouin":
               if(args[0])
               {
                  if(OptionManager.getOptionManager("atouin")[args[0]] != null)
                  {
                     val = args[1];
                     if(val == "true")
                     {
                        val = true;
                     }
                     if(val == "false")
                     {
                        val = false;
                     }
                     if(parseInt(val).toString() == val)
                     {
                        val = parseInt(val);
                     }
                     OptionManager.getOptionManager("atouin")[args[0]] = val;
                  }
                  else
                  {
                     console.output(args[0] + " not found on AtouinOption");
                  }
               }
               else
               {
                  prop = new Array();
                  for(name in OptionManager.getOptionManager("atouin"))
                  {
                     prop.push({
                        "name":name,
                        "value":OptionManager.getOptionManager("atouin")[name]
                     });
                  }
                  prop.sortOn("name");
                  for each(p in prop)
                  {
                     console.output(" - " + p.name + " : " + p.value);
                  }
               }
               break;
            case "showtransitions":
               Atouin.getInstance().options.showTransitions = !Atouin.getInstance().options.showTransitions;
         }
      }
      
      public function getHelp(cmd:String) : String
      {
         switch(cmd)
         {
            case "displaymapdebug":
               return "Display a given map with debug filters activated. These filters apply a different color on every map layers.";
            case "displaymap":
               return "Display a given map.";
            case "getmapcoord":
               return "Get the world point for a given map id.";
            case "getmapid":
               return "Get the map id for a given world point.";
            case "configatouin":
               return "list Atouin options if no param else set a param /configatouin [paramName] [paramValue]";
            case "showtransitions":
               return "Toggle map transitions highlighting";
            default:
               return "No help for command \'" + cmd + "\'";
         }
      }
   }
}
