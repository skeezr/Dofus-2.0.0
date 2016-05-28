package com.ankamagames.dofus.internalDatacenter.guild
{
   import com.ankamagames.dofus.network.types.game.guild.tax.TaxCollectorInformations;
   import com.ankamagames.dofus.network.types.game.guild.tax.TaxCollectorFightersInformation;
   import com.ankamagames.dofus.network.types.game.character.CharacterMinimalPlusLookInformations;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorName;
   import com.ankamagames.dofus.datacenter.npcs.TaxCollectorFirstname;
   import com.ankamagames.dofus.network.types.game.guild.tax.TaxCollectorInformationsInWaitForHelpState;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.logic.game.common.frames.SocialFrame;
   import com.ankamagames.dofus.network.types.game.guild.tax.AdditionalTaxCollectorInformations;
   
   public class TaxCollectorWrapper
   {
       
      public var uniqueId:int;
      
      public var firstName:String;
      
      public var lastName:String;
      
      public var additonalInformation:AdditionalTaxCollectorInformations;
      
      public var mapWorldX:int;
      
      public var mapWorldY:int;
      
      public var subareaId:int;
      
      public var state:int;
      
      public var allyCharactersInformations:Vector.<com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper>;
      
      public var enemyCharactersInformations:Vector.<com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper>;
      
      public var missingTimeBeforeFight:Number;
      
      public var waitTimeForPlacement:Number;
      
      public var nbPositionPerTeam:uint;
      
      public function TaxCollectorWrapper()
      {
         super();
      }
      
      public static function create(pInformations:TaxCollectorInformations, pFightersInformations:TaxCollectorFightersInformation) : TaxCollectorWrapper
      {
         var item:TaxCollectorWrapper = null;
         var tcFighter:CharacterMinimalPlusLookInformations = null;
         var fighter:CharacterMinimalPlusLookInformations = null;
         var fighterEnemy:CharacterMinimalPlusLookInformations = null;
         var tcfwa:com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper = null;
         var tcfwe:com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper = null;
         item = new TaxCollectorWrapper();
         item.uniqueId = pInformations.uniqueId;
         item.lastName = TaxCollectorName.getTaxCollectorNameById(pInformations.lastNameId).name;
         item.firstName = TaxCollectorFirstname.getTaxCollectorFirstnameById(pInformations.firtNameId).firstname;
         item.additonalInformation = pInformations.additonalInformation;
         item.mapWorldX = pInformations.worldX;
         item.mapWorldY = pInformations.worldY;
         item.subareaId = pInformations.subAreaId;
         item.state = pInformations.state;
         if(pInformations.state == 1)
         {
            item.missingTimeBeforeFight = (pInformations as TaxCollectorInformationsInWaitForHelpState).waitingForHelpInfo.timeLeftBeforeFight;
            item.waitTimeForPlacement = (pInformations as TaxCollectorInformationsInWaitForHelpState).waitingForHelpInfo.waitTimeForPlacement;
            item.nbPositionPerTeam = (pInformations as TaxCollectorInformationsInWaitForHelpState).waitingForHelpInfo.nbPositionForDefensors;
            if(item.allyCharactersInformations == null)
            {
               item.allyCharactersInformations = new Vector.<com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper>();
            }
            tcFighter = new CharacterMinimalPlusLookInformations();
            tcFighter.entityLook = pInformations.look;
            tcFighter.id = item.uniqueId;
            if(Kernel.getWorker().getFrame(SocialFrame) != null)
            {
               tcFighter.level = (Kernel.getWorker().getFrame(SocialFrame) as SocialFrame).guild.level;
            }
            else
            {
               tcFighter.level = 0;
            }
            tcFighter.name = item.lastName + " " + item.firstName;
            item.allyCharactersInformations.push(com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper.create(0,tcFighter));
         }
         else
         {
            item.missingTimeBeforeFight = 0;
            item.waitTimeForPlacement = 0;
            item.nbPositionPerTeam = 7;
         }
         if(Boolean(pFightersInformations) && pInformations.uniqueId == pFightersInformations.collectorId)
         {
            if(item.allyCharactersInformations == null)
            {
               item.allyCharactersInformations = new Vector.<com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper>();
            }
            for each(fighter in pFightersInformations.allyCharactersInformations)
            {
               tcfwa = com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper.create(0,fighter);
               item.allyCharactersInformations.push(tcfwa);
            }
            if(item.enemyCharactersInformations == null)
            {
               item.enemyCharactersInformations = new Vector.<com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper>();
            }
            for each(fighterEnemy in pFightersInformations.enemyCharactersInformations)
            {
               tcfwe = com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper.create(1,fighterEnemy);
               item.enemyCharactersInformations.push(tcfwe);
            }
         }
         else
         {
            item.allyCharactersInformations = null;
            item.enemyCharactersInformations = null;
         }
         return item;
      }
      
      public function update(pInformations:TaxCollectorInformations, pFightersInformations:TaxCollectorFightersInformation) : void
      {
         var tcFight:CharacterMinimalPlusLookInformations = null;
         var tcFighter:CharacterMinimalPlusLookInformations = null;
         var fighter:CharacterMinimalPlusLookInformations = null;
         var fighterEnemy:CharacterMinimalPlusLookInformations = null;
         var tcfwa:com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper = null;
         var tcfwe:com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper = null;
         this.uniqueId = pInformations.uniqueId;
         this.lastName = TaxCollectorName.getTaxCollectorNameById(pInformations.lastNameId).name;
         this.firstName = TaxCollectorFirstname.getTaxCollectorFirstnameById(pInformations.firtNameId).firstname;
         this.additonalInformation = pInformations.additonalInformation;
         this.mapWorldX = pInformations.worldX;
         this.mapWorldY = pInformations.worldY;
         this.subareaId = pInformations.subAreaId;
         this.state = pInformations.state;
         if(pInformations.state == 1)
         {
            if(this.allyCharactersInformations == null)
            {
               this.allyCharactersInformations = new Vector.<com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper>();
            }
            tcFight = new CharacterMinimalPlusLookInformations();
            tcFight.entityLook = pInformations.look;
            if(Kernel.getWorker().getFrame(SocialFrame) != null)
            {
               tcFight.level = (Kernel.getWorker().getFrame(SocialFrame) as SocialFrame).guild.level;
            }
            else
            {
               tcFight.level = 0;
            }
            tcFight.name = this.lastName + " " + this.firstName;
            this.allyCharactersInformations.push(com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper.create(0,tcFight));
         }
         if(pInformations.state == 0)
         {
            this.allyCharactersInformations = new Vector.<com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper>();
            this.enemyCharactersInformations = new Vector.<com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper>();
         }
         if(Boolean(pFightersInformations) && pInformations.uniqueId == pFightersInformations.collectorId)
         {
            this.missingTimeBeforeFight = (pInformations as TaxCollectorInformationsInWaitForHelpState).waitingForHelpInfo.timeLeftBeforeFight;
            this.waitTimeForPlacement = (pInformations as TaxCollectorInformationsInWaitForHelpState).waitingForHelpInfo.waitTimeForPlacement;
            this.nbPositionPerTeam = (pInformations as TaxCollectorInformationsInWaitForHelpState).waitingForHelpInfo.nbPositionForDefensors;
            this.allyCharactersInformations = new Vector.<com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper>();
            tcFighter = new CharacterMinimalPlusLookInformations();
            tcFighter.entityLook = null;
            tcFighter.id = this.uniqueId;
            if(Kernel.getWorker().getFrame(SocialFrame) != null)
            {
               tcFighter.level = (Kernel.getWorker().getFrame(SocialFrame) as SocialFrame).guild.level;
            }
            else
            {
               tcFighter.level = 0;
            }
            tcFighter.name = this.lastName + " " + this.firstName;
            this.allyCharactersInformations.push(com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper.create(2,tcFighter));
            for each(fighter in pFightersInformations.allyCharactersInformations)
            {
               tcfwa = com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper.create(0,fighter);
               this.allyCharactersInformations.push(tcfwa);
            }
            this.enemyCharactersInformations = new Vector.<com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper>();
            for each(fighterEnemy in pFightersInformations.enemyCharactersInformations)
            {
               tcfwe = com.ankamagames.dofus.internalDatacenter.guild.TaxCollectorFightersWrapper.create(1,fighterEnemy);
               this.enemyCharactersInformations.push(tcfwe);
            }
         }
      }
   }
}
