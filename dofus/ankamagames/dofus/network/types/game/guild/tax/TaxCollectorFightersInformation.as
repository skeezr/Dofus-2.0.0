package com.ankamagames.dofus.network.types.game.guild.tax
{
   import com.ankamagames.jerakine.network.INetworkType;
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalPlusLookInformations;
   import flash.utils.IDataOutput;
   import flash.utils.IDataInput;
   
   public class TaxCollectorFightersInformation implements INetworkType
   {
      
      public static const protocolId:uint = 169;
       
      public var collectorId:int = 0;
      
      public var allyCharactersInformations:Vector.<CharacterMinimalPlusLookInformations>;
      
      public var enemyCharactersInformations:Vector.<CharacterMinimalPlusLookInformations>;
      
      public function TaxCollectorFightersInformation()
      {
         this.allyCharactersInformations = new Vector.<CharacterMinimalPlusLookInformations>();
         this.enemyCharactersInformations = new Vector.<CharacterMinimalPlusLookInformations>();
         super();
      }
      
      public function getTypeId() : uint
      {
         return 169;
      }
      
      public function initTaxCollectorFightersInformation(collectorId:int = 0, allyCharactersInformations:Vector.<CharacterMinimalPlusLookInformations> = null, enemyCharactersInformations:Vector.<CharacterMinimalPlusLookInformations> = null) : TaxCollectorFightersInformation
      {
         this.collectorId = collectorId;
         this.allyCharactersInformations = allyCharactersInformations;
         this.enemyCharactersInformations = enemyCharactersInformations;
         return this;
      }
      
      public function reset() : void
      {
         this.collectorId = 0;
         this.allyCharactersInformations = new Vector.<CharacterMinimalPlusLookInformations>();
         this.enemyCharactersInformations = new Vector.<CharacterMinimalPlusLookInformations>();
      }
      
      public function serialize(output:IDataOutput) : void
      {
         this.serializeAs_TaxCollectorFightersInformation(output);
      }
      
      public function serializeAs_TaxCollectorFightersInformation(output:IDataOutput) : void
      {
         output.writeInt(this.collectorId);
         output.writeShort(this.allyCharactersInformations.length);
         for(var _i2:uint = 0; _i2 < this.allyCharactersInformations.length; _i2++)
         {
            (this.allyCharactersInformations[_i2] as CharacterMinimalPlusLookInformations).serializeAs_CharacterMinimalPlusLookInformations(output);
         }
         output.writeShort(this.enemyCharactersInformations.length);
         for(var _i3:uint = 0; _i3 < this.enemyCharactersInformations.length; _i3++)
         {
            (this.enemyCharactersInformations[_i3] as CharacterMinimalPlusLookInformations).serializeAs_CharacterMinimalPlusLookInformations(output);
         }
      }
      
      public function deserialize(input:IDataInput) : void
      {
         this.deserializeAs_TaxCollectorFightersInformation(input);
      }
      
      public function deserializeAs_TaxCollectorFightersInformation(input:IDataInput) : void
      {
         var _item2:CharacterMinimalPlusLookInformations = null;
         var _item3:CharacterMinimalPlusLookInformations = null;
         this.collectorId = input.readInt();
         var _allyCharactersInformationsLen:uint = input.readUnsignedShort();
         for(var _i2:uint = 0; _i2 < _allyCharactersInformationsLen; _i2++)
         {
            _item2 = new CharacterMinimalPlusLookInformations();
            _item2.deserialize(input);
            this.allyCharactersInformations.push(_item2);
         }
         var _enemyCharactersInformationsLen:uint = input.readUnsignedShort();
         for(var _i3:uint = 0; _i3 < _enemyCharactersInformationsLen; _i3++)
         {
            _item3 = new CharacterMinimalPlusLookInformations();
            _item3.deserialize(input);
            this.enemyCharactersInformations.push(_item3);
         }
      }
   }
}
