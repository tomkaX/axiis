package org.axiis.layouts.scale
{
	import flash.events.Event;
	
	/**
	 * A scale that deals with linear data.
	 */

	 
	public class LinearScale extends ContinuousScale implements IScale
	{
			 
	 
		/**
		 * TRUE: Scale will reverse valueToLayout calc based on min/max layout (helpful for vertical charts to accomodate top,left ==  0,0)
		 * FALSE:  Scale will return normal valueToLayout
		 */
		[Bindable]
		public var invert:Boolean=false;
	
		override public function valueToLayout(value:Object):Number
		{
			if(invalidated)
				validate();
				
			var percentage:Number = getPercentageBetweenValues(Number(value),Number(minValue),Number(maxValue));
			percentage = Math.max(0,Math.min(1.0,percentage));
			
			//trace("value to Layout " + value + " --> " + (percentage * (maxLayout - minLayout) + minLayout).toString());
			
			if  (!invert)
				return percentage * (maxLayout - minLayout) + minLayout;
			else
				return maxLayout - (percentage * (maxLayout - minLayout) + minLayout);
		}
		
		override public function layoutToValue(layout:Number):Object
		{
			if (this.invalidated)
				validate();
				
			var percentage:Number = getPercentageBetweenValues(Number(layout),Number(minLayout),Number(maxLayout));
			percentage = Math.max(0,Math.min(1,percentage));
			return percentage * (Number(maxValue) - Number(minValue)) + Number(minValue);
		}
		
		// This comes up a lot... maybe it should be in a util class
		private function getPercentageBetweenValues(value:Number,minimum:Number,maximum:Number):Number
		{
			return 1 - (maximum - value) / (maximum - minimum);
		}
	}
}