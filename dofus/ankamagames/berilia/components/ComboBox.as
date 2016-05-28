package com.ankamagames.berilia.components
{
   import com.ankamagames.berilia.types.graphic.GraphicContainer;
   import com.ankamagames.berilia.FinalizableUIComponent;
   import com.ankamagames.berilia.types.graphic.ButtonContainer;
   import flash.display.DisplayObject;
   import com.ankamagames.jerakine.types.Uri;
   import com.ankamagames.berilia.types.graphic.UiRootContainer;
   import com.ankamagames.berilia.api.SecureUiRootContainer;
   import com.ankamagames.berilia.api.SecureComponent;
   import com.ankamagames.jerakine.namespaces.restricted_namespace;
   import com.ankamagames.berilia.types.graphic.GraphicElement;
   import com.ankamagames.berilia.enums.StatesEnum;
   import com.ankamagames.jerakine.messages.Message;
   import com.ankamagames.berilia.components.messages.SelectItemMessage;
   import com.ankamagames.berilia.enums.SelectMethodEnum;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseDownMessage;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseWheelMessage;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardMessage;
   import flash.ui.Keyboard;
   import com.ankamagames.jerakine.handlers.messages.mouse.MouseReleaseOutsideMessage;
   import com.ankamagames.jerakine.handlers.messages.keyboard.KeyboardKeyUpMessage;
   import flash.events.Event;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   import flash.events.MouseEvent;
   import com.ankamagames.jerakine.interfaces.IInterfaceListener;
   import com.ankamagames.berilia.Berilia;
   
   public class ComboBox extends GraphicContainer implements FinalizableUIComponent
   {
       
      private var _list:com.ankamagames.berilia.components.Grid;
      
      private var _button:ButtonContainer;
      
      private var _mainContainer:DisplayObject;
      
      private var _bgTexture:com.ankamagames.berilia.components.Texture;
      
      private var _listTexture:com.ankamagames.berilia.components.Texture;
      
      private var _finalized:Boolean;
      
      private var _maxListSize:uint = 300;
      
      private var _previousState:Boolean = false;
      
      public var listSizeOffset:uint = 25;
      
      public var autoCenter:Boolean = true;
      
      public function ComboBox()
      {
         super();
         this._button = new ButtonContainer();
         this._button.soundId = "0";
         this._bgTexture = new com.ankamagames.berilia.components.Texture();
         this._listTexture = new com.ankamagames.berilia.components.Texture();
         this._list = new com.ankamagames.berilia.components.Grid();
         this.showList(false);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function set buttonTexture(uri:Uri) : void
      {
         this._bgTexture.uri = uri;
      }
      
      public function get buttonTexture() : Uri
      {
         return this._bgTexture.uri;
      }
      
      public function set listTexture(uri:Uri) : void
      {
         this._listTexture.uri = uri;
      }
      
      public function get listTexture() : Uri
      {
         return this._listTexture.uri;
      }
      
      public function get maxHeight() : uint
      {
         return this._maxListSize;
      }
      
      public function set maxHeight(v:uint) : void
      {
         this._maxListSize = v;
      }
      
      public function set dataProvider(data:*) : void
      {
         var nbSlot:uint = this._maxListSize / this._list.slotHeight;
         if(data.length > nbSlot)
         {
            this._list.width = width - 2;
            this._list.height = this._maxListSize;
            this._list.slotWidth = this._list.width - 16;
         }
         else
         {
            this._list.width = width - this.listSizeOffset;
            this._list.height = this._list.slotHeight * data.length;
            this._list.slotWidth = this._list.width;
         }
         this._listTexture.height = this._list.height + 8;
         this._listTexture.width = this._list.width + 3;
         this._list.dataProvider = data;
      }
      
      public function get dataProvider() : *
      {
         return this._list.dataProvider;
      }
      
      public function get finalized() : Boolean
      {
         return this._finalized;
      }
      
      public function set finalized(b:Boolean) : void
      {
         this._finalized = b;
      }
      
      public function set scrollBarCss(uri:Uri) : void
      {
         this._list.verticalScrollbarCss = uri;
      }
      
      public function get scrollBarCss() : Uri
      {
         return this._list.verticalScrollbarCss;
      }
      
      public function set rendererName(name:String) : void
      {
         this._list.rendererName = name;
      }
      
      public function get rendererName() : String
      {
         return this._list.rendererName;
      }
      
      public function set rendererArgs(args:String) : void
      {
         this._list.rendererArgs = args;
      }
      
      public function get rendererArgs() : String
      {
         return this._list.rendererArgs;
      }
      
      public function get value() : *
      {
         return this._list.selectedItem;
      }
      
      public function set value(o:*) : void
      {
         this._list.selectedItem = o;
      }
      
      public function set autoSelect(b:Boolean) : void
      {
         this._list.autoSelect = b;
      }
      
      public function get autoSelect() : Boolean
      {
         return this._list.autoSelect;
      }
      
      public function set selectedItem(v:Object) : void
      {
         this._list.selectedItem = v;
      }
      
      public function get selectedIndex() : uint
      {
         return this._list.selectedIndex;
      }
      
      public function set selectedIndex(v:uint) : void
      {
         this._list.selectedIndex = v;
      }
      
      public function get container() : *
      {
         if(!this._mainContainer)
         {
            return null;
         }
         if(this._mainContainer is UiRootContainer)
         {
            return SecureUiRootContainer.getSecureUi(this._mainContainer as UiRootContainer,getUi().uiModule.trusted);
         }
         return SecureComponent.getSecureComponent(this._mainContainer,getUi().uiModule.trusted);
      }
      
      restricted_namespace function renderModificator(childs:Array) : Array
      {
         this._list.rendererName = !!this._list.rendererName?this._list.rendererName:"LabelGridRenderer";
         this._list.rendererArgs = !!this._list.rendererArgs?this._list.rendererArgs:",0xFFFFFF,0xEEEEFF,0xC0E272,0x99D321";
         this._list.width = width - this.listSizeOffset;
         this._list.slotWidth = this._list.width - 16;
         this._list.slotHeight = height - 4;
         return this._list.restricted_namespace::renderModificator(childs);
      }
      
      public function finalize() : void
      {
         this._button.width = width;
         this._button.height = height;
         this._bgTexture.width = width;
         this._bgTexture.height = height;
         this._bgTexture.autoGrid = true;
         this._bgTexture.finalize();
         this._button.addChild(this._bgTexture);
         getUi().registerId(this._bgTexture.name,new GraphicElement(this._bgTexture,new Array(),this._bgTexture.name));
         var stateChangingProperties:Array = new Array();
         stateChangingProperties[StatesEnum.STATE_OVER] = new Array();
         stateChangingProperties[StatesEnum.STATE_OVER][this._bgTexture.name] = new Array();
         stateChangingProperties[StatesEnum.STATE_OVER][this._bgTexture.name]["gotoAndStop"] = StatesEnum.STATE_OVER_STRING.toLocaleLowerCase();
         stateChangingProperties[StatesEnum.STATE_CLICKED] = new Array();
         stateChangingProperties[StatesEnum.STATE_CLICKED][this._bgTexture.name] = new Array();
         stateChangingProperties[StatesEnum.STATE_CLICKED][this._bgTexture.name]["gotoAndStop"] = StatesEnum.STATE_CLICKED_STRING.toLocaleLowerCase();
         this._button.changingStateData = stateChangingProperties;
         this._button.finalize();
         this._list.width = width - this.listSizeOffset;
         this._list.slotWidth = this._list.width - 16;
         this._list.slotHeight = height - 4;
         this._list.x = 2;
         this._list.y = height + 2;
         this._list.finalize();
         this._listTexture.width = this._list.width + 4;
         this._listTexture.autoGrid = true;
         this._listTexture.y = height - 2;
         this._listTexture.finalize();
         addChild(this._button);
         addChild(this._listTexture);
         addChild(this._list);
         this._listTexture.mouseEnabled = false;
         this._list.mouseEnabled = false;
         this._mainContainer = this._list.renderer.render(null,0,false,false);
         this._mainContainer.x = this._list.x;
         if(this.autoCenter)
         {
            this._mainContainer.y = (height - this._mainContainer.height) / 2;
         }
         this._button.addChild(this._mainContainer);
         this._finalized = true;
         getUi().iAmFinalized(this);
      }
      
      override public function process(msg:Message) : Boolean
      {
         switch(true)
         {
            case msg is MouseReleaseOutsideMessage:
               this.showList(false);
               break;
            case msg is SelectItemMessage:
               this._list.renderer.update(this._list.selectedItem,0,this._mainContainer,false,false);
               switch(SelectItemMessage(msg).selectMethod)
               {
                  case SelectMethodEnum.UP_ARROW:
                  case SelectMethodEnum.DOWN_ARROW:
                  case SelectMethodEnum.RIGHT_ARROW:
                  case SelectMethodEnum.LEFT_ARROW:
                     break;
                  default:
                     this.showList(false);
               }
               break;
            case msg is MouseDownMessage:
               if(!this._list.visible)
               {
                  this.showList(true);
                  this._list.moveTo(this._list.selectedIndex);
               }
               else if(MouseDownMessage(msg).target == this._button)
               {
                  this.showList(false);
               }
               break;
            case msg is MouseWheelMessage:
               if(this._list.visible)
               {
                  this._list.process(msg);
               }
               else
               {
                  this._list.setSelectedIndex(this._list.selectedIndex + MouseWheelMessage(msg).mouseEvent.delta / Math.abs(MouseWheelMessage(msg).mouseEvent.delta) * -1,SelectMethodEnum.WHEEL);
               }
               return true;
            case msg is KeyboardKeyUpMessage:
               if(KeyboardMessage(msg).keyboardEvent.keyCode == Keyboard.ENTER && Boolean(this._list.visible))
               {
                  this.showList(false);
                  return true;
               }
               break;
            case msg is KeyboardMessage:
               this._list.process(msg);
         }
         return false;
      }
      
      override public function remove() : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         StageShareManager.stage.removeEventListener(MouseEvent.CLICK,this.onClick);
         this._listTexture.remove();
         this._list.remove();
         this._button.remove();
         this._list.renderer.remove(this._mainContainer);
         SecureComponent.restricted_namespace::destroy(this._mainContainer);
         SecureComponent.restricted_namespace::destroy(this._list);
         this._bgTexture.remove();
         this._bgTexture = null;
         this._list = null;
         this._button = null;
         this._mainContainer = null;
         this._listTexture = null;
         super.remove();
      }
      
      private function showList(show:Boolean) : void
      {
         var listener:IInterfaceListener = null;
         var listener2:IInterfaceListener = null;
         if(this._previousState != show)
         {
            if(show)
            {
               for each(listener in Berilia.getInstance().UISoundListeners)
               {
                  listener.playUISound("16012");
               }
            }
            else
            {
               for each(listener2 in Berilia.getInstance().UISoundListeners)
               {
                  listener2.playUISound("16013");
               }
            }
         }
         this._listTexture.visible = show;
         this._list.visible = show;
         this._previousState = show;
      }
      
      private function onClick(e:MouseEvent) : void
      {
         var p:DisplayObject = DisplayObject(e.target);
         while(p.parent)
         {
            if(p == this)
            {
               return;
            }
            p = p.parent;
         }
         this.showList(false);
      }
      
      private function onAddedToStage(e:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         StageShareManager.stage.addEventListener(MouseEvent.CLICK,this.onClick);
      }
   }
}
