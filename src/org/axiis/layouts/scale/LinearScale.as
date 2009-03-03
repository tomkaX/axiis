package org.axiis.layouts.scale
{
	import flash.events.Event;
	
	/**
	 * A scale that deals with linear data.
	 */
	public class LinearScale extends NumericalScale implements IScale
	{
		override public function valueToLayout(value:Object):Number
		{
			if(invalidated)
				validate();
			var percentage:Number = getPercentageBetweenValues(Number(value),Number(minValue),Number(maxValue));
			percentage = Math.max(0,Math.min(1.0,percentage));
			return percentage * (maxLayout - minLayout) + minLayout;
		}
		
		override public function layoutToValue(layout:Number):Object
		{
			if (this.invalidated) validate();
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