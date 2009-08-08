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

	public class FreeDataTipManager
	{
		public function FreeDataTipManager()
		{
			super();
			systemManager = ApplicationGlobals.application.systemManager as ISystemManager;
		}
		
		private var systemManager:ISystemManager;
		
		private var context:Sprite;
		
		private var dataTip:UIComponent;
		
		private var axiisSprite:AxiisSprite;
		
		public function createDataTip(dataTip:UIComponent,context:UIComponent,axiisSprite:AxiisSprite):void
		{
			destroyAllDataTips();
			
			this.dataTip = dataTip;
			this.context = context;
			this.axiisSprite = axiisSprite;
			
			var point:Point = calculateDataTipPosition(axiisSprite,context)
			dataTip.x = point.x;
			dataTip.y = point.y;
			
			systemManager.topLevelSystemManager.addChildToSandboxRoot("toolTipChildren", dataTip);
			
			axiisSprite.addEventListener(MouseEvent.MOUSE_MOVE,handleMouseMove);
			axiisSprite.addEventListener(MouseEvent.MOUSE_OUT,handleMouseOut);
		}
		
		protected function calculateDataTipPosition(trigger:DisplayObject,context:DisplayObject):Point
		{
			var point:Point = new Point(trigger.mouseX,trigger.mouseY); 
			point = trigger.localToGlobal(point);
			point = systemManager.stage.globalToLocal(point);
			return point;
		}
		
		protected function handleMouseMove(event:MouseEvent):void
		{
			if(context != null)
			{
				var point:Point = calculateDataTipPosition(DisplayObject(event.target),context);
				dataTip.x = point.x;
				dataTip.y = point.y;
				dataTip.invalidateDisplayList();
			}
		}
		
		protected function handleMouseOut(event:MouseEvent):void
		{
			destroyAllDataTips();
		}
		
		public function destroyAllDataTips():void
		{
			if(context != null && dataTip != null && axiisSprite != null)
			{
				systemManager.topLevelSystemManager.removeChildFromSandboxRoot("toolTipChildren", dataTip);
				axiisSprite.removeEventListener(MouseEvent.MOUSE_MOVE,handleMouseMove);
				axiisSprite.removeEventListener(MouseEvent.MOUSE_OUT,handleMouseOut);
				context = null;
				dataTip = null;
				axiisSprite = null;
			}
		}
	}
}