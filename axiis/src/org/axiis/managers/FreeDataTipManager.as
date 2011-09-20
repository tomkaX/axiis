package org.axiis.managers
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	import mx.managers.ISystemManager;
	
	import org.axiis.core.AxiisSprite;

	/**
	 * FreeDataTipManager will lay out a single data tip that follows the cursor
	 * as the user moves the mouse.
	 */
	public class FreeDataTipManager implements IDataTipManager
	{
		public function FreeDataTipManager()
		{
			super();
			
		}
		
		/**
		 * @inheritDoc IDataTipManager#dataTips
		 */
		public function get dataTips():Array {
			return [dataTip];
		}
		

		private var context:Sprite;
		
		private var dataTip:UIComponent;
		
		private var axiisSprite:AxiisSprite;
		
		/**
		 * @inheritDoc IDataTipManager#createDataTip
		 */
		public function createDataTip(dataTips:Array,context:UIComponent,axiisSprite:AxiisSprite):void
		{
			var dataTip:UIComponent=dataTips[0];
			destroyAllDataTips();
			
			this.dataTip = dataTip;
			this.context = context;
			this.axiisSprite = axiisSprite;
			
			var point:Point = calculateDataTipPosition(axiisSprite,context)
			dataTip.x = point.x+3;
			dataTip.y = point.y;
			
			if(context)
				context.systemManager.addChild(dataTip);
			//	context.systemManager.addChildToSandboxRoot("toolTipChildren", dataTip);
			else {
				var sm:ISystemManager = context['systemManager'] as ISystemManager;
				sm.topLevelSystemManager.addChild(dataTip);
				//systemManager.topLevelSystemManager.addChildToSandboxRoot("toolTipChildren", dataTip);
			}
			
			axiisSprite.addEventListener(MouseEvent.MOUSE_MOVE,handleMouseMove);
			axiisSprite.addEventListener(MouseEvent.MOUSE_OUT,handleMouseOut);
		}
		
		/**
		 * @private
		 */
		protected function calculateDataTipPosition(trigger:AxiisSprite,context:DisplayObject):Point
		{
			var point:Point = new Point(trigger.mouseX,trigger.mouseY); 
			var sm:ISystemManager = trigger.layout.owner['systemManager'] as ISystemManager;
			point = trigger.localToGlobal(point);
			point = sm.stage.globalToLocal(point);
			return point;
		}
		
		/**
		 * @private
		 */
		protected function handleMouseMove(event:MouseEvent):void
		{
			if(context != null)
			{
				var point:Point = calculateDataTipPosition(AxiisSprite(event.target),context);
				dataTip.x = point.x;
				dataTip.y = point.y;
				dataTip.invalidateDisplayList();
			}
		}
		
		/**
		 * @private
		 */
		protected function handleMouseOut(event:MouseEvent):void
		{
			destroyAllDataTips();
		}
		
		/**
		 * @inheritDoc IDataTipManager#destroyAllDataTips
		 */
		public function destroyAllDataTips():void
		{
			if(context != null && dataTip != null && axiisSprite != null)
			{
				UIComponent(context).systemManager.removeChild(dataTip);
			//	UIComponent(context).systemManager.removeChildFromSandboxRoot("toolTipChildren", dataTip);
				axiisSprite.removeEventListener(MouseEvent.MOUSE_MOVE,handleMouseMove);
				axiisSprite.removeEventListener(MouseEvent.MOUSE_OUT,handleMouseOut);
				context = null;
				dataTip = null;
				axiisSprite = null;
			}
		}
	}
}