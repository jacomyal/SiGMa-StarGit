package com.stargit{
	
	import com.ofnodesandedges.y2011.core.control.CoreControler;
	import com.ofnodesandedges.y2011.core.data.Edge;
	import com.ofnodesandedges.y2011.core.data.Graph;
	import com.ofnodesandedges.y2011.core.data.Node;
	import com.ofnodesandedges.y2011.core.interaction.InteractionControler;
	import com.ofnodesandedges.y2011.core.layout.CircularLayout;
	import com.ofnodesandedges.y2011.utils.ColorUtils;
	import com.ofnodesandedges.y2011.utils.Trace;
	
	import flash.external.ExternalInterface;
	
	public class InputConnectors{
		
		// Graph attributes definition:
		public static const VALUES:String = "values";
		
		public static const TYPE:String = "type";
		public static const NUM:String = "Num";
		public static const STR:String = "Str";
		
		public static const COLOR_MIN:String = "colorMin";
		public static const COLOR_MAX:String = "colorMax";
		public static const COLOR_DEF:String = "default";
		
		public static var randomScale:Number = 2000;
		
		public static function pushNode(value:Object):Node{
			var nodeObject:Object = value;
			var node:Node = new Node(nodeObject['id'],nodeObject['label']);
			
			for(var key:String in nodeObject){
				switch(key){
					case "x": node.x = int(nodeObject[key]); break;
					case "y": node.y = int(nodeObject[key]); break;
					case "shape": node.shape = int(nodeObject[key]); break;
					case "size": node.size = Number(nodeObject[key]); break;
					case "color": node.color = uint(nodeObject[key]); break;
					default: node.attributes[key] = nodeObject[key];
				}
			}
			
			// Randomize node positions if null:
			if(node.x==0 && node.y==0){
				node.x = Math.random()*randomScale;
				node.y = Math.random()*randomScale;
			}
			
			return node;
		}
		
		public static function pushEdge(value:Object):Edge{
			var edgeObject:Object = value;
			var edge:Edge = new Edge(edgeObject["id"],edgeObject["sourceID"],edgeObject["targetID"]);
			
			for(var key:String in edgeObject){
				switch(key){
					case "weight": edge.weight = Number(edgeObject[key]); break;
					case "type": edge.type = int(edgeObject[key]); break;
					case "label": edge.label = String(edgeObject[key]); break;
					default: edge.attributes[key] = edgeObject[key];
				}
			}
			
			return edge;
		}
		
		public static function resetGraphPosition():void{
			CoreControler.x = 0;
			CoreControler.y = 0;
			CoreControler.ratio = 1;
		}
		
		public static function pushGraph(value:Object):void{
			var nodes:Object = value["nodes"];
			var edges:Object = value["edges"];
			
			var newNodes:Vector.<Node> = new Vector.<Node>();
			var newEdges:Vector.<Edge> = new Vector.<Edge>();
			
			var node:Object, edge:Object;
			
			// Nodes:
			for each(node in nodes){
				newNodes.push(pushNode(node));
			}
			
			// Edges:
			for each(edge in edges){
				newEdges.push(pushEdge(edge));
			}
			
			Graph.pushGraph(newNodes,newEdges,true);
		}
		
		public static function updateGraph(value:Object):void{
			var nodes:Object = value["nodes"];
			var edges:Object = value["edges"];
			
			var newNodes:Vector.<Node> = new Vector.<Node>();
			var newEdges:Vector.<Edge> = new Vector.<Edge>();
			
			var node:Object, edge:Object;
			
			// Nodes:
			for each(node in nodes){
				newNodes.push(pushNode(node));
			}
			
			// Edges:
			for each(edge in edges){
				newEdges.push(pushEdge(edge));
			}
			
			CircularLayout.apply(Math.sqrt(nodes.length+1)*10);
			
			Graph.updateGraph(newNodes,newEdges,true);
		}
		
		public static function setColor(field:String,attributes:Object):void{
			var attribute:Object = attributes[field];
			var node:Node;
			
			if(attribute[TYPE]==NUM){
				var colorMin:uint = uint(attribute[COLOR_MIN]);
				var colorMax:uint = uint(attribute[COLOR_MAX]);
				var colorDef:uint = uint(attribute[COLOR_DEF]);
				
				var minValue:Number = Graph.nodes.length ? (Graph.nodes[0].attributes[field] ? Graph.nodes[0].attributes[field] : 0) : 0;
				var maxValue:Number = Graph.nodes.length ? (Graph.nodes[0].attributes[field] ? Graph.nodes[0].attributes[field] : 0) : 0;
				
				for each(node in Graph.nodes){
					minValue = node.attributes[field] ? Math.min(minValue,node.attributes[field]) : minValue;
					maxValue = node.attributes[field] ? Math.max(maxValue,node.attributes[field]) : maxValue;
				}
				
				for each(node in Graph.nodes){
					node.color = node.attributes[field] ? ColorUtils.inBetweenColor(colorMin,colorMax,(node.attributes[field]-minValue)/(maxValue-minValue)) : colorDef;
				}
			}else if(attribute[TYPE]==STR){
				var defaultColor:uint = uint(attribute[COLOR_DEF]);
				var hasGoodValue:Boolean;
				
				for each(node in Graph.nodes){
					hasGoodValue = false;
					
					for(var value:String in attribute[VALUES]){
						if(node.attributes[field]==value){
							node.color = uint(attribute[VALUES][value]);
							hasGoodValue = true;
							break;
						}
					}
					
					node.color = hasGoodValue ? node.color : defaultColor;
				}
			}
		}
		
		public static function setSize(field:String):void{
			var node:Node;
			
			for each(node in Graph.nodes){
				node.size = node.attributes[field] ? node.attributes[field] : 1;
			}
		}
	}
}