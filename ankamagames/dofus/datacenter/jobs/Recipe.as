package com.ankamagames.dofus.datacenter.jobs
{
   import com.ankamagames.jerakine.data.GameData;
   import com.ankamagames.dofus.internalDatacenter.items.ItemWrapper;
   
   public class Recipe
   {
      
      private static const MODULE:String = "Recipes";
       
      public var resultId:int;
      
      private var _result:ItemWrapper;
      
      public var ingredientIds:Vector.<int>;
      
      public var quantities:Vector.<uint>;
      
      private var _ingredients:Vector.<ItemWrapper>;
      
      public function Recipe()
      {
         super();
      }
      
      public static function create(resultId:int, ingredientIds:Vector.<int>, quantities:Vector.<uint>) : Recipe
      {
         var o:Recipe = new Recipe();
         o.resultId = resultId;
         o.ingredientIds = ingredientIds;
         o.quantities = quantities;
         return o;
      }
      
      public static function getRecipeByResultId(resultId:int) : Recipe
      {
         return GameData.getObject(MODULE,resultId) as Recipe;
      }
      
      public function get result() : ItemWrapper
      {
         if(!this._result)
         {
            this._result = ItemWrapper.create(0,0,this.resultId,0,null,false);
         }
         return this._result;
      }
      
      public function get ingredients() : Vector.<ItemWrapper>
      {
         var ingredientsCount:uint = 0;
         var i:uint = 0;
         if(this._ingredients == null)
         {
            ingredientsCount = this.ingredientIds.length;
            this._ingredients = new Vector.<ItemWrapper>(ingredientsCount,true);
            for(i = 0; i < ingredientsCount; i++)
            {
               this._ingredients[i] = ItemWrapper.create(0,0,this.ingredientIds[i],this.quantities[i],null,false);
            }
         }
         return this._ingredients;
      }
   }
}
