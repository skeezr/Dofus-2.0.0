package com.ankamagames.jerakine.utils.display
{
   import com.ankamagames.jerakine.types.Point3D;
   import flash.geom.Point;
   
   public class Dofus1Line
   {
       
      public function Dofus1Line()
      {
         super();
      }
      
      public static function getLine(x1:int, y1:int, z1:int, x2:int, y2:int, z2:int) : Array
      {
         var i:int = 0;
         var pStart:Point3D = null;
         var cell:Point = null;
         var y:uint = 0;
         var x:uint = 0;
         var line:Array = new Array();
         var pFrom:Point3D = new Point3D(x1,y1,z1);
         var pTo:Point3D = new Point3D(x2,y2,z2);
         pStart = new Point3D(pFrom.x + 0.5,pFrom.y + 0.5,pFrom.z);
         var pEnd:Point3D = new Point3D(pTo.x + 0.5,pTo.y + 0.5,pTo.z);
         var padX:Number = 0;
         var padY:Number = 0;
         var padZ:Number = 0;
         var steps:Number = 0;
         var descending:* = pStart.z > pEnd.z;
         var xToTest:Array = new Array();
         var yToTest:Array = new Array();
         var cas:uint = 0;
         if(Math.abs(pStart.x - pEnd.x) == Math.abs(pStart.y - pEnd.y))
         {
            steps = Math.abs(pStart.x - pEnd.x);
            padX = pEnd.x > pStart.x?Number(1):Number(-1);
            padY = pEnd.y > pStart.y?Number(1):Number(-1);
            padZ = steps == 0?Number(0):!!descending?Number((pFrom.z - pTo.z) / steps):Number((pTo.z - pFrom.z) / steps);
            cas = 1;
         }
         else if(Math.abs(pStart.x - pEnd.x) > Math.abs(pStart.y - pEnd.y))
         {
            steps = Math.abs(pStart.x - pEnd.x);
            padX = pEnd.x > pStart.x?Number(1):Number(-1);
            padY = pEnd.y > pStart.y?Math.abs(pStart.y - pEnd.y) == 0?Number(0):Number(Math.abs(pStart.y - pEnd.y) / steps):Number(-Math.abs(pStart.y - pEnd.y) / steps);
            padZ = steps == 0?Number(0):!!descending?Number((pFrom.z - pTo.z) / steps):Number((pTo.z - pFrom.z) / steps);
            cas = 2;
         }
         else
         {
            steps = Math.abs(pStart.y - pEnd.y);
            padX = pEnd.x > pStart.x?Math.abs(pStart.x - pEnd.x) == 0?Number(0):Number(Math.abs(pStart.x - pEnd.x) / steps):Number(-Math.abs(pStart.x - pEnd.x) / steps);
            padY = pEnd.y > pStart.y?Number(1):Number(-1);
            padZ = steps == 0?Number(0):!!descending?Number((pFrom.z - pTo.z) / steps):Number((pTo.z - pFrom.z) / steps);
            cas = 3;
         }
         for(i = 0; i < steps; i++)
         {
            if(cas == 2)
            {
               if(Math.floor(pStart.y + padY / 2) == Math.floor(pStart.y + padY * 3 / 2))
               {
                  yToTest = [Math.floor(pStart.y + padY)];
               }
               else
               {
                  yToTest = [Math.floor(pStart.y + padY / 2),Math.floor(pStart.y + padY * 3 / 2)];
               }
            }
            else if(cas == 3)
            {
               if(Math.floor(pStart.x + padX / 2) == Math.floor(pStart.x + padX * 3 / 2))
               {
                  xToTest = [Math.floor(pStart.x + padX)];
               }
               else
               {
                  xToTest = [Math.floor(pStart.x + padX / 2),Math.floor(pStart.x + padX * 3 / 2)];
               }
            }
            if(yToTest.length > 0)
            {
               for(y = 0; y < yToTest.length; y++)
               {
                  cell = new Point(Math.floor(pStart.x + padX),yToTest[y]);
                  line.push(cell);
               }
            }
            else if(xToTest.length > 0)
            {
               for(x = 0; x < xToTest.length; x++)
               {
                  cell = new Point(xToTest[x],Math.floor(pStart.y + padY));
                  line.push(cell);
               }
            }
            else
            {
               cell = new Point(Math.floor(pStart.x + padX),Math.floor(pStart.y + padY));
               line.push(cell);
            }
            pStart.x = pStart.x + padX;
            pStart.y = pStart.y + padY;
         }
         return line;
      }
   }
}
