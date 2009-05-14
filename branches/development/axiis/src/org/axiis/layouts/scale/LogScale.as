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
	/**
	 * A scale that converts logarithmic data to layout space. Values from the
	 * dataProvider are converted to layout-space using log base 10.
	 */
	public class LogScale extends ContinuousScale
	{
		/**
		 * @inheritDoc IScale#valueToLayout
		 */
		override public function valueToLayout(value:Object,invert:Boolean=false):Number
		{
			var logValue:Number = Math.log(Number(value)) / Math.LN10;
			
			// These two values should be stored at the class level to prevent redundant computation
			var logMinValue:Number = Math.log(Number(minLayout)) / Math.LN10;
			var logMaxValue:Number = Math.log(Number(maxValue)) / Math.LN10;
			
			var percentage:Number = getPercentageBetweenValues(logValue,logMinValue,logMaxValue)
			percentage = Math.max(0,Math.min(1,percentage));
			return percentage * (maxLayout - minLayout) + minLayout;
		}
		
		/**
		 * @inheritDoc IScale#layoutToValue
		 */
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