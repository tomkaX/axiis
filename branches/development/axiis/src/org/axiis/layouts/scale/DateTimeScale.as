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
	 * A scale that can be used to convert Dates to layout space.
	 */
	public class DateTimeScale extends ContinuousScale implements IScale
	{
		/**
		 * @inheritDoc IScale#valueToLayout
		 */
		public function valueToLayout(value:Object,invert:Boolean=false):Number
		{
			if(invalidated)
				validate();
			
			var minDate:Date = minValue as Date;
			var maxDate:Date = maxValue as Date;
			var percentage:Number = getPercentageBetweenValues(Number(value),minDate.valueOf(),maxDate.valueOf());
			percentage = Math.max(0,Math.min(1.0,percentage));
			return percentage * (maxLayout - minLayout) + minLayout;
		}
		
		/**
		 * @inheritDoc IScale#layoutToValue
		 */
		public function layoutToValue(layout:Number):Object
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