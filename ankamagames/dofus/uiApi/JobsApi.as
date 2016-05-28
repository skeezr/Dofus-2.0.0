package com.ankamagames.dofus.uiApi
{
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.berilia.types.data.UiModule;
   import com.ankamagames.dofus.logic.game.common.frames.JobsFrame;
   import com.ankamagames.dofus.kernel.Kernel;
   import com.ankamagames.dofus.internalDatacenter.jobs.KnownJob;
   import com.ankamagames.dofus.logic.game.common.managers.PlayedCharacterManager;
   import com.ankamagames.dofus.datacenter.jobs.Job;
   import com.ankamagames.dofus.network.types.game.interactive.skill.SkillActionDescription;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobDescription;
   import com.ankamagames.dofus.datacenter.jobs.Skill;
   import com.ankamagames.dofus.network.types.game.interactive.skill.SkillActionDescriptionCollect;
   import com.ankamagames.dofus.network.types.game.interactive.skill.SkillActionDescriptionCraft;
   import com.ankamagames.dofus.datacenter.items.Item;
   import com.ankamagames.dofus.datacenter.items.ItemType;
   import com.ankamagames.dofus.network.types.game.interactive.skill.SkillActionDescriptionCraftExtended;
   import com.ankamagames.dofus.network.types.game.context.roleplay.job.JobExperience;
   import com.ankamagames.dofus.datacenter.jobs.Recipe;
   import com.ankamagames.dofus.internalDatacenter.jobs.RecipeWithSkill;
   import com.ankamagames.dofus.network.types.game.interactive.InteractiveElement;
   import com.ankamagames.dofus.logic.game.roleplay.frames.RoleplayContextFrame;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   
   [InstanciedApi]
   public class JobsApi
   {
       
      protected var _log:Logger;
      
      private var _module:UiModule;
      
      private var _jobsFrame:JobsFrame = null;
      
      public function JobsApi()
      {
         this._log = Log.getLogger(getQualifiedClassName(JobsApi));
         super();
      }
      
      [ApiData(name="module")]
      public function set module(value:UiModule) : void
      {
         this._module = value;
      }
      
      public function get jobsFrame() : JobsFrame
      {
         if(!this._jobsFrame)
         {
            this._jobsFrame = Kernel.getWorker().getFrame(JobsFrame) as JobsFrame;
         }
         return this._jobsFrame;
      }
      
      [Untrusted]
      public function getKnownJobs() : Array
      {
         var kj:KnownJob = null;
         if(!PlayedCharacterManager.getInstance().jobs)
         {
            return null;
         }
         var knownJobs:Array = new Array();
         for each(kj in PlayedCharacterManager.getInstance().jobs)
         {
            if(kj != null)
            {
               knownJobs[kj.jobPosition] = Job.getJobById(kj.jobDescription.jobId);
            }
         }
         return knownJobs;
      }
      
      [Untrusted]
      public function getJobSkills(job:Job) : Array
      {
         var sd:SkillActionDescription = null;
         var jd:JobDescription = this.getJobDescription(job.id);
         if(!jd)
         {
            return null;
         }
         var jobSkills:Array = new Array(jd.skills.length);
         var index:uint = 0;
         for each(sd in jd.skills)
         {
            jobSkills[index++] = Skill.getSkillById(sd.skillId);
         }
         return jobSkills;
      }
      
      [Untrusted]
      public function getJobSkillType(job:Job, skill:Skill) : String
      {
         var jd:JobDescription = this.getJobDescription(job.id);
         if(!jd)
         {
            return "unknown";
         }
         var sd:SkillActionDescription = this.getSkillActionDescription(jd,skill.id);
         if(!sd)
         {
            return "unknown";
         }
         switch(true)
         {
            case sd is SkillActionDescriptionCollect:
               return "collect";
            case sd is SkillActionDescriptionCraft:
               return "craft";
            default:
               this._log.warn("Unknown SkillActionDescription type : " + sd);
               return "unknown";
         }
      }
      
      [Untrusted]
      public function getJobCollectSkillInfos(job:Job, skill:Skill) : Object
      {
         var jd:JobDescription = this.getJobDescription(job.id);
         if(!jd)
         {
            return null;
         }
         var sd:SkillActionDescription = this.getSkillActionDescription(jd,skill.id);
         if(!sd)
         {
            return null;
         }
         if(!(sd is SkillActionDescriptionCollect))
         {
            return null;
         }
         var sdc:SkillActionDescriptionCollect = sd as SkillActionDescriptionCollect;
         var infos:Object = new Object();
         infos.time = sdc.time / 10;
         infos.minResources = sdc.min;
         infos.maxResources = sdc.max;
         infos.resourceItem = Item.getItemById(skill.gatheredRessourceItem);
         return infos;
      }
      
      [Untrusted]
      public function getMaxSlotsByJobId(jobId:int) : int
      {
         var sd:SkillActionDescription = null;
         var sdc:SkillActionDescriptionCraft = null;
         var jd:JobDescription = this.getJobDescription(jobId);
         var max:int = 0;
         if(!jd)
         {
            return 0;
         }
         for each(sd in jd.skills)
         {
            if(sd is SkillActionDescriptionCraft)
            {
               sdc = sd as SkillActionDescriptionCraft;
               if(sdc.maxSlots > max)
               {
                  max = sdc.maxSlots;
               }
            }
         }
         return max;
      }
      
      [Untrusted]
      public function getJobCraftSkillInfos(job:Job, skill:Skill) : Object
      {
         var jd:JobDescription = this.getJobDescription(job.id);
         if(!jd)
         {
            return null;
         }
         var sd:SkillActionDescription = this.getSkillActionDescription(jd,skill.id);
         if(!sd)
         {
            return null;
         }
         if(!(sd is SkillActionDescriptionCraft))
         {
            return null;
         }
         var sdc:SkillActionDescriptionCraft = sd as SkillActionDescriptionCraft;
         var infos:Object = new Object();
         infos.maxSlots = sdc.maxSlots;
         infos.probability = sdc.probability;
         if(skill.modifiableItemType > -1)
         {
            infos.modifiableItemType = ItemType.getItemTypeById(skill.modifiableItemType);
         }
         if(!(sdc is SkillActionDescriptionCraftExtended))
         {
            return infos;
         }
         var sdce:SkillActionDescriptionCraftExtended = sdc as SkillActionDescriptionCraftExtended;
         infos.thresholdSlots = sdce.thresholdSlots;
         infos.optimumProbability = sdce.optimumProbability;
         return infos;
      }
      
      [Untrusted]
      public function getJobExperience(job:Job) : Object
      {
         var je:JobExperience = this.getJobExp(job.id);
         if(!je)
         {
            return null;
         }
         var xp:Object = new Object();
         xp.currentLevel = je.jobLevel;
         xp.currentExperience = je.jobXP;
         xp.levelExperienceFloor = je.jobXpLevelFloor;
         xp.levelExperienceCeil = je.jobXpNextLevelFloor;
         return xp;
      }
      
      [Untrusted]
      public function getSkillFromId(skillId:int) : Object
      {
         return Skill.getSkillById(skillId);
      }
      
      [Untrusted]
      public function getJobRecipes(job:Job, validSlotsCount:Array = null, skill:Skill = null) : Array
      {
         var sd:SkillActionDescription = null;
         var craftables:Vector.<int> = null;
         var result:int = 0;
         var recipe:Recipe = null;
         var recipeSlots:uint = 0;
         var i:uint = 0;
         var allowedCount:uint = 0;
         var jd:JobDescription = this.getJobDescription(job.id);
         if(!jd)
         {
            return null;
         }
         var recipes:Array = new Array();
         validSlotsCount.sort(Array.NUMERIC);
         for each(sd in jd.skills)
         {
            if(!(Boolean(skill) && sd.skillId != skill.id))
            {
               craftables = Skill.getSkillById(sd.skillId).craftableItemIds;
               for each(result in craftables)
               {
                  recipe = Recipe.getRecipeByResultId(result);
                  recipeSlots = recipe.ingredientIds.length;
                  for(i = 0; i < validSlotsCount.length; i++)
                  {
                     allowedCount = validSlotsCount[i];
                     if(allowedCount == recipeSlots)
                     {
                        recipes.push(new RecipeWithSkill(recipe,Skill.getSkillById(sd.skillId)));
                        break;
                     }
                     if(allowedCount > recipeSlots)
                     {
                        break;
                     }
                  }
               }
            }
         }
         recipes = recipes.sort(this.skillSortFunction);
         return recipes;
      }
      
      [Untrusted]
      public function getRecipe(objectId:uint) : Recipe
      {
         return Recipe.getRecipeByResultId(objectId);
      }
      
      [Untrusted]
      public function getRecipesList(objectId:uint) : Array
      {
         var recipeList:Array = Item.getItemById(objectId).recipes;
         if(recipeList)
         {
            return recipeList;
         }
         return new Array();
      }
      
      [Untrusted]
      public function getJobName(pJobId:uint) : String
      {
         return Job.getJobById(pJobId).name;
      }
      
      [Untrusted]
      public function getJob(pJobId:uint) : Object
      {
         return Job.getJobById(pJobId);
      }
      
      [Untrusted]
      public function getJobCrafterDirectorySettingsById(jobId:uint) : Object
      {
         var job:Object = null;
         for each(job in this.jobsFrame.settings)
         {
            if(Boolean(job) && jobId == job.jobId)
            {
               return job;
            }
         }
         return null;
      }
      
      [Untrusted]
      public function getJobCrafterDirectorySettingsByIndex(jobIndex:uint) : Object
      {
         return this.jobsFrame.settings[jobIndex];
      }
      
      [Untrusted]
      public function getUsableSkillsInMap(playerId:int) : Array
      {
         var hasSkill:Boolean = false;
         var skillId:uint = 0;
         var ie:InteractiveElement = null;
         var skillIdE:uint = 0;
         var usableSkills:Array = new Array();
         var rpContextFrame:RoleplayContextFrame = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
         var ies:Vector.<InteractiveElement> = rpContextFrame.entitiesFrame.interactiveElements;
         var skills:Vector.<uint> = rpContextFrame.getMulitCraftSkills(playerId);
         for each(skillId in skills)
         {
            hasSkill = false;
            for each(ie in ies)
            {
               for each(skillIdE in ie.enabledSkillIds)
               {
                  if(skillId == skillIdE && usableSkills.indexOf(skillIdE) == -1)
                  {
                     hasSkill = true;
                     break;
                  }
               }
               if(hasSkill)
               {
                  break;
               }
            }
            if(hasSkill)
            {
               usableSkills.push(Skill.getSkillById(skillId));
            }
         }
         return usableSkills;
      }
      
      private function skillSortFunction(a:RecipeWithSkill, b:RecipeWithSkill) : Number
      {
         if(a.recipe.quantities.length > b.recipe.quantities.length)
         {
            return -1;
         }
         if(a.recipe.quantities.length == b.recipe.quantities.length)
         {
            return 0;
         }
         return 1;
      }
      
      private function getKnownJob(jobId:uint) : KnownJob
      {
         if(!PlayedCharacterManager.getInstance().jobs)
         {
            return null;
         }
         var kj:KnownJob = PlayedCharacterManager.getInstance().jobs[jobId] as KnownJob;
         if(!kj)
         {
            return null;
         }
         return kj;
      }
      
      private function getJobDescription(jobId:uint) : JobDescription
      {
         var kj:KnownJob = this.getKnownJob(jobId);
         if(!kj)
         {
            return null;
         }
         return kj.jobDescription;
      }
      
      private function getJobExp(jobId:uint) : JobExperience
      {
         var kj:KnownJob = this.getKnownJob(jobId);
         if(!kj)
         {
            return null;
         }
         return kj.jobExperience;
      }
      
      private function getSkillActionDescription(jd:JobDescription, skillId:uint) : SkillActionDescription
      {
         var sd:SkillActionDescription = null;
         for each(sd in jd.skills)
         {
            if(sd.skillId == skillId)
            {
               return sd;
            }
         }
         return null;
      }
   }
}
