package com.ankamagames.dofus.network.messages.game.context.fight
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.context.fight.GameFightSpellCooldown;
   import com.ankamagames.dofus.network.types.game.action.fight.FightDispellableEffectExtendedInformations;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   
   public class GameFightResumeMessage extends GameFightSpectateMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6067;
       
      private var _isInitialized:Boolean = false;
      
      public var spellCooldowns:Vector.<GameFightSpellCooldown>;
      
      public var summonCount:uint = 0;
      
      public function GameFightResumeMessage()
      {
         this.spellCooldowns = new Vector.<GameFightSpellCooldown>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return Boolean(super.isInitialized) && Boolean(this._isInitialized);
      }
      
      override public function getMessageId() : uint
      {
         return 6067;
      }
      
      public function initGameFightResumeMessage(effects:Vector.<FightDispellableEffectExtendedInformations> = null, spellCooldowns:Vector.<GameFightSpellCooldown> = null, summonCount:uint = 0) : GameFightResumeMessage
      {
         super.initGameFightSpectateMessage(effects);
         this.spellCooldowns = spellCooldowns;
         this.summonCount = summonCount;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.spellCooldowns = new Vector.<GameFightSpellCooldown>();
         this.summonCount = 0;
         this._isInitialized = false;
      }
      
      override public function pack(output:IDataOutput) : void
      {
         var data:ByteArray = new ByteArray();
         this.serialize(data);
         writePacket(output,this.getMessageId(),data);
      }
      
      override public function unpack(input:IDataInput, length:uint) : void
      {
         this.deserialize(input);
      }
      
      override public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_GameFightResumeMessage(output);
      }
      
      public function serializeAs_GameFightResumeMessage(output:IDataOutput) : void
      {
         super.serializeAs_GameFightSpectateMessage(output);
         output.writeShort(this.spellCooldowns.length);
         for(var _i1:uint = 0; _i1 < this.spellCooldowns.length; _i1++)
         {
            (this.spellCooldowns[_i1] as GameFightSpellCooldown).serializeAs_GameFightSpellCooldown(output);
         }
         if(this.summonCount < 0)
         {
            throw new Error("Forbidden value (" + this.summonCount + ") on element summonCount.");
         }
         output.writeByte(this.summonCount);
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameFightResumeMessage(input);
      }
      
      public function deserializeAs_GameFightResumeMessage(input:IDataInput) : void
      {
         var _item1:GameFightSpellCooldown = null;
         super.deserialize(input);
         var _spellCooldownsLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _spellCooldownsLen; _i1++)
         {
            _item1 = new GameFightSpellCooldown();
            _item1.deserialize(input);
            this.spellCooldowns.push(_item1);
         }
         this.summonCount = input.readByte();
         if(this.summonCount < 0)
         {
            throw new Error("Forbidden value (" + this.summonCount + ") on element of GameFightResumeMessage.summonCount.");
         }
      }
   }
}
