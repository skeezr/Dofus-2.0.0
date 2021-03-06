package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.dofus.BuildInfos;
   import com.ankamagames.dofus.network.Metadata;
   import com.ankamagames.jerakine.types.enums.BuildTypeEnum;
   
   public class VersionInstructionHandler implements ConsoleInstructionHandler
   {
       
      public function VersionInstructionHandler()
      {
         super();
      }
      
      public function handle(console:ConsoleHandler, cmd:String, args:Array) : void
      {
         switch(cmd)
         {
            case "version":
               switch(args[0])
               {
                  case "revision":
                     console.output("Build revision : " + BuildInfos.BUILD_REVISION);
                     break;
                  case "date":
                     console.output("Build date     : " + BuildInfos.BUILD_DATE);
                     break;
                  case "protocol":
                     console.output("Protocol       : " + Metadata.PROTOCOL_BUILD + " (" + Metadata.PROTOCOL_DATE + ")");
                     break;
                  case undefined:
                     console.output("DOFUS v" + BuildInfos.BUILD_VERSION + " (" + BuildTypeEnum.getTypeName(BuildInfos.BUILD_TYPE) + ")");
                     break;
                  default:
                     console.output("Unknown argument : " + args[0]);
               }
         }
      }
      
      public function getHelp(cmd:String) : String
      {
         switch(cmd)
         {
            case "version":
               return "Get the client version.";
            default:
               return "No help for command \'" + cmd + "\'";
         }
      }
   }
}
