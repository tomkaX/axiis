package org.axiis.layouts.scale
{
	import flash.events.Event;
	
	/**
	 * A scale that deals with LOG2 scale for circle radius.
	 */

	 
	public class RadiusScale extends ContinuousScale implements IScale
	{
			 
	 
	 	
		public var zeroBased:Boolean=true;
		/**
		 * TRUE: Scale will reverse valueToLayout calc based on min/max layout (helpful for vertical charts to accomodate top,left ==  0,0)
		 * FALSE:  Scale will return normal valueToLayout
		 */
	 
		override public function valueToLayout(value:Object,invert:Boolean=false):Number
		{
			var logValue:Number = Math.log(Number(value)) / Math.LN2;
			
			// These two values should be stored at the class level to prevent redundant computation
			var logMinValue:Number = Math.log(Number(minLayout)) / Math.LN2;
			var logMaxValue:Number = Math.log(Number(maxValue)) / Math.LN2;
			
			var percentage:Number = getPercentageBetweenValues(logValue,logMinValue,logMaxValue)
			percentage = Math.max(0,Math.min(1,percentage));
			return percentage * (maxLayout - minLayout) + minLayout;
		}
		
		/**
		 * @private
		 */
		override public function layoutToValue(layout:Number):Object
		{
			var percentage:Number = getPercentageBetweenValues(Number(layout),Number(minLayout),Number(maxLayout))
			percentage = Math.max(0,Math.min(1,percentage));
			percentage = Math.pow(percentage,2); 
			return percentage * (Number(maxValue) - Number(minValue)) + Number(minValue);
		}
		
		// This comes up a lot... maybe it should be in a util class
		private function getPercentageBetweenValues(value:Number,minimum:Number,maximum:Number):Number
		{
			return 1 - (maximum - value) / (maximum - minimum);
		}
	}
}