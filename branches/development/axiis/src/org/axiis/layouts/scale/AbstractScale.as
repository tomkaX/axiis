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
	 * An abstract base class that scales can extend. It provides stubs for
	 * methods defined in IScale, and sets up the necessary getters and setters
	 * to allow a user to overide minimums and maximums values. A user can set
	 * the minValue using the public setter "minValue". The protected setter
	 * "computedMinValue" allows a subclass to set the value that it determines
	 * for the minimum based only on the data. The "minValue" getter
	 * will return the user specified value if it exists. Otherwise it returns
	 * the computed value. The analogous procedure is used for maxValue.
	 */
	public class AbstractScale extends EventDispatcher
	{
		/**
		 * Indicates that the scale should recalculate it's minimum and maximum
		 * values and layouts the next time either layoutToValue or valueToLayout
		 * is called. 
		 */
		protected var invalidated:Boolean = false;
		
		// TODO we need to watch for changes to the dataProvider and call invalidate 
		[Bindable(event="dataProviderChange")]		
		/**
		 * @copy IScale#dataProvider
		 */
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		public function set dataProvider(value:Object):void
		{
			if(value != _dataProvider)
			{
				_dataProvider = value;
				invalidate();
				dispatchEvent(new Event("dataProviderChange"));
			}
		}
		private var _dataProvider:Object;
		
		[Bindable(event="dataFieldChange")]
		/**
		 * @copy IScale#dataField
		 */
		public function get dataField():String
		{
			return _dataField;
		}
		public function set dataField(value:String):void
		{
			if(value != _dataField)
			{
				_dataField = value;
				invalidate();
				dispatchEvent(new Event("dataFieldChange"));
			}
		}
		private var _dataField:String;
		
		//---------------------------------------------------------------------
		// minValue
		//---------------------------------------------------------------------
		
		[Bindable(event="minValueChange")]
		/**
		 * @copy IScale#minValue
		 */
		public function get minValue():*
		{
			return userMinValue == null ? computedMinValue : userMinValue;
		}
		public function set minValue(value:*):void
		{
			if(value != userMinValue)
			{
				userMinValue = value;
				dispatchEvent(new Event("minValueChange"));
			}
		}
		
		/**
		 * The minimum value in the dataProvider.
		 */
		protected function get computedMinValue():Object
		{
			return _computedMinValue;
		}
		protected function set computedMinValue(value:Object):void
		{
			if(value != _computedMinValue)
			{
				_computedMinValue = value;
				dispatchEvent(new Event("minValueChange"));
			}
		}
		private var _computedMinValue:Object;
		
		// TODO This should not be initialized
		/**
		 * The minimum value as specified by the user.
		 */
		protected var userMinValue:Object=0;
		
		//---------------------------------------------------------------------
		// maxValue
		//---------------------------------------------------------------------
		
		[Bindable(event="maxValueChange")]
		/**
		 * @copy IScale#maxValue
		 */
		public function get maxValue():*
		{
			return userMaxValue == null ? computedMaxValue : userMaxValue;
		}
		public function set maxValue(value:*):void
		{
			if(value != userMaxValue)
			{
				userMaxValue = value;
				dispatchEvent(new Event("maxValueChange"));
			}
		}
		
		/**
		 * The maximum value in the dataProvider.
		 */
		protected function get computedMaxValue():Object
		{
			return _computedMaxValue;
		}
		protected function set computedMaxValue(value:Object):void
		{
			if(value != _computedMaxValue)
			{
				_computedMaxValue = value;
				dispatchEvent(new Event("maxValueChange"));
			}
		}
		private var _computedMaxValue:Object;
		
		/**
		 * The maximum value as specified by the user.
		 */
		protected var userMaxValue:Object;
		
		//---------------------------------------------------------------------
		
		[Bindable(event="minLayoutChange")]
		/**
		 * @copy IScale#minLayout
		 */
		public function get minLayout():Number
		{
			return _minLayout;
		}
		public function set minLayout(value:Number):void
		{
			if(value != _minLayout)
			{
				_minLayout = value;
				dispatchEvent(new Event("minLayoutChange"));
			}
		}
		private var _minLayout:Number;
		
		[Bindable(event="maxLayoutChange")]
		/**
		 * @copy IScale#maxLayout
		 */
		public function get maxLayout():Number
		{
			return _maxLayout;
		}
		public function set maxLayout(value:Number):void
		{
			if(value != _maxLayout)
			{
				_maxLayout = value;
				dispatchEvent(new Event("maxLayoutChange"));
			}
		}
		private var _maxLayout:Number;
		
		/**
		 * Marks this IScale as needing its minValue and maxValue recomputed.
		 */
		public function invalidate():void
		{
			invalidated = true;
		}
		
		/**
		 * Initiates the computation of minValue and maxValue.
		 */
		public function validate():void
		{
			invalidated = false;
		}
	}
}