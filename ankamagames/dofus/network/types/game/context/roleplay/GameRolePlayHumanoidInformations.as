package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   
   public class GameRolePlayHumanoidInformations extends GameRolePlayNamedActorInformations implements INetworkType
   {
      
      public static const protocolId:uint = 159;
       
      public var humanoidInfo:com.ankamagames.dofus.network.types.game.context.roleplay.HumanInformations;
      
      public function GameRolePlayHumanoidInformations()
      {
         this.humanoidInfo = new com.ankamagames.dofus.network.types.game.context.roleplay.HumanInformations();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 159;
      }
      
      public function initGameRolePlayHumanoidInformations(contextualId:int = 0, look:EntityLook = null, disposition:EntityDispositionInformations = null, name:String = "", humanoidInfo:com.ankamagames.dofus.network.types.game.context.roleplay.HumanInformations = null) : GameRolePlayHumanoidInformations
      {
         super.initGameRolePlayNamedActorInformations(contextualId,look,disposition,name);
         this.humanoidInfo = humanoidInfo;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.humanoidInfo = new com.ankamagames.dofus.network.types.game.context.roleplay.HumanInformations();
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_GameRolePlayHumanoidInformations(output);
      }
      
      public function serializeAs_GameRolePlayHumanoidInformations(output:IDataOutput) : void
      {
         super.serializeAs_GameRolePlayNamedActorInformations(output);
         output.writeShort(this.humanoidInfo.getTypeId());
         this.humanoidInfo.serialize(output);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameRolePlayHumanoidInformations(input);
      }
      
      public function deserializeAs_GameRolePlayHumanoidInformations(input:IDataInput) : void
      {
         super.deserialize(input);
         var _id1:uint = input.readUnsignedShort();
         this.humanoidInfo = ProtocolTypeManager.getInstance(com.ankamagames.dofus.network.types.game.context.roleplay.HumanInformations,_id1);
         this.humanoidInfo.deserialize(input);
      }
   }
}
