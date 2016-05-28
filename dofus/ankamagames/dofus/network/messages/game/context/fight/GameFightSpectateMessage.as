package com.ankamagames.dofus.network.messages.game.context.fight
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.action.fight.FightDispellableEffectExtendedInformations;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   
   public class GameFightSpectateMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6069;
       
      private var _isInitialized:Boolean = false;
      
      public var effects:Vector.<FightDispellableEffectExtendedInformations>;
      
      public function GameFightSpectateMessage()
      {
         this.effects = new Vector.<FightDispellableEffectExtendedInformations>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 6069;
      }
      
      public function initGameFightSpectateMessage(effects:Vector.<FightDispellableEffectExtendedInformations> = null) : GameFightSpectateMessage
      {
         this.effects = effects;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.effects = new Vector.<FightDispellableEffectExtendedInformations>();
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
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_GameFightSpectateMessage(output);
      }
      
      public function serializeAs_GameFightSpectateMessage(output:IDataOutput) : void
      {
         output.writeShort(this.effects.length);
         for(var _i1:uint = 0; _i1 < this.effects.length; _i1++)
         {
            output.writeShort((this.effects[_i1] as FightDispellableEffectExtendedInformations).getTypeId());
            (this.effects[_i1] as FightDispellableEffectExtendedInformations).serialize(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_GameFightSpectateMessage(input);
      }
      
      public function deserializeAs_GameFightSpectateMessage(input:IDataInput) : void
      {
         var _id1:uint = 0;
         var _item1:FightDispellableEffectExtendedInformations = null;
         var _effectsLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _effectsLen; _i1++)
         {
            _id1 = input.readUnsignedShort();
            _item1 = ProtocolTypeManager.getInstance(FightDispellableEffectExtendedInformations,_id1);
            _item1.deserialize(input);
            this.effects.push(_item1);
         }
      }
   }
}
