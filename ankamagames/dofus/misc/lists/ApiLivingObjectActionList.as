package com.ankamagames.dofus.misc.lists
{
   import com.ankamagames.berilia.types.data.ApiAction;
   import com.ankamagames.dofus.logic.game.common.actions.livingObject.LivingObjectDissociateAction;
   import com.ankamagames.dofus.logic.game.common.actions.livingObject.LivingObjectFeedAction;
   import com.ankamagames.dofus.logic.game.common.actions.livingObject.LivingObjectChangeSkinRequestAction;
   
   public class ApiLivingObjectActionList
   {
      
      public static const LivingObjectDissociate:ApiAction = new ApiAction("LivingObjectDissociate",LivingObjectDissociateAction,true);
      
      public static const LivingObjectFeed:ApiAction = new ApiAction("LivingObjectFeed",LivingObjectFeedAction,true);
      
      public static const LivingObjectChangeSkinRequest:ApiAction = new ApiAction("LivingObjectChangeSkinRequest",LivingObjectChangeSkinRequestAction,true);
       
      public function ApiLivingObjectActionList()
      {
         super();
      }
   }
}
