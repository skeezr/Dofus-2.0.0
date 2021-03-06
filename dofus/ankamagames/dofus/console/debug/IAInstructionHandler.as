package com.ankamagames.dofus.console.debug
{
   import com.ankamagames.jerakine.console.ConsoleInstructionHandler;
   import com.ankamagames.jerakine.console.ConsoleHandler;
   import com.ankamagames.jerakine.types.positions.MapPoint;
   import com.ankamagames.atouin.types.Selection;
   import com.ankamagames.jerakine.types.zones.Lozenge;
   import com.ankamagames.atouin.utils.DataMapProvider;
   import com.ankamagames.jerakine.map.IDataMapProvider;
   import com.ankamagames.atouin.renderers.ZoneDARenderer;
   import com.ankamagames.jerakine.types.Color;
   import com.ankamagames.jerakine.types.zones.Custom;
   import com.ankamagames.jerakine.map.LosDetector;
   import com.ankamagames.atouin.managers.SelectionManager;
   import com.ankamagames.jerakine.pathfinding.Pathfinding;
   
   public class IAInstructionHandler implements ConsoleInstructionHandler
   {
       
      public function IAInstructionHandler()
      {
         super();
      }
      
      public function handle(console:ConsoleHandler, cmd:String, args:Array) : void
      {
         var cell:uint = 0;
         var cellPoint:MapPoint = null;
         var range:uint = 0;
         var cellsSelection:Selection = null;
         var lozenge:Lozenge = null;
         var cells:Vector.<uint> = null;
         var start:uint = 0;
         var end:uint = 0;
         var endPoint:MapPoint = null;
         var startPoint:MapPoint = null;
         var cellsPath:Vector.<uint> = null;
         var cellsPathSelection:Selection = null;
         var map:IDataMapProvider = DataMapProvider.getInstance();
         switch(cmd)
         {
            case "debuglos":
               if(args.length != 2)
               {
                  console.output("Arguments needed : cell and range");
               }
               else if(args.length == 2)
               {
                  cell = uint(args[0]);
                  cellPoint = MapPoint.fromCellId(cell);
                  range = uint(args[1]);
                  cellsSelection = new Selection();
                  lozenge = new Lozenge(0,range,map);
                  cells = lozenge.getCells(cell);
                  cellsSelection.renderer = new ZoneDARenderer();
                  cellsSelection.color = new Color(26112);
                  cellsSelection.zone = new Custom(LosDetector.getCell(map,cells,cellPoint));
                  SelectionManager.getInstance().addSelection(cellsSelection,"CellsFreeForLOS");
                  SelectionManager.getInstance().update("CellsFreeForLOS");
               }
               break;
            case "tracepath":
               if(args.length != 2)
               {
                  console.output("Arguments needed : start and end of the path");
               }
               else if(args.length == 2)
               {
                  start = uint(args[0]);
                  end = uint(args[1]);
                  endPoint = MapPoint.fromCellId(end);
                  if(map.height == 0 || map.width == 0 || !map.pointMov(endPoint.x,endPoint.y,true))
                  {
                     console.output("Problem with the map or the end.");
                  }
                  else
                  {
                     startPoint = MapPoint.fromCellId(start);
                     cellsPath = Pathfinding.findPath(map,startPoint,endPoint).getCells();
                     cellsPathSelection = new Selection();
                     cellsPathSelection.renderer = new ZoneDARenderer();
                     cellsPathSelection.color = new Color(26112);
                     cellsPathSelection.zone = new Custom(cellsPath);
                     SelectionManager.getInstance().addSelection(cellsPathSelection,"CellsForPath");
                     SelectionManager.getInstance().update("CellsForPath");
                  }
               }
         }
      }
      
      public function getHelp(cmd:String) : String
      {
         switch(cmd)
         {
            case "debuglos":
               return "Display all cells which have LOS with the given cell.";
            case "tracepath":
               return "Display all cells of the path between the start and the end.";
            default:
               return "Unknown command";
         }
      }
   }
}
