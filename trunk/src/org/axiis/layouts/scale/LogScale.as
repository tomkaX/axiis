package org.axiis.layouts.scale
{
	/**
	 * A scale that deals with logarithmic data. Values from the dataProvider
	 * are converted to layout-space using log base 10.
	 */
	public class LogScale extends NumericalScale
	{
		override public function valueToLayout(value:Object):Number
		{
			var logValue:Number = Math.log(Number(value)) / Math.LN10;
			
			// These two values should be stored at the class level to prevent redundant computation
			var logMinValue:Number = Math.log(Number(minLayout)) / Math.LN10;
			var logMaxValue:Number = Math.log(Number(maxValue)) / Math.LN10;
			
			var percentage:Number = getPercentageBetweenValues(logValue,logMinValue,logMaxValue)
			percentage = Math.max(0,Math.min(1,percentage));
			return percentage * (maxLayout - minLayout) + minLayout;
		}
		
		override public function layoutToValue(layout:Number):Object
		{
			var percentage:Number = getPercentageBetweenValues(Number(layout),Number(minLayout),Number(maxLayout))
			percentage = Math.max(0,Math.min(1,percentage));
			percentage = Math.pow(percentage,10); 
			return percentage * (Number(maxValue) - Number(minValue)) + Number(minValue);
		}
		
		// This comes up a lot... maybe it should be in a util class
		private function getPercentageBetweenValues(value:Number,minimum:Number,maximum:Number):Number
		{
			return 1 - (maximum - value) / (maximum - minimum);
		}
	}
}