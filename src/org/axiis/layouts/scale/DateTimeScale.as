package org.axiis.layouts.scale
{
	public class DateTimeScale extends ContinuousScale implements IScale
	{
		override public function valueToLayout(value:Object):Number
		{
			if(invalidated)
				validate();
			
			var minDate:Date = minValue as Date;
			var maxDate:Date = maxValue as Date;
			var percentage:Number = getPercentageBetweenValues(Number(value),minDate.valueOf(),maxDate.valueOf());
			percentage = Math.max(0,Math.min(1.0,percentage));
			return percentage * (maxLayout - minLayout) + minLayout;
		}
		
		override public function layoutToValue(layout:Number):Object
		{
			if (this.invalidated)
				validate();
			
			var minDate:Date = minValue as Date;
			var maxDate:Date = maxValue as Date;
			var percentage:Number = getPercentageBetweenValues(Number(layout),Number(minLayout),Number(maxLayout));
			percentage = Math.max(0,Math.min(1,percentage));
			return new Date(percentage * (maxDate.valueOf() - minDate.valueOf()) + minDate.valueOf());
		}
		
		// This comes up a lot... maybe it should be in a util class
		private function getPercentageBetweenValues(value:Number,minimum:Number,maximum:Number):Number
		{
			return 1 - (maximum - value) / (maximum - minimum);
		}
	}
}