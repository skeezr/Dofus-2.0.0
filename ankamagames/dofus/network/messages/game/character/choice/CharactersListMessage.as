package com.ankamagames.dofus.network.messages.game.character.choice
{
   import com.ankamagames.jerakine.network.NetworkMessage;
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.character.choice.CharacterBaseInformations;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import com.ankamagames.jerakine.network.utils.BooleanByteWrapper;
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   
   public class CharactersListMessage extends NetworkMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 151;
       
      private var _isInitialized:Boolean = false;
      
      public var hasStartupActions:Boolean = false;
      
      public var tutorielAvailable:Boolean = false;
      
      public var characters:Vector.<CharacterBaseInformations>;
      
      public function CharactersListMessage()
      {
         this.characters = new Vector.<CharacterBaseInformations>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return this._isInitialized;
      }
      
      override public function getMessageId() : uint
      {
         return 151;
      }
      
      public function initCharactersListMessage(hasStartupActions:Boolean = false, tutorielAvailable:Boolean = false, characters:Vector.<CharacterBaseInformations> = null) : CharactersListMessage
      {
         this.hasStartupActions = hasStartupActions;
         this.tutorielAvailable = tutorielAvailable;
         this.characters = characters;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         this.hasStartupActions = false;
         this.tutorielAvailable = false;
         this.characters = new Vector.<CharacterBaseInformations>();
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
         this.serializeAs_CharactersListMessage(output);
      }
      
      public function serializeAs_CharactersListMessage(output:IDataOutput) : void
      {
         var _box0:uint = 0;
         BooleanByteWrapper.setFlag(_box0,0,this.hasStartupActions);
         BooleanByteWrapper.setFlag(_box0,1,this.tutorielAvailable);
         output.writeByte(_box0);
         output.writeShort(this.characters.length);
         for(var _i3:uint = 0; _i3 < this.characters.length; _i3++)
         {
            output.writeShort((this.characters[_i3] as CharacterBaseInformations).getTypeId());
            (this.characters[_i3] as CharacterBaseInformations).serialize(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_CharactersListMessage(input);
      }
      
      public function deserializeAs_CharactersListMessage(input:IDataInput) : void
      {
         var _id3:uint = 0;
         var _item3:CharacterBaseInformations = null;
         var _box0:uint = input.readByte();
         this.hasStartupActions = BooleanByteWrapper.getFlag(_box0,0);
         this.tutorielAvailable = BooleanByteWrapper.getFlag(_box0,1);
         var _charactersLen:uint = input.readUnsignedShort();
         for(var _i3:uint = 0; _i3 < _charactersLen; _i3++)
         {
            _id3 = input.readUnsignedShort();
            _item3 = ProtocolTypeManager.getInstance(CharacterBaseInformations,_id3);
            _item3.deserialize(input);
            this.characters.push(_item3);
         }
      }
   }
}
