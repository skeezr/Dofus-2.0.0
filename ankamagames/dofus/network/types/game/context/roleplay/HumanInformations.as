package com.ankamagames.dofus.network.types.game.context.roleplay
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.look.EntityLook;
   import com.ankamagames.dofus.network.types.game.character.restriction.ActorRestrictionsInformations;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class HumanInformations implements INetworkType
   {
      
      public static const protocolId:uint = 157;
       
      public var followingCharactersLook:Vector.<EntityLook>;
      
      public var emoteId:int = 0;
      
      public var emoteEndTime:uint = 0;
      
      public var restrictions:ActorRestrictionsInformations;
      
      public var titleId:uint = 0;
      
      public function HumanInformations()
      {
         this.followingCharactersLook = new Vector.<EntityLook>();
         this.restrictions = new ActorRestrictionsInformations();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 157;
      }
      
      public function initHumanInformations(followingCharactersLook:Vector.<EntityLook> = null, emoteId:int = 0, emoteEndTime:uint = 0, restrictions:ActorRestrictionsInformations = null, titleId:uint = 0) : HumanInformations
      {
         this.followingCharactersLook = followingCharactersLook;
         this.emoteId = emoteId;
         this.emoteEndTime = emoteEndTime;
         this.restrictions = restrictions;
         this.titleId = titleId;
         return this;
      }
      
      public function reset() : void
      {
         this.followingCharactersLook = new Vector.<EntityLook>();
         this.emoteId = 0;
         this.emoteEndTime = 0;
         this.restrictions = new ActorRestrictionsInformations();
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_HumanInformations(output);
      }
      
      public function serializeAs_HumanInformations(output:IDataOutput) : void
      {
         output.writeShort(this.followingCharactersLook.length);
         for(var _i1:uint = 0; _i1 < this.followingCharactersLook.length; _i1++)
         {
            (this.followingCharactersLook[_i1] as EntityLook).serializeAs_EntityLook(output);
         }
         output.writeByte(this.emoteId);
         if(this.emoteEndTime < 0 || this.emoteEndTime > 65535)
         {
            throw new Error("Forbidden value (" + this.emoteEndTime + ") on element emoteEndTime.");
         }
         output.writeShort(this.emoteEndTime);
         this.restrictions.serializeAs_ActorRestrictionsInformations(output);
         if(this.titleId < 0)
         {
            throw new Error("Forbidden value (" + this.titleId + ") on element titleId.");
         }
         output.writeShort(this.titleId);
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_HumanInformations(input);
      }
      
      public function deserializeAs_HumanInformations(input:IDataInput) : void
      {
         var _item1:EntityLook = null;
         var _followingCharactersLookLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _followingCharactersLookLen; _i1++)
         {
            _item1 = new EntityLook();
            _item1.deserialize(input);
            this.followingCharactersLook.push(_item1);
         }
         this.emoteId = input.readByte();
         this.emoteEndTime = input.readUnsignedShort();
         if(this.emoteEndTime < 0 || this.emoteEndTime > 65535)
         {
            throw new Error("Forbidden value (" + this.emoteEndTime + ") on element of HumanInformations.emoteEndTime.");
         }
         this.restrictions = new ActorRestrictionsInformations();
         this.restrictions.deserialize(input);
         this.titleId = input.readShort();
         if(this.titleId < 0)
         {
            throw new Error("Forbidden value (" + this.titleId + ") on element of HumanInformations.titleId.");
         }
      }
   }
}
