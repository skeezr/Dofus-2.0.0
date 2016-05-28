package com.ankamagames.dofus.network.messages.game.character.choice
{
   import com.ankamagames.jerakine.network.INetworkMessage;
   import com.ankamagames.dofus.network.types.game.character.choice.CharacterToRecolorInformation;
   import com.ankamagames.dofus.network.types.game.character.choice.CharacterBaseInformations;
   import flash.utils.IDataOutput;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import com.ankamagames.dofus.network.ProtocolTypeManager;
   
   public class CharactersListWithModificationsMessage extends CharactersListMessage implements INetworkMessage
   {
      
      public static const protocolId:uint = 6120;
       
      private var _isInitialized:Boolean = false;
      
      public var charactersToRecolor:Vector.<CharacterToRecolorInformation>;
      
      public var charactersToRename:Vector.<int>;
      
      public function CharactersListWithModificationsMessage()
      {
         this.charactersToRecolor = new Vector.<CharacterToRecolorInformation>();
         this.charactersToRename = new Vector.<int>();
         super();
      }
      
      override public function get isInitialized() : Boolean
      {
         return Boolean(super.isInitialized) && Boolean(this._isInitialized);
      }
      
      override public function getMessageId() : uint
      {
         return 6120;
      }
      
      public function initCharactersListWithModificationsMessage(hasStartupActions:Boolean = false, tutorielAvailable:Boolean = false, characters:Vector.<CharacterBaseInformations> = null, charactersToRecolor:Vector.<CharacterToRecolorInformation> = null, charactersToRename:Vector.<int> = null) : CharactersListWithModificationsMessage
      {
         super.initCharactersListMessage(hasStartupActions,tutorielAvailable,characters);
         this.charactersToRecolor = charactersToRecolor;
         this.charactersToRename = charactersToRename;
         this._isInitialized = true;
         return this;
      }
      
      override public function reset() : void
      {
         super.reset();
         this.charactersToRecolor = new Vector.<CharacterToRecolorInformation>();
         this.charactersToRename = new Vector.<int>();
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
         this.serializeAs_CharactersListWithModificationsMessage(output);
      }
      
      public function serializeAs_CharactersListWithModificationsMessage(output:IDataOutput) : void
      {
         super.serializeAs_CharactersListMessage(output);
         output.writeShort(this.charactersToRecolor.length);
         for(var _i1:uint = 0; _i1 < this.charactersToRecolor.length; _i1++)
         {
            output.writeShort((this.charactersToRecolor[_i1] as CharacterToRecolorInformation).getTypeId());
            (this.charactersToRecolor[_i1] as CharacterToRecolorInformation).serialize(output);
         }
         output.writeShort(this.charactersToRename.length);
         for(var _i2:uint = 0; _i2 < this.charactersToRename.length; _i2++)
         {
            output.writeInt(this.charactersToRename[_i2]);
         }
      }
      
      override public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_CharactersListWithModificationsMessage(input);
      }
      
      public function deserializeAs_CharactersListWithModificationsMessage(input:IDataInput) : void
      {
         var _id1:uint = 0;
         var _item1:CharacterToRecolorInformation = null;
         var _val2:int = 0;
         super.deserialize(input);
         var _charactersToRecolorLen:uint = input.readUnsignedShort();
         for(var _i1:uint = 0; _i1 < _charactersToRecolorLen; _i1++)
         {
            _id1 = input.readUnsignedShort();
            _item1 = ProtocolTypeManager.getInstance(CharacterToRecolorInformation,_id1);
            _item1.deserialize(input);
            this.charactersToRecolor.push(_item1);
         }
         var _charactersToRenameLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _charactersToRenameLen; _i2++)
         {
            _val2 = input.readInt();
            this.charactersToRename.push(_val2);
         }
      }
   }
}
