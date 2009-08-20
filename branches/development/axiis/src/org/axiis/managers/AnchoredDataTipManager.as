package org.axiis.managers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.ApplicationGlobals;
	import mx.core.UIComponent;
	import mx.managers.ISystemManager;
	
	import org.axiis.core.AxiisSprite;

	public class AnchoredDataTipManager implements IDataTipManager
	{
		public function AnchoredDataTipManager()
		{
			super();
			systemManager = ApplicationGlobals.application.systemManager as ISystemManager;
		}
		
		private var systemManager:ISystemManager;
		
		private var contexts:Array = [];
		
		private var dataTips:Array = [];
		
		public function createDataTip(dataTip:UIComponent,context:UIComponent,axiisSprite:AxiisSprite):void
		{
			var anchorPoint:Point = calculateDataTipPosition(axiisSprite,context);
			dataTip.x = anchorPoint.x;
			dataTip.y = anchorPoint.y;
			
			systemManager.topLevelSystemManager.addChildToSandboxRoot("toolTipChildren", dataTip);
			
			contexts.push(context);
			dataTips.push(dataTip);
			
			axiisSprite.addEventListener(MouseEvent.MOUSE_OUT,handleMouseOut);
		}
		
		protected function calculateDataTipPosition(trigger:AxiisSprite,context:DisplayObject):Point
		{
			var point:Point = trigger.localToGlobal(trigger.dataTipAnchorPoint); 
			point = systemManager.stage.globalToLocal(point);
			return point;
		}
		
		protected function handleMouseOut(event:MouseEvent):void
		{
			destroyAllDataTips();
		}
		
		public function destroyAllDataTips():void
		{
			for(var a:int = 0; a < contexts.length; a++)
			{
				var context:Sprite = contexts[a];
				var dataTip:UIComponent = dataTips[a];
				context.graphics.clear();
				systemManager.topLevelSystemManager.removeChildFromSandboxRoot("toolTipChildren", dataTip);
			}
			contexts = [];
			dataTips = [];
		}
	}
}