package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class GameFightFighterNamedInformations extends GameFightFighterInformations implements INetworkType
   {
      
      public static const protocolId:uint = 158;
       
      public var name:String = "";
      
      public function GameFightFighterNamedInformations()
      {
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 158;
      }
      
      public function initGameFightFighterNamedInformations(contextualId:int = 0, look:EntityLook = null, disposition:EntityDispositionInformations = null, teamId:uint = 2, alive:Boolean = false, stats:GameFightMinimalStats = null, name:String = "") : GameFightFighterNamedInformations
      {
         super.initGameFightFighterInformations(contextualId,look,disposition,teamId,alive,stats);
         this.name = name;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.name = "";
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_GameFightFighterNamedInformations(output);
      }
      
      public function serializeAs_GameFightFighterNamedInformations(output:IDataOutput) : void
      {
         super.serializeAs_GameFightFighterInformations(output);
         output.writeUTF(this.name);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameFightFighterNamedInformations(input);
      }
      
      public function deserializeAs_GameFightFighterNamedInformations(input:IDataInput) : void
      {
         super.deserialize(input);
         this.name = input.readUTF();
      }
   }
}
