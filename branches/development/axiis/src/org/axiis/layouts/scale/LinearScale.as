package org.axiis.layouts.scale
{
	import flash.events.Event;
	
	/**
	 * A scale that deals with linear data.
	 */
	public class LinearScale extends ContinuousScale implements IScale
	{
		public var zeroBased:Boolean=true;
		
		/**
		 * TRUE: Scale will reverse valueToLayout calc based on min/max layout (helpful for vertical charts to accomodate top,left ==  0,0)
		 * FALSE:  Scale will return normal valueToLayout
		 */
		override public function valueToLayout(value:Object, invert:Boolean=false):Number
		{
			if(invalidated)
				validate();
				
			var per:Number= getPercentageBetweenValues(Number(value),Number(minValue),Number(maxValue));
		
			per = Math.max(0,Math.min(1.0,per));
			
			if (invert)
				per=1-per;
			
			return (maxLayout-minLayout)*per + minLayout;
		}
		
		// TODO THIS FUNCTION NEEDS TO ACCOUNT FOR ZERO BASED, IT DOES NOT RIGHT NOW
		override public function layoutToValue(layout:Number):Object
		{
			if (this.invalidated)
				validate();
				
			var percentage:Number = getPercentageBetweenValues(Number(layout),Number(minLayout),Number(maxLayout));
			
			
			percentage = Math.max(0,Math.min(1.0,percentage));
			return percentage * (Number(maxValue) - Number(minValue)) + Number(minValue);
		}
		
		// This comes up a lot... maybe it should be in a util class
		private function getPercentageBetweenValues(value:Number,min:Number,max:Number):Number
		{
			var per:Number=Math.abs(value)/(max-min);
			
			 if (zeroBased && min < 0) {
				per=Math.abs(min)/(max-min) + (value < 0 ? -per:per);
			}
			
			return per;
		}
	}
}