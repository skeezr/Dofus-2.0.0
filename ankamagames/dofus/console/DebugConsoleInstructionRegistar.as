package com.ankamagames.dofus.console
{
   import com.ankamagames.jerakine.console.ConsoleInstructionRegistar;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.dofus.console.debug.VersionInstructionHandler;
   import com.ankamagames.dofus.console.debug.CryptoInstructionHandler;
   import com.ankamagames.dofus.console.debug.DisplayMapInstructionHandler;
   import com.ankamagames.dofus.console.debug.ClearSceneInstructionHandler;
   import com.ankamagames.dofus.console.debug.UiHandlerInstructionHandler;
   import com.ankamagames.dofus.console.debug.DtdInstructionHandler;
   import com.ankamagames.dofus.console.debug.ClearTextureCacheInstructionHandler;
   import com.ankamagames.dofus.console.debug.WorkerStatusInstructionHandler;
   import com.ankamagames.dofus.console.debug.ConnectionInstructionHandler;
   import com.ankamagames.dofus.console.debug.PanicInstructionHandler;
   import com.ankamagames.dofus.console.debug.FullScreenInstructionHandler;
   import com.ankamagames.dofus.console.debug.ResetInstructionHandler;
   import com.ankamagames.dofus.console.debug.EnterFrameInstructionHandler;
   import com.ankamagames.dofus.console.debug.MiscInstructionHandler;
   import com.ankamagames.dofus.console.debug.TiphonInstructionHandler;
   import com.ankamagames.dofus.console.debug.InventoryInstructionHandler;
   import com.ankamagames.dofus.console.debug.FontInstructionHandler;
   import com.ankamagames.dofus.console.debug.BenchmarkInstructionHandler;
   import com.ankamagames.dofus.console.debug.ActionsInstructionHandler;
   import com.ankamagames.dofus.console.debug.IAInstructionHandler;
   import com.ankamagames.dofus.console.debug.FightInstructionHandler;
   import com.ankamagames.dofus.console.debug.SoundInstructionHandler;
   
   public class DebugConsoleInstructionRegistar implements ConsoleInstructionRegistar
   {
       
      public function DebugConsoleInstructionRegistar()
      {
         super();
      }
      
      public function registerInstructions(console:ConsoleHandler) : void
      {
         console.addHandler("version",new VersionInstructionHandler());
         console.addHandler(["crc32","md5"],new CryptoInstructionHandler());
         console.addHandler(["displaymap","displaymapdebug","getmapcoord","getmapid","testatouin","configatouin","mapid","showcellid","playerjump","showtransitions"],new DisplayMapInstructionHandler());
         console.addHandler("clearscene",new ClearSceneInstructionHandler());
         console.addHandler(["loadui","unloadui","clearuicache","setuiscale","useuicache","uilist","reloadui","fps"],new UiHandlerInstructionHandler());
         console.addHandler(["dtd","componentdtd","shortcutsdtd","kerneleventdtd"],new DtdInstructionHandler());
         console.addHandler("cleartexturecache",new ClearTextureCacheInstructionHandler());
         console.addHandler("workerstatus",new WorkerStatusInstructionHandler());
         console.addHandler("connectionstatus",new ConnectionInstructionHandler());
         console.addHandler(["panic","throw"],new PanicInstructionHandler());
         console.addHandler("fullscreen",new FullScreenInstructionHandler());
         console.addHandler("reset",new ResetInstructionHandler());
         console.addHandler("enterframecount",new EnterFrameInstructionHandler());
         console.addHandler(["parallelsequenceteststart","log","i18nsize","newdofus"],new MiscInstructionHandler());
         console.addHandler("additem",new TiphonInstructionHandler());
         console.addHandler(["listinventory","searchitem","makeinventory"],new InventoryInstructionHandler());
         console.addHandler("jptest",new FontInstructionHandler());
         console.addHandler(["addmovingcharacter","setanimation","setdirection","showfps"],new BenchmarkInstructionHandler());
         console.addHandler(["sendaction","listactions","sendhook"],new ActionsInstructionHandler());
         console.addHandler("debuglos",new IAInstructionHandler());
         console.addHandler("tracepath",new IAInstructionHandler());
         console.addHandler(["setspellscriptparam","setspellscript"],new FightInstructionHandler());
         console.addHandler(["playmusic","stopmusic","playambiance","stopambiance","addsoundinplaylist","stopplaylist","playplaylist","activesounds"],new SoundInstructionHandler());
      }
   }
}
