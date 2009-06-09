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
	 * A scale that converts logarithmic data to layout space. Values from the
	 * dataProvider are converted to layout-space using log base 10.
	 */
	public class LogScale extends ContinuousScale implements IScale
	{
		public function LogScale()
		{
			super();
			base = 10;
		}
		
		private var logOfBase:Number;
		
		[Bindable(event="baseChange")]
		public function get base():Number
		{
			return _base;
		}
		public function set base(value:Number):void
		{
			if(value != _base)
			{
				_base = value;
				logOfBase = Math.log(_base);
				invalidate();
				dispatchEvent(new Event("baseChange"));
			}
		}
		private var _base:Number;
		
		/**
		 * @inheritDoc IScale#valueToLayout
		 */
		public function valueToLayout(value:Object,invert:Boolean=false):Object
		{
			var logValue:Number = Math.log(Number(value)) / logOfBase;
			
			// These two values should be stored at the class level to prevent redundant computation
			var logMinValue:Number = Math.log(Number(minLayout)) / logOfBase;
			var logMaxValue:Number = Math.log(Number(maxValue)) / logOfBase;
			
			var percentage:Number = getPercentageBetweenValues(logValue,logMinValue,logMaxValue)
			percentage = Math.max(0,Math.min(1,percentage));
			return percentage * (maxLayout - minLayout) + minLayout;
		}
		
		/**
		 * @inheritDoc IScale#layoutToValue
		 */
		public function layoutToValue(layout:Object):Object
		{
			if(!(layout is Number))
				throw new Error("layout parameter must be a Number");

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