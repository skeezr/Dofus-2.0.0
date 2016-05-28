package com.ankamagames.dofus.console
{
   import com.ankamagames.jerakine.console.ConsoleInstructionRegistar;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.dofus.console.chat.InfoInstructionHandler;
   import com.ankamagames.dofus.console.chat.LatencyInstructionHandler;
   import com.ankamagames.dofus.console.chat.SocialInstructionHandler;
   import com.ankamagames.dofus.console.chat.MessagingInstructionHandler;
   import com.ankamagames.dofus.console.chat.FightInstructionHandler;
   import com.ankamagames.dofus.console.chat.EmoteInstructionHandler;
   import com.ankamagames.dofus.console.chat.OptionsInstructionHandler;
   import com.ankamagames.dofus.console.chat.StatusInstructionHandler;
   
   public class ChatConsoleInstructionRegistrar implements ConsoleInstructionRegistar
   {
       
      public function ChatConsoleInstructionRegistrar()
      {
         super();
      }
      
      public function registerInstructions(console:ConsoleHandler) : void
      {
         console.addHandler(["whois","version","ver","about","whoami","mapid","cellid","time"],new InfoInstructionHandler());
         console.addHandler(["aping","ping"],new LatencyInstructionHandler());
         console.addHandler(["f","ignore","invite"],new SocialInstructionHandler());
         console.addHandler(["w","whisper","msg","t","g","p","a","r","b","m"],new MessagingInstructionHandler());
         console.addHandler(["spectator","list","players","kick"],new FightInstructionHandler());
         console.addHandler(["sit","bye","appl","mad","fear","weap","pipo","oups","hi","kiss","pfc1","pfc2","pfc3","cross","point","crow","rest","sit2","champ","aura","bat"],new EmoteInstructionHandler());
         console.addHandler(["tab"],new OptionsInstructionHandler());
         console.addHandler(["away","release"],new StatusInstructionHandler());
      }
   }
}
