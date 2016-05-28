package com.ankamagames.berilia.frames
{
   import com.ankamagames.jerakine.messages.Frame;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import com.ankamagames.jerakine.types.enums.Priority;
   import flash.display.DisplayObject;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.jerakine.handlers.messages.HumanInputMessage;
   import com.ankamagames.berilia.components.Grid;
   import com.ankamagames.berilia.components.messages.ComponentMessage;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardKeyUpMessage;
   import com.ankamagames.berilia.UIComponent;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseClickMessage;
   import com.ankamagames.jerakine.handlers.messages.Action;
   import com.ankamagames.berilia.types.event.InstanceEvent;
   import com.ankamagames.berilia.managers.KernelEventsManager;
   import com.ankamagames.berilia.utils.BeriliaHookList;
   import com.ankamagames.berilia.api.SecureComponent;
   import com.ankamagames.berilia.managers.UIEventManager;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseDoubleClickMessage;
   import flash.display.InteractiveObject;
   import flash.events.MouseEvent;
   import com.ankamagames.berilia.Berilia;
   import com.ankamagames.berilia.components.messages.SelectItemMessage;
   import com.ankamagames.berilia.components.messages.ItemRollOverMessage;
   import com.ankamagames.berilia.components.messages.ItemRollOutMessage;
   import com.ankamagames.berilia.components.messages.ItemRightClickMessage;
   import com.ankamagames.berilia.components.messages.DropMessage;
   import com.ankamagames.berilia.components.messages.DeleteTabMessage;
   import com.ankamagames.berilia.components.messages.RenameTabMessage;
   import com.ankamagames.jerakine.utils.misc.ReadOnlyObject;
   import com.ankamagames.berilia.components.messages.MapElementRollOverMessage;
   import com.ankamagames.berilia.components.messages.MapElementRollOutMessage;
   import com.ankamagames.berilia.components.messages.MapRollOverMessage;
   import com.ankamagames.berilia.components.messages.VideoBufferChangeMessage;
   import com.ankamagames.berilia.components.messages.ColorChangeMessage;
   import com.ankamagames.berilia.components.messages.TextureReadyMessage;
   import com.ankamagames.berilia.components.messages.CreateTabMessage;
   import com.ankamagames.berilia.components.messages.MapMoveMessage;
   import com.ankamagames.berilia.components.messages.VideoConnectFailedMessage;
   import com.ankamagames.berilia.components.messages.VideoConnectSuccessMessage;
   import com.ankamagames.berilia.components.messages.ComponentReadyMessage;
   import com.ankamagames.jerakine.utils.misc.BoxingUnBoxing;
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.berilia.enums.EventEnums;
   import com.ankamagames.jerakine.utils.misc.CallWithParameters;
   
   public class UIInteractionFrame implements Frame
   {
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(UIInteractionFrame));
       
      private var hierarchy:Array;
      
      private var currentDo:DisplayObject;
      
      public function UIInteractionFrame()
      {
         super();
      }
      
      public function get priority() : int
      {
         return Priority.HIGHEST;
      }
      
      public function process(msg:Message) : Boolean
      {
         var himsg:HumanInputMessage = null;
         var onlyGrid:Boolean = false;
         var isGrid:* = false;
         var gridInstance:Grid = null;
         var dispatched:Boolean = false;
         var comsg:ComponentMessage = null;
         var kkumsg:KeyboardKeyUpMessage = null;
         var uic:UIComponent = null;
         var res:Boolean = false;
         var newMsg:MouseClickMessage = null;
         var uic3:UIComponent = null;
         var uic4:UIComponent = null;
         var act2:Action = null;
         var ie2:InstanceEvent = null;
         var args:Array = null;
         this.currentDo = null;
         switch(true)
         {
            case msg is HumanInputMessage:
               himsg = HumanInputMessage(msg);
               this.hierarchy = new Array();
               this.currentDo = himsg.target;
               while(this.currentDo != null)
               {
                  if(this.currentDo is UIComponent)
                  {
                     this.hierarchy.push(this.currentDo);
                  }
                  this.currentDo = this.currentDo.parent;
               }
               if(msg is MouseClickMessage)
               {
                  KernelEventsManager.getInstance().processCallback(BeriliaHookList.MouseClick,SecureComponent.getSecureComponent(MouseClickMessage(msg).target));
               }
               if(msg is KeyboardKeyUpMessage)
               {
                  kkumsg = KeyboardKeyUpMessage(msg);
                  KernelEventsManager.getInstance().processCallback(BeriliaHookList.KeyUp,SecureComponent.getSecureComponent(kkumsg.target),kkumsg.keyboardEvent.keyCode);
               }
               onlyGrid = false;
               for each(uic in this.hierarchy)
               {
                  isGrid = UIComponent(uic) is Grid;
                  if(!onlyGrid || Boolean(isGrid))
                  {
                     res = UIComponent(uic).process(himsg);
                     if(res)
                     {
                        if(isGrid)
                        {
                           onlyGrid = true;
                        }
                        else
                        {
                           this.hierarchy = null;
                           this.currentDo = null;
                           return true;
                        }
                     }
                  }
                  if(!gridInstance && Boolean(isGrid))
                  {
                     gridInstance = Grid(uic);
                  }
               }
               this.currentDo = himsg.target;
               dispatched = false;
               while(this.currentDo != null)
               {
                  if(UIEventManager.getInstance().isRegisteredInstance(this.currentDo,msg))
                  {
                     dispatched = true;
                     this.processRegisteredUiEvent(msg,gridInstance);
                     break;
                  }
                  this.currentDo = this.currentDo.parent;
               }
               if(msg is MouseClickMessage)
               {
                  KernelEventsManager.getInstance().processCallback(BeriliaHookList.PostMouseClick,SecureComponent.getSecureComponent(MouseClickMessage(msg).target));
               }
               if(msg is MouseDoubleClickMessage && !dispatched)
               {
                  newMsg = new MouseClickMessage(himsg.target as InteractiveObject,new MouseEvent(MouseEvent.CLICK));
                  Berilia.getInstance().handler.process(newMsg);
               }
               this.hierarchy = null;
               this.currentDo = null;
               break;
            case msg is ComponentMessage:
               comsg = ComponentMessage(msg);
               this.hierarchy = new Array();
               this.currentDo = comsg.target;
               while(this.currentDo != null)
               {
                  if(this.currentDo is UIComponent)
                  {
                     this.hierarchy.unshift(this.currentDo);
                  }
                  this.currentDo = this.currentDo.parent;
               }
               if(this.hierarchy.length == 0)
               {
                  return false;
               }
               for each(uic3 in this.hierarchy)
               {
                  UIComponent(uic3).process(comsg);
               }
               comsg.bubbling = true;
               this.hierarchy.reverse();
               this.hierarchy.pop();
               for each(uic4 in this.hierarchy)
               {
                  UIComponent(uic4).process(comsg);
               }
               this.hierarchy = null;
               if(!comsg.canceled)
               {
                  for each(act2 in comsg.actions)
                  {
                     Berilia.getInstance().handler.process(act2);
                  }
                  this.currentDo = comsg.target;
                  while(this.currentDo != null)
                  {
                     if(Boolean(UIEventManager.getInstance().instances[this.currentDo]) && Boolean(UIEventManager.getInstance().instances[this.currentDo].events[getQualifiedClassName(msg)]))
                     {
                        ie2 = InstanceEvent(UIEventManager.getInstance().instances[this.currentDo]);
                        switch(true)
                        {
                           case msg is ColorChangeMessage:
                              args = [SecureComponent.getSecureComponent(ie2.instance)];
                              break;
                           case msg is SelectItemMessage:
                              args = [SecureComponent.getSecureComponent(ie2.instance),SelectItemMessage(msg).selectMethod,SelectItemMessage(msg).isNewSelection];
                              break;
                           case msg is ItemRollOverMessage:
                              args = [SecureComponent.getSecureComponent(ie2.instance),ItemRollOverMessage(msg).item];
                              break;
                           case msg is ItemRollOutMessage:
                              args = [SecureComponent.getSecureComponent(ie2.instance),ItemRollOutMessage(msg).item];
                              break;
                           case msg is ItemRightClickMessage:
                              args = [SecureComponent.getSecureComponent(ie2.instance),ItemRightClickMessage(msg).item];
                              break;
                           case msg is TextureReadyMessage:
                              args = [SecureComponent.getSecureComponent(ie2.instance)];
                              break;
                           case msg is DropMessage:
                              args = [DropMessage(msg).target,DropMessage(msg).source];
                              break;
                           case msg is CreateTabMessage:
                              args = [SecureComponent.getSecureComponent(ie2.instance)];
                              break;
                           case msg is DeleteTabMessage:
                              args = [SecureComponent.getSecureComponent(ie2.instance),DeleteTabMessage(msg).deletedIndex];
                              break;
                           case msg is RenameTabMessage:
                              args = [SecureComponent.getSecureComponent(ie2.instance),RenameTabMessage(msg).index,RenameTabMessage(msg).name];
                              break;
                           case msg is MapElementRollOverMessage:
                              args = [SecureComponent.getSecureComponent(ie2.instance),ReadOnlyObject.create(MapElementRollOverMessage(msg).targetedElement)];
                              break;
                           case msg is MapElementRollOutMessage:
                              args = [SecureComponent.getSecureComponent(ie2.instance),ReadOnlyObject.create(MapElementRollOutMessage(msg).targetedElement)];
                              break;
                           case msg is MapMoveMessage:
                              args = [SecureComponent.getSecureComponent(ie2.instance)];
                              break;
                           case msg is MapRollOverMessage:
                              args = [SecureComponent.getSecureComponent(ie2.instance),MapRollOverMessage(msg).x,MapRollOverMessage(msg).y];
                              break;
                           case msg is VideoConnectFailedMessage:
                              args = [SecureComponent.getSecureComponent(ie2.instance)];
                              break;
                           case msg is VideoConnectSuccessMessage:
                              args = [SecureComponent.getSecureComponent(ie2.instance)];
                              break;
                           case msg is VideoBufferChangeMessage:
                              args = [SecureComponent.getSecureComponent(ie2.instance),VideoBufferChangeMessage(msg).state];
                              break;
                           case msg is ComponentReadyMessage:
                              args = [SecureComponent.getSecureComponent(ie2.instance)];
                        }
                        if(args)
                        {
                           args = BoxingUnBoxing.boxParam(args);
                           GraphicContainer(ie2.instance).getUi().restricted_namespace::call(ie2.callbackObject[EventEnums.convertMsgToFct(getQualifiedClassName(msg))],args);
                           return true;
                        }
                        break;
                     }
                     this.currentDo = this.currentDo.parent;
                  }
               }
               break;
         }
         return false;
      }
      
      public function pushed() : Boolean
      {
         return true;
      }
      
      public function pulled() : Boolean
      {
         return true;
      }
      
      private function processRegisteredUiEvent(msg:Message, gridInstance:Grid) : void
      {
         var args:Array = null;
         var fct:String = null;
         var ie:InstanceEvent = InstanceEvent(UIEventManager.getInstance().instances[this.currentDo]);
         var fctName:String = EventEnums.convertMsgToFct(getQualifiedClassName(msg));
         if(gridInstance)
         {
            args = [SecureComponent.getSecureComponent(ie.instance)];
            fct = gridInstance.renderer.eventModificator(msg,fctName,args,ie.instance as UIComponent);
            CallWithParameters.call(ie.callbackObject[fctName],args);
         }
         else
         {
            ie.callbackObject[fctName](SecureComponent.getSecureComponent(ie.instance));
         }
      }
   }
}
