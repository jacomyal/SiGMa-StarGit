package com.stargit{
	
	import com.ofnodesandedges.y2011.core.control.CoreControler;
	import com.ofnodesandedges.y2011.core.data.Graph;
	import com.ofnodesandedges.y2011.core.drawing.EdgeDrawer;
	import com.ofnodesandedges.y2011.core.drawing.GraphDrawer;
	import com.ofnodesandedges.y2011.core.interaction.Glasses;
	import com.ofnodesandedges.y2011.core.layout.forceAtlas.ForceAtlas;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	
	public class Main extends Sprite{
		
		public function Main(s:Stage){
			s.addChild(this);
			
			if (ExternalInterface.available) {
				ExternalInterface.call("stargit.onFlashReady");
			}
			
			// Resize:
			stage.addEventListener(Event.RESIZE,resize);
			
			// We first initialize the graph:
			CoreControler.init(this,stage.stageWidth,stage.stageHeight);
			ForceAtlas.initAlgo();
			
			CoreControler.displayNodes = true;
			CoreControler.displayEdges = true;
			CoreControler.displayLabels = true;
			Graph.defaultEdgeType = EdgeDrawer.CURVE;
			
			CoreControler.minDisplaySize = 2;
			CoreControler.maxDisplaySize = 6;
			CoreControler.minDisplayThickness = 1;
			CoreControler.maxDisplayThickness = 12;
			CoreControler.textThreshold = 3.5;
			
			CoreControler.edgeSizes = true;
			
			GraphDrawer.setEdgesColor(0xcccccc);
			GraphDrawer.setLabelsColor(0x444444);
			GraphDrawer.fontName = "Helvetica";
			
			// We allow the cross domain:
			Security.allowDomain("*");
			
			// We just activate some communication features:
			//  - JS to Flash:
			ExternalInterface.addCallback("initForceAtlas",ForceAtlas.initAlgo);
			ExternalInterface.addCallback("killForceAtlas",ForceAtlas.killAlgo);
			ExternalInterface.addCallback("deleteGraph",Graph.deleteGraph);
			ExternalInterface.addCallback("pushGraph",InputConnectors.pushGraph);
			ExternalInterface.addCallback("updateGraph",InputConnectors.updateGraph);
			ExternalInterface.addCallback("resetGraphPosition",InputConnectors.resetGraphPosition);
			ExternalInterface.addCallback("activateFishEye",function():void{CoreControler.addGraphicEffect(Glasses.fishEyeDisplay);});
			ExternalInterface.addCallback("deactivateFishEye",function():void{CoreControler.removeGraphicEffect(Glasses.fishEyeDisplay);});
			ExternalInterface.addCallback("hasFishEye",function():Boolean{return CoreControler.hasGraphicEffect(Glasses.fishEyeDisplay);});
			ExternalInterface.addCallback("deactivateFishEye",function():void{CoreControler.removeGraphicEffect(Glasses.fishEyeDisplay);});
			
			ExternalInterface.addCallback("setDisplayEdges",function(value:Boolean):void{CoreControler.displayEdges = value;});
			ExternalInterface.addCallback("getDisplayEdges",function():Boolean{return CoreControler.displayEdges;});
			
			ExternalInterface.addCallback("setDisplayNodes",function(value:Boolean):void{CoreControler.displayNodes = value;});
			ExternalInterface.addCallback("getDisplayNodes",function():Boolean{return CoreControler.displayNodes;});
			
			ExternalInterface.addCallback("setDisplayLabels",function(value:Boolean):void{CoreControler.displayLabels = value;});
			ExternalInterface.addCallback("getDisplayLabels",function():Boolean{return CoreControler.displayLabels;});
			
			ExternalInterface.addCallback("setColor",InputConnectors.setColor);
			ExternalInterface.addCallback("setSize",InputConnectors.setSize);
			
			ExternalInterface.addCallback("setMinDisplaySize",function(value:Number):void{CoreControler.minDisplaySize = value;});
			ExternalInterface.addCallback("setMaxDisplaySize",function(value:Number):void{CoreControler.maxDisplaySize = value;});
			
			//  - Flash to JS:
			OutputConnectors.activate_onClickNodes("stargit.onClickNodes");
			OutputConnectors.activate_onOverNodes("stargit.onOverNodes");
		}
		
		private function resize(e:Event):void{
			CoreControler.resize(stage.stageWidth,stage.stageHeight);
		}
	}
}