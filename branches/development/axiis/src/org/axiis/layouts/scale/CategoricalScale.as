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
	import flash.events.EventDispatcher;
	
	/**
	 * A scale that converts categorical (String) data into layout space.
	 * The categories are assumed to be sorted alphabetically.
	 */
	public class CategoricalScale extends AbstractScale implements IScale
	{
		/**
		 * A sorted list of all unique possible values found within the dataProvider
		 */
		private var uniqueValues:Array = [];
		
		/**
		 * @inheritDoc IScale#validate
		 */
		override public function validate():void
		{
			super.validate();
			uniqueValues = extractUniqueValues();
			if(uniqueValues.length > 0)
			{
				computedMinValue = uniqueValues[0];
				computedMaxValue = uniqueValues[uniqueValues.length - 1];
			}				
		}
		
		/**
		 * Converts a value to layout-space. If the value is not represented within
		 * the dataProvider, NaN is returned.
		 * 
		 * @param value The value to be converted into layout space.
		 * @param invert Whether the minValue translates to minLayout (false) or to maxLayout (true).
		 */
		public function valueToLayout(value:Object,invert:Boolean=false):Number
		{
			if(invalidated)
				validate();
				
			var valueIndex:Number = uniqueValues.indexOf(value);
			if(valueIndex == -1)
				return NaN;
			
			var percentage:Number = (valueIndex + 1) / uniqueValues.length;
			var toReturn:Number = percentage * (maxLayout - minLayout) + minLayout;
			return toReturn;
		}
		
		/**
		 * Converts a layout position to a value from the dataProvider. The layout
		 * position is clamped between minLayout and maxLayout before the
		 * translation takes place.
		 * 
		 * @param The layout position to translate into a value.
		 */
		public function layoutToValue(layout:Number):Object
		{ 
			if (invalidated)
				validate();
				
			var layoutDelta:Number = maxLayout - minLayout;
			var layoutPercentage:Number = (layout - layoutDelta) / (layoutDelta);
			var index:Number = Math.round(layoutPercentage * uniqueValues.length) - 1;
			index = Math.max(0,Math.min(uniqueValues.length - 1,index));
			return uniqueValues[index];
		}
		
		/**
		 * Builds a sorted array of the unique values found within the dataProvider.
		 * Excludes values that fall alphabetically outside the user specified range
		 * of minLayout to maxLayout. 
		 */
		private function extractUniqueValues():Array
		{
			var toReturn:Array = [];
			for each(var o:Object in dataProvider)
			{
				var currValue:Object = dataField == null ? o : o[dataField];
				if((toReturn.indexOf(currValue) == -1)	// Check if the value isn't in the array
					&& (userMinValue == null || currValue >= userMinValue) // Check if the value is in bounds
					&& (userMaxValue == null || currValue <= userMaxValue))
				{
					toReturn.push(currValue);
				}
			}
			toReturn.sort();
			return toReturn;
		}
	}
}