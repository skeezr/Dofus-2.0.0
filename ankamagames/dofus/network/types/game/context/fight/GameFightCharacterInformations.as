package com.ankamagames.dofus.network.types.game.context.fight
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.character.alignment.ActorAlignmentInformations;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class GameFightCharacterInformations extends GameFightFighterNamedInformations implements INetworkType
   {
      
      public static const protocolId:uint = 46;
       
      public var level:uint = 0;
      
      public var alignmentInfos:ActorAlignmentInformations;
      
      public function GameFightCharacterInformations()
      {
         this.alignmentInfos = new ActorAlignmentInformations();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 46;
      }
      
      public function initGameFightCharacterInformations(contextualId:int = 0, look:EntityLook = null, disposition:EntityDispositionInformations = null, teamId:uint = 2, alive:Boolean = false, stats:GameFightMinimalStats = null, name:String = "", level:uint = 0, alignmentInfos:ActorAlignmentInformations = null) : GameFightCharacterInformations
      {
         super.initGameFightFighterNamedInformations(contextualId,look,disposition,teamId,alive,stats,name);
         this.level = level;
         this.alignmentInfos = alignmentInfos;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.level = 0;
         this.alignmentInfos = new ActorAlignmentInformations();
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_GameFightCharacterInformations(output);
      }
      
      public function serializeAs_GameFightCharacterInformations(output:IDataOutput) : void
      {
         super.serializeAs_GameFightFighterNamedInformations(output);
         if(this.level < 0)
         {
            throw new Error("Forbidden value (" + this.level + ") on element level.");
         }
         output.writeShort(this.level);
         this.alignmentInfos.serializeAs_ActorAlignmentInformations(output);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameFightCharacterInformations(input);
      }
      
      public function deserializeAs_GameFightCharacterInformations(input:IDataInput) : void
      {
         super.deserialize(input);
         this.level = input.readShort();
         if(this.level < 0)
         {
            throw new Error("Forbidden value (" + this.level + ") on element of GameFightCharacterInformations.level.");
         }
         this.alignmentInfos = new ActorAlignmentInformations();
         this.alignmentInfos.deserialize(input);
      }
   }
}
