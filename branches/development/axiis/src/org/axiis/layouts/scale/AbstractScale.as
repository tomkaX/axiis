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
	 * An abstract base class that scales can extend.
	 * 
	 * Provides stubs for methods defined in IScale.
	 * 
	 * Provides the getter/setter functions necessary for allowing a user to
	 * override computed minimum and maximums as follows:
	 *  
	 * A user can set the minValue using the public setter "minValue".
	 * The protected setter "computedMinValue" allows a subclass to set the
	 * value that it determines for the minimum. The "minValue" getter
	 * will return the user specified value if it exists. Otherwise it returns
	 * the computed value. The analogous procedure is used for maxValue.
	 */
	public class AbstractScale extends EventDispatcher
	{
		protected var invalidated:Boolean = false;
		
		[Bindable(event="dataProviderChange")]
		public function set dataProvider(value:Object):void
		{
			if(value != _dataProvider)
			{
				_dataProvider = value;
				invalidate();
				dispatchEvent(new Event("dataProviderChange"));
			}
		}
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		private var _dataProvider:Object;
		
		[Bindable(event="dataFieldChange")]
		public function set dataField(value:String):void
		{
			if(value != _dataField)
			{
				_dataField = value;
				invalidate();
				dispatchEvent(new Event("dataFieldChange"));
			}
		}
		public function get dataField():String
		{
			return _dataField;
		}
		private var _dataField:String;
		
		//---------------------------------------------------------------------
		// minValue
		//---------------------------------------------------------------------
		
		[Bindable(event="minValueChange")]
		public function set minValue(value:Object):void
		{
			if(value != userMinValue)
			{
				userMinValue = value;
				dispatchEvent(new Event("minValueChange"));
			}
		}
		public function get minValue():Object
		{
			return userMinValue == null ? computedMinValue : userMinValue;
		}
		
		protected function set computedMinValue(value:Object):void
		{
			if(value != _computedMinValue)
			{
				_computedMinValue = value;
				dispatchEvent(new Event("minValueChange"));
			}
		}
		protected function get computedMinValue():Object
		{
			return _computedMinValue;
		}
		private var _computedMinValue:Object;
		protected var userMinValue:Object=0;
		
		//---------------------------------------------------------------------
		// maxValue
		//---------------------------------------------------------------------
		
		[Bindable(event="maxValueChange")]
		public function set maxValue(value:Object):void
		{
			if(value != userMaxValue)
			{
				userMaxValue = value;
				dispatchEvent(new Event("maxValueChange"));
			}
		}
		public function get maxValue():Object
		{
			return userMaxValue == null ? computedMaxValue : userMaxValue;
		}
		protected function set computedMaxValue(value:Object):void
		{
			if(value != _computedMaxValue)
			{
				_computedMaxValue = value;
				dispatchEvent(new Event("maxValueChange"));
			}
		}
		protected function get computedMaxValue():Object
		{
			return _computedMaxValue;
		}
		private var _computedMaxValue:Object;
		protected var userMaxValue:Object;
		
		//---------------------------------------------------------------------
		
		[Bindable(event="minLayoutChange")]
		public function set minLayout(value:Number):void
		{
			if(value != _minLayout)
			{
				_minLayout = value;
				dispatchEvent(new Event("minLayoutChange"));
			}
		}
		public function get minLayout():Number
		{
			return _minLayout;
		}
		private var _minLayout:Number;
		
		[Bindable(event="maxLayoutChange")]
		public function set maxLayout(value:Number):void
		{
			if(value != _maxLayout)
			{
				_maxLayout = value;
				dispatchEvent(new Event("maxLayoutChange"));
			}
		}
		public function get maxLayout():Number
		{
			return _maxLayout;
		}
		private var _maxLayout:Number;
		
		public function invalidate():void
		{
			invalidated = true;
		}
		
		public function validate():void
		{
			invalidated = false;
		}
		
		public function valueToLayout(value:Object,invert:Boolean=false):Number
		{
			return NaN;
		}
		
		public function layoutToValue(layout:Number):Object
		{
			return null;
		}
	}
}