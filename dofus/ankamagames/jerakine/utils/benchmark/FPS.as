package com.ankamagames.jerakine.utils.benchmark
{
   import flash.display.Sprite;
   import com.ankamagames.jerakine.logger.Logger;
   import com.ankamagames.jerakine.logger.Log;
   import flash.utils.getQualifiedClassName;
   import flash.text.TextField;
   import flash.events.MouseEvent;
   import flash.events.Event;
   import flash.display.DisplayObjectContainer;
   import flash.utils.getTimer;
   import flash.system.System;
   import flash.display.DisplayObject;
   import flash.display.InteractiveObject;
   import flash.profiler.showRedrawRegions;
   import flash.events.KeyboardEvent;
   import flash.events.TextEvent;
   import com.ankamagames.jerakine.utils.display.StageShareManager;
   
   public class FPS extends Sprite
   {
      
      private static var _self:com.ankamagames.jerakine.utils.benchmark.FPS;
      
      public static var Fonction:Function;
      
      protected static const _log:Logger = Log.getLogger(getQualifiedClassName(com.ankamagames.jerakine.utils.benchmark.FPS));
       
      private var TempsZero:int;
      
      private var Largeur:int;
      
      private var Hauteur:int;
      
      private var ListeCouleur:Array;
      
      private var Graphique:Sprite;
      
      private var Cadre:Sprite;
      
      private var ListeCourbe:Array;
      
      private var ListeCourbeBase:Array;
      
      private var CourbeIPS:Array;
      
      private var Decalage:Array;
      
      private var DecalageX:int;
      
      private var DecalageY:int;
      
      private var Mémoire:TextField;
      
      private var TexteIPS:TextField;
      
      private var NbImage:int = 0;
      
      private var TempsImage:int = 0;
      
      private var ISBase:int;
      
      private var Retracage:Boolean = false;
      
      private var sLog:Sprite;
      
      private var tLog:TextField;
      
      private var ctrlKey:Boolean = false;
      
      private var logObjectList:Array;
      
      private var lastLog:String;
      
      public var O:Object;
      
      public function FPS(L:int, H:int, IS:int)
      {
         this.ListeCouleur = new Array(7108545,13325419,40277,15394843,16525567);
         this.Graphique = new Sprite();
         this.Cadre = new Sprite();
         this.ListeCourbe = new Array();
         this.ListeCourbeBase = new Array();
         this.CourbeIPS = new Array();
         this.Decalage = new Array();
         this.Mémoire = new TextField();
         this.TexteIPS = new TextField();
         this.sLog = new Sprite();
         this.tLog = new TextField();
         this.logObjectList = new Array();
         super();
         this.ISBase = IS;
         this.Largeur = L;
         this.Hauteur = H;
         addChild(this.Graphique);
         graphics.beginFill(0,0.8);
         graphics.drawRoundRect(-1,0,this.Largeur,this.Hauteur + 2,10,10);
         graphics.endFill();
         this.Cadre.addChild(this.Mémoire);
         this.Mémoire.x = 0;
         this.Mémoire.y = this.Hauteur - 20;
         this.Mémoire.selectable = false;
         this.Mémoire.multiline = false;
         this.Mémoire.width = 50;
         this.Mémoire.height = 22;
         this.Mémoire.thickness = 200;
         this.Cadre.addChild(this.TexteIPS);
         this.TexteIPS.x = 10;
         this.TexteIPS.selectable = false;
         this.TexteIPS.multiline = false;
         this.TexteIPS.width = 50;
         this.TexteIPS.height = 22;
         this.TexteIPS.thickness = 200;
         addChild(this.Cadre);
         this.Cadre.graphics.lineStyle(2,0,1,true);
         this.Cadre.graphics.beginFill(0,0.7);
         this.Cadre.graphics.drawRoundRect(-1,0,40,this.Hauteur + 2,10,10);
         this.Cadre.graphics.endFill();
         this.Cadre.graphics.lineStyle(1,12078546,0.8,true);
         this.Cadre.graphics.moveTo(0,this.Hauteur - Math.ceil(1000 / IS));
         this.Cadre.graphics.lineTo(this.Largeur,this.Hauteur - Math.ceil(1000 / IS));
         this.Cadre.graphics.lineStyle(2,0,1,true);
         this.Cadre.graphics.drawRoundRect(-1,0,this.Largeur,this.Hauteur + 2,10,10);
         addChild(this.sLog);
         this.sLog.addChild(this.tLog);
         this.sLog.x = this.Largeur + 5;
         this.tLog.x = 2;
         this.tLog.y = 1;
         this.tLog.selectable = false;
         this.tLog.multiline = true;
         this.tLog.thickness = 200;
         this.tLog.autoSize = "left";
         this.tLog.addEventListener(TextEvent.LINK,this.disabledList);
         this.Graphique.graphics.lineStyle(1);
         StageShareManager.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDownHandler);
         StageShareManager.stage.addEventListener(KeyboardEvent.KEY_UP,this.keyUpHandler);
      }
      
      public static function getInstance() : com.ankamagames.jerakine.utils.benchmark.FPS
      {
         if(!_self)
         {
            _self = new com.ankamagames.jerakine.utils.benchmark.FPS(200,50,50);
         }
         return _self;
      }
      
      public function init() : void
      {
         addEventListener(MouseEvent.MOUSE_DOWN,this.Clique);
         addEventListener(Event.ENTER_FRAME,this.Boucle,false,100000);
      }
      
      public function destroy() : void
      {
         removeEventListener(MouseEvent.MOUSE_DOWN,this.Clique);
         removeEventListener(Event.ENTER_FRAME,this.Boucle);
      }
      
      public function watchArray(name:String, list:Object, now:Boolean = true) : void
      {
         var num:int = this.logObjectList.length;
         for(var i:int = 0; i < num; i = i + 4)
         {
            if(this.logObjectList[i] == name)
            {
               this.logObjectList[i + 1] = list;
               return;
            }
         }
         this.logObjectList.push(name,list,now,0);
      }
      
      public function watchSprite(name:String, sprite:DisplayObjectContainer, now:Boolean = true) : void
      {
         var num:int = this.logObjectList.length;
         for(var i:int = 0; i < num; i = i + 4)
         {
            if(this.logObjectList[i] == name)
            {
               this.logObjectList[i + 1] = sprite;
               return;
            }
         }
         this.logObjectList.push(name,sprite,now,1);
      }
      
      public function watchMouse(name:String, sprite:DisplayObjectContainer, now:Boolean = true) : void
      {
         var num:int = this.logObjectList.length;
         for(var i:int = 0; i < num; i = i + 4)
         {
            if(this.logObjectList[i] == name)
            {
               this.logObjectList[i + 1] = sprite;
               return;
            }
         }
         this.logObjectList.push(name,sprite,now,2);
      }
      
      public function updateLog() : void
      {
         var text:String = null;
         var num:int = 0;
         var i:int = 0;
         var name:String = null;
         var D:int = 0;
         var list:Object = null;
         var value:int = 0;
         var type:int = 0;
         var o:Object = null;
         if(this.sLog.stage)
         {
            text = "<font size=\'13\' face=\'Verdana\'>";
            num = this.logObjectList.length;
            for(i = 0; i < num; i = i + 4)
            {
               name = this.logObjectList[i];
               if(name == "[Tiphon] _aResources")
               {
                  D = 0;
               }
               if(this.logObjectList[i + 2])
               {
                  list = this.logObjectList[i + 1];
                  value = 0;
                  type = this.logObjectList[i + 3];
                  if(type == 0)
                  {
                     for each(o in list)
                     {
                        value++;
                     }
                  }
                  else if(type == 1)
                  {
                     value = this.countDisplayObject(list as DisplayObjectContainer);
                  }
                  else if(type == 2)
                  {
                     value = this.countEvilMouse(list as DisplayObjectContainer);
                  }
                  text = text + ("<font color=\'#009D9D\'><a href=\'event:" + name + "\'>" + name + "</a></font><font color=\'#C8C9DD\'> -&gt; </font><font color=\'#6C77C1\'>" + value + "</font>\n");
               }
               else
               {
                  text = text + ("<font color=\'#CB546B\'><a href=\'event:" + name + "\'>" + name + "</a></font>\n");
               }
            }
            if(this.lastLog != text)
            {
               this.lastLog = text;
               this.tLog.htmlText = text;
               this.sLog.graphics.clear();
               this.sLog.graphics.lineStyle(2,0,1,true);
               this.sLog.graphics.beginFill(0,0.8);
               this.sLog.graphics.drawRoundRect(-1,0,this.tLog.width + 8,this.tLog.height + 3,10,10);
               this.sLog.graphics.endFill();
            }
         }
      }
      
      public function Nouvelle_Valeur(COURBE:int, BASE:Boolean = false, CUMULUS:Boolean = false) : void
      {
         var Courbe:Array = null;
         var ValeurFinie:int = 0;
         var ValeurCible:int = 0;
         var Valeur:int = getTimer();
         if(COURBE == -1)
         {
            if(Valeur - this.TempsImage > 1000)
            {
               this.TempsImage = this.TempsImage + 1000;
               if(this.NbImage < this.ISBase * 0.6)
               {
                  this.TexteIPS.htmlText = "<font face=\'Verdana\' size=\'10\' color=\'#F83F43\' >" + this.NbImage;
               }
               else if(this.NbImage < this.ISBase * 0.8)
               {
                  this.TexteIPS.htmlText = "<font face=\'Verdana\' size=\'10\' color=\'#F7DB40\' >" + this.NbImage;
               }
               else
               {
                  this.TexteIPS.htmlText = "<font face=\'Verdana\' size=\'10\' color=\'#2F7FCC\' >" + this.NbImage;
               }
               this.NbImage = 0;
            }
            this.NbImage++;
            if(this.TempsZero == 0)
            {
               this.TempsZero = Valeur;
            }
            else
            {
               this.CourbeIPS.push(Valeur - this.TempsZero);
               this.TempsZero = Valeur;
               if(this.CourbeIPS.length > this.Largeur)
               {
                  this.CourbeIPS.shift();
               }
            }
         }
         else
         {
            Courbe = this.ListeCourbe[COURBE];
            if(Courbe == null)
            {
               Courbe = new Array();
               this.ListeCourbe[COURBE] = Courbe;
               Courbe.push(0);
            }
            if(BASE)
            {
               this.ListeCourbeBase[COURBE] = Valeur;
            }
            else
            {
               ValeurFinie = Valeur - this.ListeCourbeBase[COURBE];
               ValeurCible = Courbe.length - 1;
               Courbe[ValeurCible] = Courbe[ValeurCible] + ValeurFinie;
            }
         }
      }
      
      public function Rendu() : void
      {
         this.Mémoire.htmlText = "<font face=\'Verdana\' size=\'10\' color=\'#6C77C1\' >" + int(System.totalMemory / 10000) / 100;
         this.Graphique.graphics.clear();
         this.Graphique.graphics.lineStyle(1,16777215,1,true);
         var CodeCouleur:int = 0;
         this.Tracage_Courbe(this.CourbeIPS);
         var NbCourbe:int = this.ListeCourbe.length;
         for(var c:int = 0; c < NbCourbe; c++)
         {
            this.Graphique.graphics.lineStyle(1,this.ListeCouleur[c],1,true);
            if(c == 0)
            {
               this.Tracage_Courbe(this.ListeCourbe[c],false,false);
            }
            else
            {
               this.Tracage_Courbe(this.ListeCourbe[c],false);
            }
         }
         this.updateLog();
      }
      
      private function Tracage_Courbe(COURBE:Array, DECALAGE:Boolean = false, INIT_DECALAGE:Boolean = false) : void
      {
         var i:int = 0;
         var Valeur:int = 0;
         var Nb:int = COURBE.length;
         if(Nb > 0)
         {
            this.Graphique.graphics.moveTo(0,this.Hauteur - COURBE[0]);
            for(i = 0; i < Nb; i++)
            {
               Valeur = COURBE[i];
               if(INIT_DECALAGE)
               {
                  this.Decalage[i] = Valeur;
                  this.Graphique.graphics.lineTo(i,this.Hauteur - Valeur);
               }
               else if(DECALAGE)
               {
                  this.Decalage[i] = this.Decalage[i] + Valeur;
                  this.Graphique.graphics.lineTo(i,this.Hauteur - this.Decalage[i]);
               }
               else
               {
                  this.Graphique.graphics.lineTo(i,this.Hauteur - Valeur);
               }
            }
         }
      }
      
      private function countDisplayObject(doc:DisplayObjectContainer) : int
      {
         var dio:DisplayObject = null;
         var value:int = 0;
         var num:int = doc.numChildren;
         for(var i:int = 0; i < num; i++)
         {
            dio = doc.getChildAt(i);
            if(dio is DisplayObjectContainer)
            {
               value = value + this.countDisplayObject(dio as DisplayObjectContainer);
            }
            else
            {
               value++;
            }
         }
         return value;
      }
      
      private function countEvilMouse(doc:DisplayObjectContainer) : int
      {
         var dio:DisplayObject = null;
         var dioc:DisplayObjectContainer = null;
         var value:int = 0;
         var num:int = doc.numChildren;
         for(var i:int = 0; i < num; i++)
         {
            dio = doc.getChildAt(i);
            if(dio is DisplayObjectContainer)
            {
               dioc = dio as DisplayObjectContainer;
               if(dioc.mouseEnabled)
               {
                  value++;
               }
               if(dioc.mouseChildren)
               {
                  value = value + this.countEvilMouse(dioc);
               }
            }
            else if(dio is InteractiveObject)
            {
               if(InteractiveObject(dio).mouseEnabled)
               {
                  value++;
               }
            }
         }
         return value;
      }
      
      private function Boucle(E:Event) : void
      {
         var Courbe:Array = null;
         this.Rendu();
         this.Nouvelle_Valeur(-1);
         var nb:int = this.ListeCourbe.length;
         for(var i:int = 0; i < nb; i++)
         {
            Courbe = this.ListeCourbe[i];
            Courbe.push(0);
            if(Courbe.length > this.Largeur)
            {
               Courbe.shift();
            }
         }
      }
      
      private function Clique(E:MouseEvent) : void
      {
         if(mouseX < 40)
         {
            if(this.ctrlKey)
            {
               if(Fonction != null)
               {
                  Fonction();
               }
            }
            else if(mouseY < 25)
            {
               this.Retracage = !this.Retracage;
               showRedrawRegions(this.Retracage,17595);
            }
            else
            {
               System.gc();
            }
         }
         else
         {
            this.DecalageX = mouseX;
            this.DecalageY = mouseY;
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.Boucle_Souris);
            stage.addEventListener(MouseEvent.MOUSE_UP,this.Declique);
         }
      }
      
      private function Declique(E:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.Boucle_Souris);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.Declique);
      }
      
      private function Boucle_Souris(E:MouseEvent) : void
      {
         x = stage.mouseX - this.DecalageX;
         y = stage.mouseY - this.DecalageY;
         E.updateAfterEvent();
      }
      
      private function keyDownHandler(E:KeyboardEvent) : void
      {
         this.ctrlKey = E.ctrlKey;
      }
      
      private function keyUpHandler(E:KeyboardEvent) : void
      {
         this.ctrlKey = E.ctrlKey;
      }
      
      private function disabledList(E:TextEvent) : void
      {
         var list:Object = null;
         var o:* = undefined;
         var name:String = E.text;
         var num:int = this.logObjectList.length;
         for(var i:int = 0; i < num; i = i + 4)
         {
            if(this.logObjectList[i] == name)
            {
               if(this.logObjectList[i + 3] == 0)
               {
                  list = this.logObjectList[i + 1];
                  for(o in list)
                  {
                     list[o] = null;
                     delete list[o];
                  }
               }
               else
               {
                  this.logObjectList[i + 2] = !this.logObjectList[i + 2];
               }
               return;
            }
         }
      }
   }
}
