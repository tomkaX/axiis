///////////////////////////////////////////////////////////////////////////////
//	Copyright (c) 2009 Team Axiis
//
//	Permission is hereby granted, free of charge, to any person
//	obtaining a copy of this software and associated documentation
//	files (the "Software"), to deal in the Software without
//	restriction, including without limitation the rights to use,
//	copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following
//	conditions:
//
//	The above copyright notice and this permission notice shall be
//	included in all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//	OTHER DEALINGS IN THE SOFTWARE.
///////////////////////////////////////////////////////////////////////////////

package org.axiis.layouts.scale
{
	import flash.events.Event;
	
	/**
	 * A scale that deals with linear numeric data.
	 */
	public class LinearScale extends ContinuousScale implements IScale
	{
		// TODO Let's move this to ContinuousScale since that deals with numerical data
		/**
		 * Whether the scale should use zero as it's baseline (true) or allow for negative values.
		 */
		public var zeroBased:Boolean = true;
		
		/**
		 * @inheritDoc IScale#valueToLayout
		 */
		public function valueToLayout(value:Object, invert:Boolean=false):Number
		{
			if(invalidated)
				validate();
				
			var per:Number= getPercentageBetweenValues(Number(value),Number(minValue),Number(maxValue));
		
			per = Math.max(0,Math.min(1.0,per));
			
		
			
			//trace("value to Layout " + value + " --> " + (percentage * (maxLayout - minLayout) + minLayout).toString());
			
			if  (invert)
				per=1-per;

			return (maxLayout-minLayout)*per + minLayout;
		}
		
		/**
		 * @inheritDoc IScale#layoutToValue
		 */
		public function layoutToValue(layout:Number):Object
		{
			if (this.invalidated)
				validate();
				
			var percentage:Number = layout/(maxLayout-minLayout)
			
			return percentage * (Number(maxValue) - Number(minValue)) + Number(minValue);
		}
		
		// TODO This comes up a lot... maybe it should be in a util class
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