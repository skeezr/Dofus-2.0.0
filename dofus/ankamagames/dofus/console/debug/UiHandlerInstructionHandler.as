package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.managers.UiRenderManager;
   import com.ankamagames.jerakine.managers.StoreDataManager;
   import com.ankamagames.berilia.BeriliaConstants;
   
   public class UiHandlerInstructionHandler implements ConsoleInstructionHandler
   {
       
      public function UiHandlerInstructionHandler()
      {
         super();
      }
      
      public function handle(console:ConsoleHandler, cmd:String, args:Array) : void
      {
         var count:uint = 0;
         var i:* = null;
         var s:* = null;
         switch(cmd)
         {
            case "loadui":
               break;
            case "unloadui":
               if(args.length == 0)
               {
                  count = 0;
                  for(i in Berilia.getInstance().uiList)
                  {
                     if(Berilia.getInstance().uiList[i].name != "Console")
                     {
                        Berilia.getInstance().unloadUi(Berilia.getInstance().uiList[i].name);
                        count++;
                     }
                  }
                  console.output(count + " UI were unload");
                  break;
               }
               if(Berilia.getInstance().unloadUi(args[0]))
               {
                  console.output("RIP " + args[0]);
               }
               else
               {
                  console.output(args[0] + " does not exist or an error occured while unloading UI");
               }
               break;
            case "clearuicache":
               UiRenderManager.getInstance().clearCache();
               break;
            case "setuiscale":
               Berilia.getInstance().scale = Number(args[0]);
               break;
            case "useuicache":
               StoreDataManager.getInstance().setData(BeriliaConstants.DATASTORE_UI_DEFINITION,"useCache",args[0] == "true");
               BeriliaConstants.USE_UI_CACHE = args[0] == "true";
               break;
            case "uilist":
               for(s in Berilia.getInstance().uiList)
               {
                  console.output(" - " + s);
               }
               break;
            case "reloadui":
               Berilia.getInstance().unloadUi(args[0]);
               break;
            case "fps":
               Dofus.getInstance().toggleFPS();
         }
      }
      
      public function getHelp(cmd:String) : String
      {
         switch(cmd)
         {
            case "loadui":
               return "Load an UI. Usage: loadUi <uiId> <uiInstanceName>(optional)";
            case "unloadui":
               return "Unload UI with the given UI instance name.";
            case "clearuicache":
               return "Clear all UI in cache (will force xml parsing).";
            case "setuiscale":
               return "Set scale for all scalable UI. Usage: setUiScale <Number> (100% = 1.0)";
            case "useuiCache":
               return "Enable UI caching";
            case "uilist":
               return "Get current UI list";
            case "reloadui":
               return "Unload and reload an Ui";
            case "fps":
               return "Toggle FPS";
            default:
               return "No help for command \'" + cmd + "\'";
         }
      }
   }
}
