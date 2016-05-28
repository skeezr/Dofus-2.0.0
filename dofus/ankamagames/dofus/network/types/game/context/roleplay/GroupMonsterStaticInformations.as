package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.INetworkType;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class GroupMonsterStaticInformations implements INetworkType
   {
      
      public static const protocolId:uint = 140;
       
      public var mainCreatureGenericId:int = 0;
      
      public var mainCreaturelevel:uint = 0;
      
      public var underlings:Vector.<com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupInformations>;
      
      public function GroupMonsterStaticInformations()
      {
         this.underlings = new Vector.<com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupInformations>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 140;
      }
      
      public function initGroupMonsterStaticInformations(mainCreatureGenericId:int = 0, mainCreaturelevel:uint = 0, underlings:Vector.<com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupInformations> = null) : GroupMonsterStaticInformations
      {
         this.mainCreatureGenericId = mainCreatureGenericId;
         this.mainCreaturelevel = mainCreaturelevel;
         this.underlings = underlings;
         return this;
      }
      
      public function reset() : void
      {
         this.mainCreatureGenericId = 0;
         this.mainCreaturelevel = 0;
         this.underlings = new Vector.<com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupInformations>();
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_GroupMonsterStaticInformations(output);
      }
      
      public function serializeAs_GroupMonsterStaticInformations(output:IDataOutput) : void
      {
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
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GroupMonsterStaticInformations(input);
      }
      
      public function deserializeAs_GroupMonsterStaticInformations(input:IDataInput) : void
      {
         var _item3:com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupInformations = null;
         this.mainCreatureGenericId = input.readInt();
         this.mainCreaturelevel = input.readShort();
         if(this.mainCreaturelevel < 0)
         {
            throw new Error("Forbidden value (" + this.mainCreaturelevel + ") on element of GroupMonsterStaticInformations.mainCreaturelevel.");
         }
         var _underlingsLen:uint = input.readUnsignedShort();
         for(var _i3:uint = 0; _i3 < _underlingsLen; _i3++)
         {
            _item3 = new com.ankamagames.dofus.network.types.game.context.roleplay.MonsterInGroupInformations();
            _item3.deserialize(input);
            this.underlings.push(_item3);
         }
      }
   }
}
