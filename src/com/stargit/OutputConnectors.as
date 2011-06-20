package com.stargit{
	
	import com.ofnodesandedges.y2011.core.data.Graph;
	import com.ofnodesandedges.y2011.core.interaction.InteractionControler;
	import com.ofnodesandedges.y2011.utils.ContentEvent;
	import com.ofnodesandedges.y2011.utils.PrintUtils;
	
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	
	public class OutputConnectors{
		
		//
		// ON CLICK STAGE:
		public static function activate_onClickStage(call:String):void{
			ParamsManager.ONCLICKSTAGE_CALL = call;
			InteractionControler.addEventListener(InteractionControler.CLICK_STAGE,onClickStage);
		}
		
		private static function onClickStage(e:ContentEvent):void{
			if (ExternalInterface.available) {
				ExternalInterface.call(ParamsManager.ONCLICKSTAGE_CALL,e.content);
			}
		}
		
		//
		// ON CLICK NODES:
		public static function activate_onClickNodes(call:String):void{
			ParamsManager.ONCLICKNODES_CALL = call;
			InteractionControler.addEventListener(InteractionControler.CLICK_NODES,onClickNodes);
		}
		
		private static function onClickNodes(e:ContentEvent):void{
			if (ExternalInterface.available) {
				ExternalInterface.call(ParamsManager.ONCLICKNODES_CALL,e.content);
			}
		}
		
		//
		// ON MOUSE OVER NODES:
		public static function activate_onOverNodes(call:String):void{
			ParamsManager.ONOVERNODES_CALL = call;
			InteractionControler.addEventListener(InteractionControler.OVER_NODES,onOverNodes);
		}
		
		private static function onOverNodes(e:ContentEvent):void{
			if (ExternalInterface.available) {
				ExternalInterface.call(ParamsManager.ONOVERNODES_CALL,e.content);
			}
		}
		
		//
		// ON ZOOMING
		public static function activate_onZooming(call:String):void{
			ParamsManager.ONZOOM_CALL = call;
			InteractionControler.addEventListener(InteractionControler.ON_ZOOMING,onZooming);
		}
		
		private static function onZooming(e:ContentEvent):void{
			if (ExternalInterface.available) {
				ExternalInterface.call(ParamsManager.ONZOOM_CALL,e.content);
			}
		}
	}
}