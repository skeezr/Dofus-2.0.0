package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.network.types.game.context.EntityDispositionInformations;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class GameRolePlayGroupMonsterInformations extends GameRolePlayActorInformations implements INetworkType
   {
      
      public static const protocolId:uint = 160;
       
      public var mainCreatureGenericId:int = 0;
      
      public var mainCreaturelevel:uint = 0;
      
      public var underlings:Vector.<com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupInformations>;
      
      public var ageBonus:int = 0;
      
      public function GameRolePlayGroupMonsterInformations()
      {
         this.underlings = new Vector.<com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupInformations>();
         super();
      }
      
      override public function getTypeId() : uint
      {
         return 160;
      }
      
      public function initGameRolePlayGroupMonsterInformations(contextualId:int = 0, look:EntityLook = null, disposition:EntityDispositionInformations = null, mainCreatureGenericId:int = 0, mainCreaturelevel:uint = 0, underlings:Vector.<com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupInformations> = null, ageBonus:int = 0) : GameRolePlayGroupMonsterInformations
      {
         super.initGameRolePlayActorInformations(contextualId,look,disposition);
         this.mainCreatureGenericId = mainCreatureGenericId;
         this.mainCreaturelevel = mainCreaturelevel;
         this.underlings = underlings;
         this.ageBonus = ageBonus;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.mainCreatureGenericId = 0;
         this.mainCreaturelevel = 0;
         this.underlings = new Vector.<com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupInformations>();
         this.ageBonus = 0;
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_GameRolePlayGroupMonsterInformations(output);
      }
      
      public function serializeAs_GameRolePlayGroupMonsterInformations(output:IDataOutput) : void
      {
         super.serializeAs_GameRolePlayActorInformations(output);
         output.writeInt(this.mainCreatureGenericId);
         if(this.mainCreaturelevel < 0)
         {
            throw new Error("Forbidden value (" + this.mainCreaturelevel + ") on element mainCreaturelevel.");
         }
         output.writeShort(this.mainCreaturelevel);
         output.writeShort(this.underlings.length);
         for(var _i3:uint = 0; _i3 < this.underlings.length; _i3++)
         {
            (this.underlings[_i3] as com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupInformations).serializeAs_MonsterInGroupInformations(output);
         }
         if(this.ageBonus < -1 || this.ageBonus > 1000)
         {
            throw new Error("Forbidden value (" + this.ageBonus + ") on element ageBonus.");
         }
         output.writeShort(this.ageBonus);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameRolePlayGroupMonsterInformations(input);
      }
      
      public function deserializeAs_GameRolePlayGroupMonsterInformations(input:IDataInput) : void
      {
         var _item3:com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupInformations = null;
         super.deserialize(input);
         this.mainCreatureGenericId = input.readInt();
         this.mainCreaturelevel = input.readShort();
         if(this.mainCreaturelevel < 0)
         {
            throw new Error("Forbidden value (" + this.mainCreaturelevel + ") on element of GameRolePlayGroupMonsterInformations.mainCreaturelevel.");
         }
         var _underlingsLen:uint = input.readUnsignedShort();
         for(var _i3:uint = 0; _i3 < _underlingsLen; _i3++)
         {
            _item3 = new com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupInformations();
            _item3.deserialize(input);
            this.underlings.push(_item3);
         }
         this.ageBonus = input.readShort();
         if(this.ageBonus < -1 || this.ageBonus > 1000)
         {
            throw new Error("Forbidden value (" + this.ageBonus + ") on element of GameRolePlayGroupMonsterInformations.ageBonus.");
         }
      }
   }
}
