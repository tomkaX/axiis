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
		
		private var axiisSprites:Array = [];

		
		public function createDataTip(dataTips:Array,context:UIComponent,axiisSprite:AxiisSprite):void
		{
			var dataTip:UIComponent=dataTips[0];
			var anchorPoint:Point = calculateDataTipPosition(axiisSprite,context);
			dataTip.x = anchorPoint.x;
			dataTip.y = anchorPoint.y;
			
			systemManager.topLevelSystemManager.addChildToSandboxRoot("toolTipChildren", dataTip);
			
			contexts.push(context);
			this.dataTips.push(dataTip);
			axiisSprites.push(axiisSprite);
			
			axiisSprite.addEventListener(MouseEvent.MOUSE_OUT,handleMouseOut);
			//axiisSprite.addEventListener(MouseEvent.MOUSE_MOVE,handleMouseMove);
		}
		
		protected function calculateDataTipPosition(trigger:AxiisSprite,context:DisplayObject):Point
		{
			var point:Point=trigger.localToGlobal(trigger.dataTipAnchorPoint);
			point = systemManager.stage.globalToLocal(point);
			return point;
		}
		
		protected function handleMouseOut(event:MouseEvent):void
		{
			trace("mousing out");
			destroyAllDataTips();
		}
		
		protected function handleMouseMove(event:MouseEvent):void
		{
			//trace("mousing move");
			
		}
		
		public function destroyAllDataTips():void
		{
			while (dataTips.length > 0)
			{
				var context:Sprite = contexts.pop();
				var dataTip:UIComponent = dataTips.pop();
				var axiisSprite:AxiisSprite = axiisSprites.pop();
				context.graphics.clear();
				systemManager.topLevelSystemManager.removeChildFromSandboxRoot("toolTipChildren", dataTip);

				axiisSprite.removeEventListener(MouseEvent.MOUSE_OUT,handleMouseOut);
				
				context=null;
				dataTip=null;
				axiisSprite=null;

			}
			contexts = [];
			dataTips = [];
			axiisSprites = [];
		}
	}
}